se ()
{
#	/programs/Bismark_v0.19.0/bismark /home/genomefiles/mouse/mm9/chromosomes_combined/ $file
	outFile=$(basename $file .fastq.gz)_bismark_bt2.bam
	deDupFile=$(basename $outFile .bam).deduplicated.bam
	/programs/Bismark_v0.19.0/deduplicate_bismark --bam -s $outFile
	/programs/Bismark_v0.19.0/bismark_methylation_extractor --cytosine_report --bedGraph --parallel 10 --zero_based -o bam/ --genome_folder /home/genomefiles/mouse/mm9/chromosomes_combined/ $deDupFile
}

PE ()
{
	outFile=$(basename $file .fastq.gz)_bismark_bt2_pe.bam
	deDupFile=$(basename $outFile .bam).deduplicated.bam
#	/programs/Bismark_v0.19.0/bismark /home/genomefiles/mouse/mm9/chromosomes_combined/ -1 $file -2 $file2
#	/programs/Bismark_v0.19.0/deduplicate_bismark --bam -p $outFile
#	/programs/Bismark_v0.19.0/bismark_methylation_extractor --ignore_r2 3 --cytosine_report --bedGraph --parallel 10 --zero_based -o bam/ --genome_folder /home/genomefiles/mouse/mm9/chromosomes_combined/ $deDupFile
}

for type in forebrain hindbrain kidney liver lung midbrain stomach heart
do
	file=$(ls fastq/*${type}*.trim.fastq.gz)
	file=$(echo $file | awk '{gsub(" ", ","); print}')
	se &
done

for file in 
#$(ls fastq/*.trim.fastq.gz | grep _1)
do
	file2=$(echo $file | awk '{sub("_1", "_2"); print}')
	echo $file2
#	PE &
done
wait
mkdir bam
mv *bismark_bt2_SE_report.txt *.bam bam/
echo done
