compareStage=E14.5m
#PGC
mkdir png
sort -b /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/motifs > temp1
cut -f 1 /media/4TB4/isaac/PGC_RNAseq/E16.5m.genes.fpkm | sort -b > temp2

for motif in 
#All $(join -i temp1 temp2)
#$(cat ../ATAC_DNAme_embryoComparison/motifs_CpGs/motifs)
do
	sh getmeatMotifs.sh $motif $compareStage
done

for file in 
#$(ls avgme_*_${compareStage}_distal.txt)
do
	if [ $(cat $file | wc -l) -eq 0 ]; then
		rm $file
	else
		E135mme=$(grep E13.5m $file | cut -f2)
		E165mme=$(grep E16.5m $file | cut -f2)
		notE135mme=$(grep E13.5m $file | cut -f3)
		notE165mme=$(grep E16.5m $file | cut -f3)
		TF=$(basename $file .txt | cut -f2 -d"_")
		echo $TF $E135mme $E165mme $notE135mme $notE165mme | awk 'BEGIN{OFS="\t"}{print $1,$3-$2,$5-$4}' >> ${compareStage}diffTable.txt
	fi
done
#grep All countTable_$compareStage > countTable_${compareStage}_ctrl
#join ${compareStage}diffTable.txt countTable_$compareStage | awk '{gsub(" ", "\t"); print}' > temp
#join -i temp /media/4TB4/isaac/PGC_RNAseq/expressedGenes_E16.5m.txt | awk '{gsub(" ", "\t"); print}' | cut -f1-3 > ${compareStage}diffTable.txt &
#join -i temp /media/4TB4/isaac/PGC_RNAseq/expressedGenes_E16.5m.txt | awk '{gsub(" ", "\t"); print}' | cut -f1,4,5 > countTable_$compareStage &
wait

R --vanilla --args ${compareStage}diffTable.txt countTable_$compareStage $compareStage < makeScatterplot_diffme.R
