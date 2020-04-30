fastqFolder=fastq
mkdir fastq
mkdir bam

getFastq ()
{
	if [ $(grep $GSM runInfo.txt | grep PAIRED | wc -l) -gt 0 ]; then
		fastq-dump --gzip ${SRR} --split-files -O $fastqFolder
	        mv ${fastqFolder}/${SRR}_1.fastq.gz ${fastqFolder}/${name}.${SRR}_1.fastq.gz
	        mv ${fastqFolder}/${SRR}_2.fastq.gz ${fastqFolder}/${name}.${SRR}_2.fastq.gz
	else
		fastq-dump.2.9.4 -B --gzip ${SRR}  -O $fastqFolder
		mv ${fastqFolder}/${SRR}.fastq.gz ${fastqFolder}/${name}.${SRR}.fastq.gz
	fi
}

for GSM in $(grep -e K4 -e K27 GSMtable.txt | cut -f1)
do
  	echo $GSM
        name=$(grep $GSM GSMtable.txt | cut -f2 | awk '{gsub(" ", ""); print}')
	echo $name
        SRRs=$(grep $GSM runInfo.txt | cut -f1)
        for SRR in $SRRs
        do
		echo $SRR
                getFastq &
        done
done
wait
echo done
