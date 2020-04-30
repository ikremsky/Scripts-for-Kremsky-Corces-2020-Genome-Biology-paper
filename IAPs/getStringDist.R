library("stringdist")
library("stringr")
args=commandArgs(trailingOnly=TRUE)

i=1
name=as.character(args[i]); i=i+1
x=read.delim(as.character(args[i]), header=F); i=i+1
queries=x[,5]

seq=as.character(args[i]); i=i+1
type=name

qlens=str_length(queries)
Tlen=str_length(seq)
diffs=Tlen-qlens

dist=stringdist(queries,seq, method="lv")-diffs

write.table(cbind(x,dist), paste(name, ".txt", sep=""), quote=F, row.names=F, sep="\t", col.names=F)
