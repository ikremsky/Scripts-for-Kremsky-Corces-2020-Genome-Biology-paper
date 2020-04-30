library("stringdist")
args=commandArgs(trailingOnly=TRUE)

i=1
name=as.character(args[i]); i=i+1
x=read.delim(name, header=F)
seq=as.character(args[i]); i=i+1
TF=as.character(args[i]); i=i+1
type=as.character(args[i]); i=i+1

y=as.character(x[,4])

dist=stringdist(seq,y, method="lv")
write.table(cbind(x,dist), name, quote=F, row.names=F, sep="\t")
write.table(cbind(TF, mean(dist)), paste("sequences/summary_", type, ".txt", sep=""), append=T, quote=F, col.names=F, row.names=F, sep="\t")
