for type in 
#E12.5IntestinalEpithelium WTAdultIntestinalEpithelium WTMacrophage
do
	files=$(ls ${type}*deduplicated.bam)
#	files=$(echo $files | awk '{gsub(" ", ","); print}')
	/programs/Bismark_v0.19.0/deduplicate_bismark --bam --multiple -p $files &
done
wait
#mv E12.5IntestinalEpitheliumWGBS.SRR6763515_1.trim_bismark_bt2_pe.deduplicated.bam E12.5IntestinalEpitheliumWGBS.SRR6763515_1.trim_bismark_bt2_pe.deduplicated.deduplicated.bam
for file in $(ls *.deduplicated.deduplicated.bam | grep WTAdultIntestinalEpithelium)
do
	/programs/Bismark_v0.19.0/bismark_methylation_extractor --ignore_r2 3 --cytosine_report --bedGraph --parallel 10 --zero_based -o cov/ --genome_folder /home/genomefiles/mouse/mm9/chromosomes_combined/ $file &
done
wait
echo done
