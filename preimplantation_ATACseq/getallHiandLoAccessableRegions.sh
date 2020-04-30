i=1
for motif in $(cat /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/motifs)
do
	echo $motif
	if [ $(echo $i | awk '{print $1%7}') -eq 0 ]; then
		wait
	fi
	sh getHiandLoAccessableRegions.sh $motif &
	i=$(expr $i + 1)
done
wait
