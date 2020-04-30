#intersectBed -f .5 -F .5 -e -u -a ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed &
#intersectBed -f .5 -F .5 -e -v -a ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks_distal.bed &
#wait

clusterFile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/TSSclusters_ATAC_Pol2s5.bed
#/hdisk2/isaac/isaachd/ATAC-seq_naturedata/TSSlist_newcluster_forRNAPIIS2p.bed
colors="brown red orange yellow green blue purple black red orange yellow green blue purple black grey brown cyan blue1 blue2 blue3 red2 green3 red3 red4 yellow2"
type=PGC_DNAse
rm configurationFile*.txt


for k in 1 2 3 4
do
	bedFile=bedFile${k}.bed
	awk -v cluster=$k '$5 == cluster' $clusterFile > bedFile${k}.bed
	i=2
	for stage in RS GVOocyte_ATAC Sperm_ATAC Pronuclei_Mat_PN3 Pronuclei_Pat_PN3 2Cell 4Cell 8Cell Morula E9.5_PGC E10.5_PGC E12.5_female_PGC E12.5_male_PGC E13.5_female_PGC E13.5_male_PGC  E14.5_female_PGC E14.5_male_PGC E16.5_female_PGC E16.5_male_PGC
#Sperm_ATAC Sperm_Pol2s5 GVOocyte_ATAC MIIOocyte_ATAC Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 2Cell 4Cell 8Cell Morula
# Sperm_ATAC Sperm_Pol2s5 GVOocyte_ATAC MIIOocyte_ATAC Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 2Cell 4Cell 8Cell Morula
#Sperm_ATAC Sperm_Pol2s5 GVOocyte2017 GVOocyte_14d Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 1Cell 4Cell Morula
#Sperm GVOocyte_14d Pronuclei_Pat_PN5 Pronuclei_Mat_PN5 2Cell 8Cell
	do
		testLab=$stage

		if [ $(echo $stage | awk '{if($1 == "Sperm_ATAC") print 1; else print 0}') -eq 0 ]; then
			if [ $(echo $stage | awk '{if($1 == "GVOocyte2017") print 1; else print 0}') -eq 0 ]; then
				if [ $(echo $stage | awk '{if($1 == "Sperm_Pol2s5") print 1; else print 0}') -eq 0 ]; then
					if [ $(echo $stage | awk '{if($1 == "Sperm_Pol2s2") print 1; else print 0}') -eq 0 ]; then
						if [ $(echo $stage | awk '{if($1 == "GVOocyte_ATAC") print 1; else print 0}') -eq 0 ]; then
							if [ $(echo $stage | awk '{if($1 == "MIIOocyte_ATAC") print 1; else print 0}') -eq 0 ]; then
								if [ $(echo $stage | awk '{if($1 == "fPN_ATAC") print 1; else print 0}') -eq 0 ]; then
									if [ $(echo $stage | awk '{if($1 ~ "PGC") print 1; else print 0}') -eq 0 ]; then
										if [ $(echo $stage | awk '{if($1 == "RS") print 1; else print 0}') -eq 0 ]; then
											bamFile=bam/${stage}_pooled.sorted.duprmvd.bam
										else
											bamFile=/Zulu/isaac/RS/bam/RS_WT_pooled.sorted.duprmvd.bam
											#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
										fi
									else
				                                               stage=$(echo $stage | awk '{sub("_PGC", ""); print}')
                        				                       bamFile=/media/4TB4/isaac/PGC_DNAseseq/bam/${stage}_pooled.sorted.duprmvd.bam
									fi
								else
									bamFile=/Zulu/isaac/ATACseq_Hannah/bam/fPN_rep1.sorted.duprmvd.TFs.sorted.bam
									#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
								fi
							else
								bamFile=/hdisk2/isaac/ATACseqAnalysis/pooled/MIIoocyterep1_mm9.rmdup.flt.TF.sorted.bam
								#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
							fi
						else
							bamFile=/hdisk2/isaac/ATACseqAnalysis/pooled/GVoocyte_Rep1-2_pooled_x115_TF.sorted.bam
							#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
						fi
					else
						bamFile=bam/CONT_SPERM_RNAPIIS2p_Pooled-Rep1-2.bam
					fi
				else
					bamFile=/hdisk6/yoonhee/Rawdata/CONT_SPERM_TranscriptionFactor_ChiPseq/CONT_SPERM_RNAPIIS5p_Rep1-2/Pooled_Rep1-2/CONT_SPERM_RNAPIIS5p_Pooled-Rep1-2.bam
				fi
			else
				bamFile=bam/Dnaseq_GV-Oocyte_combined_sort_rmdup.bam
			fi
			#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
			fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
		else
			bamFile=/hdisk2/isaac/ATACseqAnalysis/pooled/Cont_Sperm_OmniATACseq_x115_TF_sort.bam
	#		macs2 predictd -i $bamFile 2> /hdisk2/isaac/ATACseqAnalysis/pooled/$(basename $bamFile .bam).fraglen.txt
			fl=$(grep "predicted fragment length is" /hdisk2/isaac/ATACseqAnalysis/pooled/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
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
		cat configurationFile${stage}.txt >> configurationFile${k}.txt
                cat configurationFile${stage}.txt >> configurationFile${k}_${time}.txt
	done
	wait
#	ngs.plot.r -GO km -KNC 4 -G mm9 -R bed -C configurationFile${k}.txt -F chipseq -XYL 0 -L 2500 -O ${type}_Pol2Clust$k
#	 Rscript ExtractGName.R DNAse-seq_Pol2Clust$k
done
wait
rm bedFile.bed
for k in 1 2 3 4
do
	echo $k
	echo ...
#	awk 'BEGIN{FS=":"; OFS="\t"}{sub(/c\(/, ""); sub(/\)/, ""); gsub(/\"/, ""); sub(" ", ""); print $1}' DNAse-seq_Pol2Clust${k}.gname.txt | awk 'NF > 0' | awk 'BEGIN{OFS="\t"}{print $1,NR}' | sort -k1n,1 > DNAse-seq_Pol2Clust${k}.ordering.txt
#	paste bedFile${k}.bed DNAse-seq_Pol2Clust${k}.ordering.txt | sort -k8n,8 | cut -f1-6 >> bedFile.bed
	cat bedFile${k}.bed >> bedFile.bed
done
awk 'BEGIN{OFS="\t"}{sub("bedFile4", "bedFile"); print}' configurationFile4.txt > configurationFile.txt
awk 'BEGIN{OFS="\t"}{sub("bedFile4", "bedFile"); print}' configurationFile4_early.txt > configurationFile_early.txt
awk 'BEGIN{OFS="\t"}{sub("bedFile4", "bedFile"); print}' configurationFile4_late.txt > configurationFile_late.txt
ngs.plot.r -SC global -GO none -G mm9 -R bed -C configurationFile.txt -F chipseq -XYL 0 -L 2500 -O ${type}_Pol2Clust
#ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_early.txt -F chipseq -XYL 0 -L 2500 -O ${type}_Pol2Clust_early
#ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_late.txt -F chipseq -XYL 0 -L 2500 -O ${type}_Pol2Clust_late
echo done
