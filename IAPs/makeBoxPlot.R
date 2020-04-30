magnify=2
plotPvals = function(p, maxH, asteriskDist, x1, x2)
{
        if(p < .01 & p >= .001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="*", cex=magnify)
                arrows(x1,maxH,x2,maxH,code=3,angle=90,length=0.05,col="purple", lwd=magnify)
        }
        if(p < .001 & p >= .00001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="**", cex=magnify)
		arrows(x1,maxH,x2,maxH,code=3,angle=90,length=0.05,col="purple", lwd=magnify)
        }
        if(p < .00001 & p >= .0000000001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="***", cex=magnify)
		arrows(x1,maxH,x2,maxH,code=3,angle=90,length=0.05,col="purple", lwd=magnify)
        }
        if(p < .0000000001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="****", cex=magnify)
		arrows(x1,maxH,x2,maxH,code=3,angle=90,length=0.05,col="purple", lwd=magnify)
        }
}

args=commandArgs(trailingOnly=TRUE)
i=1
data1=read.delim(as.character(args[i]), header = F); i=i+1
data2=read.delim(as.character(args[i]), header = F); i=i+1
plotName=as.character(args[i]); i=i+1

p=wilcox.test(data1[,5], data2[,5])$p.value
maxH=2.2

png(file=plotName, height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
#hist(data1[,5], breaks=50)
boxplot(x=list(data1[,5], data2[,5]), names=c("Reprog.", "non-Reprog."), ylim=c(0,maxH+.25), ylab="TRAP affinity", outline=F, lwd=magnify, lwd.tick=magnify)
axis(1, lwd.tick=magnify, at=c(1,2))
axis(2, lwd.tick=magnify)
box(lwd=magnify)
plotPvals(p,maxH,.05,1,2)
dev.off()
