peakFile=/media/4TB4/isaac/ChIPseq_NRF1/motifs_NRF1_mergedPeaks.bed/fimo.bed
#/media/4TB4/isaac/ChIPseq_NRF1/bed_shifted/NRF1_mergedPeaks.bed
name=NRF1ChIP

mkdir affinities
cd affinities
rm allPeaks.bed
#awk '{gsub("chr", ""); print}' /home/genomefiles/mouse/mm9/chromosomes_combined/mm9.allchromosomes.fa > mm9.fa
awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,$5,$6}' $peakFile > allPeaks.bed
/media/4TB4/isaac/TEPIC/TEPIC-master/Code/TEPIC.sh -c 5 -g mm9.fa -b allPeaks.bed -o $name -p ../TEPIC-master/PWMs/2.1/Merged_PSEMs/Merged_JASPAR_HOCOMOCO_KELLIS_Mus_musculus.PSEM
#/media/4TB4/isaac/TEPIC/TEPIC-master/Code/TEPIC.sh -c 5 -g mm9.fa -b /media/4TB4/isaac/ChIPseq_NRF1/motifs_NRF1_mergedPeaks.bed/fimo_NRF1.bed -o NRF1motifs -p ../TEPIC-master/PWMs/2.1/Merged_PSEMs/Merged_JASPAR_HOCOMOCO_KELLIS_Mus_musculus.PSEM
echo done
