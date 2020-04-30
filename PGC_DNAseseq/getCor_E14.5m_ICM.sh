PGCfile=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm
ICMfile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/bed/All/ESC-Rep1-2_pooled_x115-TFatfimo_All.fpkm
#/mnt/bigmama/isaac/DNAseSeq/bed_shifted/All/Morula_pooled.sorted.duprmvdatfimo_All.fpkm
#/mnt/isaachd/ATAC-seq_naturedata/bed_mm9/All/ICM_pooled.sorted.duprmvd.TFsatfimo_All.fpkm
#intersectBed -u -a $ICMfile -b $PGCfile > temp
ICMfile=temp
echo $(awk '$NF < 1' temp | wc -l) "ATAC_TF-Lo" > countFile.txt
echo $(awk '$NF >= 1 && $NF < 20' temp | wc -l) "Intermediate" >> countFile.txt
echo $(awk '$NF >= 20' temp | wc -l) "ATAC_TF-Hi" >> countFile.txt

R --vanilla --args countFile.txt < getPieCharts.R
#R --vanilla --args E14.5mvESC $PGCfile $ICMfile < getScatterPlots.R
