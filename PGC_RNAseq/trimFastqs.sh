cd fastq
for file in $(ls *.gz | grep -v _1 | grep -v _2 | grep -v trim)
do
#	python /programs/ATACseq/pyadapter_trim.py -a $file &
	outFile=$(basename $file .fastq.gz).trim.fastq.gz
	summaryFile=$(basename $file .fastq.gz).txt
	java -jar /Zulu/isaac/PGCme/Trimmomatic-0.38/trimmomatic-0.38.jar SE -threads 15 -summary $summaryFile $file $outFile ILLUMINACLIP:/Zulu/isaac/PGCme/Trimmomatic-0.38/adapters/all_SE.fa:1:0:2  TRAILING:20 MINLEN:20 &
done

for file in 
#$(ls *.gz | grep _1 | grep -v trim)
do
	file2=$(echo $file | awk '{sub("_1", "_2"); print}')
	outFile=$(basename $file .fastq.gz).trim.fastq.gz
	outFile2=$(basename $file2 .fastq.gz).trim.fastq.gz
	summaryFile=$(basename $file .fastq.gz).txt
	echo $file2
	java -jar /Zulu/isaac/PGCme/Trimmomatic-0.38/trimmomatic-0.38.jar PE -threads 15 -summary $summaryFile $file $file2 $outFile s1 $outFile2 s2 ILLUMINACLIP:/Zulu/isaac/PGCme/Trimmomatic-0.38/adapters/all_PE.fa:1:0:2 TRAILING:20 MINLEN:20 &
done
wait
echo done
