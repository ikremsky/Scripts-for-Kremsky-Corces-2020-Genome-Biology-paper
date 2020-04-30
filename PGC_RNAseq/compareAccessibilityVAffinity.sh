hiFile=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm
loFile=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm
fimoFile=/media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed
affinityFile=../E16.5m_highestAffinities.bed
mkdir sequences
cd sequences
intersectBed -wa -wb -b $hiFile -a $affinityFile | sort -k6,6 -k7n,7 -k5gr,5 | uniq -f 5 | awk 'BEGIN{OFS="\t"}{sim=$5; print $1,$2,$3,$4,sim,$NF}' >  All_E14.5mHiTFBS_similarity_fpkm
intersectBed -wa -wb -b $loFile -a $affinityFile | sort -k6,6 -k7n,7 -k5gr,5 | uniq -f 5 | awk 'BEGIN{OFS="\t"}{sim=$5; print $1,$2,$3,$4,sim,$NF}' >  All_E14.5mLoTFBS_similarity_fpkm
intersectBed -wa -wb -b /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distal.fpkm -a $affinityFile | sort -k6,6 -k7n,7 -k5gr,5 | uniq -f 5 | awk 'BEGIN{OFS="\t"}{sim=$5; print $1,$2,$3,$4,sim,$NF}' > All_similarity_fpkm

cd ..
cut -f5,7 cuffdiff/final/E16.5m-E13.5m.genes.mm9.fpkm > temp
R --vanilla --args sequences/All_E14.5mHiTFBS_similarity_fpkm sequences/All_E14.5mLoTFBS_similarity_fpkm sequences/All_similarity_fpkm < makeScatterplot.R
wc -l sequences/All_E14.5mHiTFBS_similarity_fpkm
