File1=overlapFile123_male
#overlapFile123_male
File2=overlapFile123_female
#/mnt/isaachd/ATAC-seq_naturedata/peaks_keepdups/ICM_Allpooled.sorted.duprmvd.TFs.sorted.bam_peaks.narrowPeak
#overlapFile123_female
type1=male
#PGC_persistent
#male
type2=female
#ICM
#female
id=${tye1}_${type2}
rm File1 File2

cat $File1 $File2 | sort -k1,1 -k2n,2 | bedtools merge -i - > merged.bed
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File1 > File1
intersectBed -u -f .5 -F .5 -e -a merged.bed -b $File2 > File2
intersectBed -u -a File1 -b File2 > overlapFile

sh getPariwisePeakVenns.sh File1 File2 overlapFile NA $type1 $type2 $id

mv overlapFile persistentPeaks_common_male_female
intersectBed -v -a File1 -b File2 > persistentPeaks_maleSpecific
intersectBed -v -b File1 -a File2 > persistentPeaks_femaleSpecific

