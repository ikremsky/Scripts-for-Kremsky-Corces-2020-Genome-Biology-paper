process2 ()
{
	java -jar /programs/picard-tools-2.1.7/picard.jar MergeSamFiles SORT_ORDER=coordinate $files O=bam/${treat}.sorted.duprmvd.bam
	samtools index bam/${treat}.sorted.duprmvd.bam
}

for treat in CHIP_to2i CHIP_toSerum
do
	echo $treat

	files=$(ls bam/${treat}_*sorted.duprmvd.bam | awk '{gsub("bam/", "I=bam/"); print}')
	process2 &
done
wait
echo done
