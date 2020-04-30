mkdir bed
cd bed
convert ()
{
#	/programs/liftOver $file /mnt/isaachd/methylationCellData/mm10ToMm9.over.chain $(basename $file .bedGraph).mm9.bedGraph $(basename $file .bedGraph).unmapped
#	grep -v random $(basename $file .bedGraph).mm9.bedGraph | sort -k1,1 -k2n,2 > $(basename $file .bedGraph).mm9.norandom.bedGraph
	bedGraphToBigWig $(basename $file .bedGraph).mm9.norandom.bedGraph /home/genomefiles/mouse/mm9_sizes.txt $(basename $file .bedGraph).bw
}

for file in $(ls /Zulu/isaac/PGC_RNAseq/bed/*bedGraph)
do
	convert &
done
wait
