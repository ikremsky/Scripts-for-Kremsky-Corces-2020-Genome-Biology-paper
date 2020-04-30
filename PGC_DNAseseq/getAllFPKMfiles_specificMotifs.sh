mkdir /media/4TB4/isaac/ATAC_DNAme_embryoComparison/All
#cut -f 1-3 /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed | sort -k1,1 -k2n,2 | bedtools merge -i - | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,NR,".","+"}' > /media/4TB4/isaac/ATAC_DNAme_embryoComparison/fimo_All.bed

i=1
for file in $(ls /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/specificMotifs/fimo*.bed | grep All)
do
	if [ $(echo $i | awk '{print $1%7}') -eq 0 ]; then
		echo waiting
		wait
	fi
	sh getFPKM_specificMotifs.sh $file bed
	i=$(expr $i + 1)
done
wait

for file in 
#$(ls /media/4TB4/isaac/IAPs/motifs_mm9_IAPplus2kb/specificMotifs/fimo*.bed)
do
        if [ $(echo $i | awk '{print $1%7}') -eq 0 ]; then
                echo waiting
                wait
        fi
        sh getFPKM_specificMotifs.sh $file bed_IAPs
        i=$(expr $i + 1)
done
wait
echo done

