name=IAPs

mkdir affinities
cd affinities
/media/4TB4/isaac/TEPIC/TEPIC-master/Code/TEPIC.sh -c 5 -g mm9.fa -b /Zulu/isaac/starvation_sperm/mm9_IAPs.bed -o $name -p ../TEPIC-master/PWMs/2.1/Merged_PSEMs/Merged_JASPAR_HOCOMOCO_KELLIS_Mus_musculus.PSEM
echo done
