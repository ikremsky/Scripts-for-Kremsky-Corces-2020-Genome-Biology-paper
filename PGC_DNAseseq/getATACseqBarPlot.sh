annotation=/mnt/isaachd/annotations/TSSs_500bparouns_mm9.bed
for DEpkfile in persistent_PGC_ICM
#persistentPeaks_common_male_female /mnt/isaachd/ATAC-seq_naturedata/peaks_keepdups/ICM_Allpooled.sorted.duprmvd.TFs.sorted.bam_peaks.narrowPeak
#persistentPeaks_femaleSpecific  persistentPeaks_maleSpecific
do
        intersectBed -f .5 -F .5 -e -u -b $annotation -a $DEpkfile | wc -l >> within
        intersectBed -f .5 -F .5 -e -v -b $annotation -a $DEpkfile | wc -l >> outside
done
paste within outside > DEpkCountMatrix
rm within outside
R --vanilla --args PromoterVoutsideCounts DEpkCountMatrix Promoter Distal PGC_ICM_persistent < getStackedBarPlots.R
