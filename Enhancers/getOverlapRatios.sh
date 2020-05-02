name1=E14.5m-Hi
name2=E14.5m-Lo
HiN=$(cut -f1 /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm | wc -l)
LoN=$(cut -f1 /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm | wc -l)
#cat bed/*broadPeak | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | awk 'BEGIN{OFS="\t"}{print $0,NR,".","+"}' > merged_AllStdPk.broadPeak
for file in merged_AllStdPk.broadPeak
#$(ls bed/* | grep C57)
do
	tissue=$(basename $file | awk '{sub("H3k27ac", "_"); sub("wgEncodeLicrHistone", ""); print}' | cut -f1 -d"_")
	age=$(basename $file | awk '{sub("H3k27ac", "_"); print}' | cut -f2 -d"_" | awk '{sub("StdPk.broadPeak", ""); sub("C57bl6", ""); sub("half", ""); sub("M", ""); sub("F", ""); sub("U", ""); sub("Adult", ""); print}')
	echo $tissue
	Hin=$(intersectBed -u -a /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm -b $file | wc -l)
	Lon=$(intersectBed -u -a /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.notatIAPs.distalLo.fpkm -b $file | wc -l)
	echo ${Hin}"\t"${HiN} > matrix
	echo ${Lon}"\t"${LoN} >> matrix
	R --vanilla --args $tissue matrix $age < getPariwiseBarPlots_wPval.R
done
