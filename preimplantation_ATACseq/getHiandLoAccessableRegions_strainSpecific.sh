TF=all
#$1
cd bed_TFs_strainSpecific/$TF
for type in ICM
#early2-cell 2-cell 4-cell ICM
do
	for genome in genome1 genome2
	do
		file=$(ls ${type}*fpkm | grep -v -e Lo -e Hi | grep $genome)
		echo $file
		awk '$NF < 1000' $file > $(basename $file .fpkm).Lo.fpkm
		awk '$NF > 5000' $file > $(basename $file .fpkm).Hi.fpkm
#		intersectBed -u -a temp -b $(ls /mnt/isaachd/ATAC-seq_naturedata/bed_TFs_allstrains/${TF}/${type}*Hi.fpkm | grep -v distal) > $(basename $file .fpkm).Hi.fpkm
	done
#	intersectBed -u -a ${type}_genome1pooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Hi.fpkm -b ${type}_genome2pooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Lo.fpkm > ${type}_Mspecific.fpkm &
#	intersectBed -u -a ${type}_genome2pooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Hi.fpkm -b ${type}_genome1pooled.sorted.duprmvd.TFs.sortedatfimo_${TF}.Lo.fpkm > ${type}_Pspecific.fpkm &
	intersectBed -u -a ${type}_genome1pooled.sorted.duprmvd.TFs.sortedatCpGs_strainSpecific.Hi.fpkm -b ${type}_genome2pooled.sorted.duprmvd.TFs.sortedatCpGs_strainSpecific.Lo.fpkm > ${type}_Mspecific.fpkm &
	intersectBed -u -a ${type}_genome2pooled.sorted.duprmvd.TFs.sortedatCpGs_strainSpecific.Hi.fpkm -b ${type}_genome1pooled.sorted.duprmvd.TFs.sortedatCpGs_strainSpecific.Lo.fpkm > ${type}_Pspecific.fpkm &
	wait
done

for type in 
#Cont_Sperm MIIoocyte GVoocyte
do
	file=$(ls ${type}*fpkm | grep -v -e Lo -e Hi | grep $TF)
	awk '$NF == 0' $file > $(basename $file .fpkm).Lo.fpkm
	awk '$NF > 75' $file > $(basename $file .fpkm).Hi.fpkm
done
#intersectBed -u -a MIIoocyterep1_mm9.sort.rmdup.flt.TFatfimo_${TF}.Hi.fpkm -b Cont_Sperm_OmniATACseq_x115_TF_sortatfimo_${TF}.Lo.fpkm
