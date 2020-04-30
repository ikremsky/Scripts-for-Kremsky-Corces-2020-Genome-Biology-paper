fpFolder=/hdisk2/isaac/ATACseqAnalysis/footprints_Sperm_Control_yoonheepks
#clusterFile="~/ATACseqAnalysis/peaks_yoonhee/TSSheatmap_clusters1-5.bed"
peakFile=/hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed
clusterFile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/TSSclusters_ATAC_Pol2s5_withNames.bed
#/hdisk2/isaac/isaachd/ATAC-seq_naturedata/TSSlist_newcluster_forRNAPIIS2p.bed

getPeaks ()
{
	for i in 1 2 3 4
	do
		awk -v clust=$i '$5 == clust' $clusterFile > peaks.${i}.bed &
	done
	wait
}
#getPeaks

onePosSample () {
	altType=$type

	M=$(awk -v x=$altType  'BEGIN{count=0}{if($2~"^"x"_") count+=$1/1000000}END{print count}' bed/readCounts)
	echo $bedFile
	echo $M
	echo $altType
	coverageBed -a $clusterFile -b $bedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}_paternal.fpkm &
	coverageBed -a $clusterFile -b $MbedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}_maternal.fpkm &
	for i in 
#1 2 3 4
	do
		coverageBed -a peaks.${i}.bed -b $bedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}_paternal.${i}.fpkm &
                coverageBed -a peaks.${i}.bed -b $MbedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}_maternal.${i}.fpkm &
	done
	wait
	newType=$(echo $type | awk '{sub("GVOocyte_14d", "Oocyte"); gsub("Pronuclei_", ""); sub("Pat_PN3", "PN3_P"); sub("Mat_PN3", "PN3_M"); sub("Pat_PN5", "PN5_P"); sub("Mat_PN5", "PN5_M"); print}')
}

fpkmFiles=""
for strain in paternal
do
	gamete=$(echo $strain | awk '{if($0 == "paternal") print "sperm"; else print "MIIoocyte"}')
	genome=$(echo $strain | awk '{if($0 == "paternal") print "genome2"; if($0 == "maternal") print "genome1"; if($0 == "All") print "All"}')

	for type in Sperm GVOocyte_14d Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 Pronuclei_Pat_PN5 Pronuclei_Mat_PN5 1Cell 2Cell 4Cell 8Cell Morula
	do
		fpkmFiles="$fpkmFiles ${type}_paternal.fpkm ${type}_maternal.fpkm"
		bedFile=bed/${type}_pooled.sorted.duprmvd.bed
		MbedFile=$bedFile
		onePosSample
	done
	wait
done
fpkmorigFiles=$fpkmFiles
R --vanilla --args DNAase_hc $fpkmFiles < getHeatmaps.R
for i in 1 2 3 4
do
	fpkmFiles=$(echo $fpkmorigFiles | awk -v k=$i '{sub("Sperm_maternal.fpkm ", ""); sub("GVOocyte_14d_paternal.fpkm ", ""); gsub(".fpkm", "."k".fpkm"); print}')
#	R --vanilla --args DNAase_hc_${i} $fpkmFiles < getHeatmaps.R
done
