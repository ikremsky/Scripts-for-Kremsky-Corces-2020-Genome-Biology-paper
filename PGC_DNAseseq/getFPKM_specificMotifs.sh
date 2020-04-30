peakFile=$1
dir=$2
mkdir $dir

awk 'BEGIN{OFS="\t"}{print $1,$2-250,$3+250,$4,$5,$6}' $peakFile > $(basename $peakFile)
pwd
getFPKM ()
{
	M=$(awk -v x=$type  'BEGIN{count=0}{if($2~"^"x"_") count+=$1/1000000}END{print count}' bed/readCounts)
	awk -v M=$M 'BEGIN{OFS="\t"}{K=$8; print $1,$2,$3,$4,$6/(K*M)}' bed/$(basename $file .bam).cov > bed/$(basename $file .bam)_at_$(basename $peakFile .bed).fpkm
	echo $type $file $M >> FPKMs
}

getFPKM2 ()
{
	M=$(awk -v x=$(basename $file .bam).bed '{if($2==x) print $1/1000000}' bed/readCounts)
	echo $M
	echo $peakFile
#        coverageBed -a $peakFile -b bed/$(basename $file .bam).bed | awk -v M=$M 'BEGIN{OFS="\t"}{K=$9/1000; print $1,$2,$3,$4,$5,$6,$7/(K*M)}'  > ${dir}/${motif}/$(basename $file .bam)at$(basename $peakFile .bed).fpkm
	if [ -e $NomeSeqFile ]; then
		M=$(awk -v x=$type  'BEGIN{count=0}{if($2~"^"x"_") count+=$1/1000000}END{print count}' /Zulu/isaac/PGC_Nomeseq/bed/readCounts)
		echo $M
		coverageBed -a $(basename $peakFile) -b $NomeSeqFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=$9/1000; print $1,$2,$3,$4,$5,$6,$7/(K*M)}'  > ${dir}/${motif}/${type}_NomeSeq_at_$(basename $peakFile .bed).fpkm
	fi
}


motif=$(basename $peakFile .bed | cut -f2 -d"_")
mkdir ${dir}/$motif
#cut -f1-4 $peakFile | cut -f1 -d"_" > ${dir}/${motif}/fimo_${motif}.forigv.bed &
i=1

for strain in All
do
	for type in E9.5 E10.5 E12.5_female E12.5_male E13.5_female E13.5_male E14.5_female E14.5_male E16.5_female E16.5_male
	do
		for file in bam/${type}_pooled.sorted.duprmvd.bam
		do
			NomeSeqFile=/Zulu/isaac/PGC_Nomeseq/bed/${type}_pooled.sorted.duprmvd.bed
			if [ $(echo $i | awk '{print $1%4}') -eq 0 ]; then
				wait
			fi
			echo $type
			getFPKM2 &
			i=$(expr $i + 1)
		done
	done
done
wait
