motif=All
region=distal
newDir=heatmaps_E14.5m/
mkdir $newDir
cd $newDir

HiFile=../PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm
LoFile=../PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm
tissue=WTAdultIntestinalEpithelium

meFile=$(ls /Zulu/isaac/BSseq_mouseIntestine/bed/${tissue}*_meth.hiConfidence.bed)
E75File=/mnt/isaachd/methylationCellData/bed/GSM1386025_E75_mc_CG_plus.mm9.hiConfidence.bed
#rm *.me
#intersectBed -wa -wb -a $meFile -b $E75File | cut -f 1-6 > ${tissue}_both.hiConfidence.me &
#intersectBed -wa -wb -a $meFile -b $E75File | cut -f 7- > E7.5_both.hiConfidence.me &
wait
#paste ${tissue}_both.hiConfidence.me E7.5_both.hiConfidence.me | awk '$10 < .2' | cut -f 1-6 > ${tissue}_both.hiConfidence.E7.5meLo.me & 
#paste ${tissue}_both.hiConfidence.me E7.5_both.hiConfidence.me | awk '$10 < .2' | cut -f 7- > E7.5_both.hiConfidence.E7.5meLo.me & 
#paste ${tissue}_both.hiConfidence.me E7.5_both.hiConfidence.me | awk '$10 > .8' | cut -f 1-6 > ${tissue}_both.hiConfidence.E7.5meHi.me & 
#paste ${tissue}_both.hiConfidence.me E7.5_both.hiConfidence.me | awk '$10 > .8' | cut -f 7- > E7.5_both.hiConfidence.E7.5meHi.me & 
wait
wc -l *E7.5me*.me
getFiles ()
{
	intersectBed -u -a $file -b $HiFile > $(basename $file .me).DNAseHi.me &
	intersectBed -u -a $file -b $LoFile > $(basename $file .me).DNAseLo.me &
	wait
}
for file in 
#${tissue}_both.hiConfidence.E7.5meLo.me E7.5_both.hiConfidence.E7.5meLo.me ${tissue}_both.hiConfidence.E7.5meHi.me E7.5_both.hiConfidence.E7.5meHi.me
#${tissue}_both.hiConfidence.me E7.5_both.hiConfidence.me
do
	getFiles &
done
wait
wc -l *.me
fileEnd=_both.hiConfidence.DNAseHi.me
#R --vanilla --args ${motif}_E14.5mHi ${fileEnd} E7.5${fileEnd} WTAdultIntestinalEpithelium${fileEnd} < getHeatmaps.R
fileEnd=_both.hiConfidence.DNAseLo.me
#R --vanilla --args ${motif}_E14.5mLo ${fileEnd} E7.5${fileEnd} WTAdultIntestinalEpithelium${fileEnd} < getHeatmaps.R
for fileEnd in _both.hiConfidence.E7.5meHi.DNAseHi.me _both.hiConfidence.E7.5meHi.DNAseLo.me _both.hiConfidence.E7.5meLo.DNAseHi.me _both.hiConfidence.E7.5meLo.DNAseLo.me
do
	R --vanilla --args ${motif}_allCpGs_$(basename $fileEnd .me) ${fileEnd} E7.5${fileEnd} WTAdultIntestinalEpithelium${fileEnd} < ../getHeatmaps.R
done
echo $(wc -l WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meHi.DNAseHi.me | cut -f1 -d" ") $(wc -l WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meLo.DNAseHi.me | cut -f1 -d" ") | awk '{gsub(" ", "\t"); print}'
echo $(wc -l WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meHi.DNAseLo.me | cut -f1 -d" ") $(wc -l WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meLo.DNAseLo.me | cut -f1 -d" ") | awk '{gsub(" ", "\t"); print}'
#echo $(echo $(awk '$4 > .8' WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meHi.DNAseHi.me | wc -l) \
#$(wc -l WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meHi.DNAseHi.me | cut -f1 -d" ") | awk '{print $1/$2}') \
#$(echo $(awk '$4 < .2' WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meLo.DNAseHi.me | wc -l) \
#$(wc -l WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meLo.DNAseHi.me | cut -f1 -d" ") | awk '{print $1/$2}')

#echo $(echo $(awk '$4 > .8' WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meHi.DNAseLo.me | wc -l) \
#$(wc -l WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meHi.DNAseLo.me | cut -f1 -d" ") | awk '{print $1/$2}') \
#$(echo $(awk '$4 < .2' WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meLo.DNAseLo.me | wc -l) \
#$(wc -l WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meLo.DNAseLo.me | cut -f1 -d" ") | awk '{print $1/$2}')
