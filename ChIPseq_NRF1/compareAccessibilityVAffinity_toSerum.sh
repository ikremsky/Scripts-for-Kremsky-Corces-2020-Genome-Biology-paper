fpkmFile=/media/4TB4/isaac/ChIPseq_NRF1/bed_shifted/CHIP_toSerum.sorted.duprmvdatNRF1_mergedPeaks.bed.fpkm
affinityFile=NRF1_highestAffinities.bed

mkdir sequences

intersectBed -wa -wb -b $fpkmFile -a $affinityFile | sort -k6,6 -k7n,7 -k5gr,5 | uniq -f 5 | awk 'BEGIN{OFS="\t"}{sim=$5; print $1,$2,$3,$4,sim,$NF}' > sequences/All_similarity_fpkm_toSerum

R --vanilla --args sequences/All_similarity_fpkm_toSerum < makeScatterplot_toSerum.R
wc -l sequences/All_E14.5mHiTFBS_similarity_fpkm
