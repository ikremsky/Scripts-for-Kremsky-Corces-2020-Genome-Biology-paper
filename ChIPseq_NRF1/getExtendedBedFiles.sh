mkdir bed_extended bam
process ()
{
#	macs2 predictd -i $file 2> bam/$(basename $file .bam).fraglen.txt
	el=$(grep "predicted fragment length is" bam/$(basename $file .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); print}' | awk '{print $1}')
	bamToBed -i $file | grep -v chrM | grep -v random | awk -v el=$el 'BEGIN{OFS="\t"}{if($6 == "+") pos=$2; else pos=$3-el; print $1,pos,pos+el,$4,$5,$6}' > bed_extended/$(basename $file .bam).bed
	wc -l bed_extended/$(basename $file .bam).bed | awk '{sub("bed_extended/", ""); print}' >> bed_extended/readCounts
	M=$(awk -v x=$(basename $file .bam).bed 'BEGIN{count=0}{if($2 == x) count+=$1/1000000}END{print 1/count}' bed_extended/readCounts)
	grep -v chrM bed_extended/$(basename $file .bam).bed | cut -f1-3 | sort -k1,1 | bedtools genomecov -scale $M -i - -g /home/genomefiles/mouse/mm9_sizes.txt -bg >  bed_extended/$(basename $file .bam).bedGraph
	bedGraphToBigWig bed_extended/$(basename $file .bam).bedGraph /home/genomefiles/mouse/mm9_sizes.txt bed_extended/$(basename $file .bam).bw
}

for file in $(ls /Zulu/isaac/ChIPseq_NRF1/bam/CHIP*sorted.duprmvd.bam | grep -v _1 | grep -v _2)
do
	process &
done
wait
echo done
