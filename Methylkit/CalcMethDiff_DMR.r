library(methylKit)
library(doParallel)

ncores = 4
registerDoParallel(core = ncores)

#load Unite object 
#read the myDiff object as an RDS file
meth_DMR <- readRDS("meth_DMR.rds")


# Perform differential methylation analysis between the treatment groups specified in the 'rrbsobj' object
myDiff_DMR=calculateDiffMeth(meth_DMR, mc.cores = ncores, overdispersion = "MN", effect = "wmean", test = "Chisq", slim = FALSE)


# Save the myDiff object as an RDS file
saveRDS(myDiff_DMR, file = "myDiff_DMR.rds")