fastqFolder=fastq
mkdir fastq
mkdir sam

getFastq ()
{
	fastq-dump --gzip ${SRR} -O $fastqFolder
	mv ${fastqFolder}/${SRR}.fastq.gz ${fastqFolder}/${name}.${SRR}.fastq.gz
}

for GSM in $(grep NRF1 GSMtable.txt | grep CHIP | grep TKO | cut -f1)
do
  	echo $GSM
	name=$(grep $GSM GSMtable.txt | cut -f2 | awk '{gsub(" ", ""); print}')
	SRRs=$(grep $GSM runInfo.txt | cut -f1)
	for SRR in $SRRs
	do
		getFastq &
	done
done
wait
echo done
