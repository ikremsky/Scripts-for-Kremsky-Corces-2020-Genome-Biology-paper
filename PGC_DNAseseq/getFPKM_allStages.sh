getFPKM ()
{
	M=$(awk -v x=$type  'BEGIN{count=0}{if($2~"^"x"_"   && $2 !~ "unassigned") count+=$1/1000000}END{print count}' bed/readCounts)
	coverageBed -a $peakFile -b $file | head
#awk -v M=$M 'BEGIN{OFS="\t"}{K=$9/1000; print $1,$2,$3,$4,$5,$6,$7/(K*M)}' > bed/$(basename $file .bed)at$(basename $peakFile .bed).fpkm
}
for strain in all
do
	for type in E9.5 
#E10.5 E12.5_female E12.5_male E13.5_female E13.5_male E14.5_female E14.5_male E16.5_female E16.5_male
	do
		for file in bam/${type}_pooled.sorted.duprmvd.bam
		do
			echo $type
			for peakFile in peaks/GSM2966946_E14.5_male.mm9.norandom.bed
#$(ls peaks/*${type}*.norandom.bed) nonPersistentpeaks.bed  persistentPeaks_maleSpecific.bed
		        do
				echo $peakFile
				getFPKM &
			done
			wait
		done
	done
done
wait
