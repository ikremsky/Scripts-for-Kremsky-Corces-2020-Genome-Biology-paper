align () {
	local file=$1
	local outName=$(basename $file .fastq.gz | awk '{gsub("_1", ""); print}')
	local bamoutDir=bam

#	bowtie2 -p 16 --no-mixed --no-discordant -x /home/genomefiles/mouse/mm9/chromosomes_combined/mm9.allchromosomes -U ${file} | grep -v "XS:i:" | samtools view -b -hf 0x2 - > ${bamoutDir}/${outName}.bam
	zcat $file | bowtie -t -m 1 -p 20 --mapq 254 -S /home/genomefiles/mouse/mm9/chromosomes_combined/mm9 - | samtools view -b > ${bamoutDir}/${outName}.bam
}

i=1
for file in $(ls fastq/*.SRR*.trim.fastq.gz | grep -v LIF)
do
	echo $file
        while [ $(ps -u isaac | grep bowtie | wc -l) -gt 12 ] ; do
                sleep 300
        done
	align $file &
	i=$(expr $i + 1)
done
wait
echo done
