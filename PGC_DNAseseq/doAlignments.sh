align () {
	local file=$1
	local outName=$(basename $file .fastq.gz)
	local outDir=sam
        local bamoutDir=bam

	zcat $file | bowtie -t -m 1 -p 16 --mapq 254 -S /home/genomefiles/mouse/mm9/chromosomes_combined/mm9 - ${outDir}/${outName}.sam > ${outDir}/${outName}.txt 2>&1
	samtools view -b ${outDir}/${outName}.sam > ${bamoutDir}/${outName}.bam
}

i=1
for file in $(ls fastq/*.trim.fastq.gz)
do
	echo $file
	if [ $(echo $i | awk '{print $1%40}') -eq 0 ]; then
		wait
	fi
	align $file &
	i=$(expr $i + 1)
done
wait
echo done
