cd peaks
#zcat *.gz | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - > ../allEncodePeaks.bed
cd ..
awk 'BEGIN{OFS="\t"}{print $1,$2-2000,$3+2000,$4,$5,$6}' /media/4TB4/isaac/PGCme/mm9_IAPs.bed > mm9_IAPplus2kb.bed
#cat /media/4TB4/isaac/PGC_DNAseseq/peaks/*.mm9.norandom.bed allEncodePeaks.bed $(ls /mnt/bigmama/isaac/DNAseSeq/peaks/*.bed | grep -v distal | grep -v proximal) | cut -f 1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - > allPeaks.bed
intersectBed -v -a allPeaks.bed -b mm9_IAPplus2kb.bed > allPeaks_noIAPs.bed
