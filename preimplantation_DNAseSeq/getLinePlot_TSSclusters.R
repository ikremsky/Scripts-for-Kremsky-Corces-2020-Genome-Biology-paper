args=commandArgs(trailingOnly=TRUE)

x=read.delim(as.character(args[1]), header=F)
parent=as.character(args[2])
name1="cluster1"
name2="cluster2"
name3="cluster3"
names=paste("cluster", 1:4, sep="")
n=1:length(x[,1])
avg1=x[,2]
avg2=x[,3]
sdev1=x[,4]
sdev2=x[,5]
p=x[,6]

avgA=x[,7]
avgB=x[,8]
sdevA=x[,9]
sdevB=x[,10]

#avgP=x[,12]
#sdevP=x[,13]

#avg6=x[,14]
#sdev6=x[,15]

avg=c(avg1,avg2,avgA,avgB)
Sdev=c(sdev1,sdev2,sdevA,sdevB)

png(paste("LinePlot_DNAse_", parent, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(cex.lab=1.5, cex.axis=1.4, las=2)
plot(n, avg1, ylim=range(c(avg-Sdev, avg+Sdev)), xaxt='n', pch=24, cex=2, col="green", xlab="", ylab="Mean FPKM or RPKM")
#plot(n, avg1, ylim=c(0.03670668, 0.65583212), xaxt='n', pch=24, cex=2, col="green", xlab="", ylab="Mean FPKM")
axis(1, at = n, labels = x[,1])
#legend("topleft",names,col=c("green","blue","red","black"),pch=c(24,15,25,19), cex=1.7)
arrows(n, avg1-sdev1, n, avg1+sdev1, length=0.15, angle=90, col="green", code=3, lwd=3)
arrows(n, avg2-sdev2, n, avg2+sdev2, length=0.15, angle=90, col="blue", code=3, lwd=3)
arrows(n, avgA-sdevA, n, avgA+sdevA, length=0.15, angle=90, col="red", code=3, lwd=3)
arrows(n, avgB-sdevB, n, avgB+sdevB, length=0.15, angle=90, col="black", code=3, lwd=3)
points(n, avgB, pch=19, col="black", cex=2)
points(n, avg2, pch=15, col="blue", cex=2)
points(n, avgA, pch=25, col="red", cex=2)
points(n, avg1, pch=24, col="green", cex=2)
dev.off()

print(range(c(avg-Sdev, avg+Sdev)))

