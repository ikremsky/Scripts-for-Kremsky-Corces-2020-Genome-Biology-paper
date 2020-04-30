args=commandArgs(trailingOnly=TRUE)

name=as.character(args[1])
x=read.table(as.character(args[2]))
name1=as.character(args[3])
name2=as.character(args[4])
percentages = x[,1] / x[,2]

ratios=100*x[,1]/x[,2]
x[,2] = x[,2] - x[,1]
pval = fisher.test(x)$p.value

png(paste("barplot_", "_", name, ".png", sep=""), height = 2000, width = 2000, res=300)
par(lwd=2)
barplot(ratios, ylab="% overlap w motifs at sperm THSSs", names.arg=c("starvation DMRs", "random"), cex.axis=1.5, cex.lab=1.5, cex.names=1.5)
title(main=paste("P=", formatC(pval, format = "e", digits = 2)))
dev.off()
print(pval)
