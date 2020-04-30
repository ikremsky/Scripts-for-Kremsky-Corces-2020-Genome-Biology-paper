outDir=sam
bamoutDir=bam
mkdir $outDir $bamoutDir
align () {
	local file=$1
	local outName=$(basename $file .fastq.gz | awk '{gsub("_1", ""); print}')
	local pair2=$(echo $file | awk '{gsub("_1", "_2"); print}')
	bowtie2 -p 16 --no-mixed --no-discordant -x /home/genomefiles/mouse/mm9/chromosomes_combined/mm9.allchromosomes -1 ${file} -2 $pair2 -S ${outDir}/${outName}.sam > ${outDir}/${outName}.txt 2>&1

	grep -v "XS:i:" ${outDir}/${outName}.sam | samtools view -b -hf 0x2 - > ${bamoutDir}/${outName}.bam
}

i=1
for file in $(ls fastq/*_1.trim.fastq.gz)
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
