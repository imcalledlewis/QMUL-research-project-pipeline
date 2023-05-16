library(methylKit)
library(doParallel)

ncores = 4
registerDoParallel(core = ncores)

#load Unite object 
#read the myDiff object as an RDS file
meth <- readRDS("meth.rds")


# Perform differential methylation analysis between the treatment groups specified in the 'rrbsobj' object
# The default method for differential methylation analysis is a chi-squared test (the 'test' argument can be used specify a test)
# The results of the differential methylation analysis are stored in the 'myDiff' object
myDiff <- calculateDiffMeth(meth, mc.cores = ncores, overdispersion = "MN", effect = "wmean", test = "Chisq", slim = FALSE)


# Save the myDiff object as an RDS file
saveRDS(myDiff, file = "myDiff.rds")