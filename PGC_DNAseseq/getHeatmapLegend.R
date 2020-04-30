library(fastcluster)
library("pheatmap")
i=1
name="legend_heatmap_DNAse"
DEmatrix=cbind(rnorm(100), rnorm(100))
myCol <- c(colorRampPalette(c("white", "red"))(302))
myBreaks <- c(-.1, seq(0,20,length=302))
png(paste(name, ".png", sep=""), height = 2000, width = 2000, res = 300)
pheatmap(DEmatrix, border_color=NA, color=myCol, breaks=myBreaks, cluster_rows=FALSE, cluster_cols=FALSE, scale="none", fontsize = 12, fontsize_col=32, legend=T)
dev.off()

