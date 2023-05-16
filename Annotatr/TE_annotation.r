# Install required packages
install.packages("annotatr")
install.packages("GenomicRanges")

# Load required libraries
library(annotatr)
library(methylKit)
library(GenomicRanges)
################################# make BED file ####################################
# Load Methylkit object (assuming you have already loaded and processed your data)
myDiff <- read(file = "myDiff")

# get all differentially methylated bases
meth_diff <- getMethylDiff(myDiff,difference=10,qvalue=1, plot=FALSE)

# Save the meth object as an RDS file
saveRDS(meth_diff, file = "meth_diff.rds")

# Extract CpG sites from meth_diff
#cpg_sites <- getMethylBase(meth_diff)

# Create a GRanges object from the CpG sites
#cpg_gr <- GRanges(seqnames = cpg_sites@data$chr,
#                  ranges = IRanges(start = cpg_sites@data$start,
#                                   end = cpg_sites@data$end),
#                  strand = cpg_sites@data$strand)

# Write the GRanges object to a BED file
#bed_file <- "path/to/cpg_sites.bed"
#write.table(as.data.frame(cpg_gr), file = bed_file, quote = FALSE, col.names = FALSE, row.names = FALSE, sep = "\t")
############################### load both BED files ##############################
# Load the CpG sites
#cpg_file <- "path/to/cpg.bed"
#cpg_gr <- read.table(cpg_file, header = FALSE, stringsAsFactors = FALSE)
#cpg_gr <- makeGRangesFromDataFrame(cpg_gr, ignore.strand = TRUE)

# Load the TE BED file
#te_file <- "/data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/hg38.repeatMasker.bed"
#te_gr <- read.table(te_file, header = FALSE, stringsAsFactors = FALSE)
#te_gr <- makeGRangesFromDataFrame(te_gr, ignore.strand = TRUE)

################################### annotation ####################################
# Create custom annotation object
#custom_ann <- Annotation$new()
#custom_ann$add_range_set("TE", te_gr)

# Annotate the CpG sites with TE
#annotated_cpg <- annotate_ranges(cpg_gr, annotations = custom_ann)

# Save the meth object as an RDS file
#saveRDS(annotated_cpg, file = "annotated_cpg.rds")

# Print the annotated CpG sites
#print(annotated_cpg)