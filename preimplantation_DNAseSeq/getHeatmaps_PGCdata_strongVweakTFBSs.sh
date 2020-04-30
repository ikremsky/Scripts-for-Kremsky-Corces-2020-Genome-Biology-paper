strength=weak
motif=All_${strength}
region=distal
HiFile=all.fpkm

cd bed_shifted/All
cat /media/4TB4/isaac/PGC_RNAseq/sequences/All_${strength}TFBS.bed > all.fpkm

fileEnd=_OmniATACseq_x115_TF_sortatfimo_${motif}.justHiandLo.fpkm
fileEnd2=_pooled.sorted.duprmvdatfimo_${motif}.justHiandLo.fpkm
rm *$fileEnd
getFiles ()
{
	intersectBed -u -a $file -b $HiFile > $(basename $file .fpkm)_${strength}.justHiandLo.fpkm
#	intersectBed -u -a $file -b $LoFile >> $(basename $file .fpkm).justHiandLo.fpkm
}
for file in $(ls *All.fpkm | grep -v female)
do
	getFiles &
done
wait

#R --vanilla --args ${motif}_${region} _${fileEnd} E9.5_${fileEnd} E10.5_${fileEnd} E12.5_male_${fileEnd} E13.5_female_${fileEnd} E13.5_male_${fileEnd} E14.5_female_${fileEnd}  E14.5_male_${fileEnd} E16.5_female_${fileEnd}  E16.5_male_${fileEnd} < /media/4TB4/isaac/PGC_DNAseseq/getHeatmaps.R
R --vanilla --args ${motif}_${region} ${fileEnd} ${fileEnd2} Cont_Sperm${fileEnd} Pronuclei_Pat_PN3${fileEnd2} Pronuclei_Pat_PN5${fileEnd2} 2Cell${fileEnd2} 4Cell${fileEnd2} 8Cell${fileEnd2} Morula${fileEnd2} ESC${fileEnd2} < /mnt/bigmama/isaac/DNAseSeq/getHeatmaps_PGCdata.R

#wc -l $HiFile
#wc -l E9.5Hi_E14.5mLo.distal.fpkm
#head All_distal.bed
