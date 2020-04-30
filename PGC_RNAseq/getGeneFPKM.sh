mkdir cuffdiff
mkdir cuffdiff/final
E11=/Zulu/isaac/PGC_RNAseq/bam/E11.5RNA-Seq.ERR192340.trim.UM.sorted.bam
E13=/Zulu/isaac/PGC_RNAseq/bam/E13.5mRNA-Seq.ERR192341.trim.UM.sorted.bam
E16=/Zulu/isaac/PGC_RNAseq/bam/E16.5mRNA-Seq.ERR192339.trim.UM.sorted.bam

#cuffdiff -p 5 -o cuffdiff/E13.5m /Zulu/isaac/PGC_RNAseq/gencode.vM20.annotation.gtf $E11 $E13 &
#cuffdiff -p 5 -o cuffdiff/E16.5m /Zulu/isaac/PGC_RNAseq/gencode.vM20.annotation.gtf $E11 $E16 &
#wait

for stage in E13.5m E16.5m
do
	echo $stage
	mkdir cuffdiff/$stage
#	awk 'BEGIN{OFS="\t"}{if(NR > 1 && $(NF-1) < .01) print $4,$3,$10}' cuffdiff/${stage}/gene_exp.diff | awk 'BEGIN{OFS="\t"}{sub(":", "-", $1); gsub("-", "\t", $1); print}' > cuffdiff/final/${stage}.DEgenes.bed &
#	cut -f4 cuffdiff/final/${stage}.DEgenes.bed | sort | uniq > cuffdiff/final/${stage}.DEgenes.txt &
#	awk 'BEGIN{OFS="\t"}{if(NR > 1) print $7,$1,$5,"+",$10}' cuffdiff/${stage}/isoforms.fpkm_tracking | awk 'BEGIN{OFS="\t"}{sub(":", "-", $1); gsub("-", "\t", $1); print}' | sort -k5,5 -k4,4 > cuffdiff/final/HD_${stage}.fpkm &
#	awk 'BEGIN{OFS="\t"}{if(NR > 1) print $7,$1,$5,"+",$14}' cuffdiff/${stage}/isoforms.fpkm_tracking | awk 'BEGIN{OFS="\t"}{sub(":", "-", $1); gsub("-", "\t", $1); print}' | sort -k5,5 -k4,4 > cuffdiff/final/WT_${stage}.fpkm &
#	awk 'BEGIN{OFS="\t"}{if(NR > 1) print $7,$1,$5,"+",$10}' cuffdiff/${stage}/genes.fpkm_tracking | awk 'BEGIN{OFS="\t"}{sub(":", "-", $1); gsub("-", "\t", $1); print}' | sort -k5,5 -k4,4 > cuffdiff/final/E11.5.genes.fpkm &
#	awk 'BEGIN{OFS="\t"}{if(NR > 1) print $7,$1,$5,"+",$14}' cuffdiff/${stage}/genes.fpkm_tracking | awk 'BEGIN{OFS="\t"}{sub(":", "-", $1); gsub("-", "\t", $1); print}' | sort -k5,5 -k4,4 > cuffdiff/final/${stage}.genes.fpkm &
	wait
	awk '$NF > 3' cuffdiff/final/${stage}.genes.fpkm | cut -f5 | sort | uniq > expressedGenes_${stage}.txt
done
wait
echo done
