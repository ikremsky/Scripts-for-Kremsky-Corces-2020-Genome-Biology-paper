library("qvalue")
PCutoff=.05
args=commandArgs(trailingOnly=TRUE)

x=read.delim(as.character(args[1]), header=T)
outName=as.character(args[2])
type=as.character(args[3])
cell=as.character(args[4])

names=x[,1]
n=1:length(names)
counts=x[,2]
avg1=x[,3]
avg2=x[,4]
p=x[,5]
Porder=order(p)
#q=qvalue(p)$qvalues
#counts=counts*100/sum(counts)
logFC=log((avg1+.01)/(avg2+.01), 2)
avg1=avg1*100
avg2=avg2*100
sigvals=which(p < PCutoff)
topSigvals=head(Porder, n=10)

write.table(data.frame(name=names[sigvals], logFC=logFC[sigvals], Pval=p[sigvals]), paste("Table_", outName, ".txt", sep=""), quote=F, sep="\t", row.names=F)
write.table(data.frame(name=names[topSigvals], logFC=logFC[topSigvals], Pval=p[topSigvals]), paste("Table_", outName, ".Psorted.txt", sep=""), quote=F, sep="\t", row.names=F)
