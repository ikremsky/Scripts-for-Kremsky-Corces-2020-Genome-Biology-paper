type=to2i
#to2i
#toSerum
fpkmFile=/media/4TB4/isaac/ChIPseq_NRF1/bed_extended/CHIP_${type}.sorted.duprmvdatNRF1_mergedPeaks.bed.fpkm
affinityFile=NRF1_highestAffinities.bed

mkdir sequences

intersectBed -wa -wb -b $fpkmFile -a $affinityFile | sort -k6,6 -k7n,7 -k5gr,5 | uniq -f 5 | awk 'BEGIN{OFS="\t"}{sim=$5; print $1,$2,$3,$4,sim,$NF}' > sequences/All_similarity_fpkm

R --vanilla --args sequences/All_similarity_fpkm $type < makeScatterplot.R
wc -l sequences/All_E14.5mHiTFBS_similarity_fpkm
