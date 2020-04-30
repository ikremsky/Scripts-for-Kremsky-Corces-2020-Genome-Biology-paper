qval=1.1

#grep MOTIF /mnt/isaachd/motif_databases/JASPAR/JASPAR_CORE_2014_vertebrates.meme | awk 'BEGIN{OFS="\t"}{print $2,$3}' > JasparIds.txt
#grep MOTIF /mnt/isaachd/motif_databases/MOUSE/uniprobe_mouse.meme | awk 'BEGIN{OFS="\t"}{print $2,$3}' >> JasparIds.txt

for file in $(ls motifs_mm9_IAPplus2kb/fimo.txt)
do
	newFile=$(echo $file | awk '{sub(".txt", ".bed"); print}')
	type=$(echo $file | cut -f1-2 -d"_")
	echo $newFile
        grep -h -v "#" $file | awk 'BEGIN{OFS="\t"}{print $3,$4,$1,$7,$5,$NF,$2}' | sort -k7,7 -k4g,4 | awk 'BEGIN{OFS="\t"}{print $NF,$1,$2,$3,$4,$5,$6}' | awk 'BEGIN{OFS="\t"}{gsub("-", "\t", $1); gsub(":", "\t"); print}' | awk 'BEGIN{OFS="\t"}{print $1,$2+$4-1,$2+$5,$6,$7,$8,$9}' | awk 'BEGIN{OFS="\t"}{gsub("+", "_", $6); gsub("-", "+", $6); gsub("_", "-", $6); print}' > $(echo $newFile | awk '{gsub(".bed", ".withsequence.bed"); print}')
        grep -h -v "#" $file | awk 'BEGIN{OFS="\t"}{print $3,$4,$1,$7,$5,$NF,$2}' | sort -k7,7 -k4g,4 | awk 'BEGIN{OFS="\t"}{print $NF,$1,$2,$3,$4,$5,$6}' | awk 'BEGIN{OFS="\t"}{gsub("-", "\t", $1); gsub(":", "\t"); print}' | awk 'BEGIN{OFS="\t"}{print $1,$2+$4-1,$2+$5,$6,$7,$8}' | awk 'BEGIN{OFS="\t"}{gsub("+", "_", $6); gsub("-", "+", $6); gsub("_", "-", $6); print}' > $newFile

	for id in $(cut -f1 JasparIds.txt)
	do
	        name=$(grep $id JasparIds.txt | cut -f2)
	        awk -v id=$id -v name=$name 'BEGIN{OFS="\t"}{sub(id, name"_"id, $4); print}' $newFile > temp; mv temp $newFile
	done

	awk 'BEGIN{OFS="\t"}{x=$4; sub("_full", "", x); sub("_DBD", "", x); print $4,$5,$6,$1,$2,$3,x}' $newFile | sort -k7,7 -k4,4 -k5n,5 -k6n,6 -k2g,2 | uniq -f 3 | awk 'BEGIN{OFS="\t"}{print $4,$5,$6,$1,$2,$3}' > temp; mv temp $newFile
	cut -f1 -d"_" $newFile > $(echo $newFile | awk '{sub(".bed", ".forigv.bed"); print}')
done
