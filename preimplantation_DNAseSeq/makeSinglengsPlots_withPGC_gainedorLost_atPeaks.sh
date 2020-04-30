type=PGC_E14.5mHi
TF=All
region=distal
#files="/media/4TB4/isaac/PGC_DNAseseq/bed/${TF}/E9.5Hi_E14.5mLo.distal.fpkm"
files="/media/4TB4/isaac/PGC_DNAseseq/bed/${TF}/E9.5Lo_E14.5mHi.distal.fpkm"
colors="brown red orange yellow green blue purple black red orange yellow green blue purple black grey brown cyan blue1 blue2 blue3 red2 green3 red3 red4 yellow2"
rm configurationFile*
i=2
bedFile=bedFile.bed
cat $files | awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1,$4,$5,$6}' > bedFile.bed
#cat /media/4TB4/isaac/PGC_DNAseseq/bed/${TF}/${TF}_distal.bed | awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos,pos+1,NR,".","+"}' > bedFile.bed
for k in 1 
do
	i=2
	for stage in Sperm_ATAC Pronuclei_Pat_PN3 Pronuclei_Pat_PN5 2Cell 4Cell 8Cell Morula ICM ESC
#RS GVOocyte_ATAC Sperm_ATAC Pronuclei_Mat_PN3 Pronuclei_Pat_PN3 Pronuclei_Mat_PN5 Pronuclei_Pat_PN5 2Cell 4Cell 8Cell Morula E9.5_PGC E10.5_PGC E12.5_female_PGC E12.5_male_PGC E14.5_female_PGC E14.5_male_PGC E16.5_female_PGC E16.5_male_PGC
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
											if [ $(echo $stage | awk '{if($1 == "ICM") print 1; else print 0}') -eq 0 ]; then
												if [ $(echo $stage | awk '{if($1 == "ESC") print 1; else print 0}') -eq 0 ]; then
													bamFile=bam/${stage}_pooled.sorted.duprmvd.bam
													fl=50
												else
													bamFile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/bam/ESC-Rep1-2_pooled_x115-TF.sorted.bam
													#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
													fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
												fi
											else
												bamFile=/mnt/isaachd/ATAC-seq_naturedata/bam_mm9/ICM_pooled.sorted.duprmvd.TFs.bam
#												bamFile=/mnt/isaachd/ATAC-seq_naturedata/bam_mm9/ICM_pooled.sorted.duprmvd.bam
#												#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
												fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
											fi
										else
											bamFile=/Zulu/isaac/RS/bam/RS_WT_pooled.sorted.duprmvd.bam
											#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
											fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
										fi
									else
				                                               stage=$(echo $stage | awk '{sub("_PGC", ""); print}')
                        				                       bamFile=/media/4TB4/isaac/PGC_DNAseseq/bam/${stage}_pooled.sorted.duprmvd.bam
										fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
									fi
								else
									bamFile=/Zulu/isaac/ATACseq_Hannah/bam/fPN_rep1.sorted.duprmvd.TFs.sorted.bam
									#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
									fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
								fi
							else
								bamFile=/hdisk2/isaac/ATACseqAnalysis/pooled/MIIoocyterep1_mm9.rmdup.flt.TF.sorted.bam
								#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
								fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
							fi
						else
							bamFile=/hdisk2/isaac/ATACseqAnalysis/pooled/GVoocyte_Rep1-2_pooled_x115_TF.sorted.bam
							#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
							fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
						fi
					else
						bamFile=bam/CONT_SPERM_RNAPIIS2p_Pooled-Rep1-2.bam
						fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
					fi
				else
					bamFile=/hdisk6/yoonhee/Rawdata/CONT_SPERM_TranscriptionFactor_ChiPseq/CONT_SPERM_RNAPIIS5p_Rep1-2/Pooled_Rep1-2/CONT_SPERM_RNAPIIS5p_Pooled-Rep1-2.bam
					fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
				fi
			else
				bamFile=bam/Dnaseq_GV-Oocyte_combined_sort_rmdup.bam
				fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
			fi
			#macs2 predictd -i $bamFile 2> bam/$(basename $bamFile .bam).fraglen.txt
			#fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')
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
		cat configurationFile${stage}.txt >> configurationFile.txt
                cat configurationFile${stage}.txt >> configurationFile${k}_${time}.txt
	done
	wait
#	ngs.plot.r -GO km -KNC 4 -G mm9 -R bed -C configurationFile.txt -F chipseq -XYL 0 -L 2500 -O ${type}_Pol2Clust$k
#	 Rscript ExtractGName.R DNAse-seq_Pol2Clust$k
done
wait
#ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_early.txt -F chipseq -XYL 0 -L 2000 -O ${type}_early
#ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_late.txt -F chipseq -XYL 0 -L 2000 -O ${type}_late
ngs.plot.r -SC global -GO hc -G mm9 -R bed -C configurationFile.txt -F chipseq -XYL 0 -L 2500 -O ${type} -LWD 6 -RR 5

