qval=1.1
for file in $(ls fimo/*/fimo.txt)
do








	newFile=$(echo $file | awk '{gsub(".txt", ".bed"); print}')
	echo $newFile
        grep -h -v "#" $file | grep CTCF | awk -v q=$qval 'BEGIN{OFS="\t"}{if($8 < q) print $3,$4,$1,$7,$5,$NF,$2}' | sort -k7,7 -k4g,4 | uniq -f 6 | awk 'BEGIN{OFS="\t"}{print $NF,$1,$2,$3,$4,$5,$6}' | awk 'BEGIN{OFS="\t"}{gsub("-", "\t", $1); gsub(":", "\t"); print}' | awk 'BEGIN{OFS="\t"}{print $1,$2+$4-1,$2+$5,$6,$7,$8,$9}' > $(echo $newFile | awk '{gsub(".bed", ".withsequence.bed"); print}')
        grep -h -v "#" $file |  grep CTCF | awk -v q=$qval 'BEGIN{OFS="\t"}{if($8 < q) print $3,$4,$1,$7,$5,$NF,$2}' | sort -k7,7 -k4g,4 | uniq -f 6 | awk 'BEGIN{OFS="\t"}{print $NF,$1,$2,$3,$4,$5,$6}' | awk 'BEGIN{OFS="\t"}{gsub("-", "\t", $1); gsub(":", "\t"); print}' | awk 'BEGIN{OFS="\t"}{print $1,$2+$4-1,$2+$5,$6,$7,$8}' > $(echo $newFile | awk '{gsub(".bed", ".bed"); print}')
	rm $(echo $file | awk '{gsub(".txt", ""); print}')_*.bed
	for motif in $(cut -f4 $newFile | grep CTCF | uniq)
	do
		awk -v motif=$motif '$4 == motif' $(echo $file | awk '{gsub(".txt", ".bed"); print}') > $(echo $newFile | awk -v motif=$motif '{gsub(".bed", "_"motif".bed"); print}') &
	done
done
wait
