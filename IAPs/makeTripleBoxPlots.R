plotPvals = function(p, maxH, asteriskDist, x1, x2)
{
        if(p < .01 & p >= .001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="*")
                arrows(x1,maxH,x2,maxH,code=3,lwd=1,angle=90,length=0.05,col="purple")
        }
        if(p < .001 & p >= .00001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="**")
		arrows(x1,maxH,x2,maxH,code=3,lwd=1,angle=90,length=0.05,col="purple")
        }
        if(p < .00001 & p >= .0000000001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="***")
		arrows(x1,maxH,x2,maxH,code=3,lwd=1,angle=90,length=0.05,col="purple")
        }
        if(p < .0000000001)
        {
                text(mean(c(x1,x2)), maxH+asteriskDist, labels="****")
		arrows(x1,maxH,x2,maxH,code=3,lwd=1,angle=90,length=0.05,col="purple")
        }
}

args=commandArgs(trailingOnly=TRUE)
i=1
data1=read.delim(as.character(args[i]), header = F); i=i+1
data2=read.delim(as.character(args[i]), header = F); i=i+1
data3=read.delim(as.character(args[i]), header = F); i=i+1
plotName=as.character(args[i]); i=i+1

p1=wilcox.test(data1[,5], data2[,5])$p.value
p2=wilcox.test(data2[,5], data3[,5])$p.value
p3=wilcox.test(data1[,5], data3[,5])$p.value
maxH=3

png(file=plotName, height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
#hist(data1[,5], breaks=50)
boxplot(x=list(data1[,5], data2[,5], data3[,5]), names=c("youngest", "mid", "oldest"), ylim=c(0,maxH+.25), ylab="TRAP affinity", outline=F)
plotPvals(p1,maxH,.025,1,2)
plotPvals(p2,maxH+.1,.025,2,3)
plotPvals(p3,maxH+.2,.025,1,3)
dev.off()
