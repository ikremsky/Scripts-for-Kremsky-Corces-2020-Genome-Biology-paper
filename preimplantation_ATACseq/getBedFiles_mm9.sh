folder=bed_mm9
mkdir $folder

getFPKM ()
{
#        /programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar SortSam SORT_ORDER=queryname I=$file O=$(echo $file | awk '{gsub("sorted", "Nsorted"); print}')
#	bamToBed -bedpe -i $(echo $file | awk '{gsub("sorted", "Nsorted"); print}') > ${folder}/$(basename $file .bam).bedpe
	awk 'BEGIN{OFS="\t"}{pos=int(($2+$6)/2); print $1,$2,$6,$7}' ${folder}/$(basename $file .bam).bedpe > ${folder}/$(basename $file .bam).bed
#	wc -l ${folder}/$(basename $file .bam).bed | awk -v folder=${folder}/ '{sub(folder, ""); print}' >> ${folder}/readCounts
}

for strain in All
#unassigned genome1 genome2
do
	for type in ICM
	do
		for file in $(ls bam_mm9/${type}_pooled.sorted.duprmvd.TFs.bam)
#$(ls bam_mm9/${type}_pooled.sorted.duprmvd.bam)
#$(ls bam_mm9/${type}_pooled.sorted.duprmvd.TFs.bam)
		do
			getFPKM
		done
	done
done
wait
cd bed
#wc -l *unassigned*bed >> readCounts
