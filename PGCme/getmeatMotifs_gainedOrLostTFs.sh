motif=All
region=distal
compareStage=E9.5_E14.5
fimo=/media/4TB4/isaac/PGC_DNAseseq/bed/${motif}/fimo_${motif}.forigv.bed
rm fimo_accessible.bed fimo_inaccessible.bed

motifFile=/media/4TB4/isaac/PGC_DNAseseq/bed/${motif}/E9.5Lo_E14.5mHi.distal.fpkm
ctrlFile=/media/4TB4/isaac/PGC_DNAseseq/bed/${motif}/E9.5Hi_E14.5mLo.distal.fpkm

name1="E9.5-trace | E14.5m-Hi"
name2="E9.5-Hi | E14.5m-trace"

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
		R --vanilla --args ${type}_${motif}_${compareStage}_${region}.me ${type}_${motif}_${compareStage}_${region}_ctrl.me $type ${motif}_${compareStage}_${region} ${type}_all.me < getWeightedMeanandSD_disalPeaks.R
	fi
}
for strain in paternal
do
	rm avgme.txt
	for bedFile in /Zulu/isaac/PGCme/bed/E9.5BS-Seq_meth.bed /Zulu/isaac/PGCme/bed/E10.5BS-Seq_meth.bed /Zulu/isaac/PGCme/bed/E11.5BS-Seq_meth.bed /Zulu/isaac/PGCme/bed/E13.5mBS-Seq_meth.bed /Zulu/isaac/PGCme/bed/E16.5mBS-Seq_meth.bed
	do
	        type=$(basename $bedFile | cut -f1 -d"_" | awk '{sub("BS-Seq", ""); print}')
	        echo $bedFile
	        echo $type
	        onePosSample
	done
	wait
#	awk 'BEGIN{OFS="\t"}{if($1 == "2cell") sub("2cell", "E2cell",$1); print $1,$2,$3,$4,$5,$6,$7,$8}' avgme_${motif}_${compareStage}_${region}.txt > temp; mv temp avgme_${motif}_${compareStage}_${region}.txt
	N_accessible=$(intersectBed -u -a $fimo -b $motifFile | wc -l)
	N_inaccessible=$(intersectBed -u -a $fimo -b $ctrlFile | wc -l)
	R --vanilla --args avgme_${motif}_${compareStage}_${region}.txt ${motif}_$region ${compareStage} $N_accessible $N_inaccessible "$name1" "$name2" < getLinePlot_distalPeaks.R
done
echo done
