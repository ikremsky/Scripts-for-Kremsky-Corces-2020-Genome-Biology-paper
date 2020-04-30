args=commandArgs(trailingOnly=TRUE)

data=read.delim(as.character(args[1]), header=T)
outName=as.character(args[2])
names=colnames(data)

maxes=apply(data, 1, which.max)
maxVals=apply(data, 1, max)
maxVals=formatC(maxVals, format = "e", digits = 2)
maxnames=names[maxes]

write.table(cbind(maxnames,maxVals), paste(outName, sep=""), quote=F, sep="\t", row.names=F, col.name=F)
