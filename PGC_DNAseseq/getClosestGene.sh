file=persistent_PGC_ICM
genes=/mnt/isaachd/annotations/mm9_all_Refseq_unique.bed
bedtools closest -a $file -b $genes | cut -f7 | sort | uniq > $(basename $file .bed)_genes
