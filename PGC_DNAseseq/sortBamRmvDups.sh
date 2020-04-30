process ()
{
        sortFile=bam_mm10/$(basename $file .bam).sorted.bam
        /programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar SortSam SORT_ORDER=coordinate I=$file O=$sortFile
        finalFile=bam_mm10/$(basename $sortFile .bam).duprmvd.bam
        /programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=$sortFile O=$finalFile M=metrics.txt
}


for file in $(ls bam_mm10/*.bam | grep -v sorted)
do
	process &
done
wait


process2 ()
{
	/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MergeSamFiles SORT_ORDER=coordinate $files O=bam_mm10/${stage}_pooled.sorted.duprmvd.bam
	samtools index bam_mm10/${stage}_pooled.sorted.duprmvd.bam
}

for stage in E9.5 E10.5 E12.5_male E12.5_female E13.5_female E14.5_female E16.5_female E13.5_male E14.5_male E16.5_male
do
	echo $stage

	files=$(ls bam_mm10/${stage}_rep[12].*sorted.duprmvd.bam | awk '{gsub("bam_mm10/", "I=bam_mm10/"); print}')
	process2 &
done
wait
echo done
