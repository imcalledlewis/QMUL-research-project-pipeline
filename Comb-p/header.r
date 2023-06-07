# Read the TSV file without headers
data <- read.table("sort_methDiff.bed", sep = "\t", header = FALSE)

# Add column headers
colnames(data) <- c("chrom", "start", "end", "P.value", "strand")

# Write the data with headers to a new TSV file
write.table(data, file = "sort_methDiff.bed", sep = "\t", quote = FALSE, row.names = FALSE)
