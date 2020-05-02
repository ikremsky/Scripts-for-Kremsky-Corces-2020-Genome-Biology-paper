fastqFolder=fastq
#wget -r -nd -nH ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP/SRP062/SRP062106/
mkdir fastq
mkdir sam

getFastq ()
{
	fastq-dump --gzip --split-files ${SRR} -O $fastqFolder
	mv ${fastqFolder}/${SRR}_1.fastq.gz ${fastqFolder}/${name}.${SRR}_1.fastq.gz
        mv ${fastqFolder}/${SRR}_2.fastq.gz ${fastqFolder}/${name}.${SRR}_2.fastq.gz
}
for GSM in $(grep RNA GSMtable.txt | grep MII_oocyte | cut -f1)
do
  	echo $GSM
	name=$(grep $GSM GSMtable.txt | cut -f2 | awk '{gsub(" ", ""); print}')
	SRRs=$(grep $GSM runInfo.txt | cut -f1)
	echo $SRRs
	for SRR in $SRRs
	do
		getFastq &
	done
done
wait
echo done
