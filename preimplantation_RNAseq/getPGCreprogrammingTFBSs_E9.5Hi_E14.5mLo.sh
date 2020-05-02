mkdir motifAnalysis_E9.5Hi_E14.5mLo
cd motifAnalysis_E9.5Hi_E14.5mLo
#cut -f1-4 /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed | cut -f1 -d"_" > fimo.bed &
#totalHi=$(intersectBed -u -f 1 -F 1 -e -a /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed -b /media/4TB4/isaac/PGC_DNAseseq/bed/All/E9.5Hi_E14.5mLo.distal.fpkm | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
#totalAll=$(cut -f1-3 /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
wait

for TF in 
#$(cat /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/motifs)
do
	echo $TF
	awk -v TF=$TF '$4 == TF' fimo.bed > temp
	motifHi=$(intersectBed -u -f 1 -F 1 -e -b /media/4TB4/isaac/PGC_DNAseseq/bed/All/E9.5Hi_E14.5mLo.distal.fpkm -a temp | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
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
R --vanilla --args temp E9.5Hi_E14.5mLo_motifCounts < ../getBarPlots.R
echo done
