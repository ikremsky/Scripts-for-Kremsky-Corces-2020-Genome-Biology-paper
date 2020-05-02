cd bam
for type in ESC
do
	echo $type
	files=$(ls *${type}*.UM.sorted.bam)
	samtools merge ${type}.pooled.UM.sorted.bam $files &
done
wait
