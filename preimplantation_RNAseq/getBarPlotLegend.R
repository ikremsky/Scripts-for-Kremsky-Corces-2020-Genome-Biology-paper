library(fastcluster)
library("pheatmap")
logPutoff=5
i=1
name="legend_barPlot"
DEmatrix=cbind(rnorm(100), rnorm(100))
myCol <- c(colorRampPalette(c("white", "purple4"))(logPutoff))
myBreaks <- c(seq(0,logPutoff,length=logPutoff+1))
png(paste(name, ".png", sep=""), height = 2000, width = 2000, res=310)
pheatmap(DEmatrix, border_color=NA, color=myCol, breaks=myBreaks, cluster_rows=FALSE, cluster_cols=FALSE, scale="none", fontsize = 12, fontsize_col=32, legend=T)
dev.off()

