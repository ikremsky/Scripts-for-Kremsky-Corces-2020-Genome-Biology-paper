magnify=2
plotPvals = function(p, maxH, asteriskDist, x1, x2)
{
        if(p < .01 & p >= .001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="*", cex=magnify)
                arrows(x1,maxH,x2,maxH,code=3,lwd=magnify,angle=90,length=0.05,col="purple")
        }
        if(p < .001 & p >= .00001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="**", cex=magnify)
		arrows(x1,maxH,x2,maxH,code=3,lwd=magnify,angle=90,length=0.05,col="purple")
        }
        if(p < .00001 & p >= .0000000001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="***", cex=magnify)
		arrows(x1,maxH,x2,maxH,code=3,lwd=magnify,angle=90,length=0.05,col="purple")
        }
        if(p < .0000000001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="****", cex=magnify)
		arrows(x1,maxH,x2,maxH,code=3,lwd=magnify,angle=90,length=0.05,col="purple")
        }
}

args=commandArgs(trailingOnly=TRUE)
i=1
hiData=read.delim(as.character(args[i]), header = F); i=i+1
loData=read.delim(as.character(args[i]), header = F); i=i+1
allData=read.delim(as.character(args[i]), header = F); i=i+1

p=wilcox.test(hiData[,5], loData[,5])$p.value
maxH=4.75

png(file="boxplots_E14.5mHivLo_SeqSimilarity.png", height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
#hist(hiData[,5], breaks=50)
boxplot(x=list(hiData[,5], loData[,5]), names=c("DNAse-Hi", "DNAse-Lo"), ylim=c(0,maxH+.5), ylab="TRAP affinity", outline=F, lwd=magnify)
box(lwd=magnify)
axis(1, at=c(1,2), lwd=magnify, lwd.ticks=magnify)
axis(2, lwd.ticks=magnify)
plotPvals(p,maxH,.2,1,2)
dev.off()

low=hiData[hiData[,5] < 1 & hiData[,5] > 0,6]
nlow=length(low)
mlow=mean(low)
selow=sd(low)/sqrt(nlow)
med=hiData[hiData[,5] >= 1 & hiData[,5] <= 6,6]
nmed=length(med)
mmed=mean(med)
semed=sd(med)/sqrt(nmed)
hi=hiData[hiData[,5] >= 1,6]
nhi=length(hi)
mhi=mean(hi)
sehi=sd(hi)/sqrt(nhi)
means=c(mlow, mhi)
ses=c(selow,sehi)
p1=t.test(med, low)$p.value
p2=t.test(med, hi)$p.value
p3=t.test(low, hi)$p.value

maxH=34
png(file="barrplot_E14.5mHi_SeqSimilarityVfpkm.png", height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
#plot(hiData[,5], log(hiData[,6],2), xlim=c(0,25), xlab = paste("TRAP affinity", sep = ""), ylab = "E14.5m DNAse-Hi FPKMs", col="red", main=cor(hiData[,5], log(hiData[,6],2)))
centers=barplot(means, names.arg=c("< 1", ">= 1"), col="red", xlab="TRAP affinity", ylim=c(0,maxH+4), ylab="mean RPKM", lwd=magnify)
arrows(centers,means-ses,centers,means+ses,code=3,lwd=magnify,angle=90,length=0.15)
box(lwd=magnify)
axis(1, at=centers, lwd=magnify, lwd.ticks=magnify)
axis(2, lwd.ticks=magnify)
plotPvals(p1,maxH-2,.4,centers[1],centers[2])
plotPvals(p2,maxH,.4,centers[2],centers[3])
plotPvals(p3,maxH+2,.4,centers[1],centers[3])
dev.off()

low=allData[allData[,5] < 1,6]
nlow=length(low)
mlow=mean(low)
selow=sd(low)/sqrt(nlow)
med=allData[allData[,5] >= 1 & allData[,5] <= 6,6]
nmed=length(med)
mmed=mean(med)
semed=sd(med)/sqrt(nmed)
hi=allData[allData[,5] >= 1,6]
nhi=length(hi)
mhi=mean(hi)
sehi=sd(hi)/sqrt(nhi)
means=c(mlow, mhi)
ses=c(selow,sehi)
p1=t.test(med, low)$p.value
p2=t.test(med, hi)$p.value
p3=t.test(low, hi)$p.value
maxH=3.5
png(file="barrplot_E14.5mAll_SeqSimilarityVfpkm.png", height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
centers=barplot(means, names.arg=c("< 1", ">= 1"), col="red", xlab="TRAP affinity", ylim=c(0,maxH+.3), ylab="mean RPKM")
arrows(centers,means-ses,centers,means+ses,code=3,angle=90,length=0.15, lwd=magnify)
box(lwd=magnify)
axis(1, at=centers, lwd=magnify, lwd.ticks=magnify)
axis(2, lwd=magnify, lwd.ticks=magnify)
#title(main=paste("P=", round(p1,2), "; P=", round(p2,2), sep=""))
plotPvals(p1,maxH-.2,.08,centers[1],centers[2])
plotPvals(p2,maxH,.08,centers[2],centers[3])
plotPvals(p3,maxH+.2,.08,centers[1],centers[3])
dev.off()

png(file="histogram_E14.5mHi_sequenceSimilarities.png", height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
hist(hiData[,5], breaks=100, xlab="TRAP affinity", main="")
dev.off()

png(file="histogram_E14.5mAll_sequenceSimilarities.png", height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
hist(allData[,5], breaks=100, xlab="TRAP affinity", main="")
dev.off()
