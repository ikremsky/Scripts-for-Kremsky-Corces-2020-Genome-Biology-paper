args=commandArgs(trailingOnly=TRUE)
i=1
allData=read.delim(as.character(args[i]), header = F); i=i+1

png(file="histogram_E14.5mHi_nearestGene.png", height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
hist(allData[,7], breaks=100, xlab="distance to nearest gene", main="")
dev.off()
