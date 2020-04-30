fpFolder=/hdisk2/isaac/ATACseqAnalysis/footprints_Sperm_Control_yoonheepks
clusterFile=/hdisk6/yoonhee/MAnorm_Linux_R_Package/MII-Sperm_MAnorm1/coverage_allembryos_MII-specific-17258/MII-specific-17258_PN3-PN5-M-2C-4C-8C-Mor_RPKM2_6611_ordered.bed
name=Oocyte-E

getPeaks ()
{
#        intersectBed -u -a ~/isaachd/annotations/TSSs_500bparouns_mm9.bed -b SNPs/all_DBA2J_SNPs_C57BL6NJ_reference.based_on_mm9.bed > temp
        for i in all
        do
                ii=$i
                awk 'BEGIN{OFS="\t"}{print $1,$2,$3,NR,".","+"}' $clusterFile > bedFile.${ii}.bed
#                intersectBed -u -a bedFile${ii}.bed -b /hdisk2/isaac/isaachd/ATAC-seq_naturedata/SNPs/all_DBA2J_SNPs_C57BL6NJ_reference.based_on_mm9.bed | awk 'BEGIN{OFS="\t"}{print $1,$2+100,$3-100,".",$5,$6}' | sort -k1,1 -k2n,2 | uniq | mergeBed -s -i - | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,".",".",$4}' > temp; mv temp bedFile.${ii}.bed
        done
}
getPeaks
rm avgFpkm.txt

onePosSample () {
	altType=$type

	M=$(awk -v x=$altType  'BEGIN{count=0}{if($2~"^"x"_pooled") count+=$1/1000000}END{print count}' bed/readCounts)
	echo $bedFile
	echo $M
	echo $altType
	for i in all
	do
#                coverageBed -a peaks.${i}_control.bed -b $bedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}.${i}_control.fpkm &
#		coverageBed -a bedFile.${i}.bed -b $bedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $1,$2,$3,$4,$7/(K*M)}' > ${type}_paternal.${i}.fpkm &
                coverageBed -a bedFile.${i}.bed -b $bedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}_paternal.${i}.fpkm &
                coverageBed -a bedFile.${i}.bed -b $MbedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}_maternal.${i}.fpkm &
	done
	wait
	newType=$(echo $type | awk '{sub("Sperm_ATAC", "gamete"); sub("Pronuclei_Pat_PN3", "PN3"); sub("Pronuclei_Pat_PN5", "PN5"); print}')
	R --vanilla --args ${type}_paternal.${i}.fpkm ${type}_maternal.${i}.fpkm $newType < getWeightedMeanandSD_disalPeaks_PvM.R
#	R --vanilla --args ${type}_maternal.common.fpkm ${type}_maternal.Pspecific.fpkm $newType ${type}_maternal.Mspecific.fpkm < getWeightedMeanandSD_disalPeaks.R
}

fpkmFiles=""
for strain in paternal
do
	gamete=$(echo $strain | awk '{if($0 == "paternal") print "sperm"; else print "MIIoocyte"}')
	genome=$(echo $strain | awk '{if($0 == "paternal") print "genome2"; if($0 == "maternal") print "genome1"; if($0 == "All") print "All"}')

	for type in Sperm_ATAC Pronuclei_Pat_PN3 Pronuclei_Pat_PN5
#Sperm_ATAC Oocyte_ATAC Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 Pronuclei_Pat_PN5 Pronuclei_Mat_PN5
#1Cell 2Cell 4Cell 8Cell Morula
	do
		fpkmFiles="$fpkmFiles "${type}_paternal.proximal.fpkm
		Mtype=$(echo $type | awk '{sub("_Pat_", "_Mat_"); sub("Sperm_ATAC", "GVoocyteATAC_Rep1-2"); print}')
		bedFile=bed/${type}_pooled.sorted.duprmvd.bed
		MbedFile=bed/${Mtype}_pooled.sorted.duprmvd.bed
		onePosSample
	done
	wait
done
echo $fpkmFiles
uniq avgFpkm.txt > temp; mv temp avgFpkm.txt
R --vanilla --args avgFpkm.txt $name < getLinePlot_distalPeaks_PvM.R
#R --vanilla --args avgFpkm.txt < getLinePlot_SpermPks.R

#R --vanilla --args DNAse_htmap $fpkmFiles < /hdisk2/isaac/isaachd/H3K4me3/getHeatmaps.R < getHeatmaps.R
