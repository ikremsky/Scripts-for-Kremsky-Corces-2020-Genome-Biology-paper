x=read.delim("allExpressedAndSignificantTFs_E14.5m.txt",)
x[,3]=formatC(x[,3], format = "e", digits = 2)
write.table(x,"allExpressedAndSignificantTFs_E14.5m.txt",quote=F, sep="\t", row.names=F)
