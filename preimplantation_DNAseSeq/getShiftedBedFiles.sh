mkdir bed_shifted
process ()
{
#	macs2 predictd -i $file 2> bam/$(basename $file .bam).fraglen.txt
	sl=25
#$(grep "predicted fragment length is" bam/$(basename $file .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); print}' | awk '{print int($1/2)}')
	basename $file
	echo $sl
	bamToBed -i $file | grep -v chrM | awk -v sl=$sl 'BEGIN{OFS="\t"}{len=int(($3-$2)/2); if($6 == "+") pos=$2+sl; else pos=$3-sl; print $1,pos-len,pos+len,$4,$5,$6}' > bed_shifted/$(basename $file .bam).bed
	wc -l bed_shifted/$(basename $file .bam).bed | awk '{sub("bed_shifted/", ""); print}' >> bed_shifted/readCounts
	M=$(awk -v x=$(basename $file .bam).bed 'BEGIN{count=0}{if($2 == x) count+=$1/1000000}END{print 1/count}' bed_shifted/readCounts)
	grep -v chrM bed_shifted/$(basename $file .bam).bed | cut -f1-3 | sort -k1,1 | bedtools genomecov -scale $M -i - -g /home/genomefiles/mouse/mm9_sizes.txt -bg >  bed_shifted/$(basename $file .bam).bedGraph
	bedGraphToBigWig bed_shifted/$(basename $file .bam).bedGraph /home/genomefiles/mouse/mm9_sizes.txt bed_shifted/$(basename $file .bam).bw
}

for file in 
#$(ls bam/*duprmvd.bam | grep pooled | grep ESC)
do
	process &
done
wait
echo done
cp /mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/bed/ESC-Rep1-2_pooled_x115-TF.sorted.bed bed_shifted/
wc -l bed_shifted/ESC-Rep1-2_pooled_x115-TF.sorted.bed | awk '{sub("bed_shifted/", ""); print}' >> bed_shifted/readCounts
#cp /mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/bed/Cont_Sperm_OmniATACseq_x115_TF_sort.bed bed_shifted/
#wc -l bed_shifted/Cont_Sperm_OmniATACseq_x115_TF_sort.bed | awk '{sub("bed_shifted/", ""); print}' >> bed_shifted/readCounts
#cp /mnt/isaachd/ATAC-seq_naturedata/bed_mm9/ICM_pooled.sorted.duprmvd.TFs.bed bed_shifted/
#wc -l bed_shifted/ICM_pooled.sorted.duprmvd.TFs.bed | awk '{sub("bed_shifted/", ""); print}' >> bed_shifted/readCounts
