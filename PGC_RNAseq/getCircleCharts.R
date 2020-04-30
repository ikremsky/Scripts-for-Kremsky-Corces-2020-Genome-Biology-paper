args=commandArgs(trailingOnly=TRUE)

counts=NULL
cell=NULL
p=NULL
RNAlogFC=NULL
r=1
outName=as.character(args[r]); r=r+1
while(r < length(args))
{
	x=read.delim(as.character(args[r]), header=T); r=r+1
	y=read.delim(as.character(args[r]), header=F); r=r+1
	cell=c(cell, as.character(args[r])); r=r+1
	counts=cbind(counts, x[,2])
	p=cbind(p, x[,5])
	RNAlogFC=cbind(RNAlogFC, y[,2])
}
names=x[,1]
factor=4
plotMax=length(names)
cellNum=length(cell)
myCol <- c(colorRampPalette(c("white", "black"))(100))
myBreaks <- c(seq(0,20,length=301), 1000)
colLen=length(myCol)

r=1
i=1
ys=seq(1,factor*10,length.out=10)
j=10
while(i <= plotMax)
{
	j=min(plotMax, j)
	png(paste(outName, "_", i,".png", sep=""), height = 2000, width = 2000, res = 300)
	par(cex.lab=1.3, cex.axis=1.6, las=2, mar=c(0, 0, 0, 0) + 0.1)
	plot(c(0,0),factor*c(10,10), xlim=c(0,factor*10), ylim=c(0,factor*10),axes=FALSE, plot=FALSE, xlab="", ylab="", col="white")
	text(rep(1,j-i+1),ys[1:(j-i+1)],names[i:j])
	r=1
	while(r <= cellNum)
	{
		size=-log(p[i:j],10)
		size[size < 1.30103]=0
		color=RNAlogFC[i:j]
		color[color > 20]=20
#                color[color < -3.02]=-3.02
		color=color*5
		xs=5*r
		k=1
		while(k <= j-i+1)
		{
			points(xs,ys[k], cex=size[k], pch=19, col=myCol[color[k]])
                        points(xs,ys[k], cex=size[k])
			k=k+1
		}
		r=r+1
	}
	if(i == 1)
	{
		legend(30,15, legend=c("P-val", as.character(c(.001,.0001,.00001))), pt.cex=c(0,-log(c(.001,.0001,.00001),10)), pch=c(21,21,21,21), y.intersp=2, x.intersp=1.5, box.col="white")
	}
	dev.off()
	i=i+10
	j=j+10
	
}
