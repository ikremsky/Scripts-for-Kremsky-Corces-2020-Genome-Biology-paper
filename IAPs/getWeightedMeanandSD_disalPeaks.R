library(weights)
args=commandArgs(trailingOnly=TRUE)

x=read.delim(as.character(args[1]), header=F)
y=read.delim(as.character(args[2]), header=F)
name=as.character(args[3])
motifName=as.character(args[4])
print(as.character(args[5]))
A=read.delim(as.character(args[5]), header=F)
B=read.delim(as.character(args[6]), header=F)
#C=read.delim(as.character(args[7]), header=F)

accessibleNum=length(x[,1])
inaccessibleNum=length(y[,1])

t=wtd.t.test(x[,1], y[,1], weight=x[,2], weighty=y[,2])
mean1=t$additional[2]
mean2=t$additional[3]

#p=t$coefficients[3]
meth1=round(sum(x[,1]*x[,2]))
unmeth1=round(sum((1-x[,1])*x[,2]))
meth2=round(sum(y[,1]*y[,2]))
unmeth2=round(sum((1-y[,1])*y[,2]))
print(c(meth1, unmeth1, meth2, unmeth2))
p=1
#fisher.test(as.matrix(rbind(c(meth1, unmeth1), c(meth2, unmeth2))))$p.value

#stdErr1=wtd.t.test(x[,1], weight=x[,2])$additional[4]
#stdErr2=wtd.t.test(y[,1], weight=y[,2])$additional[4]
#stdErr3=wtd.t.test(A[,1], weight=A[,2])$additional[4]
#stdErr4=wtd.t.test(B[,1], weight=B[,2])$additional[4]

t2=wtd.t.test(A[,1], B[,1], weight=A[,2], weighty=B[,2])
mean3=t2$additional[2]
mean4=t2$additional[3]
#p2=fisher.test(as.matrix(rbind(c(meth1, unmeth1), c(meth2, unmeth2))))$p.value



write.table(list(name, mean1, mean2, accessibleNum, inaccessibleNum, mean3, mean4), paste("avgme_", motifName, ".txt", sep=""), append=T, quote=F, sep="\t", row.names=F, col.names=F)
