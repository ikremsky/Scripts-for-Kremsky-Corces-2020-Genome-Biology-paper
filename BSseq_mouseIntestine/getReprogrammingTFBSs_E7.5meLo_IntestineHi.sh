mkdir motifAnalysis_E7.5meLo_IntestinemeHi
cd motifAnalysis_E7.5meLo_IntestinemeHi
#awk '$4 > .8' ../developmentalATACpeaks/WTAdultIntestinalEpithelium_both.hiConfidence.E7.5meLo.me > E7.5meLo_reprogrammed.bed &
#intersectBed -u -a /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed -b ../developmentalATACpeaks/E7.5_both.hiConfidence.me > motifs_hiConfidenceCpGs.bed
intersectBed -u -f 1 -F 1 -e -a /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed -b motifs_hiConfidenceCpGs.bed | cut -f1-4 | cut -f1 -d"_" > fimo.bed

wait

totalHi=$(intersectBed -u -f 1 -F 1 -e -a fimo.bed -b E7.5meLo_reprogrammed.bed | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
totalAll=$(cut -f1-3 fimo.bed | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
for TF in $(cat /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/motifs)
do
	echo $TF
	awk -v TF=$TF '$4 == TF' fimo.bed > temp
	motifHi=$(intersectBed -u -f 1 -F 1 -e -b E7.5meLo_reprogrammed.bed  -a temp | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
	if [ $motifHi -gt 25 ]; then
		motifAll=$(cut -f1-3 temp | sort -k1,1 -k2n,2 | bedtools merge -i - | wc -l)
		echo $motifHi $totalHi > ${TF}.matrix
		echo $motifAll $totalAll >> ${TF}.matrix
		R --vanilla --args ${TF}.matrix $(echo $TF) < ../fisherTest.R
	fi
done
awk 'NR%2 == 0 && $NF < .001 && $3 > $4' summary.txt | grep -v ":" > temp
cut -f1 temp | awk '{print toupper($1)}' | uniq -d > tempids
for TF in $(cat tempids)
do
	grep -v $TF temp > temp1; mv temp1 temp
done
R --vanilla --args temp E7.5meLo_IntestinemeHi < ../getBarPlots_motifs.R
intersectBed -u -a fimo.bed -b E7.5meLo_reprogrammed.bed | cut -f1-4 | cut -f1 -d"_" | awk '$4 == "E2F3" ' > fimo_E7.5meLo_IntestinemeHi_forigv.bed
echo done
