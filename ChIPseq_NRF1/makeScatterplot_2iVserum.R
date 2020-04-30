magnify=2
plotPvals = function(p, maxH)
{
	if(p < .01 & p >= .001)
	{
	        text(mean(centers), maxH+.25, labels="*", cex=magnify)
	        arrows(centers[1],maxH,centers[2],maxH,code=3,lwd=magnify,angle=90,length=0.1,col="purple")
	}
	if(p < .001 & p >= .00001)
	{
	        text(mean(centers), maxH+.25, labels="**", cex=magnify)
	        arrows(centers[1],maxH,centers[2],maxH,code=3,lwd=magnify,angle=90,length=0.1,col="purple")
	}
	if(p < .00001 & p >= .0000000001)
	{
	        text(mean(centers), maxH+.25, labels="***", cex=magnify)
	        arrows(centers[1],maxH,centers[2],maxH,code=3,lwd=magnify,angle=90,length=0.1,col="purple")
	}
	if(p < .0000000001)
	{
	        text(mean(centers), maxH+.25, labels="****", cex=magnify)
	        arrows(centers[1],maxH,centers[2],maxH,code=3,lwd=magnify,angle=90,length=0.1,col="purple")
	}
}

plotPvals2 = function(p, maxH, asteriskDist, x1, x2)
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
allData=read.delim(as.character(args[i]), header = F); i=i+1
name=as.character(args[i]); i=i+1

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

p=t.test(hi, low)$p.value
maxH=5
png(file=paste("barrplot_NRF1ChIPSeq_SimilarityVfpkm_", name, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
box(lwd=magnify)
#plot(hiData[,5], log(hiData[,6],2), xlim=c(0,25), xlab = paste("similarity index", sep = ""), ylab = "E14.5m DNAse-Hi FPKMs", col="red", main=cor(hiData[,5], log(hiData[,6],2)))
centers=barplot(means, names.arg=c("< 1", ">= 1"), col="red", xlab="TRAP affinity", ylim=c(0,maxH+.1), ylab="mean RPKM lost (2i to Serum)")
arrows(centers,means-ses,centers,means+ses,code=3,lwd=magnify,angle=90,length=0.15,lwd=magnify)
plotPvals(p,maxH)
dev.off()

png(file=paste("histogram_NRF1ChIPSeq_sequenceSimilarities_", name, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
hist(allData[,6], breaks=100, xlab="RPKM lost (2i to Serum)", main="")
dev.off()

lost=allData[,6] > 8
maintained=allData[,6] < .5 & allData[,6] > -.5
maxH=.14
p=wilcox.test(allData[lost,5], allData[maintained,5])$p.value
png(file=paste("boxplots_NRF1ChIPSeq_SeqAffinity_", name, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
boxplot(x=list(allData[lost,5], allData[maintained,5]), names=c("lost", "maintained"), ylim=c(0,maxH+.01), ylab="TRAP affinity", outline=F, lwd=magnify)
plotPvals2(p,maxH,.007,1,2)
dev.off()
print(allData[max(allData[,5]),])
