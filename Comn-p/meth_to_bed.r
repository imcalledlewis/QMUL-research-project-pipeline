library(methylKit)

# Read RDS object myDiff
myDiff <- readRDS('/data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/RDS_Objects/myDiff.rds')

# Convert methylDiff object to a data frame
myDiffData <- getData(myDiff)

# Extract the required columns from myDiffData
bedData <- myDiffData[, c("chr", "start", "end", "pvalue", "strand")]


# Write the data to a BED file
write.table(bedData, file = "methDiff.bed", quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)
