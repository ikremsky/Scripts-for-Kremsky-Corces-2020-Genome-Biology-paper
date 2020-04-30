args=commandArgs(trailingOnly=TRUE)
magnify=2
magnify2=2

x=read.delim(as.character(args[1]), header=F)
motif=as.character(args[2])
comparionStage=as.character(args[3])

n=1:length(x[,1])
avg1=x[,2]
avg2=x[,3]
sdev1=x[,4]
sdev2=x[,5]
p=x[,6]

avgA=x[,7]
#sdevA=x[,8]

#avg=c(avg1,avg2,avgA)
#Sdev=c(sdev1,sdev2,sdevA)

m1=which(p < .01 & p >= .001)
m2=which(p < .001 & p >= .00001)
m3=which(p < .00001 & p >= .0000000001)
m4=which(p < .0000000001)

ICMcount=as.integer(args[4])
notICMcount=as.integer(args[5])
name1=as.character(args[6])
name2=as.character(args[7])

names=c(paste(c(name1, name2), ", N=", c(ICMcount, notICMcount), sep=""), "all CpGs")
png(paste("LinePlot_DNAme_distalPeaks_", motif, "_", comparionStage, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(cex.lab=1.3, cex.axis=1.6, las=2)
#boxplot(x=list(x[,2],x[,3]), names=c("sperm", "random"))
#plot(n, avg1, ylim=range(c(avg-Sdev, avg+Sdev)), xaxt='n', col="red", xlab="", ylab="Mean meCpG/Cpg")
plot(n, avg1, xlim=c(.5,length(x[,1])+.5), ylim=c(0, 1), xaxt='n', col="red", pch=15, xlab="", ylab="Mean meCpG/CpG", cex=2*magnify2, lwd.tick=magnify2)
axis(1, at = n, labels = x[,1], lwd=magnify2, lwd.tick=magnify2)
box(lwd=magnify2)
#legend("topleft",names,col=c("red", "blue", "black"),pch=c(15,0,19), cex=1.7)
#arrows(n, avg1-sdev1, n, avg1+sdev1, length=0.15, angle=90, col="red", code=3)
points(n, avg2, col="blue", pch=0, cex=2*magnify2, lwd=magnify2)
points(n, avgA, col="black", pch=1, cex=2*magnify2, lwd=magnify2)
if(length(m1) > 0)
{
	text(m1, rep(1, length(m1)), labels=rep("*", length(m1)),cex=magnify)
}
if(length(m2) > 0)
{
	text(m2, rep(1, length(m2)), labels=rep("**", length(m2)),cex=magnify)
}
if(length(m3) > 0)
{
	text(m3, rep(1, length(m3)), labels=rep("***", length(m3)),cex=magnify)
}
if(length(m4) > 0)
{
	text(m4, rep(1, length(m4)), labels=rep("****", length(m4)),cex=magnify)
}

#arrows(n, avg2-sdev2, n, avg2+sdev2, length=0.15, angle=90, col="blue", code=3)
#arrows(n, avgA-sdevA, n, avgA+sdevA, length=0.15, angle=90, col="black", code=3)
dev.off()
png(paste("Legend_DNAme_", motif, "_", comparionStage, ".png", sep=""), height = 2000, width = 2000, res = 300)
plot(n, avg1, ylim=c(0, 1), xaxt='n', col="white", pch=15, xlab="", ylab="Mean meCpG/CpG")
legend("topleft",names,col=c("red", "blue", "black"), pch=c(15,0,1), cex=1.6)
dev.off()
