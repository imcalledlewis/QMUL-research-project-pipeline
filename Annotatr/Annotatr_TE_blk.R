# Load required libraries
library(methylKit)
library(annotatr)
library(GenomicRanges)

# Load Methylkit object (assuming you have already loaded and processed your data)
#myDiff <- read(file = "/data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/RDS_Objects/myDiff")

# get all differentially methylated bases
#meth_diff <- getMethylDiff(myDiff,difference=10,qvalue=1, plot=FALSE)

# Save the meth object as an RDS file
#saveRDS(meth_diff, file = "meth_diff.rds")

# Read the DMP data from the saved RDS file
meth_diff <- readRDS("meth_diff.rds")
# Convert DMPs to a GRanges object
dmps <- GRanges(seqnames = meth_diff$chr, ranges = IRanges(start = meth_diff$start, end = meth_diff$end))

##############Blacklist regions#############################################################
blacklist_region <- data.frame(read.table(file = "/data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Annotation/hg38-blacklist.v2.bed", header = FALSE, sep = "\t"))
blacklist_complete <- blacklist_region[1:4]
colnames(blacklist_complete) <- c("chr", "start", "end", "reason")
blklst_gr <- makeGRangesFromDataFrame(
  blacklist_complete,
  start.field = "start",
  end.field = "end",
  keep.extra.columns = TRUE
)
# Annotate DMPs with TEs
blklst_annotation <- data.frame(annotate_regions(regions = dmps, annotations = blklst_gr))
head(blklst_annotation) # Inspect the annotated data
# Save the gene annotations as an RDS file
saveRDS(blklst_annotation, file = "blklst_gr.rds")

###########################################TE###############################################
# Load the TE BED file
TEs <- data.frame(read.table(file = "/data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Annotation/hg38.repeatMasker.bed", header = FALSE, sep = "\t")) 
tes_complete <- TEs[, 5:12]
colnames(tes_complete) <- c("chr", "start", "end", "V8", "strand", "TE", "TE_type", "TE_family")

TEs_gr <- makeGRangesFromDataFrame(
  tes_complete,
  start.field = "start",
  end.field = "end",
  keep.extra.columns = TRUE
)

# Annotate DMPs with TEs
TEs_annotation <- data.frame(annotate_regions(regions = dmps, annotations = TEs_gr))
head(TEs_annotation) # Inspect the annotated data

# Save the TE annotations as an RDS file
saveRDS(TEs_annotation, file = "te_annotation.rds")

##########################################GENE##############################################
# Read the file
gene_data <- data.frame(read.table("/data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Annotation/BioMart_hg38_gene_annot.txt", sep=",", header=FALSE, stringsAsFactors=FALSE))
gene_complete <- gene_data[1:6]
# Assign column names
colnames(gene_complete) <- c("gene_id", "gene_name", "start", "end", "chr", "strand")
# Change values in the 'strand' column
gene_complete$strand <- ifelse(gene_complete$strand == 1, "+", ifelse(gene_complete$strand == -1, "-", gene_complete$strand))
# Add "chr" in front of each value in 'col' column
gene_complete$chr <- paste("chr", gene_complete$chr, sep = "")

head(gene_complete)#test

gene_gr <- makeGRangesFromDataFrame(
  gene_complete,
  start.field = "start",
  end.field = "end",
  keep.extra.columns = TRUE
)

# Annotate DMPs with genes
genes_annotation <- data.frame(annotate_regions(regions = dmps, annotations = gene_gr, ignore.strand = TRUE))
head(genes_annotation) # Inspect the annotated data

# Save the gene annotations as an RDS file
saveRDS(genes_annotation, file = "gene_annotation.rds")