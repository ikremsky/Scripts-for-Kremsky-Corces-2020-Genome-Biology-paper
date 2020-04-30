regionSize=500 #size to extend ATAC-seq peaks with footprints, in bp, to measure H3K4me3 RPKMs

mkdir FPKMatFootprints
cd FPKMatFootprints
rm *fpkm
IDRfolder=/hdisk2/isaac/ATACseqAnalysis/IDR_peaks_keepdups_p.05_top300K
peakFolder=/hdisk2/isaac/ATACseqAnalysis/firstSequencing/peaks_keepdups_p.00005
fpFolder=/hdisk2/isaac/ATACseqAnalysis/footprints_Sperm_Control_yoonheepks
peakFile=Sperm_Control_TFpeaks.bed

MsigPpeakmax=.0002
MsigMpeakmin=.01
PsigPpeakmin=.01
PsigMpeakmax=.0002


cell=Sperm

getFPKM ()
{
	coverageBed -a $peakFile -b $file | cut -f4- | awk '{gsub(":", "\t"); print}' >  $(basename $file .sorted.duprmvd.bed)at$(basename $peakFile .bed | awk '{sub("GSE71434_", ""); sub("_broadpeak", ""); print}').cov
        M=$(awk -v x=$(basename $file | cut -f1 -d"_")  'BEGIN{count=0}{if($2 ~ x && $2 !~ "unassigned") count+=$1/1000000}END{print count}' ../bed/readCounts)
        awk -v M=$M 'BEGIN{OFS="\t"}{K=$7/1000; print $1,$2,$3,$4,$5/(K*M)}' $(basename $file .sorted.duprmvd.bed)at$(basename $peakFile .bed | awk '{sub("GSE71434_", ""); sub("_broadpeak", ""); print}').cov > $(basename $file .sorted.duprmvd.bed)at$(basename $peakFile .bed).fpkm
}

cut -f1-3 /hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/CONTROL_SPERM_ATACseq_all3combined_x115_pvalue00001_peaks.bed | sort -k1,1 -k2n,2 | uniq > peaks.bed
intersectBed -u -a peaks.bed -b ${fpFolder}/fimo.bed | awk -v size=$regionSize 'BEGIN{OFS="\t"}{name=$1":"$2":"$3; print $1,$2-size,$2,name":a""\n"$1,$3,$3+size,name":b"}' > $peakFile
i=1
for file in $(ls ../bed/*bed | grep -v Sperm | grep -v temp | grep -v unassigned)
do
#	echo $file
	getFPKM &

	if [ $(echo $i | awk '{if($1%7 == 0) print 1; else print 0}') -eq 1 ]; then
		wait
	fi
	i=$(expr $i + 1)
done
wait

for Pfile in $(ls *genome2*fpkm)
do
	Mfile=$(echo $Pfile | awk '{sub("genome2", "genome1"); print}')
	type=$(echo $Pfile | cut -f1 -d"_")
	echo $type
	intersectBed -wo -f 1 -F 1 -a $Mfile -b $Pfile | awk '$4 == $9' | cut -f1-5,10 | uniq > ${type}_both.fpkm
	awk -v Pmin=$PsigPpeakmin -v Mmax=$MsigPpeakmax '$6 > Pmin && $5 < Mmax' ${type}_both.fpkm > ${type}_Penriched.bed
	intersectBed -u -a ${fpFolder}/fimo.bed -b ${type}_Penriched.bed > ${type}_PenrichedFootprints.bed
	for file in $(ls ${fpFolder}/fimo*.bed ${fpFolder}/fimo.bed | grep fimo.bed)
	do
	        if [ $(basename $file | awk '{if($0 == "fimo.bed") print 1; else print 0}') -eq 1 ]; then
	                TF=All
		else
			TF=$(basename $file .bed | cut -f2- -d"_")
	        fi
		intersectBed -u -a ${type}_both.fpkm -b $file > ${TF}_${type}_both.fpkm
		if [ $(wc -l ${TF}_${type}_both.fpkm | cut -f1 -d" ") -lt 1 ]; then
			rm ${TF}_${type}_both.fpkm
		fi
	done
done
mkdir spermLo
rm *.txt counts 
cd spermLo
rm medians.txt pvals.txt counts
cd ..
for file in $(ls ${fpFolder}/fimo.bed ${fpFolder}/fimo_*bed | grep fimo.bed)
do
	if [ $(basename $file | awk '{if($0 == "fimo.bed") print 1; else print 0}') -eq 1 ]; then
		TF=All
	else
		TF=$(basename $file .bed | cut -f2- -d"_")
	fi
	echo $file
	intersectBed -u -a sperm_rep1atSperm_Control_TFpeaks.fpkm -b $file > ${TF}_sperm.fpkm
	intersectBed -f .5 -F .5 -e -v -a ${TF}_sperm.fpkm -b ~/isaachd/annotations/TSSs_1kbarouns_mm9.bed > ${TF}_spermdistal.fpkm
        intersectBed -f .5 -F .5 -e -u -a ${TF}_sperm.fpkm -b ~/isaachd/annotations/TSSs_1kbarouns_mm9.bed > ${TF}_spermproximal.fpkm
	intersectBed -u -a MIIoocyte_pooledatSperm_Control_TFpeaks.fpkm -b $file > ${TF}_oocyte.fpkm
	intersectBed -wo -a ${TF}_sperm.fpkm -b $file | awk '$5 < .0001' | cut -f1-5 | sort -k1,1 -k2n,2 | uniq > spermLo/${TF}_spermLo.fpkm
	intersectBed -f 1 -F 1 -wo -a ${TF}_oocyte.fpkm -b spermLo/${TF}_spermLo.fpkm | awk '$4 == $9' | cut -f1-5 > spermLo/${TF}_oocyteLosperm.fpkm
	intersectBed -f 1 -F 1 -wo -a ${TF}_oocyte.fpkm -b ${TF}_spermdistal.fpkm | awk '$4 == $9' | cut -f1-5 > ${TF}_oocytedistal.fpkm
        intersectBed -f 1 -F 1 -wo -a ${TF}_oocyte.fpkm -b ${TF}_spermproximal.fpkm | awk '$4 == $9' | cut -f1-5 > ${TF}_oocyteproximal.fpkm
#	intersectBed -u -a spermLo/${TF}_spermLo.fpkm -b spermLo/${TF}_oocyteLosperm.fpkm > temp; mv temp spermLo/${TF}_spermLo.fpkm
	cd spermLo
	for fpFile in $(ls ../${TF}*_both.fpkm)
	do
		intersectBed -f 1 -F 1 -wo -a $fpFile -b ${TF}_spermLo.fpkm | awk '$4 == $10' | cut -f1-6 > $(basename $fpFile .fpkm)Losperm.fpkm
		cd ..
		intersectBed -f 1 -F 1 -wo -a $(basename $fpFile) -b ${TF}_spermdistal.fpkm | awk '$4 == $10' | cut -f1-6 > $(basename $fpFile .fpkm)distal.fpkm
                intersectBed -f 1 -F 1 -wo -a $(basename $fpFile) -b ${TF}_spermproximal.fpkm | awk '$4 == $10' | cut -f1-6 > $(basename $fpFile .fpkm)proximal.fpkm
		cd spermLo
	done
	cd ..
	if [ $(wc -l ${TF}_sperm.fpkm | cut -f1 -d" ") -lt 1 ]; then
		rm ${TF}_sperm.fpkm
	else
                wc -l ${TF}_sperm.fpkm >> counts
		count=$(grep $TF counts | awk '{print $1}')
		echo testing
		R --vanilla --args ${TF} ${TF}_sperm.fpkm ${TF}_PN5zygote_both.fpkm ${TF}_2-cellearly_both.fpkm ${TF}_2-celllate_both.fpkm ${TF}_4-cell_both.fpkm ${TF}_ICM_both.fpkm ${TF}_oocyte.fpkm ${TF}_8-cell_both.fpkm < ../getMultiBoxPlots.R
		R --vanilla --args ${TF}_distal ${TF}_spermdistal.fpkm ${TF}_PN5zygote_bothdistal.fpkm ${TF}_2-cellearly_bothdistal.fpkm ${TF}_2-celllate_bothdistal.fpkm ${TF}_4-cell_bothdistal.fpkm ${TF}_ICM_bothdistal.fpkm ${TF}_oocytedistal.fpkm ${TF}_8-cell_bothdistal.fpkm < /hdisk2/isaac/isaachd/H3K4me3/getMultiBoxPlots.R
                R --vanilla --args ${TF}_proximal ${TF}_spermproximal.fpkm ${TF}_PN5zygote_bothproximal.fpkm ${TF}_2-cellearly_bothproximal.fpkm ${TF}_2-celllate_bothproximal.fpkm ${TF}_4-cell_bothproximal.fpkm ${TF}_ICM_bothproximal.fpkm ${TF}_oocyteproximal.fpkm ${TF}_8-cell_bothproximal.fpkm < /hdisk2/isaac/isaachd/H3K4me3/getMultiBoxPlots.R
               if [ $(basename $file | awk '{if($0 == "fimo.bed") print 1; else print 0}') -eq 1 ]; then
                        R --vanilla --args ${TF}_htmap ${TF}_sperm.fpkm ${TF}_PN5zygote_both.fpkm ${TF}_2-cellearly_both.fpkm ${TF}_2-celllate_both.fpkm ${TF}_4-cell_both.fpkm ${TF}_ICM_both.fpkm ${TF}_oocyte.fpkm ${TF}_8-cell_both.fpkm < /hdisk2/isaac/isaachd/H3K4me3/getHeatmaps.R
			R --vanilla --args ${TF}_htmap_distal ${TF}_spermdistal.fpkm ${TF}_PN5zygote_bothdistal.fpkm ${TF}_2-cellearly_bothdistal.fpkm ${TF}_2-celllate_bothdistal.fpkm ${TF}_4-cell_bothdistal.fpkm ${TF}_ICM_bothdistal.fpkm ${TF}_oocytedistal.fpkm ${TF}_8-cell_bothdistal.fpkm < /hdisk2/isaac/isaachd/H3K4me3/getHeatmaps.R
			R --vanilla --args ${TF}_htmap_proximal ${TF}_spermproximal.fpkm ${TF}_PN5zygote_bothproximal.fpkm ${TF}_2-cellearly_bothproximal.fpkm ${TF}_2-celllate_bothproximal.fpkm ${TF}_4-cell_bothproximal.fpkm ${TF}_ICM_bothproximal.fpkm ${TF}_oocyteproximal.fpkm ${TF}_8-cell_bothproximal.fpkm < /hdisk2/isaac/isaachd/H3K4me3/getHeatmaps.R
			intersectBed -u -a ${fpFolder}/fimo.bed -b $(ls ${TF}_htmap_proximal*loOocyte.txt) > ${TF}_proximalloOocyte.bed
			intersectBed -u -a ${fpFolder}/fimo.bed -b $(ls ${TF}_htmap_distal*loOocyte.txt) > ${TF}_distal_loOocyte.bed
                fi
		cd spermLo
#                if [ $(basename $file | awk '{if($0 == "fimo.bed") print 1; else print 0}') -eq 1 ]; then
#                        R --vanilla --args ${TF}_htmap_Losperm_$count ${TF}_spermLo.fpkm ${TF}_PN5zygote_bothLosperm.fpkm ${TF}_2-cellearly_bothLosperm.fpkm ${TF}_2-celllate_bothLosperm.fpkm ${TF}_4-cell_bothLosperm.fpkm ${TF}_ICM_bothLosperm.fpkm ${TF}_oocyteLosperm.fpkm ${TF}_8-cell_bothLosperm.fpkm < /hdisk2/isaac/isaachd/H3K4me3/getHeatmaps.R
#                fi
		wc -l ${TF}_spermLo.fpkm >> counts
                count=$(grep $TF counts | awk '{print $1}')
#		R --vanilla --args ${TF}_losperm ${TF}_spermLo.fpkm ${TF}_PN5zygote_bothLosperm.fpkm ${TF}_2-cellearly_bothLosperm.fpkm ${TF}_2-celllate_bothLosperm.fpkm ${TF}_4-cell_bothLosperm.fpkm ${TF}_ICM_bothLosperm.fpkm ${TF}_oocyteLosperm.fpkm ${TF}_8-cell_bothLosperm.fpkm < /hdisk2/isaac/isaachd/H3K4me3/getMultiBoxPlots.R
		cd ..

	fi
done

stages=$(ls *fpkm | grep AR_full | awk '{sub(".fpkm", ""); sub("AR_full_", ""); sub("_both", ""); print}' | grep -v sperm)
cd spermLo
mkdir combined
rm combined/counts combined/medians.txt combined/pvals.txt
wc -l *_spermLo.fpkm > spermCounts

for factor in 
#$(cut -f4 ${fpFolder}/fimo.bed | cut -f1 -d"_" | awk '{print tolower($1)}' | sort | uniq)
do
	echo $factor
	echo sperm
	if [ $(grep -i $factor spermCounts | awk 'BEGIN{ct=0}{ct+=$1}END{print ct}') -gt 0 ]; then
	        cat $(ls *spermLo.fpkm | grep -i $factor) | sort -k1,1 -k2n,2 | uniq > combined/${factor}_spermLo.fpkm
	        for stage in $stages
	        do
	                echo $stage
	                cat $(ls *${stage}*Losperm.fpkm | grep -i $factor) | sort -k1,1 -k2n,2 | uniq > combined/${factor}_${stage}_bothLosperm.fpkm
	        done
	        cd combined
		wc -l ${factor}_spermLo.fpkm >> counts
		count=$(grep $factor counts | awk '{print $1}')
		R --vanilla --args ${factor}_$count ${factor}_spermLo.fpkm ${factor}_PN5zygote_bothLosperm.fpkm ${factor}_2-cellearly_bothLosperm.fpkm ${factor}_2-celllate_bothLosperm.fpkm ${factor}_4-cell_bothLosperm.fpkm ${factor}_ICM_bothLosperm.fpkm ${factor}_oocyte_bothLosperm.fpkm ${TF}_8-cell_bothLosperm.fpkm < /hdisk2/isaac/isaachd/H3K4me3/getMultiBoxPlots.R
	        cd ..
	fi
done
