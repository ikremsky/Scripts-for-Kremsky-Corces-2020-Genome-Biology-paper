args=commandArgs(trailingOnly=TRUE)

data=read.delim("NRF1_highestAffinities.bed", header=T)
#read.delim(as.character(args[1]), header=F)
outName="NRF1_highestAffinities.forigv.bed"
#as.character(args[2])
data[,4]=formatC(data[,5], format = "e", digits = 2)

write.table(data[,1:4], paste(outName, sep=""), quote=F, sep="\t", row.names=F, col.name=F)
