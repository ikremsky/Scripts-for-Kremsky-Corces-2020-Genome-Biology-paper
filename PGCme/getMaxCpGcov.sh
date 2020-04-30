cd bed
for file in $(ls *.hiConf.bed | grep -v 5f | grep -v E6.5)
do
	echo $file
	type=$(echo $file | awk '{sub("BS-Seq_meth.hiConf.bed", ""); print}')
#	max=$(intersectBed -u -a $file -b /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm | awk '{x=$5+$6; if(x > 100) print x}' | sort -nr | head -1)
#	maxCont=$(intersectBed -u -a $file -b /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm | awk '{x=$5+$6; if(x > 100) print x}' | sort -nr | head -1)
#	echo $type $max $maxCont | awk '{sub("\t", ""); print}' >> maxCpGcovs.txt

	fullFile=$(echo $file | awk '{sub(".hiConf", ""); print}')
	N=$(intersectBed -u -a $fullFile -b /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm | wc -l)
	Ncont=$(intersectBed -u -a $fullFile -b /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm | wc -l)
	echo $type $N $Ncont | awk '{sub("\t", ""); print}' >> CpGcounts.txt
done
cat maxCpGcovs.txt
cat CpGcounts.txt
cd ..
join bed/maxCpGcovs.txt bed/CpGcounts.txt | awk '{if(NF == 4) {tn=100; tN=$3; cn=$2; cN=$4} else {tn=$2; tN=$4; cn=$3; cN=$5} print $1,100*tn/tN,100*cn/cN}'
