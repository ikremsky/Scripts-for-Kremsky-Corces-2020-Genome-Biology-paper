fastqFolder=fastq
#wget -r -nd -nH ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP/SRP131/SRP131655/

mkdir sra
mkdir fastq
mkdir sam
mv *.sra sra

getFastq ()
{
	fastq-dump --gzip $SRR -O $fastqFolder
	mv ${fastqFolder}/${SRR}.fastq.gz ${fastqFolder}/${name}.${SRR}.fastq.gz
}
for GSM in $(cat GSMtable.txt | grep E14.5_female | cut -f1)
do
  	echo $GSM
	name=$(grep $GSM GSMtable.txt | cut -f2 | awk '{gsub(" ", ""); print}')
	SRRs=$(grep $GSM runInfo.txt | cut -f1)
	for SRR in $SRRs
	do
		getFastq &
	done
#	sam-dump.2.5.4 --min-mapq 254 $file > sam/$(basename $file .sra).sam &
done
wait
echo done
