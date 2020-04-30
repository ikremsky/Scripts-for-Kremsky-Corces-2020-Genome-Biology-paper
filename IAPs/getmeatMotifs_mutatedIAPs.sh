motif=All
#$1
region=distal
compareStage=IAPmutation
fimo=/media/4TB4/isaac/PGC_DNAseseq/bed/${motif}/fimo_${motif}.forigv.bed

motifFile=hiMut.bed
ctrlFile=lowMut.bed

name1="high mutation IAPs"
name2="low mutation IAPs"

rm counts.txt
onePosSample () {
        yLabel="% meCpG/CpG"
        name_1="ATAC-Seq peaks"
        name_2="random peaks"
        outName="$type"
        dataLab="$type"
        RefLabel="peak center"
	altType=$(basename $bedFile | cut -f1 -d"_")

	echo $bedFile
	echo $M
	if [ -e ${type}_${motif}_${compareStage}_${region}.me ]; then
        	echo file exists
        else
                intersectBed -u -a $bedFile -b $motifFile | awk 'BEGIN{OFS="\t"}{print $4,$5+$6}' > ${type}_${motif}_${compareStage}_${region}.me &
		intersectBed -u -a $bedFile -b $motifFile > ${type}_${motif}_${compareStage}_${region}.bed &
                intersectBed -u -a $bedFile -b $ctrlFile | awk 'BEGIN{OFS="\t"}{print $4,$5+$6}' > ${type}_${motif}_${compareStage}_${region}_ctrl.me &
		intersectBed -u -a $bedFile -b $ctrlFile >  ${type}_${motif}_${compareStage}_${region}_ctrl.bed &
		intersectBed -u -a $bedFile -b $motifFile | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,$5+$6}' > ${type}_${motif}_${compareStage}_${region}.me.bed &
	fi

	 if [ -e ${type}_all.me ]; then 
                echo ${type}_all.me exists
        else
		awk 'BEGIN{OFS="\t"}{print $4,$5+$6}' $bedFile > ${type}_all.me &
	fi
	wait
	awk '$5+$6 > 5 && $4 > .25'  ${type}_${motif}_${compareStage}_${region}_ctrl.bed >  ${type}_${motif}_${compareStage}_${region}_ctrl.meHi.bed
	awk '$5+$6 > 5 && $4 == 0'  ${type}_${motif}_${compareStage}_${region}_ctrl.bed >  ${type}_${motif}_${compareStage}_${region}_ctrl.meLo.bed
	intersectBed -u -a $ctrlFile -b ${type}_${motif}_${compareStage}_${region}_ctrl.meHi.bed > temp; mv temp ${type}_${motif}_${compareStage}_${region}_ctrl.meHi.bed
	intersectBed -u -a $ctrlFile -b ${type}_${motif}_${compareStage}_${region}_ctrl.meLo.bed > temp; mv temp ${type}_${motif}_${compareStage}_${region}_ctrl.meLo.bed
#	R --vanilla --args ${type}_${motif}_${compareStage}_${region}_ctrl.me ${type}_${motif}_${region}_ctrl ${compareStage} < getmeScatterPlot.R

	if [ $(grep $type avgme_${motif}_${compareStage}_${region}.txt | wc -l) -gt 0 ]; then
		echo avgme_${motif}.txt exists
	else
                R --vanilla --args ${type}_${motif}_${compareStage}_${region}.me ${type}_${motif}_${compareStage}_${region}_ctrl.me $type ${motif}_${compareStage}_${region} ${type}_all.me < getWeightedMeanandSD_disalPeaks_IAPmut.R
	fi
}
strain=paternal
for type in $(cut -f4 /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | sort | uniq | grep -e LTR1a -e LTR2_)
do
	rm avgme.txt
	awk '$7 > 15' ${type}_final.bed | cut -f1-6 > hiMut.bed
	awk '$7 < 3' ${type}_final.bed | cut -f1-6 > lowMut.bed

	for bedFile in /Zulu/isaac/PGCme/bed/E13.5mBS-Seq_meth.bed
	do
	        echo $bedFile
	        echo $type
	        onePosSample
	done
	wait
	N_accessible=$(cat $motifFile | wc -l)
	N_inaccessible=$(cat $ctrlFile | wc -l)
	echo $type $N_accessible $N_inaccessible >> counts.txt
done
R --vanilla --args avgme_${motif}_${compareStage}_${region}.txt ${motif}_$region ${compareStage} $N_accessible $N_inaccessible "$name1" "$name2" < getLinePlot_distalPeaks.R
cat counts.txt
