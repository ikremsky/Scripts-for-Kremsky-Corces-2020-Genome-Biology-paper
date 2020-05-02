args=commandArgs(trailingOnly=TRUE)

x=read.delim(as.character(args[1]), header=F)
strain=as.character(args[2])
name1="cluster1"
name2="cluster2"
name3="cluster3"
names=paste("cluster", 1:5, sep="")
n=1:length(x[,1])
avg1=x[,2]
avg2=x[,3]
sdev1=x[,4]
sdev2=x[,5]
p=x[,6]

avgA=x[,7]
sdevA=x[,8]

avg=c(avg1,avg2,avgA)
Sdev=c(sdev1,sdev2,sdevA)

png(paste("LinePlot_DNAme_distalPeaks_", strain, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(cex.lab=1.3, cex.axis=1.6, las=2)
#boxplot(x=list(x[,2],x[,3]), names=c("sperm", "random"))
#plot(n, avg1, ylim=range(c(avg-Sdev, avg+Sdev)), xaxt='n', pch="C", col="black", xlab="", ylab="Mean meCpG/Cpg")
plot(n, avg1, ylim=c(0.04443801, 0.8), xaxt='n', pch="C", col="black", xlab="", ylab="Mean meCpG/Cpg")
axis(1, at = n, labels = x[,1])
#legend("topright",names,col=c("red","purple","blue","orange","black"),pch=c(19,19,1,2,19), cex=1.7)
arrows(n, avg1-sdev1, n, avg1+sdev1, length=0.15, angle=90, col="black", code=3)
points(n, avg2, pch="P", col="blue")
points(n, avgA, pch="M", col="pink")
arrows(n, avg2-sdev2, n, avg2+sdev2, length=0.15, angle=90, col="blue", code=3)
arrows(n, avgA-sdevA, n, avgA+sdevA, length=0.15, angle=90, col="pink", code=3)
dev.off()

print(range(c(avg-Sdev, avg+Sdev)))

