cat /Zulu/isaac/ChIPseq_NRF1/peaks/CHIP_*narrowPeak | cut -f1-3 | sort -k1,1 -k2n,2 | bedtools merge -i - | awk 'BEGIN{OFS="\t"}{print $0,NR,".","+"}' > bed_extended/NRF1_mergedPeaks.bed
getFPKM2 ()
{
	cut -f1-6 $peakFile > $(basename $peakFile)
	M=$(awk -v x=$(basename $file) '{if($2==x) print $1/1000000}' bed_extended/readCounts)
	echo $M
        coverageBed -a  $(basename $peakFile) -b $file | awk -v M=$M 'BEGIN{OFS="\t"}{K=$9/1000; print $1,$2,$3,$4,$5,$6,$7/(K*M)}'  > bed_extended/${motif}/$(basename $file .bed)at$(basename $peakFile .narrowPeak).fpkm
	intersectBed -v -a bed_extended/${motif}/$(basename $file .bed)at$(basename $peakFile .narrowPeak).fpkm -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed > bed_extended/${motif}/$(basename $file .bed)at$(basename $peakFile .narrowPeak).distal.fpkm
}


for sample in to2i toSerum
do
	echo $sample
	file=bed_extended/CHIP_${sample}.sorted.duprmvd.bed
	peakFile=bed_extended/NRF1_mergedPeaks.bed
	getFPKM2 &
done
wait
