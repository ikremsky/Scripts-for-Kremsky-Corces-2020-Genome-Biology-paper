motifFiles="/mnt/isaachd/motif_databases/EUKARYOTE/jolma2013.meme /mnt/isaachd/motif_databases/JASPAR/JASPAR_CORE_2014_vertebrates.meme /mnt/isaachd/motif_databases/MOUSE/uniprobe_mouse.meme"

cat $motifFiles > combinedMotifs.meme
motifFile=combinedMotifs.meme

for file in /media/4TB4/isaac/IAPs/sequences/mm9_IAPplus2kb.bed.fa
do
	folder=motifs_$(basename $file .bed.fa)
	mkdir $folder
	/programs/meme_4.11.2/src/fimo --text --max-strand $motifFile $file > ${folder}/fimo.txt
done
