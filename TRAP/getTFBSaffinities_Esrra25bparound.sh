name=Esrra25bparound
#awk 'BEGIN{OFS="\t"}{pos=int(($2+$3)/2); print $1,pos-25,pos+25,$4,$5,$6}' /media/4TB4/isaac/BSseq_BPAyoonhee/fimo_Esrra_ikbaround.bed > /media/4TB4/isaac/BSseq_BPAyoonhee/fimo_Esrra_25bparound.bed

mkdir affinities
cd affinities
/media/4TB4/isaac/TEPIC/TEPIC-master/Code/TEPIC.sh -c 5 -g mm9.fa -b /media/4TB4/isaac/BSseq_BPAyoonhee/fimo_Esrra_25bparound.bed -o $name -p ../TEPIC-master/PWMs/2.1/Merged_PSEMs/Merged_JASPAR_HOCOMOCO_KELLIS_Mus_musculus.PSEM
echo done
