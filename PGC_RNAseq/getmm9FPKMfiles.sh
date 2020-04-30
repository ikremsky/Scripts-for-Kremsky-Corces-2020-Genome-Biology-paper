cd cuffdiff/final
convert ()
{
	awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4"_"$5"_"$6"_"$7}' $file > $(basename $file .fpkm).tempfpkm
	/programs/liftOver $(basename $file .fpkm).tempfpkm /mnt/isaachd/methylationCellData/mm10ToMm9.over.chain $(basename $file .fpkm).mm9.tempfpkm $(basename $file .fpkm).unmapped
	awk 'BEGIN{OFS="\t"}{gsub("_", "\t"); print}' $(basename $file .fpkm).mm9.tempfpkm | grep -v random > $(basename $file .fpkm).mm9.fpkm
}

for file in $(ls *genes.fpkm)
do
	convert &
done
wait
rm *tempfpkm
