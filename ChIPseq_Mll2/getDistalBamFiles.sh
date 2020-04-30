process ()
{
        outFile=$(echo $file | awk '{sub("duprmvd.bam", "duprmvd_distal.bam"); print}')
        intersectBed -v -a $file -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed > $outFile
        samtools index $outFile
}

for file in $(ls bam/*duprmvd.bam)
do
        process &
done
wait
echo done
