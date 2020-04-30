motif=ESR1
cd bed_TFs_allstrains/${motif}
fileEnd=atfimo_${motif}.fpkm
R --vanilla --args $motif Cont_Sperm_OmniATACseq_x115_TF_sort${fileEnd} GVoocyte_Rep1-2_pooled_x115_TF_sort${fileEnd} MIIoocyterep1_mm9.sort.rmdup.flt.TF${fileEnd} early2-cell_Allpooled.sorted.duprmvd.TFs.sorted${fileEnd} 2-cell_Allpooled.sorted.duprmvd.TFs.sorted${fileEnd} 4-cellreciprocal_Allpooled.sorted.duprmvd.TFs.sorted${fileEnd} ICM_Allpooled.sorted.duprmvd.TFs.sorted${fileEnd}  < /mnt/isaachd/ATAC-seq_naturedata/getHeatmaps_ATACseqatMotifs.R
