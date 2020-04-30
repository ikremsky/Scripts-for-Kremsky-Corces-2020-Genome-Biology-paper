type=nonreprogrammingTFsatIAPs
affinityFile=/media/4TB4/isaac/TEPIC/affinities/IAPs_TEPIC_06_25_19_11_54_19_943575913_Affinity.txt
fpkmFile=/media/4TB4/isaac/PGC_RNAseq/cuffdiff/final/E16.5m.genes.fpkm
cut -f1 $affinityFile | awk 'BEGIN{OFS="\t"}{gsub("-", "\t"); gsub(":", "\t"); if(NR > 1) print "chr"$0; else print "chr","start","end"}' > ${type}_expressedAffinities.bed
head -1 $affinityFile | awk '{gsub("\t", "\n"); print}' | cut -f1 -d"_" > tempids
awk '{if(NR%2 == 0) print $1}' /mnt/bigmama/isaac/RNAseq_mouseEmbryo/motifAnalysis_E9.5Lo_E14.mHi/summary.txt > tempids2
awk '{if(NR%2 == 0 && $NF < .05 && $3 > $4) print $1}' /mnt/bigmama/isaac/RNAseq_mouseEmbryo/motifAnalysis_E9.5Hi_E14.5mLo/summary.txt >> tempids2
sort -b tempids2 | uniq > tempids3
awk '$NF > 3' $fpkmFile | cut -f5 | grep -v Rik | sort -b > tempids2
join -v 1 -i tempids2 tempids3 > tempids4
head -1 $affinityFile | awk '{gsub("\t", "\n"); print}' | cut -f1 -d"_" | sort -b | uniq > tempids5
for TF in $(join -i tempids5 tempids4)
do
	col=$(awk -v TF=$TF '{if(toupper(TF) == toupper($1)) print NR}' tempids)
	echo $TF $col
	if [ $(echo $col | awk '{if(NF > 0) print}' | wc -l) -eq 1 ]; then
		cut -f$col $affinityFile > temp
		paste ${type}_expressedAffinities.bed temp > temp2; mv temp2 ${type}_expressedAffinities.bed
	fi
done
cut -f1-3 ${type}_expressedAffinities.bed | awk 'NR > 1' > temp2
cut -f4- ${type}_expressedAffinities.bed > temp
R --vanilla --args temp ${type}_highestAffinities.bed < getHighestAffinities.R
paste temp2 ${type}_highestAffinities.bed > temp3; mv temp3 ${type}_highestAffinities.bed
head ${type}_highestAffinities.bed
