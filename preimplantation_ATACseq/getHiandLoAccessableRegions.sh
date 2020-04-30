TF=$1
cd bed_TFs_allstrains/$TF
for type in early2-cell 2-cell ICM Cont_Sperm MIIoocyte GVoocyte
do
	file=$(ls ${type}*fpkm | grep -v -e Lo -e Hi | grep $TF)
	awk '$NF == 0' $file > $(basename $file .fpkm).Lo.fpkm
	awk '$NF > 75' $file > $(basename $file .fpkm).Hi.fpkm
	intersectBed -v -a $(basename $file .fpkm).Hi.fpkm -b /mnt/isaachd/annotations/TSSs_500bparouns_mm9.bed > $(basename $file .fpkm).distalHi.fpkm
	intersectBed -v -a $(basename $file .fpkm).Lo.fpkm -b /mnt/isaachd/annotations/TSSs_500bparouns_mm9.bed >  $(basename $file .fpkm).distalLo.fpkm
done
wc -l ICM_Allpooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Hi.fpkm ICM_Allpooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Lo.fpkm
head ICM_Allpooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Hi.fpkm ICM_Allpooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Lo.fpkm
intersectBed -u -a early2-cell_Allpooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Hi.fpkm -b ICM_Allpooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Lo.fpkm > early2cellHi_ICMLo_${TF}.notinICM.fpkm &
intersectBed -u -a ICM_Allpooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Hi.fpkm -b early2-cell_Allpooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Lo.fpkm > ICMHi_early2-cellLo_${TF}.notinICM.fpkm &
wait
head early2cellHi_ICMLo_${TF}.notinICM.fpkm ICMHi_early2-cellLo_${TF}.notinICM.fpkm
wc -l early2cellHi_ICMLo_${TF}.notinICM.fpkm ICMHi_early2-cellLo_${TF}.notinICM.fpkm
