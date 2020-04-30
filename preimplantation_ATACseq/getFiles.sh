#wget -r -nd -nH ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP/SRP055/SRP055881
mkdir sra
mkdir fastq
mkdir sam
mv *.sra sra/

for file in $(ls sra/*.sra)
#sra/SRR3536936.sra
#sra/SRR3336397.sra sra/SRR3336398.sra
#sra/SRR3536933.sra 
#sra/SRR3545573.sra
#$(awk '{if($3 == "SINGLE") print "sra/"$7".sra"}' SraRunTable.txt)
do
  	echo $file
	fastq-dump-2.5.4 --gzip --split-files $file -O /mnt/isaachd/ATAC-seq_naturedata/fastq &
#	sam-dump.2.5.4 --min-mapq 254 $file > sam/$(basename $file .sra).sam &
done
wait
echo done
