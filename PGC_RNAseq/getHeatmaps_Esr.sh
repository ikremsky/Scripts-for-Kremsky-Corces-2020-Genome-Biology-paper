motif=Esr
region=genes
HiFile=all.fpkm

cd cuffdiff/final/
grep -i Esr E11.5.genes.fpkm | grep -v Esrp | cut -f5 | grep -v "-" | grep -v os > ids_Dnmt_tet
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
R --vanilla --args ${motif}_${region} ${fileEnd} E11.5${fileEnd} E13.5m${fileEnd} E16.5m${fileEnd} < /mnt/bigmama/isaac/RNAseq_mouseEmbryo/getHeatmaps_Dnmt_Tet.R
