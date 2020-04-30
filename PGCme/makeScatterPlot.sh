mkdir png
for motif in 
#$(cat motifs_CpGs/motifs)
do
	sh getmeatMotifs.sh $motif
done
#mv *.png png/ 
#rm E13.5m_E16.5diffTable.txt allTFs.accessinE13.5m.avgme.txt
for file in 
#$(ls avgme_*.txt)
do
	if [ $(cat $file | wc -l) -eq 0 ]; then
		rm $file
	else
		E13.5mme=$(grep E13.5m $file | cut -f2)
		E16.5me=$(grep E66.5m $file | cut -f2)
		notE13.5mme=$(grep E13.5m $file | cut -f3)
		notE16.5me=$(grep E16.5m $file | cut -f3)
		TF=$(basename $file .txt | cut -f2 -d"_")
		echo $TF $E13.5mme $E16.5me $notE13.5mme $notE16.5me | awk 'BEGIN{OFS="\t"}{print $1,$3-$2,$5-$4}' >> E13.5m_E16.5diffTable.txt
	fi
done
R --vanilla --args E13.5m_E16.5diffTable.txt < makeScatterplot.R
