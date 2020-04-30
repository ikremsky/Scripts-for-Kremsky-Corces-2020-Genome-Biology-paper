args=commandArgs(trailingOnly=TRUE)
data = read.delim(as.character(args[1]), header = F)
cellLine = as.character(args[2])

names=data[,1]
ordr=order(data[,2])
sigPoints=c(head(ordr,4)[-c(3,4)], which(data[,1] == "CTCF" | data[,1] == "NRF1"))
sigPoints2=tail(ordr,4)[-c(3)]
ESR1=which(data[,1] == "ESR1")

png(file="scatterplot_accessableinICM.png", height = 2000, width = 2000, res = 300)
par(mar=c(4.8,4.6,1.35,1.2), cex.axis = 2, cex.main=2, cex.sub = 1.8, cex.lab = 2, mgp = c(3,1.1,0), mex = 1.5)
plot(data[,2], data[,3], xlim = c(-.1,1), ylim = c(0,1), xlab = paste("at E13.5-16.5m-accessible motifs", sep = ""), ylab = "at E13.5-16.5m-inaccessible motifs", main = expression(paste(Delta, "me (E16.5m-E13.5m)", sep="")), col="red")
abline(0,1)
points(data[sigPoints,2], data[sigPoints,3], col = "red", pch = 19, cex = 1)
text(data[sigPoints,2], data[sigPoints,3], labels = names[sigPoints], cex = 1.2)
points(data[sigPoints2,2], data[sigPoints2,3], col = "red", pch = 19, cex = 1)
points(data[ESR1,2], data[ESR1,3], col = "red", pch = 19, cex = 1)
text(data[sigPoints2,2], data[sigPoints2,3], labels = names[sigPoints2], cex = 1.2)
dev.off()

