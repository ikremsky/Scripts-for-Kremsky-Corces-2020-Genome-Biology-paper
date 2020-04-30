getFPKM ()
{
	M=$(awk -v x=$type  'BEGIN{count=0}{if($2~"^"x"_") count+=$1/1000000}END{print count}' bed_shifted/readCounts)
	awk -v M=$M 'BEGIN{OFS="\t"}{K=$8; print $1,$2,$3,$4,$6/(K*M)}' bed_shifted/$(basename $file .bam).cov > bed_shifted/$(basename $file .bam)_at_$(basename $peakFile .bed).fpkm
	echo $type $file $M >> FPKMs
}

getFPKM2 ()
{
	M=$(awk -v x=$(basename $file .bam).bed '{if($2==x) print $1/1000000}' bed_shifted/readCounts)
	echo $M
        coverageBed -a $peakFile -b bed_shifted/$(basename $file .bam).bed | awk -v M=$M 'BEGIN{OFS="\t"}{K=$9/1000; print $1,$2,$3,$4,$5,$6,$7/(K*M)}'  > bed_shifted/${motif}/$(basename $file .bam)at$(basename $peakFile .bed).fpkm
}


peakFile=$1
motif=$(basename $peakFile .bed | cut -f2 -d"_")
mkdir bed_shifted/$motif
cut -f1-4 $peakFile | cut -f1 -d"_" > bed_shifted/${motif}/fimo_${motif}.forigv.bed &

for strain in All
#genome1 genome2
do
	for type in Morula
#ESC
	do
		for file in bam/${type}_pooled.sorted.duprmvd.bam
		do
			echo $type
#			peakFile=/media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo_CTCF.bed
			getFPKM2 &
		done
	done
done
wait
