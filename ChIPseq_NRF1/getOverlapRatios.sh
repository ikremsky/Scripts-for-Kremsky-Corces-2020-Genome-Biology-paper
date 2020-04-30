name1=$1
name2=$2
HiN=$(cut -f1 ${name1}_mergedPks.bed | wc -l)
LoN=$(cut -f1 ${name2}_mergedPks.bed | wc -l)
intersectBed -u -a ${sample}_mergedPks.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | wc -l
name1=$(echo $name1 | awk '{sub("to", ""); print}')
name2=$(echo $name2 | awk '{sub("to", ""); print}')

Hin=$(intersectBed -u -a ${name1}_mergedPks.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | wc -l)
Lon=$(intersectBed -u -a ${name2}_mergedPks.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | wc -l)
echo ${Hin}"\t"${HiN} > matrix
echo ${Lon}"\t"${LoN} >> matrix
R --vanilla --args $name1 matrix $name2 < getPariwiseBarPlots_wPval.R
