library("VennDiagram")
args=commandArgs(trailingOnly=TRUE)
i=1
area1=as.numeric(args[i]); i=i+1
area2=as.numeric(args[i]); i=i+1
cross.area12=as.numeric(args[i]); i=i+1
name1=as.character(args[i]); i=i+1
name2=as.character(args[i]); i=i+1
outName=as.character(args[i]); i=i+1
area3=as.numeric(args[i]); i=i+1
cross.area13=as.numeric(args[i]); i=i+1
cross.area23=as.numeric(args[i]); i=i+1
name3=as.character(args[i]); i=i+1
cross.area123=as.numeric(args[i]); i=i+1

png(outName, height = 2000, width = 2000, res = 300)
draw.triple.venn(area1, area2, area3, cross.area12, cross.area23, cross.area13, cross.area123, category=c(name1, name2, name3), main="test", cat.cex=2, cat.just = list(c(.5, .5), c(.5, .5), c(.5, .5)), cat.dist=c(.02,.02,.02), cat.default.pos="outer", cat.pos=c(0,180,180), cex=1.5)
dev.off()
