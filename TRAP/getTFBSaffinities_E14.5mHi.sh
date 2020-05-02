mkdir affinities
cd affinities
#awk '{gsub("chr", ""); print}' /home/genomefiles/mouse/mm9/chromosomes_combined/mm9.allchromosomes.fa > mm9.fa
awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,$5,$6}' /media/4TB4/isaac/PGC_DNAseseq/bed/All/E14.5_male_pooled.sorted.duprmvdatfimo_All.distalHi.fpkm > allPeaks.bed
#/media/4TB4/isaac/TEPIC/TEPIC-master/Code/TEPIC.sh -c 5 -g mm9.fa -b allPeaks.bed -o E14.5mHi -p ../TEPIC-master/PWMs/2.1/Merged_PSEMs/Merged_JASPAR_HOCOMOCO_KELLIS_Mus_musculus.PSEM
/media/4TB4/isaac/TEPIC/TEPIC-master/Code/TEPIC.sh -c 8 -g mm9.fa -b /media/4TB4/isaac/ATAC_DNAme_embryoComparison/motifs_CpGs/fimo.bed -o Allmotifs -p ../TEPIC-master/PWMs/2.1/Merged_PSEMs/Merged_JASPAR_HOCOMOCO_KELLIS_Mus_musculus.PSEM
echo done
