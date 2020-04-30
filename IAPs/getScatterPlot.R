magnify=4
args=commandArgs(trailingOnly=TRUE)

x=read.delim(as.character(args[1]), header=F)
motif=as.character(args[2])
comparionStage=as.character(args[3])

n=1:length(x[,1])
avg1=x[,2]
avg2=x[,3]
#sdev1=x[,4]
#sdev2=x[,5]

avgA=x[,6]
avgB=x[,7]

#avg=c(avg1,avg2,avgA)
#Sdev=c(sdev1,sdev2,sdevA)

VMs=which(avgB != 0)

names=as.character(x[,1])
#names=c(paste(c(name1, name2), " (", c(ICMcount, notICMcount), "M CpGs)", sep=""), "all CpGs")
png(paste("LinePlot_DNAme_distalPeaks_", motif, "_", comparionStage, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(cex.lab=1.3, cex.axis=1.6, las=2)
plot(avg1, avg2, xlim=c(0,1.5), ylim=c(0, 1), col="white", pch=15, xlab="TRAP affinity", ylab="Mean meCpG/CpG", main=paste("R=", cor(avg1, avg2), sep=""), lwd.tick=magnify, cex=magnify)
#legend("topleft",names,col=c("red", "blue", "black"),pch=c(15,0,19), cex=1.7)
box(lwd=magnify)
cols=rainbow(length(x[,1]))
for (i in 1:length(x[,1]))
{
	points(avg2[i], avg1[i], pch=19, col=cols[i], cex=magnify)
}
dev.off()


png(paste("LinePlot2_DNAme_distalPeaks_", motif, "_", comparionStage, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(cex.lab=1.3, cex.axis=1.6, las=2)
plot(avg1, avg2, xlim=c(0,1.5), ylim=c(0, 1), col="white", pch=15, xlab="TRAP affinity", ylab="Mean meCpG/CpG", cex=magnify, lwd.tick=magnify)
box(lwd=magnify)
#legend("topleft",names,col=c("red", "blue", "black"),pch=c(15,0,19), cex=1.7)
cols=rainbow(length(x[,1]))
for (i in c(VMs))
{
	points(avg2[i], avg1[i], pch=19, col=cols[i], cex=magnify)
        points(avgB[i], avgA[i], pch=15, col=cols[i], cex=magnify)
        segments(avgB[i], avgA[i], avg2[i], avg1[i], lwd=magnify)
}
dev.off()

png(paste("Legend_DNAme_", motif, "_", comparionStage, ".png", sep=""), height = 2000, width = 2000, res = 300)
plot(avg2, avg1, xlim=c(.2,1.9), ylim=c(0, 1), xaxt='n', col="white", pch=15, xlab="TRAP affinity", ylab="Mean meCpG/CpG (E13.5m PGC)")
legend("topleft",as.character(x[,1]),col=cols, pch=19, cex=1.45)
legend("topright",as.character(x[VMs,1]),col=cols[VMs], pch=15, cex=1.45)
dev.off()
