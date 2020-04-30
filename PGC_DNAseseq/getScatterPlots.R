args=commandArgs(trailingOnly=TRUE)

name=as.character(args[1])
ATACseq=read.delim(as.character(args[2]), header=F)
RNAseq=read.delim(as.character(args[3]), header=F)
clusters=as.numeric(args[4])
sample1="E14.5m DNAse"
sample2="ICM ATAC"
unit1="FPKM"
unit2="FPKM"

pMatrix=cbind(matrix(ATACseq[,7]), matrix(RNAseq[,7]))
xmax=max(pMatrix[,1])
ymax=max(pMatrix[,2])
xmin=min(pMatrix[,1])
ymin=min(pMatrix[,2])
cv=cor(pMatrix[,1], pMatrix[,2], method="spearman")
par(mar=c(0, 0, 0, 0) + 0.01)
png(paste("scatterplot_", name, ".png", sep=""), height = 2000, width = 2000, res=300)
plot(pMatrix, xlab=paste(sample1), ylab=paste(sample2), xlim=c(xmin,xmax), ylim=c(ymin,ymax), cex.axis=1.5, cex.lab=1.5)
#text((xmax+xmin)/2,(ymax+ymin)/2, paste("r=", signif(cv, 2), sep=""), cex=8, col="green")
title(sub=paste("r=", signif(cv, 2), sep=""))
#points(pMatrix)
dev.off()
