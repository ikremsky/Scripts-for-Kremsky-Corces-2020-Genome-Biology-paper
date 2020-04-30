peakFile=$1
dir=$2
mkdir $dir

awk 'BEGIN{OFS="\t"}{print $1,$2-250,$3+250,$4,$5,$6}' $peakFile > $(basename $peakFile)
pwd
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
	echo $peakFile
        coverageBed -a $peakFile -b bed_shifted/$(basename $file .bam).bed | awk -v M=$M 'BEGIN{OFS="\t"}{K=$9/1000; print $1,$2,$3,$4,$5,$6,$7/(K*M)}'  > ${dir}/${motif}/$(basename $file .bam)at$(basename $peakFile .bed).fpkm
}


motif=$(basename $peakFile .bed | cut -f2 -d"_")
mkdir ${dir}/$motif
#cut -f1-4 $peakFile | cut -f1 -d"_" > ${dir}/${motif}/fimo_${motif}.forigv.bed &
i=1

for strain in All
do
	for type in Sperm Pronuclei_Pat_PN3 Pronuclei_Pat_PN5 2Cell 4Cell 8Cell Morula ICM ESC
	do
		if [ $(echo $type | awk '{if($1 == "ESC") print "1"; else print "0"}') -eq 1 ]; then
			file=ESC-Rep1-2_pooled_x115-TF.sorted.bam
		else
			if [ $(echo $type | awk '{if($1 == "ICM") print "1"; else print "0"}') -eq 1 ]; then
				file=ICM_pooled.sorted.duprmvd.TFs.bam
			else
				if [ $(echo $type | awk '{if($1 == "Sperm") print "1"; else print "0"}') -eq 1 ]; then
					file=Cont_Sperm_OmniATACseq_x115_TF_sort.bam
				else
					file=bam/${type}_pooled.sorted.duprmvd.bam
				fi
			fi
		fi
		if [ $(echo $i | awk '{print $1%4}') -eq 0 ]; then
			wait
		fi
		echo $type
		getFPKM2 &
		i=$(expr $i + 1)
	done
done
wait
