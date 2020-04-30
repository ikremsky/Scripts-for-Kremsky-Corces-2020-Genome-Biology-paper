library(weights)
args=commandArgs(trailingOnly=TRUE)

x=read.delim(as.character(args[1]), header=F)
y=read.delim(as.character(args[2]), header=F)
name=as.character(args[3])
#A=read.delim(as.character(args[4]), header=F)
#B=read.delim(as.character(args[5]), header=F)
#proximal=read.delim(as.character(args[6]), header=F)
#c6=read.delim(as.character(args[7]), header=F)

t=wtd.t.test(x[,1], y[,1], weight=x[,2], weighty=y[,2])
p=t$coefficients[3]
mean1=t$additional[2]
mean2=t$additional[3]
stdErr1=t=wtd.t.test(x[,1], weight=x[,2])$additional[4]
stdErr2=t=wtd.t.test(y[,1], weight=y[,2])$additional[4]
#stdErr3=wtd.t.test(A[,1], weight=A[,2])$additional[4]
#stdErr4=wtd.t.test(B[,1], weight=B[,2])$additional[4]
#t2=wtd.t.test(A[,1], x[,1], weight=A[,2], weighty=x[,2])
#mean3=t2$additional[2]
#mean4=t2$additional[3]
#p2=t2$coefficients[3]

write.table(list(name, mean1, mean2, stdErr1, stdErr2, p), "avgFpkm.txt", append=T, quote=F, sep="\t", row.names=F, col.names=F)
