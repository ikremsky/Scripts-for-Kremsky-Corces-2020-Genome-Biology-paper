se ()
{
#	/programs/Bismark_v0.19.0/bismark /home/genomefiles/mouse/mm9/chromosomes_combined/ $file
	outFile=$(basename $file .fastq.gz)_bismark_bt2.bam
	deDupFile=$(basename $outFile .bam).deduplicated.bam
#	/programs/Bismark_v0.19.0/deduplicate_bismark --bam -s $outFile
	/programs/Bismark_v0.19.0/bismark_methylation_extractor --comprehensive --cytosine_report --bedGraph --parallel 20 --zero_based -o bam/ --genome_folder /home/genomefiles/mouse/mm9/chromosomes_combined/ $deDupFile
}

PE ()
{
	outFile=$(basename $file .fastq.gz)_bismark_bt2_pe.bam
	deDupFile=$(basename $outFile .bam).deduplicated.bam
#	/programs/Bismark_v0.19.0/bismark /home/genomefiles/mouse/mm9/chromosomes_combined/ -1 $file -2 $file2
#	/programs/Bismark_v0.19.0/deduplicate_bismark --bam -p $outFile
	/programs/Bismark_v0.19.0/bismark_methylation_extractor --comprehensive --ignore_r2 3 --cytosine_report --bedGraph --parallel 20 --zero_based -o bam/ --genome_folder /home/genomefiles/mouse/mm9/chromosomes_combined/ $deDupFile
}

for file in $(ls fastq/E*txt fastq2/E*txt| grep -v _1 | grep -v _2 | grep -v test | awk '{sub("txt", "trim.fastq.gz"); print}')
#$(ls fastq2/*.trim.fastq.gz | grep -v _1 | grep -v _2 | grep -v test | grep ERR192350)
do
	se &
done

for file in $(ls fastq/E*txt fastq2/E*txt| grep _1 | awk '{sub("txt", "trim.fastq.gz"); print}')
#E6.5BS-Seq1.ERR192350_1.trim.fastq.gz
#$(ls fastq2/*.trim.fastq.gz | grep _1)
do
	file2=$(echo $file | awk '{sub("_1", "_2"); print}')
	echo $file2
	PE &
done
wait
mkdir bam
mv *bismark_bt2_SE_report.txt *.bam bam/
echo done
