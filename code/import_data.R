library(dplyr)
library(tidyverse)

nfl_data_dir <- list.files(path = 'NFL_analysis/data/', full.names = TRUE,
                           pattern = "*.csv")

nfl_data <- lapply(nfl_data_dir, read_csv)

nfl_df_names <- c("block","chart","conv","defense","drive","fgxp","fumble",
                  "game","injury","intercept","kicker","koff","offense",
                  "pass","pbp","penalty","play","player","punt","redzone",
                  "rush","sack","safety","snap","tackle","td","team")

names(nfl_data) <- nfl_df_names


