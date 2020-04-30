fpFolder=/hdisk2/isaac/ATACseqAnalysis/footprints_Sperm_Control_yoonheepks
#clusterFile="~/ATACseqAnalysis/peaks_yoonhee/TSSheatmap_clusters1-5.bed"
clusterFile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/TSSclusters_ATAC_Pol2s5.bed
#/hdisk2/isaac/isaachd/ATAC-seq_naturedata/TSSlist_newcluster_forRNAPIIS2p.bed


#cp /hdisk2/isaac/ATACseqAnalysis/bed/Cont_Sperm_OmniATACseq_x115_TF_sort.bed /mnt/bigmama/isaac/DNAseSeq/bed/Sperm_ATAC_pooled.sorted.duprmvd.bed

getPeaks ()
{
	intersectBed -u -a ~/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed -b /hdisk2/isaac/isaachd/ATAC-seq_naturedata/SNPs/v5/all_PWK_PhJ_SNPs_C57BL_6NJ_reference.based_on_mm9.bed > temp
	for i in 1 2 3 4
	do
		ii=$(expr $i + 0)
		awk -v i=$i '$5 == i' $clusterFile | awk 'BEGIN{OFS="\t"}{print $1,$2,$3,".",$5,$6}' > bedFile${ii}.bed
	done
}
#getPeaks
#rm avgFpkm.txt

onePosSample () {
        altType=$type
        M=$(awk -v x=$altType  'BEGIN{count=0}{if($2~"^"x"_pooled") count+=$1/1000000}END{print count}' bed/readCounts)

	echo $bedFile
	echo $M
        for i in  1 2 3 4
        do
                ii=$(expr $i + 0)
#		coverageBed -a bedFile${ii}.bed -b $bedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}.${ii}.fpkm &
##                coverageBed -a bedFile${ii}.bed -b $bedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $1,$2,$3,$7/(K*M),1}' > ${type}.${ii}.fpkm &
        done
	wait

	newType=$(echo $type | awk '{sub("2Cell", "E2Cell"); sub("GVoocyteATAC_Rep1-2", "GVOcyt"); sub("MIIoocyteATACrep1", "MIIOcyt"); sub("GVOocyte_14d", "Oocyte"); gsub("Pronuclei_", ""); sub("Sperm_ATAC", "Sperm"); sub("Pat_PN3", "PN3_P"); sub("Mat_PN3", "PN3_M"); sub("Pat_PN5", "PN5_P"); sub("Mat_PN5", "PN5_M"); print}')
         R --vanilla --args ${type}.1.fpkm ${type}.2.fpkm $newType ${type}.3.fpkm ${type}.4.fpkm < getWeightedMeanandSD_TSSclusters.R
}
strain=all
gamete=$(echo $strain | awk '{if($0 == "paternal") print "sperm"; else print "MIIoocyte"}')
genome=$(echo $strain | awk '{if($0 == "paternal") print "genome2"; else print "genome1"}')

for type in Sperm_ATAC GVoocyteATAC_Rep1-2 MIIoocyteATACrep1 Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 Pronuclei_Pat_PN5 Pronuclei_Mat_PN5 2Cell 4Cell 8Cell Morula
#GVOocyte_14d
do
	bedFile=bed/${type}_pooled.sorted.duprmvd.bed
	echo $type
#	onePosSample
done
wait
R --vanilla --args avgFpkm.txt $strain < getLinePlot_TSSclusters.R

