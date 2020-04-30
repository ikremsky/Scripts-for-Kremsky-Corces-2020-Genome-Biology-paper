fname <- commandArgs(T)

zip.fname <- paste(fname, 'zip', sep='.')
heatmap.dat <- file.path(fname, 'heatmap.RData')
load(unz(zip.fname, heatmap.dat))
gene.list <- strsplit(as.character(go.list[[1]]), ',')
gname.list <- sapply(gene.list, function(x) x)
write.table(gname.list, file=paste(fname, 'gname.txt', sep='.'),
            col.names=F, row.names=F, quote=F)


