motif=E16.5mHi
region=genes
HiFile=all.fpkm

cd cuffdiff/final/
idFile=/media/4TB4/isaac/PGC_RNAseq/ids
fileEnd=.genes.E16.5mHi.fpkm
rm *$fileEnd
getFiles ()
{
	join -1 5 -i $file $idFile | awk 'BEGIN{OFS="\t"}{print $2,$3,$4,$5,$1,$6,$7}' > $(basename $file .fpkm).E16.5mHi.fpkm
}
for file in $(ls *genes.fpkm)
do
	getFiles &
done
wait
R --vanilla --args ${motif}_${region} ${fileEnd} zygote_PN5${fileEnd} 2cell_early${fileEnd} 2cell_late${fileEnd} 4cell${fileEnd} 8cell${fileEnd} ICM${fileEnd} ESC${fileEnd} < /mnt/bigmama/isaac/RNAseq_mouseEmbryo/getHeatmaps.R
