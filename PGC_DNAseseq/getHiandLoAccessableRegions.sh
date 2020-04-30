TF=$1
#intersectBed -u -a /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed | cut -f1-4 | cut -f1 -d"_" | cut -f1-4 | cut -f1 -d"_" > fimo_IAPs.forigv.bed
sort -k4b,4 fimo_IAPs.forigv.bed | grep -v ":" > temp
grep -v ARNTL /mnt/bigmama/isaac/RNAseq_mouseEmbryo/cuffdiff/final/ids_PGCandPreimp > ids_E16.5m
join -1 4 -i temp ids_E16.5m | awk 'BEGIN{OFS="\t"}{print $2,$3,$4,$1}' > fimo_IAPs.ETFs.forigv.bed
mkdir bed/$TF
cd bed/$TF
for type in 
#E9.5 E10.5 E12.5_male E13.5_male E14.5_male E16.5_male
#E9.5 E10.5 E12.5_female E12.5_male E13.5_female E13.5_male E14.5_female E14.5_male E16.5_female E16.5_male
do
	altType=$(echo $type | awk '{sub("_male", "m"); sub("_female", "f"); print}')
	file=$(ls ${type}*fpkm | grep -v Lo | grep -v Hi | grep -v distal | grep -v genuine | grep -v NomeSeq)
	summitFile=/media/4TB4/isaac/PGC_DNAseseq/peaks/${type}_summits.bed
	echo $file

	intersectBed -u -a $file -b /media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/allPeaks.bed > $(basename $file .fpkm).genuine.fpkm
	intersectBed -v -a $(basename $file .fpkm).genuine.fpkm -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed > $(basename $file .fpkm).distal.fpkm
	awk '$NF == 0' $(basename $file .fpkm).genuine.fpkm > $(basename $file .fpkm).Lo.fpkm
	intersectBed -u -a $(basename $file .fpkm).fpkm -b $summitFile | awk '$NF > 20' >  $(basename $file .fpkm).Hi.fpkm
	intersectBed -v -a $(basename $file .fpkm).Hi.fpkm -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed > $(basename $file .fpkm).distalHi.fpkm
#	intersectBed -u -a $(basename $file .fpkm).distalHi.fpkm -b /media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/mm9_IAPplus2kb.bed > $(basename $file .fpkm).atIAPs.distalHi.fpkm
	intersectBed -u -a $(basename $file .fpkm).distalHi.fpkm -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed > $(basename $file .fpkm).atIAPs.distalHi.fpkm
	intersectBed -u -b $(basename $file .fpkm).distalHi.fpkm -a /Zulu/isaac/starvation_sperm/mm9_IAPs.bed > $(basename $file .fpkm).distalHi.IAPs.fpkm
#	intersectBed -u -b $(basename $file .fpkm).distalHi.fpkm -a /media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/mm9_IAPplus2kb.bed > temp
#	intersectBed -u -a /Zulu/isaac/starvation_sperm/mm9_IAPs.bed -b temp > $(basename $file .fpkm).distalHi.IAPs.fpkm
	intersectBed -v -a $(basename $file .fpkm).Lo.fpkm -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed >  $(basename $file .fpkm).distalLo.fpkm
        intersectBed -u -a $(basename $file .fpkm).distalLo.fpkm -b /media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/mm9_IAPplus2kb.bed > $(basename $file .fpkm).atIAPs.distalLo.fpkm
        intersectBed -v -a $(basename $file .fpkm).distalLo.fpkm -b /media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/mm9_IAPplus2kb.bed > $(basename $file .fpkm).notatIAPs.distalLo.fpkm
	if [ $(echo $type | awk '{if($1 == "E13.5_male") print 1; else print 0}') -eq 1 ]; then
		echo .
#		intersectBed -wa -wb -a $(basename $file .fpkm).notatIAPs.distalLo.fpkm -b /Zulu/isaac/PGCme/bed/${altType}BS-Seq_meth.bed | awk '$11 == 0 && $12+$13 > 5' | cut -f1-6 > $(basename $file .fpkm).notatIAPs.distalLo.meLo.fpkm &
#		intersectBed -wa -wb -a $(basename $file .fpkm).notatIAPs.distalLo.fpkm -b /Zulu/isaac/PGCme/bed/${altType}BS-Seq_meth.bed | awk '$11 > .25 && $12+$13 > 5' | cut -f1-6 > $(basename $file .fpkm).notatIAPs.distalLo.meHi.fpkm &
#		intersectBed -wa -wb -a $(basename $file .fpkm).atIAPs.distalLo.fpkm -b /Zulu/isaac/PGCme/bed/${altType}BS-Seq_meth.bed | awk '$11 == 0 && $12+$13 > 5' | cut -f1-6 > $(basename $file .fpkm).atIAPs.distalLo.meLo.fpkm &
#		intersectBed -wa -wb -a $(basename $file .fpkm).atIAPs.distalLo.fpkm -b /Zulu/isaac/PGCme/bed/${altType}BS-Seq_meth.bed | awk '$11 > .25 && $12+$13 > 5' | cut -f1-6 > $(basename $file .fpkm).atIAPs.distalLo.meHi.fpkm &
	fi
done
intersectBed -u -a E13.5_male_pooled.sorted.duprmvdatfimo_${TF}.Hi.fpkm -b E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.Hi.fpkm > temp
intersectBed -u -a temp -b E16.5_male_pooled.sorted.duprmvdatfimo_${TF}.Hi.fpkm > E13.5-16.5_male_persistent.Hi.fpkm
intersectBed -v -a E13.5-16.5_male_persistent.Hi.fpkm -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed > E13.5-16.5_male_persistent.distalHi.fpkm
intersectBed -u -a E13.5-16.5_male_persistent.Hi.fpkm -b /mnt/isaachd/annotations/TSSs_500bparouns_mm9.bed > E13.5-16.5_male_persistent.proximalHi.fpkm

intersectBed -u -a E13.5_male_pooled.sorted.duprmvdatfimo_${TF}.Lo.fpkm -b E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.Lo.fpkm > temp
intersectBed -u -a temp -b E16.5_male_pooled.sorted.duprmvdatfimo_${TF}.Lo.fpkm > E13.5-16.5_male_persistent.Lo.fpkm
intersectBed -v -a E13.5-16.5_male_persistent.Lo.fpkm -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed > E13.5-16.5_male_persistent.distalLo.fpkm
intersectBed -v -a E13.5-16.5_male_persistent.distalLo.fpkm -b /media/4TB4/isaac/PGC_DNAseseq/allMouseTFs/mm9_IAPplus2kb.bed > E13.5-16.5_male_persistent.notatIAPs.distalLo.fpkm
intersectBed -u -a E13.5-16.5_male_persistent.Lo.fpkm -b /mnt/isaachd/annotations/TSSs_500bparouns_mm9.bed > E13.5-16.5_male_persistent.proximalLo.fpkm

intersectBed -u -a E13.5_male_pooled.sorted.duprmvdatfimo_${TF}.fpkm -b E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.Hi.fpkm | awk '$NF < 12' > E14.5m_gained.fpkm
intersectBed -v -a E14.5m_gained.fpkm -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed > E14.5m_gained.distal.fpkm
intersectBed -u -a E14.5m_gained.fpkm -b /mnt/isaachd/annotations/TSSs_500bparouns_mm9.bed > E14.5m_gained.proximal.fpkm

intersectBed -u -a E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.fpkm -b E13.5_male_pooled.sorted.duprmvdatfimo_${TF}.Hi.fpkm | awk '$NF < 12' > E14.5m_lost.fpkm
intersectBed -v -a E14.5m_lost.fpkm -b /mnt/isaachd/annotations/TSSs_2.5kbarouns_mm9.bed > E14.5m_lost.distal.fpkm
intersectBed -u -a E14.5m_lost.fpkm -b /mnt/isaachd/annotations/TSSs_500bparouns_mm9.bed > E14.5m_lost.proximal.fpkm
wait

intersectBed -u -a E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.distal.fpkm -b E9.5_pooled.sorted.duprmvdatfimo_${TF}.distalHi.fpkm | awk '$NF < 2.5' > E9.5Hi_E14.5mLo.distal.fpkm
intersectBed -u -a E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.distalHi.fpkm -b E9.5_pooled.sorted.duprmvdatfimo_${TF}.distalHi.fpkm > E9.5Hi_E14.5mHi.distal.fpkm
intersectBed -u -a E9.5_pooled.sorted.duprmvdatfimo_${TF}.distal.fpkm -b E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.distalHi.fpkm | awk '$NF < 2.5' > E9.5Lo_E14.5mHi.distal.fpkm
intersectBed -u -a E16.5_male_NomeSeq_at_fimo_${TF}.fpkm -b E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.distalHi.fpkm | awk '$NF > 5' > E16.5m_DNAseHi_MNaseHi.distal.fpkm
intersectBed -u -a E16.5_male_NomeSeq_at_fimo_${TF}.fpkm -b E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.distalHi.fpkm | awk '$NF == 0' > E16.5m_DNAseHi_MNaseLo.distal.fpkm
intersectBed -u -a E16.5_male_NomeSeq_at_fimo_${TF}.fpkm -b E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.notatIAPs.distalLo.fpkm | awk '$NF > 5' > E16.5m_DNAseLo_MNaseHi.distal.fpkm
intersectBed -u -a E16.5_male_NomeSeq_at_fimo_${TF}.fpkm -b E14.5_male_pooled.sorted.duprmvdatfimo_${TF}.notatIAPs.distalLo.fpkm | awk '$NF == 0' > E16.5m_DNAseLo_MNaseLo.distal.fpkm
echo done $TF
