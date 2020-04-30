folder=bed
mkdir bed

getFPKM ()
{
        /programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar SortSam SORT_ORDER=queryname I=$file O=$(echo $file | awk '{gsub("sorted", "Nsorted"); print}')
	bamToBed -bedpe -i $(echo $file | awk '{gsub("sorted", "Nsorted"); print}') > ${folder}/$(basename $file .bam).bedpe
	awk 'BEGIN{OFS="\t"}{pos=int(($2+$6)/2); print $1,pos-50,pos+50,$7}' ${folder}/$(basename $file .bam).bedpe > ${folder}/$(basename $file .bam).bed
	wc -l ${folder}/$(basename $file .bam).bed | awk -v folder=${folder}/ '{sub(folder, ""); print}' >> ${folder}/readCounts
}

for strain in All
#unassigned genome1 genome2
do
	for type in 8-cell
#early2-cell 2-cell 4-cell ICM
	do
		for file in $(ls bam/${type}_${strain}pooled.sorted.duprmvd.bam)
		do
#			peakFile=peaks/$(echo ${type}_peaks.sorted.bed | awk '{tolower($0); gsub("early2-cell", "2cell_early"); gsub("-", ""); gsub("ICM", "icm"); print}')
			getFPKM
		done
	done
	type=4-cellreciprocal
	peakFile=peaks/4cell_peaks.sorted.bed
	file=$(ls bam/${type}_${strain}pooled.sorted.duprmvd.bam)
#bam/test.trimmed.unassigned.sorted.duprmvd.bam
#	getFPKM
done
wait
cd bed
#wc -l *unassigned*bed >> readCounts
