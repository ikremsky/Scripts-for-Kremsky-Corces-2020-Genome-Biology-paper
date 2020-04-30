args=commandArgs(trailingOnly=TRUE)

x=read.delim(as.character(args[1]), header=F)
name1="cluster1"
name2="cluster2"
name3="cluster3"
#names=c("Proximal paternal", "Proximal maternal", "Proximal control", "Distal paternal", "Distal maternal", "Distal control")
#names=c("Proximal paternal", "Proximal maternal", "Proximal control")
names=c("Distal Sperm TF-THSSs", "Distal control")
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

avgc1=x[,12]
avgc2=x[,13]
sdevc1=x[,14]
sdevc2=x[,15]

sdevc2[1]=sdevc2[1]+.001

avg=c(avg1,avg2,avgA,avgB,avgc1,avgc2)
Sdev=c(sdev1,sdev2,sdevA,sdevB,sdevc1,sdevc2)

png("DNAseseq_atSpermpks_distal.png", height = 2000, width = 2000, res = 300)
par(cex.lab=1.3, cex.axis=1.6, las=2)
#boxplot(x=list(x[,2],x[,3]), names=c("sperm", "random"))
#plot(n, avg1, ylim=range(c(avg-Sdev, avg+Sdev)), xaxt='n', pch=19, col="blue", xlab="", ylab="Mean FPKM")
#plot(n, avg1, ylim=c(0, 10.5791385), xaxt='n', pch=19, col="blue", xlab="", ylab="Mean FPKM")
plot(n, avgA, ylim=c(0, 3), xaxt='n', pch=1, col="red", xlab="", ylab="Mean FPKM")
#plot(n, avgA, ylim=range(c(avg-Sdev, avg+Sdev)), xaxt='n', pch=1, col="red", xlab="", ylab="Mean FPKM")
axis(1, at = n, labels = x[,1])
#legend("topleft",names,col=c("blue","pink", "black"),pch=c(19,19,19), cex=1.2)
legend("topleft",names,col=c("red", "black"),pch=c(1,1), cex=1.2)
axis(1, at = n, labels = x[,1])
#legend("topleft",names,col=c("blue","pink", "black", "blue","pink", "black"),pch=c(19,19,19,1,1,1), cex=1.2)
arrows(n, avgc2-sdevc2, n, avgc2+sdevc2, length=0.15, angle=90, col="black", code=3)
#arrows(n, avgc1-sdevc1, n, avgc1+sdevc1, length=0.15, angle=90, col="black", code=3)
#arrows(n, avg2-sdev2, n, avg2+sdev2, length=0.15, angle=90, col="pink", code=3)
#arrows(n, avg1-sdev1, n, avg1+sdev1, length=0.15, angle=90, col="blue", code=3)
#arrows(n, avgB-sdevB, n, avgB+sdevB, length=0.15, angle=90, col="pink", code=3)
arrows(n, avgA-sdevA, n, avgA+sdevA, length=0.15, angle=90, col="red", code=3)

#points(n, avgc1, pch=19, col="black")
points(n, avgc2, pch=1, col="black")
#points(n, avg2, pch=19, col="pink")
#points(n, avg1, pch=19, col="blue")
#points(n, avgB, pch=1, col="pink")
points(n, avgA, pch=1, col="red")

dev.off()

print(range(c(avg-Sdev, avg+Sdev)))
