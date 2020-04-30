process ()
{
        sortFile=bam/$(basename $file .bam).sorted.bam
#        java -jar /programs/picard-tools-2.1.7/picard.jar SortSam SORT_ORDER=coordinate I=$file O=$sortFile
	samtools sort $file > $sortFile
        finalFile=bam/$(basename $sortFile .bam).duprmvd.bam
        java -jar /programs/picard-tools-2.1.7/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=$sortFile O=$finalFile M=metrics.txt
}


for file in $(ls bam/*.bam | grep -v sorted)
do
        process &
done
wait
echo done
