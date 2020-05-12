library(dplyr)
library(d3heatmap)


dat <- read.csv("./data/sample_data.csv", row.name = 1)

genes      <- unique(rownames(dat))
conditions <- colnames(dat)

selectAll <- "Select All"

choices_genes <- c(selectAll, genes)
choices_conditions <- c(selectAll, conditions)

