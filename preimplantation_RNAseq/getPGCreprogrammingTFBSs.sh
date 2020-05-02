mkdir motifAnalysis_E9.5Lo_E14.mHi
cd motifAnalysis_E9.5Lo_E14.mHi
cut -f1-4 /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed | cut -f1 -d"_" > fimo.bed &
join -i /media/4TB4/isaac/PGC_RNAseq/ids /mnt/bigmama/isaac/RNAseq_mouseEmbryo/cuffdiff/final/ids_PGCandPreimp > ids
totalHi=$(intersectBed -u -f 1 -F 1 -e -a /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed -b /media/4TB4/isaac/PGC_DNAseseq/bed/All/E9.5Lo_E14.5mHi.distal.fpkm | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
totalAll=$(cut -f1-3 /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
wait

for TF in $(cat ids)
do
	echo $TF
	awk -v TF=$TF '$4 == TF' fimo.bed > temp
	motifHi=$(intersectBed -u -f 1 -F 1 -e -a /media/4TB4/isaac/PGC_DNAseseq/bed/All/E9.5Lo_E14.5mHi.distal.fpkm -b temp | wc -l)
	motifAll=$(wc -l temp | cut -f1 -d" ")
	echo $motifHi $totalHi > ${TF}.matrix
	echo $motifAll $totalAll >> ${TF}.matrix
	R --vanilla --args ${TF}.matrix $(echo $TF) < ../fisherTest.R
done
awk 'NR%2 == 0' summary.txt > temp
R --vanilla --args temp E9.5Lo_E14.5mHi_motifCounts < ../getBarPlots.R
