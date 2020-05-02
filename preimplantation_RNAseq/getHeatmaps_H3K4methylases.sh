motif=H3K4methylases
region=genes
HiFile=all.fpkm

cd cuffdiff/final/
grep -e Kmt2d -e Ash2l -e Kdm5 zygote_PN5.genes.fpkm | cut -f5 | grep -v "-" | grep -v os | sort -b > ids_Dnmt_tet
idFile=ids_Dnmt_tet
fileEnd=.genes.${motif}.fpkm
rm *$fileEnd
getFiles ()
{
	join -1 5 -i $file $idFile | awk 'BEGIN{OFS="\t"}{print $2,$3,$4,$5,$1,$6,$7}' > $(basename $file .fpkm).${motif}.fpkm
}
for file in $(ls *genes.fpkm)
do
	getFiles &
done
wait
R --vanilla --args ${motif}_${region} ${fileEnd} zygote_PN5${fileEnd} 2cell_early${fileEnd} 2cell_late${fileEnd} 4cell${fileEnd} 8cell${fileEnd} ICM${fileEnd} ESC${fileEnd} < /mnt/bigmama/isaac/RNAseq_mouseEmbryo/getHeatmaps_Dnmt_Tet.R
