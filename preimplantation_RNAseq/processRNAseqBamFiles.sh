mkdir bam
process ()
{
	local newFile=bam/${name}.UM.sorted.bam
        samtools view -h $file | awk '$1 ~ "^@" || $NF == "NH:i:1"' | samtools view -bh - > bam/${name}.UM.bam
	samtools sort bam/${name}.UM.bam > $newFile
#	java -jar /programs/picard-tools-2.1.7/picard.jar MarkDuplicate REMOVE_DUPLICATES=true I=$newFile O=$(echo $newFile | awk '{sub(".bam", ".duprmvd)}') M=metrics.txt
}

for file in $(ls */accepted_hits.bam | grep ocyt)
do
	name=$(echo $file | cut -f1 -d"/")
        process &
done
wait
echo done
