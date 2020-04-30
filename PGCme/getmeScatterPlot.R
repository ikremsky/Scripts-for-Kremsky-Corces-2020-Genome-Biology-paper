library(weights)
args=commandArgs(trailingOnly=TRUE)

x=read.delim(as.character(args[1]), header=F)
motif=as.character(args[2])
comparionStage=as.character(args[3])

png(paste("Scatterplot_DNAme_", motif, "_", comparionStage, ".png", sep=""), height = 2000, width = 2000, res = 300)
plot(x[,2], x[,1], ylab="meCpG/CpG", xlab="coverage")
dev.off()

png(paste("histogram_DNAme_", motif, "_", comparionStage, ".png", sep=""), height = 2000, width = 2000, res = 300)
wtd.hist(x[,1],weight=x[,2], xlab="meCpG/CpG", main="", freq=F, breaks=10000)
dev.off()
