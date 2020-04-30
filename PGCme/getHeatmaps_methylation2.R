library(fastcluster)
library(gplots)
library("pheatmap")
args=commandArgs(trailingOnly=TRUE)
i=1
name=as.character(args[i]); i=i+1
DEmatrix=NULL
fileEnd=as.character(args[i]); i=i+1

while (i <= length(args))
{
	#original code for use with fpkm
	x=read.delim(as.character(args[i]), header=F); i=i+1
	DEmatrix=cbind(DEmatrix,as.numeric(x[,4]))	
}
coords=x[,1:3]
cent=round((coords[,3]+coords[,2])/2)
coords[,2]=cent
coords[,3]=cent+1
myCol <- c(colorRampPalette(c("white", "green4"))(6))
myBreaks <- c(-.2, -.001, .2, .4, .6, .8, 1)
#y=kmeans(DEmatrix,32, iter.max = 50, nstart=100)
#clusters=y$cluster
sums=apply(DEmatrix,1,max)
#DEmatrix=DEmatrix[sums > 20,]
#ordr=hclust(dist(DEmatrix))$order
#ordr=seq(length(DEmatrix[,1]))
#ordr=order(DEmatrix[,2]-DEmatrix[,1], decreasing=T)
ordr=order(DEmatrix[,1], decreasing=T)
#png(paste("heatmap_", name, ".png", sep=""), height = 2500, width = 2500, res=1000)
png(paste("heatmap_", name, ".png", sep=""), height = 3600, width = 3600, res=1200)
#ordr=order(clusters, apply(abs(DEmatrix), 1, max))
#colnames(DEmatrix)=gsub("WTAdultIntestinalEpithelium", "Intestine", gsub(fileEnd, "", args[-c(1,2)]))
colnames(DEmatrix)=c("a", "b")
pheatmap(DEmatrix[ordr,], border_color=NA, color=myCol, breaks=myBreaks, cluster_rows=FALSE, cluster_cols=FALSE, scale="none", fontsize = 12, fontsize_col=20, legend=F)
dev.off()
write.table(cbind(coords[ordr,], seq(length.out = length(ordr))), paste(name, ".bed", sep=""), row.names=F, col.names=F, quote=F, sep="\t")
