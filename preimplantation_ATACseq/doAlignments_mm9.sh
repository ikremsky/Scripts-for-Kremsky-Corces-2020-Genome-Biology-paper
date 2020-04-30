#cd strain_genomes
#bowtie-build DBA.fa DBA
#bowtie-build C57BL.fa C57BL
#cd ..

align () {
	local file=$1
	local outName=$(basename $file .fastq.gz | awk '{gsub("_1", ""); print}')
	local pair2=$(echo $file | awk '{gsub("_1", "_2"); print}')
	local outDir=/hdisk2/isaac/ATACseqNatureData/sam_mm9
	bamoutDir=/mnt/isaachd/ATAC-seq_naturedata/bam_mm9
	mkdir $outDir
        local outDir2=sam
#	bowtie2 -x /home/genomefiles/mouse/mm9/chromosomes_combined/mm9.allchromosomes -X 2000 -1 ${file} -2 $pair2 -S ${outDir}/${outName}.sam >> ${outDir}/${outName}.txt 2>&1

	grep -v "XS:i:" ${outDir}/${outName}.sam | samtools view -b -hf 0x2 - > ${bamoutDir}/${outName}.bam
#	samtools view -f 0x2 -q 30 -b -o ${bamoutDir}/${outName}.bam ${outDir}/${outName}.sam
	/programs/jdk1.8.0_73/bin/java -jar /programs/picard-tools-2.1.0/picard.jar SortSam SORT_ORDER=coordinate I=${bamoutDir}/${outName}.bam O=${bamoutDir}/${outName}.sorted.bam
#	samtools index ${bamoutDir}/${outName}.sorted.bam
}

i=1
for file in $(ls fastq/*.SRR*_1.trimmed.fastq.gz | awk '$0 ~ "ICM"')
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
