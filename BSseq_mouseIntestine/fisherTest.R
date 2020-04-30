args=commandArgs(trailingOnly=TRUE)

file=as.character(args[1])
region=as.character(args[2])

x = read.table(file)
percentages = x[,1] / x[,2]
x[,2] = x[,2] - x[,1]
pval = fisher.test(x)$p.value

write.table(data.frame(rbind(paste("region", "count", "uniqu_ratio", "nonunique_ratio", "P-val", sep = "\t"), paste(region, x[1,1], percentages[1], percentages[2], pval, sep = "\t"))), "summary.txt", append=T, quote=F, row.names=F, col.names=F)
