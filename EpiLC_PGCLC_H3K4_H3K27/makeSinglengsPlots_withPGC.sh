type=PGCLCs_atPGC_E14.5mHi
TF=All
region=distal
files="/media/4TB4/isaac/PGC_DNAseseq/bed/${TF}/E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.distalHi.fpkm"
colors="brown red orange yellow green blue purple black red orange yellow green blue purple black grey brown cyan blue1 blue2 blue3 red2 green3 red3 red4 yellow2"
rm configurationFile*
i=2
bedFile=bedFile.bed
cat $files | awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1,$4,$5,$6}' > bedFile.bed

getFL ()
{
	if [ -e $(basename $bamFile .bam).fraglen.txt ]; then
		echo fragFile exists
	else
		macs2 predictd -i $bamFile 2> $(basename $bamFile .bam).fraglen.txt
	fi
}


for k in 1 
do
	i=2
	for stage in E14.5m_DNAse-Hi ESC_H3K4me3 ESC_H3K27me3 EpiLC_H3K4me3 EpiLC_H3K27me3 d2PGCLC_H3K4me3 d2PGCLC_H3K27me3 E11.5PGC_H3K4me3 E11.5PGC_H3K27me3 d6PGCLC_H3K4me3 d6PGCLC_H3K27me3
	do
		testLab=$stage

		if [ $(echo $stage | awk '{if($1 ~ "E14.5m_DNAse-Hi") print 1; else print 0}') -eq 0 ]; then
			if [ $(echo $stage | awk '{if($1 ~ "E11.5") print 1; else print 0}') -eq 0 ]; then
				bamFile=bam/${stage}_pooled.sorted.duprmvd_distal.bam
				getFL
				stage=$(echo $stage | awk '{sub("5000mESC", "H3K4me3"); print}')
				fl=$(grep "predicted fragment length is" $(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
			else
				stage=$(echo $stage | awk '{sub("E11.5", ""); print}')
				bamFile=/hdisk2/isaac/ChIPseq_E11.5PGC/bam/${stage}_pooled.sorted_distal.bam
				getFL
				fl=$(grep "predicted fragment length is" $(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
			fi
		else
			stage="TF-ATAC"
			bamFile=/media/4TB4/isaac/PGC_DNAseseq/bam/E14.5_male_pooled.sorted.duprmvd.bam
			getFL
			fl=$(grep "predicted fragment length is" /mnt/bigmama/isaac/DNAseSeq/bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
		fi
		color=$(echo $colors | cut -f $i -d" ")
		echo $color
		#macs2 predictd -i $bamFile 2> $(basename $bamFile .bam).fraglen.txt &

		echo "${bamFile} ${bedFile} ${testLab} ${fl} $color" | awk '{gsub(" ", "\t"); print}' > configurationFile${stage}.txt

	        if [ $(echo $i | awk '{if($1 <= 8) print 0; else print 1}') -eq 0 ]; then
	                time=early
	        else
	                time=late
	        fi


		i=$(expr $i + 1)
		cat configurationFile${stage}.txt >> configurationFile.txt
                cat configurationFile${stage}.txt >> configurationFile${k}_${time}.txt
	done
	wait
#	ngs.plot.r -GO none -G mm9 -R bed -C configurationFile${stage}.txt -F chipseq -XYL 0 -L 5000 -O ${type}_singleCofactor
#	 Rscript ExtractGName.R DNAse-seq_Pol2Clust$k
done
wait
ngs.plot.r -SC global -GO hc -G mm9 -R bed -C configurationFile.txt -F chipseq -XYL 0 -L 5000 -O ${type} -LWD 6

