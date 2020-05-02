mkdir bam
process ()
{
	local newFile=bam/${name}.UM.sorted.bam
        samtools view -h $file | awk '$1 ~ "^@" || $NF == "NH:i:1"' | samtools view -bh - > bam/${name}.UM.bam
	samtools sort bam/${name}.UM.bam > $newFile
}

for file in $(ls */accepted_hits.bam)
do
	name=$(echo $file | cut -f1 -d"/")
        process &
done
wait
echo done
