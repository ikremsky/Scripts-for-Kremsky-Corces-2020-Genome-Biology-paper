#intersectBed -v -a bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm -b ../TSS.bed > temp
intersectBed -u -a temp -b /mnt/isaachd/ATAC-seq_naturedata/peaks_keepdups/ICM_Allpooled.sorted.duprmvd.TFs.sorted.bam_peaks.narrowPeak > temp2
for file in $(ls /Zulu/isaac/PGCme/bed/*hiConf.bed | grep -v fBS | grep -e 16 -e 13)
do
	intersectBed -u -a temp2 -b $file > temp3; mv temp3 temp2
done

for file in $(ls /mnt/isaachd/methylationCellData/bed/*hiConfidence.bed | grep -e ICM -e E75)
do
        intersectBed -u -a temp2 -b $file > temp3; mv temp3 temp2
done

sort -k7nr,7 temp2 | head
wc -l temp2
