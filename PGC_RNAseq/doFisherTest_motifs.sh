#Note: must run /media/4TB4/isaac/PGCme/doMultipleLinePlots.sh first to get the count Files
startDir=$(pwd)
Region="distal"
rm summary_*txt *.exp temp* ids
countFile=/media/4TB4/isaac/PGCme/countTable_E14.5m
countCtrlFile=/media/4TB4/isaac/PGCme/countTable_E14.5m_ctrl

motifctrlN=$(awk -v motif=All '{if($1 == motif) print $2}' $countCtrlFile)
ctrltotalN=$(awk -v motif=All '{if($1 == motif) print $2+$3}' $countCtrlFile)

awk '$NF > 10' /media/4TB4/isaac/PGC_RNAseq/cuffdiff/final/E16.5m.genes.fpkm | cut -f5,7 | sort -k1b,1 > E16.5m.genes.fpkm
fpkmFile=../E16.5m.genes.fpkm

region=$Region
for type in E14.5m
do
	rm summary_${region}.txt
	mkdir ${type}_motifs
	cd ${type}_motifs
	for motif in $(cut -f1 $countFile)
	do
		rm -r individualTFs
		mkdir individualTFs
		motifN=$(awk -v motif=$motif '{if($1 == motif) print $2}' $countFile)
		totalN=$(awk -v motif=$motif '{if($1 == motif) print $2+$3}' $countFile)
		echo $motifN $totalN > ${motif}.matrix
		echo $motifctrlN $ctrltotalN >> ${motif}.matrix
		echo $motif
		cat ${motif}.matrix
		R --vanilla --args ${motif}.matrix $(echo $motif) < ../fisherTest.R
	done
	awk 'BEGIN{OFS="\t"}{if(NR == 1 || NR%2 == 0 ) print}' summary.txt > temp; mv temp summary_${region}.txt
	R --vanilla --args summary_${region}.txt ${type}_${region} Ctrl $type < ../getTables.R
	rm *.matrix
	awk 'BEGIN{OFS="\t"}{if(NR > 1 && $5 < .001 && $3 > $4) print $1}' summary_${region}.txt | grep -v ":" | sort -b > temp1

	join -i temp1 $fpkmFile | awk '{print $1}' >> ${startDir}/ids &
	join -i temp1 $fpkmFile | awk 'BEGIN{OFS="\t"}{print $1,$2}' > ${startDir}/${type}_${region}.exp
	wait

	cd $startDir
	grep -v ":" ids | sort -b | uniq > temp; mv temp ids
	for region in $Region
	do
		echo $region $CtrlType
	        for file in $(ls ${type}_motifs/summary_${region}.txt)
		do
			echo $file
			sample=$(echo $file | cut -f1 -d"_")
			awk 'NR > 1' $file | grep -v ":" | sort -k1b,1 > temp
			join -a 1 ids temp | awk 'BEGIN{OFS="\t"}{if(NF == 1) print "0","1","1","1",$1; else print $2,$3,$4,$5,$1}' | sort -k5,5 -k4g,4 | uniq -f 4 | awk 'BEGIN{OFS="\t"}{print $5,$1,$2,$3,$4}' | awk 'BEGIN{OFS="\t"; print "region", "count","uniqu_ratio","nonunique_ratio","P-val"}{P=1; if($3 > $4) {P=$5; if(P < .00001) P=.00001} print $1,$2,$3,$4,P}' | awk '$2 > 100 && $NF < .001' > $(basename $file .txt)_${sample}.txt
		done

		cut -f1 $(basename $file .txt)_${sample}.txt | sort -b > ids
		for nextid in $(awk '{print toupper($1)}' ids | sort -b | uniq -D)
		do
			grep -v $nextid ids | sort -b | uniq > temp; mv temp ids
		done

		join ids $(basename $file .txt)_${sample}.txt | awk '{gsub(" ", "\t"); print}' > temp; mv temp $(basename $file .txt)_${sample}.txt

		for file in $(ls *${region}.exp)
		do
			join -i -a 1 ids $file | awk 'BEGIN{OFS="\t"}{if(NF > 1) logFC=$2; else logFC=0; print sqrt(logFC*logFC),logFC,$1}' | sort -k3,3 -k1nr,1 | uniq -f 2 | awk 'BEGIN{OFS="\t"}{print $3,$2}' > temp; mv temp $file
		done
		R --vanilla --args ${region} summary_${region}_${type}.txt E14.5m_${region}.exp E14.5m < getCircleCharts.R
	done
done
R --vanilla < getCirclePlotLegent.R
