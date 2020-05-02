firstDir=$(pwd)
mkdir sequences











for file in /hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/RS_S_CTCF_RSCTCFpeak_cluster3_forNGSplot_50ntaround.bed /hdisk2/isaac/ATACseqAnalysis/peaks_yoonhee/Sperm_specificCTCF_837.bed bed/CTCFpeaks_inSpermandEScelss.bed
do
	echo $file
	fastaFromBed -fi /home/genomefiles/mouse/mm9.allchromosomes.fa -bed $file -fo sequences/$(basename $file | awk '{gsub(".bed", ".justfp.fa"); print}') &
done
wait

