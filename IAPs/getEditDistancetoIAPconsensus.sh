awk 'BEGIN{OFS="\t"; seq=""; type=""}{if($1 ~ ">") {print type,seq; sub(">", ""); type=$1} else seq=seq$0}' /Zulu/isaac/BSseq_BPAYoonhee/IAPLTR_consensus.fa > IAPLTR_consensus.txt

for type in $(cut -f4 /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | sort | uniq)
do
#	awk -v type=$type '$4 == type' /Zulu/isaac/starvation_sperm/mm9_IAPs.bed > IAPs_${type}.bed
#	sh getSequence_fastaFromBed.sh IAPs_${type}.bed
#	awk -v type=$type 'BEGIN{OFS="\t"}{if(NR%2 == 0) print pos,type,toupper($1),"+"; else pos=$1}' sequences/IAPs_${type}.bed.fa | awk 'BEGIN{OFS="\t"}{sub(">", ""); sub(":", "\t"); sub("-","\t"); print}' > sequences/IAPs_${type}.bed
	consensus=$(awk -v type=$type '{if($1 == type) print $2}' IAPLTR_consensus.txt)
	if [ $(echo $consensus | awk '{print length($0)}') -gt 0 ]; then
#		R --vanilla --args $type sequences/IAPs_${type}.bed $consensus < getStringDist.R
#		intersectBed -f 1 -F 1 -wa -wb -a ${type}.txt -b reprogrammingTFsatIAPs_highestAffinities.bed | cut -f1-7,12 > ${type}_final.bed
#		intersectBed -f 1 -F 1 -wa -wb -a ${type}.txt -b nonreprogrammingTFsatIAPs_highestAffinities.bed | cut -f1-7,12 > ${type}_nonrep_final.bed
		R --vanilla --args $type ${type}_final.bed reprog < getScatterPlot_mutationVaffinity.R
		R --vanilla --args $type ${type}_nonrep_final.bed nonreprog < getScatterPlot_mutationVaffinity.R
	fi
done
#reprogrammingTFsatIAPs_highestAffinities.bed
