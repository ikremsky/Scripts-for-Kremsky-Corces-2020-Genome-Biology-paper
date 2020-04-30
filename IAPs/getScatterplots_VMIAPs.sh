bedFile=/Zulu/isaac/PGCme/bed/E13.5mBS-Seq_meth.bed
compareStage=E13.5m
motifFile=temp1
prog=reprogramming
#nonreprogramming
for type in $(cut -f4 /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | sort | uniq)
do

        if [ -e ${type}_${motif}_${compareStage}_${prog}.affin ]; then 
                echo file exists
        else
		grep $type /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | grep -v random > temp1
		intersectBed -u -a temp1 -b VM-IAPs_validated.mm9.bed > tempVM &
		intersectBed -v -a temp1 -b VM-IAPs_validated.mm9.bed > tempnonVM &
		wait

                intersectBed -u -a $bedFile -b tempnonVM | awk 'BEGIN{OFS="\t"}{print $4,$5+$6}' > ${type}_${motif}_${compareStage}_${prog}.me &
                intersectBed -u -a $bedFile -b tempVM | awk 'BEGIN{OFS="\t"}{print $4,$5+$6}' > ${type}_${motif}_${compareStage}_${prog}_VM.me &
		intersectBed -u -a ${prog}TFsatIAPs_highestAffinities.bed -b temp1 > temp
		intersectBed -u -a temp -b tempnonVM | awk 'BEGIN{OFS="\t"}{print $5,1}' > ${type}_${motif}_${compareStage}_${prog}.affin &

		intersectBed -u -a ${prog}TFsatIAPs_highestAffinities.bed -b tempVM | awk 'BEGIN{OFS="\t"}{print $5,1}' > ${type}_${motif}_${compareStage}_${prog}_VM.affin
		if [ $(wc -l ${type}_${motif}_${compareStage}_${prog}_VM.affin | cut -f1 -d" ") -lt 25 ]; then
			echo 0 1 | awk '{sub(" ", "\t"); print $0"\n"$0"\n"$0"\n"}' > ${type}_${motif}_${compareStage}_${prog}_VM.affin
			echo 0 1 | awk '{sub(" ", "\t"); print $0"\n"$0"\n"$0"\n"}' > ${type}_${motif}_${compareStage}_${prog}_VM.me
		fi
		wait
        fi

        if [ $(grep $type avgme_${motif}_${compareStage}_${prog}.txt | wc -l) -gt 0 ]; then
                echo avgme_${motif}.txt exists
        else
		R --vanilla --args ${type}_${motif}_${compareStage}_${prog}.me ${type}_${motif}_${compareStage}_${prog}.affin $type ${motif}_${compareStage}_${prog} \
${type}_${motif}_${compareStage}_${prog}_VM.me ${type}_${motif}_${compareStage}_${prog}_VM.affin < getWeightedMeanandSD_disalPeaks.R
	fi
done
R --vanilla --args avgme_${motif}_${compareStage}_${prog}.txt ${motif}_$prog ${compareStage} $N_accessible $N_inaccessible "$name1" "$name2" < getScatterPlot.R
