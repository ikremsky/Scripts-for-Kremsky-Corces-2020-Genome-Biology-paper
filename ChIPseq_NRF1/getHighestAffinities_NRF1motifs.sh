type=NRF1motifs
fpkmFile=/media/4TB4/isaac/ChIPseq_NRF1/bed_shifted/CHIP_to2i.sorted.duprmvdatNRF1_mergedPeaks.bed.fpkm
affinityFile=/media/4TB4/isaac/TEPIC/affinities/NRF1ChIP_TEPIC_06_20_19_15_41_23_882744621_Affinity.txt
cut -f1 $affinityFile | awk 'BEGIN{OFS="\t"}{gsub("-", "\t"); gsub(":", "\t"); if(NR > 1) print "chr"$0; else print "chr","start","end"}' > ${type}_expressedAffinities.bed
head -1 $affinityFile | awk '{gsub("\t", "\n"); print}' | cut -f1 -d"_" > tempids
for TF in $(grep -i NRF1 tempids)
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
