library(methylKit)
library(doParallel)

ncores = 4
registerDoParallel(core = ncores)

#load Unite object 
#read the myDiff object as an RDS file
wgbsobj <- readRDS("wgbsobj.rds")

#tilting window for regions 
DMR_tile = tileMethylCounts(wgbsobj,win.size=1000,step.size=1000,cov.bases = 10)

#using the unite() function
meth_DMR <- unite(DMR_tile, min.per.group = 2L, destrand=FALSE, mc.cores=4)

# Save the meth object as an RDS file
saveRDS(meth_DMR , file = "meth_DMR .rds")

