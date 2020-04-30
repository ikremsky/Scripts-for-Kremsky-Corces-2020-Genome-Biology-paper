mkdir bed
cd bam

combine ()
{
	local file1=$(echo $files | awk '{print $1}')
	local file2=$(echo $files | awk '{print $2}')
	local outFile=../bed/${type}_meth.bed
	intersectBed -f 1 -F 1 -wa -wb -a $file1 -b $file2 | grep -v chrM | awk 'BEGIN{OFS="\t"}{meth=$5+$11; unmeth=$6+$12; print $1,$2,$3,meth/(meth+unmeth),meth,unmeth}' > $outFile
	intersectBed -f 1 -F 1 -v -a $file1 -b $file2 | grep -v chrM | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4/100,$5,$6}' >> $outFile
	intersectBed -f 1 -F 1 -v -b $file1 -a $file2 | grep -v chrM | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4/100,$5,$6}' >> $outFile
	name=/Zulu/isaac/PGCme/bed/$(basename $outFile .bed)
	awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 20 && $4 > .9) print}' $outFile > ${name}.meHi.bed &
	awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 20 && $4 < .1) print}' $outFile > ${name}.meLo.bed &
	if [ $(echo $files | awk '{print NF}') -eq 3 ]; then
		
	fi
}

for type in E12.5IntestinalEpithelium WTAdultIntestinalEpithelium WTMacrophage
#$(ls *.cov | cut -f1,2 -d"." | awk '{sub("Seq.", "Seq"); print}' | sort | uniq)
do
	echo $type
	files=$(ls ${type}*zero.cov)
	if [ $(echo $files | awk '{print NF}') -gt 1 ]; then
		combine &
	else
		awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 20 && $4 > .9) print}' $files > ${name}.meHi.bed &
		awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 20 && $4 < .1) print}' $files > ${name}.meLo.bed &
	fi
done
wait
echo done
