mkdir cuffdiff
mkdir cuffdiff/final

#cuffdiff -p 5 -o cuffdiff/E13.5m /Zulu/isaac/PGC_RNAseq/gencode.vM20.annotation.gtf $E11 $E13 &
#cuffdiff -p 5 -o cuffdiff/E16.5m /Zulu/isaac/PGC_RNAseq/gencode.vM20.annotation.gtf $E11 $E16 &
#wait

ESCfiles=$(ls /Zulu/isaac/mESC_RNAseq/bam/*sorted.bam | grep -v pool | awk '{gsub("\n", ","); print}')
stages="MII_oocyte ESC"
#"zygote_PN5 2cell_early 2cell_late 4cell 8cell ICM ESC"
ESCfiles=$(echo $ESCfiles | awk '{gsub(" ", ","); print}')

for i in $(seq $(echo $stages | awk '{print NF-1}'))
do
	stage=$(echo $stages | cut -f $i -d" ")
	echo $stage
	files=$(ls /Zulu/isaac/RNAseq_embryo_Nature/bam/*${stage}*.trim.UM.sorted.bam)
	files=$(echo $files | awk '{gsub(" ", ","); print}')
	mkdir cuffdiff/$stage
	cuffdiff -p 25 -o cuffdiff/$stage /Zulu/isaac/PGC_RNAseq/gencode.vM20.annotation.gtf $ESCfiles $files
	awk 'BEGIN{OFS="\t"}{if(NR > 1) print $7,$1,$5,"+",$10}' cuffdiff/${stage}/genes.fpkm_tracking | awk 'BEGIN{OFS="\t"}{sub(":", "-", $1); gsub("-", "\t", $1); print}' | sort -k5b,5 -k4,4 > cuffdiff/final/ESC.genes.fpkm &
	awk 'BEGIN{OFS="\t"}{if(NR > 1) print $7,$1,$5,"+",$14}' cuffdiff/${stage}/genes.fpkm_tracking | awk 'BEGIN{OFS="\t"}{sub(":", "-", $1); gsub("-", "\t", $1); print}' | sort -k5b,5 -k4,4 > cuffdiff/final/${stage}.genes.fpkm &
#	wait
#	awk '$NF > 3' cuffdiff/final/${stage}.genes.fpkm | cut -f5 | sort | uniq > expressedGenes_${stage}.txt
done
wait
echo done
