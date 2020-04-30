cd bam

process ()
{
	/programs/Bismark-0.22.1/coverage2cytosine --merge_CpG --zero_based --genome_folder /home/genomefiles/mouse/mm9/chromosomes_combined/ -o $outFile $file
}

for file in $(ls *cov.gz)
do
	outFile=$(basename $file .cov.gz)
	process &
done
wait
echo done
