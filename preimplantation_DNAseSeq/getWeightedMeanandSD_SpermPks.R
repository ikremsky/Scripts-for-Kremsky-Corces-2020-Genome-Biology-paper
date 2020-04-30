library(weights)
args=commandArgs(trailingOnly=TRUE)

x=read.delim(as.character(args[1]), header=F)
y=read.delim(as.character(args[2]), header=F)
name=as.character(args[3])
A=read.delim(as.character(args[4]), header=F)
B=read.delim(as.character(args[5]), header=F)
c1=read.delim(as.character(args[6]), header=F)
c2=read.delim(as.character(args[7]), header=F)

t=wtd.t.test(x[,1], y[,1], weight=x[,2], weighty=y[,2])
p=t$coefficients[3]
mean1=t$additional[2]
mean2=t$additional[3]
stdErr1=wtd.t.test(x[,1], weight=x[,2])$additional[4]
stdErr2=wtd.t.test(y[,1], weight=y[,2])$additional[4]
stdErr3=wtd.t.test(A[,1], weight=A[,2])$additional[4]
stdErr4=wtd.t.test(B[,1], weight=B[,2])$additional[4]
t2=wtd.t.test(A[,1], B[,1], weight=A[,2], weighty=B[,2])
mean3=t2$additional[2]
mean4=t2$additional[3]
p2=t2$coefficients[3]

t3=wtd.t.test(c1[,1], c2[,1], weight=c1[,2], weighty=c2[,2])
mean5=t3$additional[2]
mean6=t3$additional[3]
stdErr5=wtd.t.test(c1[,1], weight=c1[,2])$additional[4]
stdErr6=wtd.t.test(c2[,1], weight=c2[,2])$additional[4]

write.table(list(name, mean1, mean2, stdErr1, stdErr2, p, mean3, mean4, stdErr3, stdErr4, p2, mean5,mean6,stdErr5,stdErr6), "avgFpkm.txt", append=T, quote=F, sep="\t", row.names=F, col.names=F)
