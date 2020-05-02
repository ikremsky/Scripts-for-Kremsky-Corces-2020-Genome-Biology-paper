align () {
	local file=$1
	local outName=$(basename $file .fastq.gz | awk '{gsub("_1", ""); print}')
	local pair2=$(echo $file | awk '{gsub("_1", "_2"); print}')
	local outDir=$(basename $file .fastq.gz)
	tophat2 -p 16 --no-mixed --no-discordant -o $outDir -G /Zulu/isaac/PGC_RNAseq/gencode.vM20.annotation.gtf /home/genomefiles/human/bowtie2/mm10 ${file} $pair2
}

i=1
for file in $(ls fastq/*_1.trim.fastq.gz)
do
	echo $file
	if [ $(echo $i | awk '{print $1%20}') -eq 0 ]; then
		wait
	fi
	align $file &
	i=$(expr $i + 1)
done
wait
echo done
