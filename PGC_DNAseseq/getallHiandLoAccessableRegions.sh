i=1
sort -b /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/motifs > temp1
cut -f 1 /media/4TB4/isaac/PGC_RNAseq/E16.5m.genes.fpkm | sort -b > temp2

for motif in $(join -i temp1 temp2)
do
	echo $motif
	if [ $(echo $i | awk '{print $1%3}') -eq 0 ]; then
		wait
	fi
	sh getHiandLoAccessableRegions.sh $motif &
	i=$(expr $i + 1)
done
wait
echo done
