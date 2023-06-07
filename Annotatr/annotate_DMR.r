library(annotatr)
library(GenomicRanges)
library(rtracklayer)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(GenomicFeatures)


###########################################DMR###############################################
# Load the DMR BED file
DMR <- data.frame(read.table(file = "//data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Comb-p/DMR_test_26-05-2023/results/DMR_def.regions-t.bed", header = TRUE, sep = "\t")) 


DMR_gr <- makeGRangesFromDataFrame(
  DMR,
  start.field = "start",
  end.field = "end",
  keep.extra.columns = TRUE
)

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
blklst_annotation <- data.frame(annotate_regions(regions = DMR_gr, annotations = blklst_gr))
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


# Annotate DMRs with TEs
TEs_annotation <- data.frame(annotate_regions(regions = DMR_gr, annotations = TEs_gr))
head(TEs_annotation)
# Save the TE annotations as an RDS file
saveRDS(TEs_annotation, file = "TE_annotation.rds")
##############Basicgene regions#############################################################
gene = c('hg38_cpgs','hg38_basicgenes')
gene_gr = build_annotations(genome = 'hg38', annotations = gene)

# Annotate DMR with genes
genes_annotation <- data.frame(annotate_regions(regions = DMR_gr, annotations = gene_gr, ignore.strand = TRUE))
head(genes_annotation) # Inspect the annotated data
# Save the gene annotations as an RDS file
saveRDS(genes_annotation, file = "gene_annotation.rds")

################################################match_key#############################################################################
blklst_annotation <- readRDS("blklst_gr.rds")
# Create the new column
blklst_annotation$match_key <- paste(blklst_annotation$seqnames, ":", blklst_annotation$start, "-", blklst_annotation$end, sep = "")

te_annotation<- readRDS("TE_annotation.rds")
# Create the new column
te_annotation <- transform(te_annotation, match_key = paste(te_annotation$seqnames, ":", te_annotation$start, "-", te_annotation$end, sep = ""))
head(te_annotation)#test

gene_annotation<- readRDS("gene_annotation.rds")
# Create the new column
gene_annotation <- cbind(gene_annotation, match_key = paste(gene_annotation$seqnames, ":", gene_annotation$start, "-", gene_annotation$end, sep = ""))
head(gene_annotation)

##############################################merge################################################

# Find matching rows
matching_rows <- match(te_annotation$match_key, blklst_annotation$match_key)
# Remove matching rows
TEs_annotation_rm_blklst <- te_annotation[is.na(matching_rows), ]
# Print the updated te_annotation dataframe
#head(TEs_annotation_rm_blklst)

saveRDS(TEs_annotation_rm_blklst, file = "TEs_annotation_rm_blklst.rds")

# Find matching rows in TEs_annotation_rm_blklst
matching_rows <- match(TEs_annotation_rm_blklst$match_key, gene_annotation$match_key)

# Select only the matching rows in TEs_annotation_rm_blklst
matched_TEs_annotation <- TEs_annotation_rm_blklst[!is.na(matching_rows), ]

# Merge the matched_TEs_annotation dataframe with gene_annotation based on match_key
merged_df <- merge(matched_TEs_annotation, gene_annotation, by = "match_key")
#head(merged_df)
names(merged_df)
saveRDS(merged_df, file = "TE_present_in_genes.rds")
selected_columns <- merged_df[, c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 17, 18, 19, 24, 29, 36, 37,38)]

# Remove duplicates
selected_columns <- unique(selected_columns)

# Remove rows with empty columns
selected_columns <- selected_columns[complete.cases(selected_columns), ]
head(selected_columns)
write.table(selected_columns, "DMR_trimmed.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
saveRDS(selected_columns, file = "DMR_trimmed.rds")


# Filter the data based on significance in z_sidak_p.x
filtered_data <- selected_columns[selected_columns$z_sidak_p.x < 0.05, ]

# Specify the file path for the filtered data TSV file
filtered_file_path <- "filtered_DMR.tsv"

# Write the filtered data to a TSV file
write.table(filtered_data, file = filtered_file_path, sep = "\t", quote = FALSE, row.names = FALSE)


