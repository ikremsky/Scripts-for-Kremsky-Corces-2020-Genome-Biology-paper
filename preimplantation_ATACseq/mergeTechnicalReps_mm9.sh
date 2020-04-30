cd bam_mm9
stages="ICM"
runPicard ()
{
	local files="$(ls ATAC-Seq${stage}${rep}*.trimmed.sorted.bam | awk '{gsub("ATAC-", "I=ATAC-"); print}')"

#	/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MergeSamFiles SORT_ORDER=coordinate $files O=${stage}_${rep}.sorted.bam
#	/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=${stage}_${rep}.sorted.bam O=${stage}_${rep}.sorted.duprmvd.bam M=${stage}_${rep}.txt
#	samtools view -h ${stage}_${rep}.sorted.duprmvd.bam > ${stage}_${rep}.sorted.duprmvd.sam
#	python /hdisk2/isaac/ATACseqAnalysis/SAM-ATAC4.py 1 115 ${stage}_${rep}.sorted.duprmvd.sam ${stage}_${rep}.sorted.duprmvd.TFs.sam
#	samtools view -b  ${stage}_${rep}.sorted.duprmvd.TFs.sam > ${stage}_${rep}.sorted.duprmvd.TFs.bam
#	samtools sort ${stage}_${rep}.sorted.duprmvd.TFs.bam > ${stage}_${rep}.sorted.duprmvd.TFs.sorted.bam
}
for cell in all
do
        for stage in $stages
        do
		for rep in rep1 rep2
		do
			runPicard &
		done
	done
done
wait
#samtools merge ICM_pooled.sorted.duprmvd.TFs.bam ICM_rep1.sorted.duprmvd.TFs.sorted.bam ICM_rep2.sorted.duprmvd.TFs.sorted.bam
#samtools index ICM_pooled.sorted.duprmvd.TFs.bam

samtools merge ICM_pooled.sorted.duprmvd.bam ICM_rep1.sorted.duprmvd.bam ICM_rep2.sorted.duprmvd.bam
samtools index ICM_pooled.sorted.duprmvd.bam
