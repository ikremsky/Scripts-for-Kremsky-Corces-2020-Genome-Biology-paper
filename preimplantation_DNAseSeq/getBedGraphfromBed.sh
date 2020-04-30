cd bed
getBG ()
{
	M=$(awk -v x=$file  'BEGIN{count=0}{if($2 == x) count+=$1/1000000}END{print 1/count}' readCounts)
#	grep -v chrM $file | cut -f1-3 | sort -k1,1 | bedtools genomecov -scale $M -i - -g /home/genomefiles/mouse/mm9_sizes.txt -bg > $(basename $file .bed).bedGraph
	bedGraphToBigWig $(basename $file .bed).bedGraph /home/genomefiles/mouse/mm9_sizes.txt $(basename $file .bed).bw
}

i=1
for file in $(ls *bed)
do
	getBG &
        if [ $(echo $i | awk '{print $1%6}') -eq 0 ]; then
                wait
        fi
        i=$(expr $i + 1)
done
wait
