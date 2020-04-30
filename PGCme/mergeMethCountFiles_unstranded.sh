mkdir bed
cd bam

combine ()
{
	local file1=$(echo $files | awk '{print $1}')
	local file2=$(echo $files | awk '{print $2}')
	local outFile=/Zulu/isaac/PGCme/bed/${type}_meth.bed
#	intersectBed -f 1 -F 1 -wa -wb -a $file1 -b $file2 | grep -v chrM | awk 'BEGIN{OFS="\t"}{meth=$5+$11; unmeth=$6+$12; print $1,$2,$3,meth/(meth+unmeth),meth,unmeth}' > $outFile
#	intersectBed -f 1 -F 1 -v -a $file1 -b $file2 | grep -v chrM | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4/100,$5,$6}' >> $outFile
#	intersectBed -f 1 -F 1 -v -b $file1 -a $file2 | grep -v chrM | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4/100,$5,$6}' >> $outFile
	name=/Zulu/isaac/PGCme/bed/$(basename $outFile .bed)
	awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 5 && $4 > .8) print}' $outFile > ${name}.meHi.bed &
	awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 5 && $4 < .2) print}' $outFile > ${name}.meLo.bed
	awk 'BEGIN{OFS="\t"}{count=$5+$6; if(count > 5) print}' $outFile > ${name}.hiConf.bed
}

for type in $(ls *.cov | cut -f1,2 -d"." | awk '{sub("Seq.", "Seq"); print}' | sort | uniq)
do
	echo $type
	files=$(ls ${type}*.merged_CpG_evidence.cov)
	if [ $(echo $files | awk '{print NF}') -gt 1 ]; then
		combine &
	fi
done
wait
echo done
