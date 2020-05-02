cd bam
for type in MII_oocyte
do
	echo $type
	files=$(ls RNA-Seq${type}*.UM.sorted.bam)
	samtools merge ${type}.pooled.UM.sorted.bam $files &
done
wait
