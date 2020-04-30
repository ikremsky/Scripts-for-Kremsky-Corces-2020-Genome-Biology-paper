cd fastq
for file in $(ls *.gz | grep -v trim)
do
#	python /programs/ATACseq/pyadapter_trim.py -a $file &
	outFile=$(basename $file .fastq.gz).trim.fastq.gz
	summaryFile=$(basename $file .fastq.gz).txt
	java -jar /Zulu/isaac/PGCme/Trimmomatic-0.38/trimmomatic-0.38.jar SE -threads 10 -summary $summaryFile $file $outFile ILLUMINACLIP:/Zulu/isaac/PGCme/Trimmomatic-0.38/adapters/TruSeq3-SE.fa:1:0:2 TRAILING:20 MINLEN:20 &
done
wait
echo done
