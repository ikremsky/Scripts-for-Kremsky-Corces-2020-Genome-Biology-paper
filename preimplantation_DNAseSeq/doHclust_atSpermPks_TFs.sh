fpFolder=/hdisk2/isaac/ATACseqAnalysis/footprints_Sperm_Control_yoonheepks
#clusterFile="~/ATACseqAnalysis/peaks_yoonhee/TSSheatmap_clusters1-5.bed"
peakFile=/hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/Cont_Sperm_OmniATACseq_x115_TF_peaks.bed
clusterFile=/mnt/bigmama/isaac/geneClusters_Pol2s5_ATACseq/TSSclusters_ATAC_Pol2s5_withNames.bed
#/hdisk2/isaac/isaachd/ATAC-seq_naturedata/TSSlist_newcluster_forRNAPIIS2p.bed

getPeaks ()
{
	awk 'BEGIN{OFS="\t"}{print $1,$2-100,$3+100,$4,".","+"}' $peakFile > temp
	N=$(wc -l temp | cut -f1 -d" ")
	avg=$(awk -v n=$N 'BEGIN{x=0}{x+=$3-$2-200}END{print int(x/(2*n))}' temp)
	sh /hdisk2/isaac/isaachd/H3K4me3/shiftIDRpeaksForControl.sh /hdisk2/isaac/isaachd/ATAC-seq_naturedata/SNPs/all_DBA2J_SNPs_C57BL6NJ_reference.based_on_mm9.bed
#	intersectBed -u -a temp -b /hdisk2/isaac/isaachd/ATAC-seq_naturedata/SNPs/all_DBA2J_SNPs_C57BL6NJ_reference.based_on_mm9.bed > peaks.bed &
	intersectBed -v -a /hdisk2/isaac/isaachd/ATAC-seq_naturedata/SNPs/all_DBA2J_SNPs_C57BL6NJ_reference.based_on_mm9.random.bed -b temp > controlSNPs.bed &
	wait
        mv temp peaks.bed

	intersectBed -u -a peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed | sort -k1,1 -k2n,2 | uniq | mergeBed -s -i - | awk 'BEGIN{OFS="\t"}{print $1,$2+100,$3-100,".",".","+"}' > peaks.proximal.bed &
        intersectBed -v -a peaks.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed | sort -k1,1 -k2n,2 | uniq | mergeBed -s -i - | awk 'BEGIN{OFS="\t"}{print $1,$2+100,$3-100,".",".","+"}' > peaks.distal.bed &
        intersectBed -u -a controlSNPs.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed | sort -k1,1 -k2n,2 | awk -v len=$avg 'BEGIN{OFS="\t"}{if($2-len > 0) print $1,$2-len,$3+len,".",".","+"}' > peaks.proximal_control.bed
	intersectBed -v -a controlSNPs.bed -b ~/isaachd/annotations/TSSs_500bparouns_mm9.bed | sort -k1,1 -k2n,2 | awk -v len=$avg 'BEGIN{OFS="\t"}{if($2-len > 0) print $1,$2-len,$3+len,".",".","+"}' > peaks.distal_control.bed
	wait
}
#getPeaks
rm avgFpkm.txt

onePosSample () {
	altType=$type

	M=$(awk -v x=$altType  'BEGIN{count=0}{if($2~"^"x"_") count+=$1/1000000}END{print count}' bed/readCounts)
	echo $bedFile
	echo $M
	echo $altType
	for i in proximal distal
	do
                coverageBed -a peaks.${i}_control.bed -b $bedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}.${i}_control.fpkm &
		coverageBed -a peaks.${i}.bed -b $bedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}_paternal.${i}.fpkm &
                coverageBed -a peaks.${i}.bed -b $MbedFile | awk -v M=$M 'BEGIN{OFS="\t"}{K=($9-1)/1000; print $7/(K*M),1}' > ${type}_maternal.${i}.fpkm &
	done
	wait
	newType=$(echo $type | awk '{sub("GVOocyte_14d", "Oocyte"); gsub("Pronuclei_", ""); sub("Pat_PN3", "PN3_P"); sub("Mat_PN3", "PN3_M"); sub("Pat_PN5", "PN5_P"); sub("Mat_PN5", "PN5_M"); print}')
#        R --vanilla --args ${type}_paternal.proximal.fpkm ${type}_maternal.proximal.fpkm $newType ${type}_paternal.distal.fpkm ${type}_maternal.distal.fpkm ${type}.proximal_control.fpkm ${type}.distal_control.fpkm < getWeightedMeanandSD_SpermPks.R
}

fpkmFiles=""
for strain in paternal
do
	gamete=$(echo $strain | awk '{if($0 == "paternal") print "sperm"; else print "MIIoocyte"}')
	genome=$(echo $strain | awk '{if($0 == "paternal") print "genome2"; if($0 == "maternal") print "genome1"; if($0 == "All") print "All"}')

	for type in Sperm GVOocyte_14d Pronuclei_Pat_PN3 Pronuclei_Mat_PN3 Pronuclei_Pat_PN5 Pronuclei_Mat_PN5 1Cell 2Cell 4Cell 8Cell Morula
	do
		fpkmFiles="$fpkmFiles "${type}_paternal.proximal.fpkm
		bedFile=bed/${type}_pooled.sorted.duprmvd.bed
		MbedFile=$bedFile
#		onePosSample
	done
	wait
done
echo $fpkmFiles
#R --vanilla --args avgFpkm.txt < getLinePlot_SpermPks_distal.R
#R --vanilla --args avgFpkm.txt < getLinePlot_SpermPks.R
#R --vanilla --args DNAse_htmap $fpkmFiles < /hdisk2/isaac/isaachd/H3K4me3/getHeatmaps.R < getHeatmaps.R

for i in 1 2 3 4
do
	R --vanilla --args < getHeatmaps.R
done
