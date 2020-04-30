motifFiles="/mnt/isaachd/motif_databases/EUKARYOTE/jolma2013.meme /mnt/isaachd/motif_databases/JASPAR/JASPAR_CORE_2014_vertebrates.meme /mnt/isaachd/motif_databases/MOUSE/uniprobe_mouse.meme"

#cat $motifFiles > combinedMotifs.meme
motifFile=combinedMotifs.meme

#sh getSequence_fastaFromBed.sh bed_shifted/NRF1_mergedPeaks.bed

for file in sequences/NRF1_mergedPeaks.bed.fa
do
	folder=motifs_$(basename $file .fa)
	mkdir $folder
	/programs/meme_4.11.2/src/fimo --text --max-strand $motifFile $file | grep -i CG > ${folder}/fimo.txt
done
wait
