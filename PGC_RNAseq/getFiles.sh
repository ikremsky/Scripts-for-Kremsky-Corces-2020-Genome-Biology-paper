fastqFolder=fastq
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192339/ERR192339.fastq.gz &
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192340/ERR192340.fastq.gz &
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192341/ERR192341.fastq.gz &
wait

wait
mkdir $fastqFolder
mkdir sam
mv *.gz ${fastqFolder}/

getFastq ()
{
#	fastq-dump-2.5.4 --gzip sra/${SRR}.sra -O $fastqFolder
	mv ${fastqFolder}/${SRR}.fastq.gz ${fastqFolder}/${name}.${SRR}.fastq.gz
	mv ${fastqFolder}/${SRR}_1.fastq.gz ${fastqFolder}/${name}.${SRR}_1.fastq.gz
	mv ${fastqFolder}/${SRR}_2.fastq.gz ${fastqFolder}/${name}.${SRR}_2.fastq.gz
}
for GSM in $(cat GSMtable.txt | cut -f1)
do
  	echo $GSM
	name=$(grep $GSM GSMtable.txt | cut -f2 | awk '{gsub(" ", ""); print}')
	SRRs=$GSM
	for SRR in $SRRs
	do
		getFastq &
	done
#	sam-dump.2.5.4 --min-mapq 254 $file > sam/$(basename $file .sra).sam &
done
wait
echo done
