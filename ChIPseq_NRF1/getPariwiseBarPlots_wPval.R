args=commandArgs(trailingOnly=TRUE)
plotPvals2 = function(p, maxH, asteriskDist, x1, x2)
{
	magnify=2
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


name=as.character(args[1])
x=read.table(as.character(args[2]))
age=as.character(args[3])
percentages = x[,1] / x[,2]

ratios=100*x[,1]/x[,2]
x[,2] = x[,2] - x[,1]
pval = fisher.test(x)$p.value

maxH=max(ratios)
#24
#max(ratios)
png(paste("barplot_", name, "_", age, ".png", sep=""), height = 2000, width = 2000, res=300)
par(lwd=2)
mp=barplot(ratios, ylab="% overlap w IAPs", names.arg=c(name, age), cex.axis=1.3, cex.lab=1.3, cex.names=1.8, ylim=c(0,maxH+4), lwd=2, col="red", beside=T)
plotPvals2(pval,maxH+2,1,mp[1],mp[2])
dev.off()
print(pval)
