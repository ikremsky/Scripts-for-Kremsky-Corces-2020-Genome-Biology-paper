#intersectBed -f .5 -F .5 -e -u -a ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed &
#intersectBed -f .5 -F .5 -e -v -a ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks_distal.bed &
#wait

bedFile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/TSSclusters_ATAC_Pol2s5.bed
colors="brown red orange yellow green blue purple grey black cyan blue1 blue2 blue3 red2 red3 red4 yellow2 purple2 green2 green3 purple3 green4"
type=DNAse-seq_PGC

rm configurationFile.txt
i=2
for stage in GVOocyte Sperm_ATAC Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 Pronuclei_Pat_PN5 Pronuclei_Mat_PN5 2Cell 4Cell 8Cell Morula E9.5_PGC E10.5_PGC E12.5_female_PGC E12.5_male_PGC  E12.5_female_PGC E12.5_male_PGC E14.5_female_PGC E14.5_male_PGC E16.5_female_PGC E16.5_male_PGC
#Sperm_ATAC Sperm_Pol2s5 Sperm GVOocyte2017 GVOocyte_14d Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 Pronuclei_Pat_PN5 Pronuclei_Mat_PN5 1Cell 2Cell 4Cell 8Cell Morula
do
	testLab=$stage

        if [ $(echo $stage | awk '{if($1 == "Sperm_ATAC") print 1; else print 0}') -eq 0 ]; then
        	if [ $(echo $stage | awk '{if($1 == "GVOocyte2017") print 1; else print 0}') -eq 0 ]; then
                	if [ $(echo $stage | awk '{if($1 == "Sperm_Pol2s5") print 1; else print 0}') -eq 0 ]; then
                        	if [ $(echo $stage | awk '{if($1 == "Sperm_Pol2s2") print 1; else print 0}') -eq 0 ]; then
					if [ $(echo $stage | awk '{if($1 ~ "PGC") print 1; else print 0}') -eq 0 ]; then
						if [ $(echo $stage | awk '{if($1 ~ "GVOocyte") print 1; else print 0}') -eq 0 ]; then
	                                		bamFile=bam/${stage}_pooled.sorted.duprmvd.bam
						else
							bamFile=/hdisk2/isaac/ATACseqAnalysis/pooled/GVoocyte_Rep1-2_pooled_x115_TF.sorted.bam
#							macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
						fi
					else
						stage=$(echo $stage | awk '{sub("_PGC", ""); print}')
						bamFile=/media/4TB4/isaac/PGC_DNAseseq/bam/${stage}_pooled.sorted.duprmvd.bam
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
#               macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
		fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
        else
        	bamFile=/hdisk2/isaac/ATACseqAnalysis/pooled/Cont_Sperm_OmniATACseq_x115_TF_sort.bam
#               macs2 predictd -i $bamFile 2> /hdisk2/isaac/ATACseqAnalysis/pooled/$(basename $bamFile .bam).fraglen.txt
#		fl=$(grep "predicted fragment length is" /hdisk2/isaac/ATACseqAnalysis/pooled/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
        fi
	color=$(echo $colors | cut -f $i -d" ")
	echo $color
	#macs2 predictd -i $bamFile 2> $(basename $bamFile .bam).fraglen.txt &

	echo "${bamFile} ${bedFile} ${testLab} ${fl} $color" | awk '{gsub(" ", "\t"); print}' > configurationFile${stage}.txt

	i=$(expr $i + 1)
	cat configurationFile${stage}.txt >> configurationFile.txt
#	ngs.plot.r -GO none -G mm9 -R bed -C configurationFile${stage}.txt -F chipseq -XYL 0 -L 500 -O ${type}_${stage}Pol2Clust &
done
wait
ngs.plot.r -GO none -G mm9 -R bed -C configurationFile.txt -F chipseq -XYL 0 -L 3000 -O ${type}_Pol2Clust
