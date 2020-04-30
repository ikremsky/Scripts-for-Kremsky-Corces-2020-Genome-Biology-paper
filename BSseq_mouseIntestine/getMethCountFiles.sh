mkdir bed
cd bam

process ()
{
	local outFile=../bed/$(basename $file .zero.cov)_meth.bed
#	awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4/100,$5,$6}' $file  > $outFile
	name=../bed/$(basename $outFile .bed)
	awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 10 && $4 > .8) print}' $outFile > ${name}.meHi.bed &
	awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 10 && $4 < .2) print}' $outFile > ${name}.meLo.bed &
	awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 9) print}' $outFile > ${name}.hiConfidence.bed &
}

for file in $(ls *.zero.cov)
do
	echo $(basename $file .zero.cov)
	process &
done
wait
echo done
