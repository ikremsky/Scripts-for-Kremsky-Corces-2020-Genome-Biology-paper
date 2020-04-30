process ()
{
        rep1a=$(grep $type replicates.txt | awk '{if($1 == 1) print $NF}' | head -1)
        rep1b=$(grep $type replicates.txt | awk '{if($1 == 1) print $NF}' | tail -1)
        rep2a=$(grep $type replicates.txt | awk '{if($1 == 2) print $NF}' | head -1)
        rep2b=$(grep $type replicates.txt | awk '{if($1 == 2) print $NF}' | tail -1)
	echo $type
	file1a=$(ls bam/*${rep1a}*deduplicated.bam)
	file1b=$(ls bam/*${rep1b}*deduplicated.bam)
	file2a=$(ls bam/*${rep2a}*deduplicated.bam)
        file2b=$(ls bam/*${rep2b}*deduplicated.bam)
	samtools merge -n bam/${type}_rep1.merged.bam $file1a $file1b &
	samtools merge -n bam/${type}_rep2.merged.bam $file2a $file2b &
	wait
	/programs/Bismark_v0.19.0/deduplicate_bismark --bam -s bam/${type}_rep1.merged.bam &
	/programs/Bismark_v0.19.0/deduplicate_bismark --bam -s bam/${type}_rep2.merged.bam &
}

i=1
for type in 
#forebrain hindbrain kidney liver lung midbrain stomach heart
do
	process &
        if [ $(echo $i | awk '{print $1%16}') -eq 0 ]; then
                wait
        fi
        i=$(expr $i + 1)
done
wait
echo done1
#mv *bismark_bt2_SE_report.txt *.bam bam/
i=1
for file in $(ls bam/*merged.deduplicated.bam | awk 'NR > 1')
do
	echo starting $file
	/programs/Bismark_v0.19.0/bismark_methylation_extractor --cytosine_report --bedGraph --parallel 50 --zero_based -o bam/ --genome_folder /home/genomefiles/mouse/mm9/chromosomes_combined/ $file
	if [ $(echo $i | awk '{print $1%3}') -eq 0 ]; then
		wait
	fi
	i=$(expr $i + 1)
done
wait
echo done2
