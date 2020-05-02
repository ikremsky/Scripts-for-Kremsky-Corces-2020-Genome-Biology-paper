args=commandArgs(trailingOnly=TRUE)
logPutoff=5
i=1
x=as.matrix(read.delim(as.character(args[i]), header=F)); i=i+1
name=as.character(args[i]); i=i+1
counts=as.integer(x[,2])
names=as.character(x[,1])
myCol <- c(colorRampPalette(c("white", "purple4"))(logPutoff))
logPs=-log(as.numeric(x[,5]), 10)
logPs=round(logPs)+1
logPs[logPs > logPutoff]=logPutoff

colors=rep("white", length(counts))
colors[as.numeric(x[,5]) < .05]="purple"
png(paste("barplot_", name, ".png", sep=""), height = 2000, width = 2000, res=300)
par(lwd=2, las=1)
barplot(counts, width = 1, xlab="# of TFBSs", ylim=c(0,64), names.arg=names, cex.axis=1.5, cex.lab=1.5, cex.names=1, horiz=T, space=1, col=myCol[logPs])
dev.off()
