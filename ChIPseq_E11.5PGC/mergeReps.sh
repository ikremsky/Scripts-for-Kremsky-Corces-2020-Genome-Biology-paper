cd bam

runPicard ()
{
	local files="$(ls ${stage}*.bam | grep -v sort)"
	echo $files
	for file in 
#$files
	do
		local outName=$(basename $file .bam)
		/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar SortSam SORT_ORDER=coordinate I=${outName}.bam O=${outName}.sorted.bam &
	done
	wait
	local files="$(echo $files | awk '{gsub(".bam", ".sorted.bam"); print}')"
	for file in 
#$files
	do
		/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=$file O=$(basename $file .bam).duprmvd.bam M=${stage}_${rep}.txt &
	done
	wait
	local files="$(echo $files | awk -v stage=$stage '{gsub(".sorted.bam", ".sorted.duprmvd.bam"); gsub(stage, "I="stage); print}')"
	/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MergeSamFiles SORT_ORDER=coordinate $files O=${stage}_pooled.sorted.bam
}

mergeAndSplit ()
{
	for rep in 1
        do
                runPicard &
        done
	wait
}

for stage in $(ls *.bam | cut -f1-2 -d"_" | cut -f1 -d"." | sort | uniq)
do
	mergeAndSplit &
done
wait
echo done
