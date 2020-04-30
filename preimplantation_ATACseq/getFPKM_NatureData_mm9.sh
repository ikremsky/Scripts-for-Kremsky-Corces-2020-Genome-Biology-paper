getFPKM ()
{
	M=$(awk -v x=$type  'BEGIN{count=0}{if($2~"^"x"_") count+=$1/1000000}END{print count}' bed_mm9/readCounts)
	awk -v M=$M 'BEGIN{OFS="\t"}{K=$8; print $1,$2,$3,$4,$6/(K*M)}' bed_mm9/$(basename $file .bam).cov > bed_mm9/$(basename $file .bam)_at_$(basename $peakFile .bed).fpkm
	echo $type $file $M >> FPKMs
}

getFPKM2 ()
{
	M=$(awk -v x=$(basename $file .bam).bed '{if($2==x) print $1/1000000}' bed_mm9/readCounts)
	echo $M
        coverageBed -a $peakFile -b bed_mm9/$(basename $file .bam).bed | awk -v M=$M 'BEGIN{OFS="\t"}{K=$9/1000; print $1,$2,$3,$4,$5,$6,$7/(K*M)}'  > bed_mm9/${motif}/$(basename $file .bam)at$(basename $peakFile .bed).fpkm
}


peakFile=$1
motif=$(basename $peakFile .bed | cut -f2 -d"_")
mkdir bed_mm9/$motif
cut -f1-4 $peakFile | cut -f1 -d"_" > bed_mm9/${motif}/fimo_${motif}.forigv.bed &

for strain in All
#genome1 genome2
do
	for type in ICM
	do
		for file in bam_mm9/${type}_pooled.sorted.duprmvd.TFs.bam
		do
			if [ $(echo $type | awk '{x=0; if($1 == "Sperm" || $1 ~ "Oocyte") x=1; print x}') -eq 1 ]; then
				file=bed_mm9/$(echo $type | awk '{if($1 == "Sperm") print "Cont_Sperm_OmniATACseq_x115_TF_sort.bam"; else {if($1 ~ "GVOocyte") print "GVoocyte_Rep1-2_pooled_x115_TF_sort.bam"; else print "MIIoocyterep1_mm9.sort.rmdup.flt.TF.bam"}}')
				echo $file
			fi
			echo $type
#			peakFile=/media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo_CTCF.bed
			getFPKM2 &
		done
	done
done
wait
