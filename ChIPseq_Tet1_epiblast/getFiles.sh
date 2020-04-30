fastqFolder=fastq
mkdir fastq
mkdir sam

getFastq ()
{
	fastq-dump --gzip ${SRR} -O $fastqFolder
	mv ${fastqFolder}/${SRR}.fastq.gz ${fastqFolder}/${name}.${SRR}.fastq.gz
}
for GSM in $(grep -v H3K GSMtable.txt | grep -v RNA | grep -v double | grep -v Pol | cut -f1)
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
