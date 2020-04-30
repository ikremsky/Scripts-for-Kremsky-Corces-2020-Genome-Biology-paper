motif=All
region=distal
newDir=heatmaps_methylation/
mkdir $newDir
cd $newDir
start=E9.5
mid=E13.5m
end=E16.5m

#rm *.me
HiFile1=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm
LoFile1=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm

awk '$5+$6 > 9' /Zulu/isaac/PGCme/bed/E9.5BS-Seq_meth.bed > E9.5BS-Seq_meth.hiConf.bed &
awk '$5+$6 > 9' /Zulu/isaac/PGCme/bed/E13.5mBS-Seq_meth.bed > E13.5mBS-Seq_meth.hiConf.bed &
awk '$5+$6 > 9' /Zulu/isaac/PGCme/bed/E16.5mBS-Seq_meth.bed > E16.5mBS-Seq_meth.hiConf.bed &
wait

meFile1=E6.5BS-Seq_meth.hiConf.bed
meFile2=E13.5mBS-Seq_meth.hiConf.bed
meFile3=E16.5mBS-Seq_meth.hiConf.bed


#intersectBed -u -a $meFile1 -b $meFile2 > temp
#intersectBed -u -a $meFile3 -b temp > temp2
rm temp
intersectBed -u -a $meFile1 -b temp2 | sort -k1,1 -k2n,2 > ${start}_both.hiConfidence.me &
intersectBed -u -a $meFile2 -b temp2 | sort -k1,1 -k2n,2 > ${mid}_both.hiConfidence.me &
intersectBed -u -a $meFile3 -b temp2 | sort -k1,1 -k2n,2 > ${end}_both.hiConfidence.me &
wait

getFiles ()
{
	intersectBed -u -a $file -b $HiFile1 > $(basename $file .me).$(basename $HiFile1 .bed).me &
	intersectBed -u -a $file -b $LoFile1 > $(basename $file .me).$(basename $LoFile1 .bed).me &
	wait
}
for file in ${start}_both.hiConfidence.me ${mid}_both.hiConfidence.me ${end}_both.hiConfidence.me
do
	getFiles &
done
wait
wc -l *.me
for fileEnd in _both.hiConfidence.$(basename $HiFile1 .bed).me _both.hiConfidence.$(basename $LoFile1 .bed).me
do
	R --vanilla --args E14.5mHivLoCpGs$(basename $fileEnd .me) ${fileEnd} ${start}${fileEnd}  ${mid}${fileEnd} ${end}${fileEnd} < ../getHeatmaps_methylation_E14.5mHi.R
done

wc -l ${start}_both.hiConfidence.$(basename $HiFile1 .bed).me ${start}_both.hiConfidence.$(basename $LoFile1 .bed).me
