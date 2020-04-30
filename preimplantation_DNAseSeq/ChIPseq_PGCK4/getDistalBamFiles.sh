process ()
{
	outFile=$(echo $file | awk '{sub(".bam", "_distal.bam"); print}')
	intersectBed -v -a $file -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed > $outFile
	samtools index $outFile
}

for file in $(ls bam/*pool*bam)
do
	echo $file
	process &
done
wait
echo done
