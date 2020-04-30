peakFile=peaks
mkdir $peakFile
cd $peakFile

i=1
for treat in toSerum to2i
do
	file=$(ls ../bam/CHIP_${treat}.sorted.duprmvd.bam)
	ctrlFile=$(ls ../bam/INPUT_${treat}_1.sorted.duprmvd.bam)
	echo $file
       macs2 callpeak --keep-dup all -g mm -f BAM -c $ctrlFile -t $file -n $(basename $file .sorted.duprmvd.bam) &
        if [ $(echo $i | awk '{print $1%6}') -eq 0 ]; then
                wait
        fi
        i=$(expr $i + 1)
done
wait
echo done
