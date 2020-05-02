#wget http://hgdownload.cse.ucsc.edu/goldenPath/mm10/liftOver/mm10ToMm9.over.chain.gz
mkdir bed
cd bed
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386020/suppl/GSM1386020%5Fsperm%5Fmc%5FCG%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386021/suppl/GSM1386021%5F2cell%5Fmc%5FCG%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386022/suppl/GSM1386022%5F4cell%5Fmc%5FCG%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386023/suppl/GSM1386023%5FICM%5Fmc%5FCG%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386024/suppl/GSM1386024%5FE65%5Fmc%5FCG%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386025/suppl/GSM1386025%5FE75%5Fmc%5FCG%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386021/suppl/GSM1386021%5F2cell%5Fmc%5FCG%5Fpaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386022/suppl/GSM1386022%5F4cell%5Fmc%5FCG%5Fpaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386023/suppl/GSM1386023%5FICM%5Fmc%5FCG%5Fpaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386024/suppl/GSM1386024%5FE65%5Fmc%5FCG%5Fpaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386025/suppl/GSM1386025%5FE75%5Fmc%5FCG%5Fpaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386019/suppl/GSM1386019%5Foocyte%5Fmc%5FCG%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386021/suppl/GSM1386021%5F2cell%5Fmc%5FCG%5Fmaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386022/suppl/GSM1386022%5F4cell%5Fmc%5FCG%5Fmaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386023/suppl/GSM1386023%5FICM%5Fmc%5FCG%5Fmaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386024/suppl/GSM1386024%5FE65%5Fmc%5FCG%5Fmaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386025/suppl/GSM1386025%5FE75%5Fmc%5FCG%5Fmaternal%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386028/suppl/GSM1386028%5F2cell%5Fhmc%5Fmaternal%5FCG%5F%2B%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386028/suppl/GSM1386028%5F2cell%5Fhmc%5Fmaternal%5FCG%5F%2D%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386028/suppl/GSM1386028%5F2cell%5Fhmc%5Fpaternal%5FCG%5F%2B%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386028/suppl/GSM1386028%5F2cell%5Fhmc%5Fpaternal%5FCG%5F%2D%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386027/suppl/GSM1386027%5FE135M%5Fmc%5FCG%5Fplus%2Ebed%2Egz
#wget ftp://ftp.ncbi.nlm.nih.gov/geo/samples/GSM1386nnn/GSM1386026/suppl/GSM1386026%5FE135F%5Fmc%5FCG%5Fplus%2Ebed%2Egz

#gunzip *gz
for file in 
#$(ls *.bed | grep -v mm | grep -v hmc | grep E135)
do
	awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,$5","$6}' $file > temp
	mv temp $(basename $file .bed).mm10.bed
done

for file in 
#$(ls *mm10.bed | grep E135)
do
	/programs/liftOver $file ../mm10ToMm9.over.chain $(echo $file | awk '{gsub("mm10", "mm9"); print}') $(echo $file | awk '{gsub("mm10", "mm9"); print}').unmapped &
done
wait

i=1
for file in $(ls *mm9.bed)
do
	name=$(basename $file .bed)
#	awk '{gsub(",", "\t"); print}' $file > temp
#	mv temp $file
        awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 10 && $4 > .8) print}' $file > ${name}.meHi.bed &
        awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 10 && $4 < .2) print}' $file > ${name}.meLo.bed &
	awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 9) print}' $file > ${name}.hiConfidence.bed &
	if [ $(echo $i | awk '{print $1%4}') -eq 0 ]; then
		echo waiting $i
		wait
	fi
	i=$(expr $i + 1)
done
wait
echo done
