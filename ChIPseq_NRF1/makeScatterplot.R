magnify=2
plotPvals = function(p, maxH)
{
	if(p < .01 & p >= .001)
	{
	        text(mean(centers), maxH+.5, labels="*", cex=magnify)
	        arrows(centers[1],maxH,centers[2],maxH,code=3,lwd=magnify,angle=90,length=0.1,col="purple")
	}
	if(p < .001 & p >= .00001)
	{
	        text(mean(centers), maxH+.5, labels="**", cex=magnify)
	        arrows(centers[1],maxH,centers[2],maxH,code=3,lwd=magnify,angle=90,length=0.1,col="purple")
	}
	if(p < .00001 & p >= .0000000001)
	{
	        text(mean(centers), maxH+.5, labels="***", cex=magnify)
	        arrows(centers[1],maxH,centers[2],maxH,code=3,lwd=magnify,angle=90,length=0.1,col="purple")
	}
	if(p < .0000000001)
	{
	        text(mean(centers), maxH+.5, labels="****", cex=magnify)
	        arrows(centers[1],maxH,centers[2],maxH,code=3,lwd=magnify,angle=90,length=0.1,col="purple")
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
maxH=25
png(file=paste("barplot_NRF1ChIPSeq_SimilarityVfpkm_", name, ".png", sep=""), height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
#plot(hiData[,5], log(hiData[,6],2), xlim=c(0,25), xlab = paste("similarity index", sep = ""), ylab = "E14.5m DNAse-Hi FPKMs", col="red", main=cor(hiData[,5], log(hiData[,6],2)))
centers=barplot(means, names.arg=c("< 1", ">= 1"), col="red", xlab="TRAP affinity", ylim=c(0,maxH+1.5), ylab="mean RPKM", lwd=magnify)
box(lwd=magnify)
axis(1, at=centers, lwd.ticks=magnify)
axis(2, lwd.ticks=magnify)
arrows(centers,means-ses,centers,means+ses,code=3,angle=90,length=0.15, lwd=magnify)
#title(main=paste("P=", formatC(p, format = "e", digits = 2), sep=""))
plotPvals(p,maxH)
dev.off()


png(file="histogram_NRF1ChIPSeq_sequenceSimilarities.png", height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
hist(allData[,5], breaks=100, xlab="TRAP affinity", main="")
dev.off()
