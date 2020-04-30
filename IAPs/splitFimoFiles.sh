cd motifs_mm9_IAPplus2kb
mkdir specificMotifs

getFiles ()
{
	grep $motif fimo.forigv.bed | cut -f 1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | awk -v motif=$motif 'BEGIN{OFS="\t"}{print $1,$2,$3,motif,".","+"}' > specificMotifs/fimo_${motif}.bed
	if [ $(head specificMotifs/fimo_${motif}.bed | wc -l) -eq 0 ]; then
		rm specificMotifs/fimo_${motif}.bed
	fi
}

cut -f4 fimo.forigv.bed | sort | uniq > motifs
for motif in $(cat /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/motifs)
do
	getFiles &
done
wait
cut -f 1-3 fimo.forigv.bed | sort -k1,1 -k2n,2 | bedtools merge -i - | awk -v motif=All 'BEGIN{OFS="\t"}{print $1,$2,$3,motif,".","+"}' > specificMotifs/fimo_All.bed
echo done
