fastqFolder=fastq2
#wget -r -nd -nH ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR192/
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192344/ERR192344.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192348/ERR192348.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192353/ERR192353_1.fastq.gz &
wait
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192353/ERR192353_2.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192355/ERR192355_1.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192355/ERR192355_2.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192345/ERR192345.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192346/ERR192346.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192349/ERR192349.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192352/ERR192352_1.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192352/ERR192352_2.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192358/ERR192358_1.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192358/ERR192358_2.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192351/ERR192351_1.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192351/ERR192351_2.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192354/ERR192354_1.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192354/ERR192354_2.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192356/ERR192356_1.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192356/ERR192356_2.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192360/ERR192360_1.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192360/ERR192360_2.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192359/ERR192359_1.fastq.gz &
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192359/ERR192359_2.fastq.gz &
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192350/ERR192350_1.fastq.gz &
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192350/ERR192350_2.fastq.gz &
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192361/ERR192361_1.fastq.gz &
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR192/ERR192361/ERR192361_2.fastq.gz &
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
echo done1
sh trimFastqs.sh
echo done2
sh doAlignmnets.sh
echo done3
