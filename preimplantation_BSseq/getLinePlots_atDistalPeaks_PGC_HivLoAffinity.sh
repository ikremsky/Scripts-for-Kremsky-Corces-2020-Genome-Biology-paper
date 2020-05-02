#/hdisk6/yoonhee/MAnorm_Linux_R_Package/MII-Sperm_MAnorm1/coverage_allembryos_Sperm-specific-40120/Sperm-specific_15095_sperm_fithic_fdr05_flip-TSS-gene_2712.bed
region=distal
compareStage=ESCmeatE14.5mHi_HivLoAffinity
TF=All
affinityFile=/media/4TB4/isaac/PGC_RNAseq/E16.5m_highestAffinities.bed
fpkmFile=/media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm


name1="TRAP Affinity >= 1"
name2="TRAP Affinity < 1"

awk '$NF >= 1' $affinityFile > HiAffinities.bed
awk '$NF < 1' $affinityFile > LoAffinities.bed

intersectBed -u -a $fpkmFile -b HiAffinities.bed > temp; mv temp HiAffinities.bed
intersectBed -u -a $fpkmFile -b LoAffinities.bed > temp; mv temp LoAffinities.bed

pkFile=HiAffinities.bed
ctrlFile=LoAffinities.bed

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
strain=paternal
for strain in paternal
do
	gamete=$(echo $strain | awk '{if($0 == "paternal") print "sperm"; else print "oocyte"}')
	genome=$(echo $strain | awk '{if($0 == "paternal") print "genome2"; else print "genome1"}')

        N_accessible=$(cat $pkFile | wc -l)
        N_inaccessible=$(cat $ctrlFile | wc -l)
	rm avgme.txt
	for bedFile in $(ls bed/*mm9.bed | grep -v + | grep -v - | grep -v hmc | grep -e $gamete -e $strain)
	do
	        type=$(echo $bedFile | cut -f2 -d"_" | awk '{sub("E75", "E7.5"); sub("E65", "E6.5"); print}')
	        echo $bedFile
	        echo $type
	        onePosSample
	done
	wait
	R --vanilla --args avgme_${motif}_${compareStage}_${region}.txt ${motif}_$region ${compareStage} $N_accessible $N_inaccessible "$name1" "$name2" < getLinePlot_distalPeaks_withPval.R
done
