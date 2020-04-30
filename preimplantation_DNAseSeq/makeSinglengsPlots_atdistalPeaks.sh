#intersectBed -f .5 -F .5 -e -u -a ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed &
#intersectBed -f .5 -F .5 -e -v -a ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks_distal.bed &
#wait

TF=Enhancers

files="/hdisk6/yoonhee/MAnorm_Linux_R_Package/MII-Sperm_MAnorm1/coverage_allembryos_Sperm-specific-40120/Sperm-specific_40120_PN3-PN5-P_2C-4C-8C-Mor_15095_ordered.bed /hdisk6/yoonhee/MAnorm_Linux_R_Package/MII-Sperm_MAnorm1/coverage_allembryos_MII-specific-17258/MII-specific-17258_PN3-PN5-M-2C-4C-8C-Mor_RPKM2_6611_ordered.bed /hdisk6/yoonhee/MAnorm_Linux_R_Package/MII-Sperm_MAnorm1/coverage_allembryos_MII-SP-overlap-10369/MII-SP-overlap-10369_allembryo-RPKM2_7932_ordered.bed"
#"/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/Sperm-specific-E_GVOocyteFPKMlt1.bed /hdisk6/yoonhee/MAnorm_Linux_R_Package/MII-Sperm_MAnorm1/coverage_allembryos_MII-specific-17258/MII-specific-17258_PN3-PN5-M-2C-4C-8C-Mor_RPKM2_6611_ordered.bed /hdisk6/yoonhee/MAnorm_Linux_R_Package/MII-Sperm_MAnorm1/coverage_allembryos_MII-SP-overlap-10369/MII-SP-overlap-10369_allembryo-RPKM2_7932_ordered.bed"
#/hdisk6/yoonhee/MAnorm_Linux_R_Package/MII-Sperm_MAnorm1/coverage_allembryos_Sperm-specific-40120/Sperm-specific_40120_PN3-PN5-P_2C-4C-8C-Mor_15095_ordered.bed
#CONT_SPERM_Foxa1_Rep1-2_pooled_bowtie2_withINPUT_peaks_withsummit_nonTSS500bp_5163.fpkmGT3.bed
#/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/Sperm_GVoocyte_merged.bed
#/hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed
#GVOocyte_ATAC
#/hdisk6/yoonhee/ATAC-seq_rawdata/GVoocyte/GVoocyte_Rep1-2_pooled_x115_TF_MACS_wiggle/GVoocyte_Rep1-2_pooled_x115_TF_peaks_28439.bed
#Sperm_ATAC
#/hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed
#FoxA1
#/hdisk6/yoonhee/Rawdata/CONT_SPERM_TranscriptionFactor_ChiPseq/CONT_SPERM_Foxa1_Rep1-2/Pooled_Rep1-2_bowtie2/CONT_SPERM_Foxa1_Rep1-2_pooled_bowtie2_withINPUT_MACS_wiggle/CONT_SPERM_Foxa1_Rep1-2_pooled_bowtie2_withINPUT_peaks_withsummit_nonTSS500bp_5163.bed
#/hdisk6/yoonhee/Rawdata/Oct.4.2016_ChiPseq_reseq/CONT_SPERM_Foxa1_rep1-2_pooled_withINPUT_MACS_wiggle/CONT_SPERM_Foxa1_rep1-2_pooled_withINPUT_peaks.bed

#/hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/peaks_yonnhee_CTCF_S-RS_overlapped_24026.bed
#/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/OmniATACseq_at_Sperm_GVoocyte_merged_distal_sortedBySperm-Oocyte.fpkm
#/hdisk6/yoonhee/Rawdata/CONT_SPERM_TranscriptionFactor_ChiPseq/CONT_SPERM_Foxa1_Rep1-2/Pooled_Rep1-2_bowtie2/CONT_SPERM_Foxa1_Rep1-2_pooled_bowtie2_withINPUT_MACS_wiggle/CONT_SPERM_Foxa1_Rep1-2_pooled_bowtie2_withINPUT_peaks_withsummit_nonTSS500bp_5163.bed
#CTCFubiquitous_motifs
#/mnt/bigmama/isaac/Mouse_CTCF_ChIPs/ubiquitousCTCFmotifs.bed
#CTCF_motifs
#mikesCTCFmotifs_mm9.bed
#CTCF
#/hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/peaks_yonnhee_CTCF_S-RS_overlapped_24026.bed

#All ATAC
#/hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks_distal.bed
#NFYB:
#/hdisk2/isaac/ATACseqAnalysis/footprints_Sperm_Control_yoonheepks/fimo_MA0502.1.bed
colors="brown red orange green blue purple grey brown black red orange yellow green blue purple brown red orange green blue purple grey brown black red orange yellow green blue purple brown red orange green blue purple grey brown black red orange yellow green blue purple"
type=DNAse-seq_${TF}_distal

rm temp2.bed
i=1
for bedFile in 
#$files
do
	if [ -e $(basename $bedFile .bed).fpkm ]; then
		echo RPKM file exists
	else
		awk 'BEGIN{OFS="\t"}{print $1,$2,$3,NR,".","+"}' $bedFile > $(basename $bedFile .bed).mod.bed
		M=$(awk -v x=Sperm_ATAC  'BEGIN{count=0}{if($2~"^"x"_pooled") count+=$1/1000000}END{print count}' bed/readCounts)
		coverageBed -a $(basename $bedFile .bed).mod.bed -b bed/Sperm_ATAC_pooled.sorted.duprmvd.bed | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $1,$2,$3,$4,$7/(K*M)}' > $(basename $bedFile .bed).fpkm &
		N=$(awk -v x=GVoocyteATAC_Rep1-2 'BEGIN{count=0}{if($2~"^"x"_pooled") count+=$1/1000000}END{print count}' bed/readCounts)
		coverageBed -a $(basename $bedFile .bed).mod.bed -b bed/MIIoocyteATACrep1_pooled.sorted.duprmvd.bed  | awk -v M=$N 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $1,$2,$3,$4,$7/(K*M)}' > $(basename $bedFile .bed).oocyte.fpkm &
		wait
	fi
	if [ $(basename $bedFile | awk '{if($0 ~ "MII-specific") print 1; else print 0}') -eq 1 ]; then
		basename $bedFile
		echo sorting by oocyte FPKM
		intersectBed -v -a $(basename $bedFile .bed).oocyte.fpkm -b /mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/TSSclusters_ATAC_Pol2s5.bed | awk -v i=$i 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1,NR"_"i,$5,"+"}' > temp.bed
	else
		intersectBed -v -a $(basename $bedFile .bed).fpkm -b /mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/TSSclusters_ATAC_Pol2s5.bed | awk -v i=$i 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1,NR"_"i,$5,"+"}' > temp.bed
		#intersectBed -f 1 -F 1 -wo -a $(basename $bedFile .bed).fpkm -b $(basename $bedFile .bed).oocyte.fpkm | awk 'BEGIN{OFS="\t"}{if($5 > $10) base=$5; else base=$10; print $1,$2,$3,NR,($5-$10)/base,"+"}' > temp.bed
	fi
	sort -k5gr,5 temp.bed >> temp2.bed
	i=$(expr $i + 1)
done
bedFile=temp2.bed
cat /media/4TB4/isaac/PGC_DNAseseq/bed/All/All_distal.bed | awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1,NR,".","+"}' > bedFile.bed


rm configurationFile*
i=2
for k in 1
do
	bedFile=bedFile${k}.bed
	awk -v cluster=$k '$5 == cluster' $clusterFile > bedFile${k}.bed
	i=2
	for stage in RS GVOocyte_ATAC Sperm_ATAC Pronuclei_Mat_PN3 Pronuclei_Pat_PN3 Pronuclei_Mat_PN5 Pronuclei_Pat_PN5 2Cell 4Cell 8Cell Morula E9.5_PGC E10.5_PGC E12.5_female_PGC E12.5_male_PGC E14.5_female_PGC E14.5_male_PGC E16.5_female_PGC E16.5_male_PGC
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
waitwait
#ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_early.txt -F chipseq -XYL 0 -L 2000 -O ${type}_early
#ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_late.txt -F chipseq -XYL 0 -L 2000 -O ${type}_late
ngs.plot.r -SC global -GO none -G mm9 -R bed -C configurationFile.txt -F chipseq -XYL 0 -L 2500 -O ${type} -LWD 6

