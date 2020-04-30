cd bam

runPicard ()
{
	if [ $rep -eq 1 ]; then
		local files="$(ls ${stage}.S*.bam | grep -v sort)"
	else
		local files="$(ls ${stage}_${rep}*.bam | grep -v sort)"
	fi
	echo $files
	for file in $files
	do
		local outName=$(basename $file .bam)
		/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar SortSam SORT_ORDER=coordinate I=${outName}.bam O=${outName}.sorted.bam &
	done
	wait
	local files="$(echo $files | awk '{gsub(".bam", ".sorted.bam"); print}' | awk -v stage=$stage '{gsub(stage, "I="stage); print}')"
	/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MergeSamFiles SORT_ORDER=coordinate $files O=${stage}_${rep}.sorted.bam
	/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=${stage}_${rep}.sorted.bam O=${stage}_${rep}.sorted.duprmvd.bam M=${stage}_${rep}.txt
}

mergeAndSplit ()
{
	for rep in 1 2
        do
                runPicard &
        done
	wait

	/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MergeSamFiles SORT_ORDER=coordinate I=${stage}_1.sorted.duprmvd.bam I=${stage}_2.sorted.duprmvd.bam O=${stage}_pooled.sorted.duprmvd.bam
        samtools index ${stage}_pooled.sorted.duprmvd.bam
	wait
}

for stage in $(ls *.bam | cut -f1-2 -d"_" | cut -f1 -d"." | grep ESC | sort | uniq)
do
	mergeAndSplit &
done
wait
echo done
