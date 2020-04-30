paste /media/4TB4/isaac/ChIPseq_NRF1/bed_shifted/CHIP_to2i.sorted.duprmvdatNRF1_mergedPeaks.bed.fpkm /media/4TB4/isaac/ChIPseq_NRF1/bed_shifted/CHIP_toSerum.sorted.duprmvdatNRF1_mergedPeaks.bed.fpkm | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,$5,$6,$7-$NF}' > mergedPeaks_2i-Serum.fpkm
fpkmFile=mergedPeaks_2i-Serum.fpkm
affinityFile=NRF1_highestAffinities.bed
mkdir sequences

awk '$NF > 1' reprogrammingTFs_highestAffinities.bed > reprogrammingTFs_highestAffinities_Hi.bed
awk '$NF < .1' reprogrammingTFs_highestAffinities.bed > reprogrammingTFs_highestAffinities_Lo.bed

#intersectBed -wa -wb -b $fpkmFile -a $affinityFile | sort -k6,6 -k7n,7 -k5gr,5 | uniq -f 5 | awk 'BEGIN{OFS="\t"}{sim=$5; print $1,$2,$3,$4,sim,$NF}' > sequences/All_similarity_fpkm_2i-Serum
intersectBed -u -a sequences/All_similarity_fpkm_2i-Serum -b reprogrammingTFs_highestAffinities_Lo.bed > sequences/All_similarity_fpkm_2i-Serum_reprogrammingLo
intersectBed -u -a sequences/All_similarity_fpkm_2i-Serum -b reprogrammingTFs_highestAffinities_Hi.bed > sequences/All_similarity_fpkm_2i-Serum_reprogrammingHi
#R --vanilla --args sequences/All_similarity_fpkm_2i-Serum 2ivSerum < makeScatterplot_2iVserum.R
R --vanilla --args sequences/All_similarity_fpkm_2i-Serum_reprogrammingLo 2ivSerum_reprogrammingLo < makeScatterplot_2iVserum.R
R --vanilla --args sequences/All_similarity_fpkm_2i-Serum_reprogrammingHi 2ivSerum_reprogrammingHi < makeScatterplot_2iVserum.R

