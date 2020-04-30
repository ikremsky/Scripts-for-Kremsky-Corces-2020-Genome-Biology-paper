args=commandArgs(trailingOnly=TRUE)

plotPvals2 = function(p, maxH, asteriskDist, x1, x2)
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


x=read.delim(as.character(args[1]), header=F)
y=read.delim(as.character(args[2]), header=F)
outName=as.character(args[3])
p=wilcox.test(x[,1], y[,1])$p.value
maxH=.5

png(paste(outName, ".png", sep=""), height = 2000, width = 2000, res = 300)
boxplot(x=list(x[,1], y[,1]), names=c("E14.5m DNAse-Hi", "E14.5m DNAse-Lo CpGIs"), ylim=c(0,maxH+.05), ylab="CpG density", outline=F)
#title(sub=paste("P=", round(p,2), sep=""))
plotPvals2(p,maxH,.01,1,2)
dev.off()
