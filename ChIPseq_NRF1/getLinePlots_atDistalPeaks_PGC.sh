#/hdisk6/yoonhee/MAnorm_Linux_R_Package/MII-Sperm_MAnorm1/coverage_allembryos_Sperm-specific-40120/Sperm-specific_15095_sperm_fithic_fdr05_flip-TSS-gene_2712.bed
region=peaks
compareStage=NRF1
TF=All

name1="TRAP Affinity >=1"
name2="TRAP Affinity < 1"
affinityFile=NRF1_highestAffinities.bed
#/media/4TB4/isaac/ChIPseq_NRF1/NRF1motifs_highestAffinities.bed
awk '$NF >= 1' $affinityFile > NRF1_Hi.bed
awk '$NF < 1' $affinityFile > NRF1_Lo.bed

intersectBed -u -a /media/4TB4/isaac/ChIPseq_NRF1/motifs_NRF1_mergedPeaks.bed/fimo_NRF1.bed -b NRF1_Hi.bed > temp; mv temp NRF1_Hi.bed
intersectBed -u -a /media/4TB4/isaac/ChIPseq_NRF1/motifs_NRF1_mergedPeaks.bed/fimo_NRF1.bed -b  NRF1_Lo.bed > temp; mv temp NRF1_Lo.bed

pkFile=/media/4TB4/isaac/ChIPseq_NRF1/NRF1_Hi.bed
ctrlFile=/media/4TB4/isaac/ChIPseq_NRF1/NRF1_Lo.bed

onePosSample () {
        yLabel="% meCpG/CpG"
        name_1="ATAC-Seq peaks"
        name_2="random peaks"
        outName="$type"
        dataLab="$type"
        RefLabel="peak center"
	altType=$(basename $bedFile | cut -f1 -d"_")

	echo $bedFile
	echo $M

        if [ -e ${type}_${motif}_${compareStage}_${region}.me ]; then
                echo file exists
        else
	        intersectBed -u -a $bedFile -b $pkFile | awk 'BEGIN{OFS="\t"}{print $4,$5+$6}' > ${type}_${motif}_${compareStage}_${region}.me &
		intersectBed -u -a $bedFile -b $ctrlFile | awk 'BEGIN{OFS="\t"}{print $4,$5+$6}' > ${type}_${motif}_${compareStage}_${region}_ctrl.me &
	fi

        if [ -e ${type}_all.me ]; then 
                echo ${type}_all.me exists
        else
                awk 'BEGIN{OFS="\t"}{print $4,$5+$6}' $bedFile > ${type}_all.me &
        fi
        wait
	R --vanilla --args ${type}_${motif}_${compareStage}_${region}.me ${type}_${motif}_${compareStage}_${region}_ctrl.me $type ${motif}_${compareStage}_${region} ${type}_all.me < getWeightedMeanandSD_PGC.R
#        R --vanilla --args ${type}.common.me ${type}.Pspecific.me $type ${type}.Mspecific.me < getWeightedMeanandSD_disalPeaks.R
}
for strain in paternal
do
        N_accessible=$(cat $pkFile | wc -l)
        N_inaccessible=$(cat $ctrlFile | wc -l)
	rm avgme.txt
	for bedFile in /Zulu/isaac/BSseq_2itoserumRemethylation/bed/BisSeq_to2i.SRR2500904_1.trim_bismark_bt2_pe.deduplicated.bedGraph.gz.bismark_meth.bed /Zulu/isaac/BSseq_2itoserumRemethylation/bed/BisSeq_toSerum.SRR2500905_1.trim_bismark_bt2_pe.deduplicated.bedGraph.gz.bismark_meth.bed
	do
	        type=$(basename $bedFile | cut -f1 -d"." | awk '{sub("BisSeq_to", ""); print}')
	        echo $bedFile
	        echo $type
	        onePosSample
	done
	wait
	R --vanilla --args avgme_${motif}_${compareStage}_${region}.txt ${motif}_$region ${compareStage} $N_accessible $N_inaccessible "$name1" "$name2" < getLinePlot_distalPeaks_withPval.R
done
