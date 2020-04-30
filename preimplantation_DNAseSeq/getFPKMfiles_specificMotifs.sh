i=1
for file in $(ls /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/specificMotifs/fimo*.bed | grep All)
do
	if [ $(echo $i | awk '{print $1%10}') -eq 0 ]; then
		echo waiting
		wait
	fi
	sh getFPKM_NatureData_mm9.sh $file &
	i=$(expr $i + 1)
done
wait
