magnify=4
args=commandArgs(trailingOnly=TRUE)

i=1
type=as.character(args[i]); i=i+1
x=read.delim(as.character(args[i]), header=F)
reprog=as.character(args[i]); i=i+1

avg1=log(x[,7]+1, 2)
avg2=log(x[,8]+1, 2)

png(paste("scatterPlot_IAPs_mutationVaffinity_", type, reprog, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(cex.lab=1.3, cex.axis=1.6, las=2)
plot(avg1, avg2, xlab="log2(edit distance + 1)", ylab="log2(TRAP affinity + 1)", main=type, sub=paste("R=", cor(avg1, avg2), sep=""), lwd.tick=magnify, cex=magnify)
#legend("topleft",names,col=c("red", "blue", "black"),pch=c(15,0,19), cex=1.7)
box(lwd=magnify)
dev.off()
