process ()
{
        sortFile=bam/$(basename $file .bam).sorted.bam
        /programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar SortSam SORT_ORDER=coordinate I=$file O=$sortFile
        finalFile=bam/$(basename $sortFile .bam).duprmvd.bam
        /programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=$sortFile O=$finalFile M=metrics.txt
}


for file in 
#$(ls bam/*.bam | grep -v sorted)
do
	process &
done
wait

for stage in 
#Sperm GVOocyte_14d Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 Pronuclei_Pat_PN5 Pronuclei_Mat_PN5 1Cell 2Cell 4Cell 8Cell Morula
do
	echo $stage

	files="$(echo $files | awk '{gsub(".bam", ".sorted.bam"); print}' | awk '{gsub("ChIP-", "I=ChIP-"); print}')"
	files=$(ls bam/${stage}_[12]_Dnase-seq*sorted.duprmvd.bam | awk '{gsub("bam/", "I=bam/"); print}')
#	/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MergeSamFiles SORT_ORDER=coordinate $files O=bam/${stage}_pooled.sorted.duprmvd.bam &
	samtools index bam/${stage}_pooled.sorted.duprmvd.bam &
done
wait
/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar MergeSamFiles SORT_ORDER=coordinate I=bam/100-cellESC_Dnase-seq.SRR3091098.sorted.duprmvd.bam I=bam/30-cellESC_Dnase-seq.SRR3091097.sorted.duprmvd.bam O=bam/ESC_pooled.sorted.duprmvd.bam
samtools index bam/ESC_pooled.sorted.duprmvd.bam
