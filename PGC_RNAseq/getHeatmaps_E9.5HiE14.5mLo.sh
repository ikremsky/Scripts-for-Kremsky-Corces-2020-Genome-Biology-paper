motif=E9.5HiE14.5mLo
region=genes
HiFile=all.fpkm

cd cuffdiff/final/
cut -f1 /mnt/bigmama/isaac/RNAseq_mouseEmbryo/motifAnalysis_E9.5Hi_E14.5mLo/temp | grep -v TFAP | awk '{sub("Tcfap", "Tfap"); print}' > ids_E9.5HiE14.5mLo
idFile=ids_E9.5HiE14.5mLo
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
