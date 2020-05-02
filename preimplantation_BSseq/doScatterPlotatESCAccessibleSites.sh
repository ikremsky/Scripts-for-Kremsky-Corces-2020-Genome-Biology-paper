compareStage=ESC
mkdir png
sort -b /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/motifs > temp1
cut -f5,7 /mnt/bigmama/isaac/RNAseq_mouseEmbryo/cuffdiff/final/ESC.genes.fpkm | awk '$NF > 10' | cut -f 1 | cut -f1 -d":" | sort -b > temp2

for motif in 
#$(join -i temp1 temp2)
do
	sh getmeatMotifs_ESC.sh $motif $compareStage
done

for file in 
#$(ls avgme_*_${compareStage}_distal.txt)
do
	if [ $(cat $file | wc -l) -eq 0 ]; then
		rm $file
	else
		ICMme=$(grep ICM $file | cut -f2)
		E75me=$(grep E75 $file | cut -f2)
		notICMme=$(grep ICM $file | cut -f3)
		notE75me=$(grep E75 $file | cut -f3)
		TF=$(basename $file .txt | cut -f2 -d"_")
		echo $TF $ICMme $E75me $notICMme $notE75me | awk 'BEGIN{OFS="\t"}{print $1,$3-$2,$5-$4}' >> ${compareStage}diffTable.txt
	fi
done

R --vanilla --args ${compareStage}diffTable.txt countTable_$compareStage $compareStage < makeScatterplot_diffme.R
