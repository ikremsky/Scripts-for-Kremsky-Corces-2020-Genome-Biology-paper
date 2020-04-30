cd bed
getBG ()
{
	echo $file $M 
	cut -f1-4 $file | grep -v chrM | sort -k1,1 -k2,2n > $(basename $file .bed).sorted.bed &
	grep -v chrM $file | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$5+$6}' | sort -k1,1 -k2,2n >  $(basename $file .bed).coverage.bed &
	wait
	bedGraphToBigWig $(basename $file .bed).sorted.bed /home/genomefiles/mouse/mm9_sizes.txt $(basename $file .bed).bw &
	bedGraphToBigWig $(basename $file .bed).coverage.bed /home/genomefiles/mouse/mm9_sizes.txt $(basename $file .bed).coverage.bw
}

i=1
for file in $(ls *meth.bed)
do
	type=$(basename $file | cut -f1 -d"_")
	getBG &
        if [ $(echo $i | awk '{print $1%25}') -eq 0 ]; then
                wait
        fi
        i=$(expr $i + 1)
done
wait
echo done
