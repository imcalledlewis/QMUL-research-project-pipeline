library('methylKit')
meth <- readRDS('/data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/RDS_Objects/meth.rds')

betas<- percMethylation(meth, rowids = F)/100

saveRDS(betas, 'betas.rds')
#betas <- readRDS('betas.rds')
head(betas)

DMR <- read.table('/data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/Comb-p/DMR_test_26-05-2023/annotate/Finalfilter/gene_role_DMR_12.tsv', header = TRUE)
# Filter rows where there are no missing values in the "name" column
filtered_df <- DMR[complete.cases(DMR$role), ]

filtered_alu_L1 <- filtered_df[filtered_df$annot.TE_family %in% c("L1", "Alu"), ]
print(filtered_alu_L1)


DMP <- data.frame(readRDS('/data/home/bt22880/WGBS_TE_pipeline/WGBS_methylkit/percMethylation/filtered_myDiff_12.rds'))
head(DMP)

# Splitting match_key column into chromosome start and end columns
match_key_split <- strsplit(filtered_alu_L1$match_key, "[:-]")

# Extracting chromosome, start, and end values
chr <- sapply(match_key_split, function(x) x[1])
start <- sapply(match_key_split, function(x) x[2])
end <- sapply(match_key_split, function(x) x[3])

# Creating a new data frame with separated values
separated_alu_L1 <- data.frame(chr, start, end)
# Remove duplicates based on all columns
separated_alu_L1 <- separated_alu_L1[!duplicated(separated_alu_L1), ]
# Printing the separated data frame
print(separated_alu_L1)
# Calculate center point
center <- as.character((DMP$start + DMP$end) / 2)

# Add center point to the filtered data frame
DMP$center <- center

# Filtering rows within the specified regions
# Create a logical vector to indicate if the center is within the specified regions
within_regions <- DMP$chr %in% separated_alu_L1$chr &
  (as.numeric(center) >= separated_alu_L1$start & as.numeric(center) <= separated_alu_L1$end)

# Filter the DMP data based on the logical vector
DMP <- DMP[within_regions, ]

betas <- as.data.frame(betas)
# Split row names by "." and extract components
row_components <- strsplit(row.names(betas), "\\.")

# Extract "chr", "start", and "end" components
chr <- sapply(row_components, `[`, 1)
start <- sapply(row_components, `[`, 2)
end <- sapply(row_components, `[`, 3)

# Add new columns to the data frame
betas$chr <- chr
betas$start <- start
betas$end <- end

# Create a logical vector to indicate if the center is within the specified regions
within_regions_betas <- betas$chr %in% DMP$chr &
  (betas$start == DMP$start & betas$end == DMP$end)

betas <- betas[within_regions_betas, ]

write.table(
  betas,
  file = "betas_filtered.tsv",
  sep = "\t",
  quote = FALSE,
  col.names = FALSE,
  row.names = FALSE
)