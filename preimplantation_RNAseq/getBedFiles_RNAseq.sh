mkdir bed
getFPKM ()
{
	bamToBed -split -i $file | grep -v random > bed/$(basename $file .bam).split.bed &
	bamToBed -i $file | grep -v random >  bed/$(basename $file .bam).bed &
	wait
	wc -l bed/$(basename $file .bam).bed | awk '{sub("bed/", ""); print}' >> bed/readCounts
}

for file in $(ls bam/*.pooled.UM.sorted.bam)
do
	getFPKM &
done
wait
echo done
