cd bed
getBG ()
{
	echo $file $M 
	awk 'BEGIN{OFS="\t"}{print $4,$1,$2,$3}' $file | grep -v random | sort -k2,2 -k3,3n | uniq -f 1 | awk 'BEGIN{OFS="\t"}{print $2,$3,$4,$1}' > $(basename $file .hiConfidence.bed).sorted.bed &
	awk 'BEGIN{OFS="\t"}{print $5+$6,$1,$2,$3}' $file | grep -v random | sort -k2,2 -k3,3n | uniq -f 1 | awk 'BEGIN{OFS="\t"}{print $2,$3,$4,$1}' >  $(basename $file .hiConfidence.bed).coverage.bed &
	wait
	bedGraphToBigWig $(basename $file .hiConfidence.bed).sorted.bed /home/genomefiles/mouse/mm9_sizes.txt $(basename $file .hiConfidence.bed).bw &
	bedGraphToBigWig $(basename $file .hiConfidence.bed).coverage.bed /home/genomefiles/mouse/mm9_sizes.txt $(basename $file .hiConfidence.bed).cov.bw
}

i=1
for file in $(ls *.hiConfidence.bed | grep -v aternal)
do
	type=$(basename $file | cut -f1 -d"_")
	getBG &
        if [ $(echo $i | awk '{print $1%25}') -eq 0 ]; then
                wait
        fi
        i=$(expr $i + 1)
done
wait
