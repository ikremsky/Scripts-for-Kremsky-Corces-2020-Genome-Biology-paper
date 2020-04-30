#intersectBed -f .5 -F .5 -e -u -a ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks_proximal.bed &
#intersectBed -f .5 -F .5 -e -v -a ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > ~/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks_distal.bed &
#wait
controlBed=/hdisk6/yoonhee/Downloads/GSE76642_GVooyte_PN5_DnaseSeq_Cell_2016/GV_Oocyte_14d_Dnase-seq_pooled_MACS_wiggle/GV_Oocyte_14d_Dnase-seq_pooled_peaks.bed
intersectBed -f .5 -F .5 -e -u -a $controlBed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > oocyte_proximal.bed &
intersectBed -f .5 -F .5 -e -v -a $controlBed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed > oocyte_distal.bed &
wait

distalBed=/hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks_distal.bed
proximalBed=/hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks_proximal.bed
colors="red orange yellow green blue purple brown cyan blue1 blue2 blue3 red"
type=DNAse-seq

intersectBed -v -a $proximalBed -b oocyte_proximal.bed > spermSpecific_proximal.bed
intersectBed -v -b $proximalBed -a oocyte_proximal.bed > oocyteSpecific_proximal.bed

intersectBed -v -a $distalBed -b oocyte_distal.bed > spermSpecific_distal.bed
intersectBed -v -b $distalBed -a oocyte_distal.bed > oocyteSpecific_distal.bed

rm configurationFile_proximal.txt configurationFile_distal.txt configurationFile_spermSpecific_proximal.txt configurationFile_spermSpecific_distal.txt configurationFile_oocyteSpecific_proximal.txt configurationFile_oocyteSpecific_distal.txt
i=2
for stage in Sperm GVOocyte_14d Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 Pronuclei_Pat_PN5 Pronuclei_Mat_PN5 1Cell 2Cell 4Cell 8Cell Morula
do
	testLab=$stage
	bamFile=bam/${stage}_pooled.sorted.duprmvd.bam
	color=$(echo $colors | cut -f $i -d" ")
	echo $color
	#macs2 predictd -i $bamFile 2> $(basename $bamFile .bam).fraglen.txt &
	fl=$(grep "predicted fragment length is" bam/$(basename $bamFile .bam).fraglen.txt | cut -f2 -d"#" | awk '{gsub("predicted fragment length is ", ""); gsub(" bps" , ""); gsub(" ", ""); print}')

	echo "${bamFile} ${proximalBed} ${testLab} ${fl} $color" | awk '{gsub(" ", "\t"); print}' > configurationFile_proximal${stage}.txt
        echo "${bamFile} ${distalBed} ${testLab} ${fl} $color" | awk '{gsub(" ", "\t"); print}' > configurationFile_distal${stage}.txt

        echo "${bamFile} spermSpecific_proximal.bed ${testLab} ${fl} $color" | awk '{gsub(" ", "\t"); print}' > configurationFile_spermSpecific_proximal${stage}.txt
        echo "${bamFile} spermSpecific_distal.bed ${testLab} ${fl} $color" | awk '{gsub(" ", "\t"); print}' > configurationFile_spermSpecific_distal${stage}.txt

        echo "${bamFile} oocyteSpecific_proximal.bed ${testLab} ${fl} $color" | awk '{gsub(" ", "\t"); print}' > configurationFile_oocyteSpecific_proximal${stage}.txt
        echo "${bamFile} oocyteSpecific_distal.bed ${testLab} ${fl} $color" | awk '{gsub(" ", "\t"); print}' > configurationFile_oocyteSpecific_distal${stage}.txt
	i=$(expr $i + 1)
#       ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_proximal${stage}.txt -F chipseq -XYL 0 -L 2500 -O ${type}_${stage}_proximal &
#       ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_distal${stage}.txt -F chipseq -XYL 0 -L 2500 -O ${type}_${stage}_distal &
#       ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_spermSpecific_proximal${stage}.txt -F chipseq -XYL 0 -L 2500 -O ${type}_${stage}_spermSpecific_proximal &
#       ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_spermSpecific_distal${stage}.txt -F chipseq -XYL 0 -L 2500 -O ${type}_${stage}_spermSpecific_distal &
#       ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_oocyteSpecific_proximal${stage}.txt -F chipseq -XYL 0 -L 2500 -O ${type}_${stage}_oocyteSpecific_proximal &
#       ngs.plot.r -GO none -G mm9 -R bed -C configurationFile_oocyteSpecific_distal${stage}.txt -F chipseq -XYL 0 -L 2500 -O ${type}_${stage}_oocyteSpecific_distal
	cat configurationFile_proximal${stage}.txt >> configurationFile_proximal.txt
	cat configurationFile_spermSpecific_proximal${stage}.txt >> configurationFile_spermSpecific_proximal.txt
	cat configurationFile_oocyteSpecific_proximal${stage}.txt >> configurationFile_oocyteSpecific_proximal.txt
	cat configurationFile_distal${stage}.txt >> configurationFile_distal.txt
	cat configurationFile_spermSpecific_distal${stage}.txt >> configurationFile_spermSpecific_distal.txt
	cat configurationFile_oocyteSpecific_distal${stage}.txt >> configurationFile_oocyteSpecific_distal.txt
done
wait
ngs.plot.r -GO km -KNC 5 -G mm9 -R bed -C configurationFile_proximal.txt -F chipseq -XYL 0 -L 2500 -O ${type}_proximal_km &
#ngs.plot.r -GO km -KNC 5 -G mm9 -R bed -C configurationFile_spermSpecific_proximal.txt -F chipseq -XYL 0 -L 2500 -O ${type}_spermSpecific_proximal_km &
#ngs.plot.r -GO km -KNC 5 -G mm9 -R bed -C configurationFile_oocyteSpecific_proximal.txt -F chipseq -XYL 0 -L 2500 -O ${type}_oocyteSpecific_proximal_km &
ngs.plot.r -GO km -KNC 3  -G mm9 -R bed -C configurationFile_distal.txt -F chipseq -XYL 0 -L 2500 -O ${type}_distal_km &
ngs.plot.r -GO km -KNC 3 -G mm9 -R bed -C configurationFile_spermSpecific_distal.txt -F chipseq -XYL 0 -L 2500 -O ${type}_spermSpecific_distal_km &
ngs.plot.r -GO km -KNC 3 -G mm9 -R bed -C configurationFile_oocyteSpecific_distal.txt -F chipseq -XYL 0 -L 2500 -O ${type}_oocyteSpecific_distal &
wait
