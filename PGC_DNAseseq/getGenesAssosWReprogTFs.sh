#/media/4TB4/isaac/PGC_DNAseseq/bed/All/E9.5Hi_E14.5mLo.distal.fpkm
#/media/4TB4/isaac/PGC_DNAseseq/bed/All/E9.5Lo_E14.5mHi.distal.fpkm

awk '$NF > 10' /media/4TB4/isaac/PGC_RNAseq/cuffdiff/final/E11.5.genes.mm9.fpkm | cut -f1-6 | sort -k1,1 -k2n,2 > E10.5genes.fpkm
awk '$NF > 10' /media/4TB4/isaac/PGC_RNAseq/cuffdiff/final/E16.5m.genes.mm9.fpkm | cut -f1-6 | sort -k1,1 -k2n,2 > E16.5mgenes.fpkm

intersectBed -wa -wb -a ../TSS.bed -b E10.5genes.fpkm | awk '$4 == $11' | cut -f1-6 | sort -k1,1 -k2n,2 > temp; mv temp E10.5genes.fpkm
intersectBed -wa -wb -a ../TSS.bed -b E16.5mgenes.fpkm | awk '$4 == $11' | cut -f1-6 | sort -k1,1 -k2n,2 > temp; mv temp  E16.5mgenes.fpkm

bedtools closest -d -a /media/4TB4/isaac/PGC_DNAseseq/bed/All/E9.5Hi_E14.5mLo.distal.fpkm -b E10.5genes.fpkm | awk '$NF < 10000' | cut -f11 | sort -b | uniq > E9.5HiE14mLoassociatedGenes.txt
bedtools closest -d -a /media/4TB4/isaac/PGC_DNAseseq/bed/All/E9.5Lo_E14.5mHi.distal.fpkm -b E16.5mgenes.fpkm | awk '$NF < 10000' | cut -f11 | sort -b | uniq > E9.5LoE14mHiassociatedGenes.txt
#sort -k1,1 -k2n,2 ../TSS.bed > TSS.bed
wc -l E9.5HiE14mLoassociatedGenes.txt E9.5LoE14mHiassociatedGenes.txt
