File1=persistentPeaks_common_male_female
File2=/mnt/isaachd/ATAC-seq_naturedata/peaks_keepdups/ICM_Allpooled.sorted.duprmvd.TFs.sorted.bam_peaks.narrowPeak
type1=PGC_persistent
type2=ICM
id=${tye1}_${type2}
rm File1 File2

cat $File1 $File2 | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - > merged.bed
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File1 > File1
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File2 > File2
intersectBed -u -a File1 -b File2 > overlapFile

sh getPariwisePeakVenns.sh File1 File2 overlapFile NA $type1 $type2 $id

mv overlapFile persistent_PGC_ICM
intersectBed -v -a File1 -b File2 > persistentPeaks_maleSpecific
intersectBed -v -b File1 -a File2 > persistentPeaks_femaleSpecific

