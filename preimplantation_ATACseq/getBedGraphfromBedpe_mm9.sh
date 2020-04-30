cd bed_mm9
getBG ()
{
	M=$(awk -v x=$(basename $file .bedpe).bed  'BEGIN{count=0}{if($2 == x) count+=$1/1000000}END{print 1/count}' readCounts)
	echo $file $M 
	grep -v chrM $file | cut -f1,2,6 | sort -k1,1 | bedtools genomecov -scale $M -i - -g /home/genomefiles/mouse/mm9_sizes.txt -bg > $(basename $file .bedpe).bedGraph
	bedGraphToBigWig $(basename $file .bedpe).bedGraph /home/genomefiles/mouse/mm9_sizes.txt $(basename $file .bed).bw
}

i=1
for file in $(ls *bedpe)
do
	type=$(basename $file | cut -f1 -d"_")
	getBG &
        if [ $(echo $i | awk '{print $1%6}') -eq 0 ]; then
                wait
        fi
        i=$(expr $i + 1)
done
wait
