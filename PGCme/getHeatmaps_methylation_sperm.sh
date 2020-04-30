motif=All
region=distal
newDir=heatmaps_methylation_epiblast_sperm/
mkdir $newDir
cd $newDir
start=E6.5
end=sperm

#rm *.me
HiFile1=/Zulu/isaac/PGCme/bed/E6.5BS-Seq_meth.meHi.bed
LoFile1=/Zulu/isaac/PGCme/bed/E6.5BS-Seq_meth.meLo.bed
HiFile2=/mnt/isaachd/methylationCellData/bed/GSM1386020_sperm_mc_CG_plus.mm9.meHi.bed
LoFile2=/mnt/isaachd/methylationCellData/bed/GSM1386020_sperm_mc_CG_plus.mm9.meLo.bed

meFile1=/Zulu/isaac/PGCme/bed/E6.5BS-Seq_meth.hiConf.bed
meFile2=/mnt/isaachd/methylationCellData/bed/GSM1386020_sperm_mc_CG_plus.mm9.hiConfidence.bed


#intersectBed -wa -wb -a $meFile1 -b $meFile2 | cut -f 1-6 > ${start}_both.hiConfidence.me &
#intersectBed -wa -wb -a $meFile1 -b $meFile2 | cut -f 7- > ${end}_both.hiConfidence.me &
wait

#paste ${start}_both.hiConfidence.me ${end}_both.hiConfidence.me | awk '$10 < .2' | cut -f 1-6 > ${start}_both.hiConfidence.meLo.me & 
#paste ${start}_both.hiConfidence.me ${end}_both.hiConfidence.me | awk '$10 < .2' | cut -f 7- > ${end}_both.hiConfidence.meLo.me & 
#paste ${start}_both.hiConfidence.me ${end}_both.hiConfidence.me | awk '$10 > .8' | cut -f 1-6 > ${start}_both.hiConfidence.meHi.me & 
#paste ${start}_both.hiConfidence.me ${end}_both.hiConfidence.me | awk '$10 > .8' | cut -f 7- > ${end}_both.hiConfidence.meHi.me &
wait

getFiles ()
{
	intersectBed -u -a $file -b $HiFile1 > $(basename $file .me).$(basename $HiFile1 .bed).me &
	intersectBed -u -a $file -b $LoFile1 > $(basename $file .me).$(basename $LoFile1 .bed).me &
        intersectBed -u -a $file -b $HiFile2 > $(basename $file .me).$(basename $HiFile2 .bed).me &
        intersectBed -u -a $file -b $LoFile2 > $(basename $file .me).$(basename $LoFile2 .bed).me &
	wait
}
for file in 
#${start}_both.hiConfidence.me ${end}_both.hiConfidence.me
do
	getFiles &
done
wait
#wc -l *.me
for fileEnd in 
#_both.hiConfidence.$(basename $HiFile1 .bed).me _both.hiConfidence.$(basename $LoFile1 .bed).me
do
	R --vanilla --args allCpGs_$(basename $fileEnd .me) ${fileEnd} ${start}${fileEnd} ${end}${fileEnd} < ../getHeatmaps_methylation.R
done

for fileEnd in 
#_both.hiConfidence.$(basename $HiFile2 .bed).me _both.hiConfidence.$(basename $LoFile2 .bed).me
do
        R --vanilla --args allCpGs_$(basename $fileEnd .me) ${fileEnd} ${start}${fileEnd} ${end}${fileEnd} < ../getHeatmaps_methylation2.R
done
echo $(wc -l ${start}_both.hiConfidence.$(basename $HiFile1 .bed).me | cut -f1 -d" ") $(wc -l ${start}_both.hiConfidence.$(basename $HiFile2 .bed).me | cut -f1 -d" ")
echo $(wc -l ${start}_both.hiConfidence.$(basename $LoFile1 .bed).me | cut -f1 -d" ") $(wc -l ${start}_both.hiConfidence.$(basename $LoFile2 .bed).me | cut -f1 -d" ")

echo $(echo $(awk '$4 > .8' ${end}_both.hiConfidence.$(basename $HiFile1 .bed).me | wc -l) \
$(wc -l ${start}_both.hiConfidence.$(basename $HiFile1 .bed).me | cut -f1 -d" ") | awk '{print $1/$2}' ) \
$(echo $(awk '$4 > .8' ${start}_both.hiConfidence.$(basename $HiFile2 .bed).me | wc -l) $(wc -l ${start}_both.hiConfidence.$(basename $HiFile2 .bed).me | cut -f1 -d" ") | awk '{print $1/$2}') "|" \
$(echo $(awk '$4 > .5' ${start}_both.hiConfidence.$(basename $HiFile2 .bed).me | wc -l) $(wc -l ${start}_both.hiConfidence.$(basename $HiFile2 .bed).me | cut -f1 -d" ") | awk '{print $1/$2}')
echo $(echo $(awk '$4 < .2' ${end}_both.hiConfidence.$(basename $LoFile1 .bed).me | wc -l) \
$(wc -l ${start}_both.hiConfidence.$(basename $LoFile1 .bed).me | cut -f1 -d" ") | awk '{print $1/$2}') \
$(echo $(awk '$4 < .2' ${start}_both.hiConfidence.$(basename $LoFile2 .bed).me | wc -l) $(wc -l ${start}_both.hiConfidence.$(basename $LoFile2 .bed).me | cut -f1 -d" ") | awk '{print $1/$2}') "|" \
$(echo $(awk '$4 < .5' ${start}_both.hiConfidence.$(basename $LoFile2 .bed).me | wc -l) $(wc -l ${start}_both.hiConfidence.$(basename $LoFile2 .bed).me | cut -f1 -d" ") | awk '{print $1/$2}')

