name=hypoDMRs

mkdir affinities
cd affinities
/media/4TB4/isaac/TEPIC/TEPIC-master/Code/TEPIC.sh -c 5 -g mm9.fa -b /media/4TB4/isaac/BPA_Yoonhe/HypoDMR-inBPAsperm_20percentDifference_p0001.bed -o $name -p ../TEPIC-master/PWMs/2.1/Merged_PSEMs/Merged_JASPAR_HOCOMOCO_KELLIS_Mus_musculus.PSEM
echo done
