library("VennDiagram")
args=commandArgs(trailingOnly=TRUE)
i=1
area1=as.numeric(args[i]); i=i+1
area2=as.numeric(args[i]); i=i+1
cross.area=as.numeric(args[i]); i=i+1
name1=as.character(args[i]); i=i+1
name2=as.character(args[i]); i=i+1
outName=as.character(args[i]); i=i+1

png(outName)
draw.pairwise.venn(area1, area2, cross.area, category=c(name1, name2), main="test", cat.cex=2, cat.just = list(c(.5, .5), c(.5, .5)), cat.dist=c(.02,.02), cat.default.pos="outer", cat.pos=c(0,180), cex=1.5)
dev.off()
