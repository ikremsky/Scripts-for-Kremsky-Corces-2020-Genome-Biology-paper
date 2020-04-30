args=commandArgs(trailingOnly=TRUE)
logPutoff=5
i=1
x=as.matrix(read.delim(as.character(args[i]), header=F)); i=i+1
counts=as.integer(x[,2])
names=as.character(x[,1])
outName=as.character(args[i]); i=i+1
myCol <- c(colorRampPalette(c("white", "purple4"))(logPutoff))
logPs=-log(as.numeric(x[,5]), 10)
logPs=round(logPs)+1
logPs[logPs > logPutoff]=logPutoff

png(paste("barplot_", outName, ".png", sep=""), height = 2000, width = 2000, res=300)
par(lwd=2, las=1)
barplot(counts, width = 1, xlab="# of TFBSs at reprogrammed CpGs", ylim=c(0,64), names.arg=names, cex.axis=1.5, cex.lab=1.5, cex.names=.97, horiz=T, space=1.15, col=myCol[logPs])
dev.off()
