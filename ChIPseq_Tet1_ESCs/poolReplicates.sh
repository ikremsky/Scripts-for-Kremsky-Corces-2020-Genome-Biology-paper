process2 ()
{
	java -jar /programs/picard-tools-2.1.7/picard.jar MergeSamFiles SORT_ORDER=coordinate $files O=bam/${treat}.sorted.duprmvd_distal.bam
	samtools index bam/${treat}.sorted.duprmvd_distal.bam
}

for treat in WTDnmt3a1
do
	echo $treat

	files=$(ls bam/${treat}_*distal.bam | awk '{gsub("bam/", "I=bam/"); print}')
	process2 &
done
wait
echo done
