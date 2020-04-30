while [ $(ps -u isaac | grep perl | wc -l) -gt 0 ] ; do
        sleep 300
done
for file in $(ls *.deduplicated.deduplicated.bam)
do
	/programs/Bismark_v0.19.0/bismark_methylation_extractor --ignore_r2 3 --cytosine_report --bedGraph --parallel 10 --zero_based -o bam/ --genome_folder /home/genomefiles/mouse/mm9/chromosomes_combined/ $file &
done
wait
