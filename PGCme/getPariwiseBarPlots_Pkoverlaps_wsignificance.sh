file1=E13.5mBS-Seq_demethResistant.notatIAPs.bed
file2=../BSseq_BPAyoonhee/hypoDMRs.bed
name1=DMR_starv
name2=accessable_motifs
id=DMR_motif

getRandomFile ()
{
        bedtools random -l $avgL -g /home/genomefiles/mouse/mm9_sizes.txt > random.bed
        intersectBed -v -a random.bed -b mm9_repeats.bed > temp
        mv temp random.bed
}

cat $file1 $file2 | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - > merged.bed
intersectBed -u -a merged.bed -b $file1 > file1.bed
intersectBed -u -a merged.bed -b $file2 > file2.bed

avgL=$(awk 'BEGIN{x=0}{x+=$3-$2}END{print x/NR}' file1.bed)
getRandomFile

OverlapN1=$(intersectBed -u -a file1.bed -b file2.bed | wc -l)
TotalN1=$(cat file1.bed | wc -l)

OverlapN2=$(intersectBed -u -a random.bed -b file2.bed | wc -l)
TotalN2=$(cat random.bed | wc -l)

echo ${OverlapN1}"\t"${TotalN1} > matrix
echo ${OverlapN2}"\t"${TotalN2} >> matrix

name=$(echo "$name1 $name2" | awk '{gsub("Rep1", ""); gsub("Rep2", ""); print}' | awk '{if($1 == $2) print $1; else print $1"_"$2}')

R --vanilla --args $id matrix $name1 $name2 "${name1}" "${name2}" "${name}_${id}_overlaps.png" < getPariwiseBarPlots_wPval.R
echo $name
