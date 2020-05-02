mkdir motifAnalysis_IAPs
cd motifAnalysis_IAPs
cut -f1-4 /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed | cut -f1 -d"_" > fimo.bed &
grep -e IAPLTR1 -e IAPLTR2 /Zulu/isaac/starvation_sperm/mm9_IAPs.bed > IAPs.bed
intersectBed -u -a /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed -b IAPs.bed | cut -f1-4 | cut -f1 -d"_" > fimo_IAPs.forigv.bed
totalHi=$(cut -f1-3 fimo_IAPs.forigv.bed | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
totalAll=$(cut -f1-3 /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
wait

for TF in $(cat /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/motifs)
do
	echo $TF
	awk -v TF=$TF '$4 == TF' fimo.bed > temp
	motifHi=$(grep $TF fimo_IAPs.forigv.bed | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
	if [ $motifHi -gt 25 ]; then
		motifAll=$(cut -f1-3 temp | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
		echo $motifHi $totalHi > ${TF}.matrix
		echo $motifAll $totalAll >> ${TF}.matrix
		R --vanilla --args ${TF}.matrix $(echo $TF) < ../fisherTest.R
	fi
done
awk 'NR%2 == 0 && $NF < .01' summary.txt > temp
cut -f1 temp | awk '{print toupper($1)}' | uniq -d > tempids
for TF in $(cat tempids)
do
	grep -v $TF temp > temp1; mv temp1 temp
done
join temp /media/4TB4/isaac/PGC_RNAseq/ids | awk '{gsub(" ", "\t"); print}' > temp2
R --vanilla --args temp2 E14.5mExpressed < ../getBarPlots_IAPs.R
echo done
