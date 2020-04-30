fastqFolder=fastq
#wget -r -nd -nH ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP/SRP068/SRP068205
mkdir fastq sra
mv *.sra sra/

getFastq ()
{
#	fastq-dump-2.5.4 --gzip $SRR -O $fastqFolder
	fastq-dump --gzip $SRR -O $fastqFolder
	mv fastq/${SRR}.fastq.gz fastq/${name}.${SRR}.fastq.gz
}

for GSM in $(grep Dnase GSMtable.txt | grep ESC | cut -f1)
do
  	echo $GSM
	name=$(grep $GSM GSMtable.txt | cut -f2 | awk '{gsub(" ", ""); print}')
	SRRs=$(grep $GSM runInfo.txt | cut -f10)
	for SRR in $SRRs
	do
		echo $SRR $name
		getFastq &
	done
#	sam-dump.2.5.4 --min-mapq 254 $file > sam/$(basename $file .sra).sam &
done
wait
echo done
