firstDir=$(pwd)

for file in $1
do
	echo $file
	fastaFromBed -fi /home/genomefiles/mouse/mm9/chromosomes_combined/mm9.allchromosomes.fa -bed $file -fo sequences/$(basename $file).fa &
done
wait

