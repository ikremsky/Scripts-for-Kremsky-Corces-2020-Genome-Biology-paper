mkdir bed_mm10
process ()
{
	macs2 predictd -i $file 2> bam_mm10/$(basename $file .bam).fraglen.txt
	sl=$(grep "predicted fragment length is" bam_mm10/$(basename $file .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); print}' | awk '{print int($1/2)}')
	bamToBed -i $file | grep -v chrM | grep -v random | awk -v sl=$sl 'BEGIN{OFS="\t"}{len=int(($3-$2)/2); if($6 == "+") pos=$2+sl; else pos=$3-sl; print $1,pos-len,pos+len,$4,$5,$6}' > bed_mm10/$(basename $file .bam).bed
	wc -l bed_mm10/$(basename $file .bam).bed | awk '{sub("bed_mm10/", ""); print}' >> bed_mm10/readCounts
	M=$(awk -v x=$(basename $file .bam).bed 'BEGIN{count=0}{if($2 == x) count+=$1/1000000}END{print 1/count}' bed_mm10/readCounts)
	grep -v chrM bed_mm10/$(basename $file .bam).bed | cut -f1-3 | sort -k1,1 | bedtools genomecov -scale $M -i - -g /home/genomefiles/mouse/mm9_sizes.txt -bg >  bed_mm10/$(basename $file .bam).bedGraph
#	bedGraphToBigWig bed_mm10/$(basename $file .bam).bedGraph /home/genomefiles/mouse/mm9_sizes.txt bed_mm10/$(basename $file .bam).bw
}

for file in $(ls bam_mm10/*duprmvd.bam | grep pooled)
do
	process &
done
wait
echo done
