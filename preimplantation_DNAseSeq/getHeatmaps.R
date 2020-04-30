library("gplots")
library(pheatmap)
args=commandArgs(trailingOnly=TRUE)

name=as.character(args[1])
sperm=read.delim(as.character(args[2]), header=F)
oocyte=read.delim(as.character(args[3]), header=F)
PN3P=read.delim(as.character(args[4]), header=F)
PN3M=read.delim(as.character(args[5]), header=F)
PN5P=read.delim(as.character(args[6]), header=F)
PN5M=read.delim(as.character(args[7]), header=F)
cell1=read.delim(as.character(args[8]), header=F)
cell2=read.delim(as.character(args[9]), header=F)
cell4=read.delim(as.character(args[10]), header=F)
cell8=read.delim(as.character(args[11]), header=F)
morula=read.delim(as.character(args[12]), header=F)

my_palette <- colorRampPalette(c("white", "red"))(n = 100)

pMatrix=as.matrix(cbind(sperm[,1], oocyte[,1], PN3P[,1], PN3M[,1], PN5P[,1], PN5M[,1], cell1[,1], cell2[,1],cell4[,1], cell8[,1], morula[,1]))
colnames(pMatrix) = c("sperm", "oocyte", "PN3_P", "PN3_M", "PN5_P", "PN5_M", "1cell", "2cell", "4cell", "8cell", "morula")

d=as.dist((1-cor(pMatrix))/2)
x=hclust(d)
png(paste(name, "_", ".png", sep=""), height = 2000, width = 2000, res = 300)
plot(x, main="", sub="", xlab="")
dev.off()


#png(paste(name, ".png", sep=""))
#heatmap.2(pMatrix, Colv=NA, distfun = function(c) as.dist((1 - t(cor(t(c)))/2)), col=my_palette, labCol=c("sperm", "oocyte", "PN3 P", "PN3 M", "PN5 P", "PN5 M", "1cell", "2cell", "4cell", "8cell", "morula"))
#dev.off()
