PATH=/programs/cutadapt-1.9.1/bin:$PATH
#/programs/trim_galore_zip/trim_galore --paired SRR2927010_1.fastq.gz SRR2927010_2.fastq.gz


trim ()
{
	local file1=$1
	local adaptor=$2
	local adaptorRev=$(echo $adaptor | awk '{x=""; y=tolower($0); gsub("a", "T", y); gsub("t", "A", y); gsub("c", "G", y); gsub("g", "C", y); for(i=length;i!=0;i--)x=x substr(y,i,1);}END{print x}')
	local file2=$(echo $file1 | awk '{gsub("_1", "_2"); print}')
	local outFile1=$(basename $file1 .fastq.gz).trimmed.fastq.gz
	local outFile2=$(basename $file2 .fastq.gz).trimmed.fastq.gz
#	/programs/trim_galore_zip/trim_galore --trim1 --paired $file1 $file2 &
        /programs/cutadapt-1.9.1/bin/cutadapt -a $adaptor -A $adaptor -q 20 -O 1 -e .2 -m 21 --info-file=$(basename $file1 .fastq.gz).info -o $outFile1 -p $outFile2 $file1 $file2 &
#--untrimmed-output=${outFile1}_ut --untrimmed-paired-output=${outFile2}_ut
#-o ${file1}_trim.fastq.gz -p ${file2}_trim.fastq.gz $file1 $file2
	#for bowtie2
#	/programs/cutadapt-1.9.1/bin/cutadapt -q 10 -o $outFile1 -p $outFile2 ${file1}_trim.fastq.gz ${file2}_trim.fastq.gz
#	fastqc $outFile1 $outFile2
	#for bowtie1
#        /programs/cutadapt-1.9.1/bin/cutadapt -u -1 -U -1 -o $outFile1 -p $outFile2 ${file1}_trim.fastq.gz ${file2}_trim.fastq.gz
	wc -l $outFile1
#	cat ${outFile1}_ut >> $outFile1 &
#	cat ${outFile2}_ut >> $outFile2 &
#	wait
#	gzip $outFile1 &
#        gzip $outFile2 &
#	rm ${file1}_trim.fastq.gz ${file2}_trim.fastq.gz ${outFile1}_ut ${outFile2}_ut
#	wait
}

cd fastq
i=1
for file1 in $(ls *_1.fastq.gz | grep -v "trim" | grep -v test | grep ICM)
do
	echo $file1
	if [ $(echo $i | awk '{print $1%6}') -eq 0 ]; then
		wait
	fi
	trim $file1 CTGTCTCTTATACACATCTGACGCTGCCGACGA &
	i=$(expr $i + 1)
done
wait
echo done
