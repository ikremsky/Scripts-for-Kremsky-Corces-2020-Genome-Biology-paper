peakFile=peaks_macs2
mkdir $peakFile
cd $peakFile

for file in $(ls ../bam/*_pooled.sorted.duprmvd.bam)
do
	echo $file
	type=$(basename $file _pooled.sorted.duprmvd.bam)
	peakFile=$(ls ../peaks/*${type}*.mm9.norandom.bed)
#       macs2 callpeak -p .05 --keep-dup all -g mm -f BAM -t $file -n $(basename $file .sorted.bam) &
#	 macs -t $file -f BAM -g mm -n $(basename $file .bam)
	summitFile=${type}_pooled.sorted.duprmvd.bam_summits.bed
	intersectBed -u -a $summitFile -b $peakFile > ../peaks/${type}_summits.bed &
done
wait
echo done
