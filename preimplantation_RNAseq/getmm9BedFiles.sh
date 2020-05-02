mkdir bed
cd bed
for file in $(ls /Zulu/isaac/RNAseq_embryo_Nature/bed/*split.bed)
do
	/programs/liftOver $file /mnt/isaachd/methylationCellData/mm10ToMm9.over.chain $(basename $file .bed).mm9.bed $(basename $file .bed).unmapped &
done
wait
