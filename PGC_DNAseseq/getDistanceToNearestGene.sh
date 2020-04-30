motifFile=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm
ctrlFile=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm
genes=/mnt/isaachd/annotations/mm9_all_Refseq_unique.bed
bedtools closest -d -a $motifFile -b $genes | cut -f1-6,14 > temp.bed
R --vanilla --args temp.bed < getHistogram.R
