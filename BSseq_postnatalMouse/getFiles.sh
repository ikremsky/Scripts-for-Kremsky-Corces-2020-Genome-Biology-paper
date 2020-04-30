fastqFolder=fastq
mkdir fastq
mkdir sam

getFastq ()
{
#	fastq-dump --gzip ${SRR} -O $fastqFolder
#	mv ${fastqFolder}/${SRR}.fastq.gz ${fastqFolder}/${name}.${SRR}.fastq.gz
	newName=$(echo "${name}" | awk '{sub(/\(/, ""); sub(/\)/, ""); print}')
	mv "${fastqFolder}/${name}.${SRR}.fastq.gz" ${fastqFolder}/${newName}.${SRR}.fastq.gz
}
for GSM in $(cat GSMtable.txt | cut -f1)
do
  	echo $GSM
	name=$(grep $GSM GSMtable.txt | cut -f2 | awk '{gsub(" ", ""); print}')
	SRRs=$(esearch -db sra -query $GSM | efetch -format docsum | xtract -pattern DocumentSummary -element Run@acc)
	for SRR in $SRRs
	do
		echo $SRR
		getFastq &
	done
done
wait
echo done
