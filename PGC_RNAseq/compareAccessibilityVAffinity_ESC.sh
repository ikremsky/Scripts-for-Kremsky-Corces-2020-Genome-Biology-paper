allFile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/bed/All/ESC-Rep1-2_pooled_x115-TFatfimo_All.distal.fpkm
hiFile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/bed/All/ESC-Rep1-2_pooled_x115-TFatfimo_All.distalHi.fpkm
loFile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/bed/All/ESC-Rep1-2_pooled_x115-TFatfimo_All.notatIAPs.distalLo.fpkm

mkdir sequences
cd sequences
intersectBed -wa -wb -b $hiFile -a ../ESC_highestAffinities.bed | sort -k6,6 -k7n,7 -k5gr,5 | uniq -f 5 | awk 'BEGIN{OFS="\t"}{sim=$5; print $1,$2,$3,$4,sim,$NF}' >  All_ESCHiTFBS_similarity_fpkm
intersectBed -wa -wb -b $loFile -a ../ESC_highestAffinities.bed | sort -k6,6 -k7n,7 -k5gr,5 | uniq -f 5 | awk 'BEGIN{OFS="\t"}{sim=$5; print $1,$2,$3,$4,sim,$NF}' >  All_ESCLoTFBS_similarity_fpkm
intersectBed -wa -wb -b $allFile -a ../ESC_highestAffinities.bed | sort -k6,6 -k7n,7 -k5gr,5 | uniq -f 5 | awk 'BEGIN{OFS="\t"}{sim=$5; print $1,$2,$3,$4,sim,$NF}' > All_similarity_fpkm_ESC

cd ..
cut -f5,7 cuffdiff/final/E16.5m-E13.5m.genes.mm9.fpkm > temp
R --vanilla --args sequences/All_ESCHiTFBS_similarity_fpkm sequences/All_ESCLoTFBS_similarity_fpkm sequences/All_similarity_fpkm_ESC < makeScatterplot_ESC.R
wc -l sequences/All_ESCHiTFBS_similarity_fpkm
