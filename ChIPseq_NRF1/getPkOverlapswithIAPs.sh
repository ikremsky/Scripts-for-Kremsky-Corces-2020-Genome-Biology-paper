for sample in TKO to2i toSerum
do
	files=$(ls NRF1CHIP${sample}*.bed)
#	cat $files | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | awk 'BEGIN{OFS="\t"}{print $0,NR,".","+"}' > ${sample}_mergedPks.bed &
done
wait

sh getOverlapRatios.sh to2i toSerum
sh getOverlapRatios.sh TKO to2i
