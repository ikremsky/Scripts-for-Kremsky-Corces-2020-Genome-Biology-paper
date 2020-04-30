args=commandArgs(trailingOnly=TRUE)

name=as.character(args[1])
counts=as.matrix(read.delim(as.character(args[2]), header=F))
name1=as.character(args[3])
name2=as.character(args[4])
i=6
labels= as.character(args[5])
while(i <= length(args))
{
	labels=paste(labels,  as.character(args[i]), sep="_")
	i=i+1
}
tots=counts[,1]+counts[,2]
png(paste("barplot_", "_", name, "_", labels, ".png", sep=""), height = 2000, width = 2000, res=300)
par(lwd=2)
barplot(t(counts), ylab="# of peaks", names.arg=labels, cex.axis=1.5, cex.lab=1.5, cex.names=1.5, legend=c(name1, name2))
dev.off()
print(counts*100/tots)
