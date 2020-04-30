motif=All
region=distal
compareStage=PGC

motifFile=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm
ctrlFile=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm

intersectBed -u -a $ctrlFile -b CpGislandss_mm9.bed > temp.bed
intersectBed -v -a $ctrlFile -b CpGislandss_mm9.bed > temp2.bed

ctrlFile=temp.bed

sh getSequence_fastaFromBed.sh $motifFile &
sh getSequence_fastaFromBed.sh $ctrlFile &
wait

for file in $motifFile $ctrlFile
do
	outFile=$(basename $file .bed).fa
	grep -v ">" $outFile | awk '{n=length($1)/2; x=toupper($1); print gsub("CG", "", x)/n}' > $(basename $file .fpkm).CpGdensity &
done
wait
R --vanilla --args $(basename $motifFile .fpkm).CpGdensity $(basename $ctrlFile .fpkm).CpGdensity boxplot_CpGdensity_E14.5mHivsCpGislands < getBoxPlots.R

ctrlFile=temp2.bed
sh getSequence_fastaFromBed.sh $ctrlFile
for file in $ctrlFile
do
        outFile=$(basename $file .bed).fa
        grep -v ">" $outFile | awk '{n=length($1)/2; x=toupper($1); print gsub("CG", "", x)/n}' > $(basename $file .fpkm).CpGdensity &
done
R --vanilla --args $(basename $motifFile .fpkm).CpGdensity $(basename $ctrlFile .fpkm).CpGdensity boxplot_CpGdensity_E14.5mHivsnonCpGislands < getBoxPlots.R

