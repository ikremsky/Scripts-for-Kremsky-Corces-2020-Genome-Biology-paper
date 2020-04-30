library(fastcluster)
library(gplots)
library("pheatmap")
args=commandArgs(trailingOnly=TRUE)
i=1
name=as.character(args[i]); i=i+1
DEmatrix=NULL
fileEnd=as.character(args[i]); i=i+1
fileEnd2=as.character(args[i]); i=i+1

while (i <= length(args))
{
	#original code for use with fpkm
	x=read.delim(as.character(args[i]), header=F); i=i+1
	DEmatrix=cbind(DEmatrix,as.numeric(x[,7]))	
}
coords=x[,1:3]
cent=round((coords[,3]+coords[,2])/2)
coords[,2]=cent
coords[,3]=cent+1
myCol <- c(colorRampPalette(c("white", "red"))(301))
myBreaks <- c(seq(0,20,length=301), 1000000)
#y=kmeans(DEmatrix,32, iter.max = 50, nstart=100)
#clusters=y$cluster
sums=apply(DEmatrix,1,max)
#DEmatrix=DEmatrix[sums > 20,]
#ordr=hclust(dist(DEmatrix))$order
#ordr=seq(length(DEmatrix[,8]))
ordr=order(DEmatrix[,1], decreasing=T)
#png(paste("heatmap_", name, ".png", sep=""), height = 2500, width = 2500, res=600)
png(paste("heatmap_", name, ".png", sep=""), height = 5000, width = 5000, res=800)
#ordr=order(clusters, apply(abs(DEmatrix), 1, max))
colnames(DEmatrix)=gsub("_male", "m", gsub(fileEnd, "", gsub(fileEnd2, "", gsub("Cont_", "", gsub("Pronuclei_", "", args[-c(1,2,3)])))))
pheatmap(DEmatrix[ordr,], border_color=NA, color=myCol, breaks=myBreaks, cluster_rows=FALSE, cluster_cols=FALSE, scale="none", fontsize = 12, fontsize_col=32, legend=F)
dev.off()
write.table(cbind(coords[ordr,], seq(length.out = length(ordr))), paste(name, ".bed", sep=""), row.names=F, col.names=F, quote=F, sep="\t")
