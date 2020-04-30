cd bed
getBG ()
{
	echo $file $M 
	cut -f1-4 $file | sort -k1,1 -k2,2n > $(basename $file .hiConf.bed).sorted.bed &
	awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$5+$6}' $file | sort -k1,1 -k2,2n >  $(basename $file .hiConf.bed).coverage.bed &
	wait
	bedGraphToBigWig $(basename $file .hiConf.bed).sorted.bed /home/genomefiles/mouse/mm9_sizes.txt $(basename $file .hiConf.bed).bw &
	bedGraphToBigWig $(basename $file .hiConf.bed).coverage.bed /home/genomefiles/mouse/mm9_sizes.txt $(basename $file .hiConf.bed).coverage.bw
}

i=1
for file in $(ls *.hiConf.bed)
do
	type=$(basename $file | cut -f1 -d"_")
	getBG &
        if [ $(echo $i | awk '{print $1%25}') -eq 0 ]; then
                wait
        fi
        i=$(expr $i + 1)
done
wait
