library(dplyr)
library(tidyverse)
library(rvest)
library(XML)


read_draft_tables <- function(x) {
  draft_url <- paste0("http://games.espn.com/ffl/tools/draftrecap?leagueId=285819&seasonId=",x)
  d <- readHTMLTable(draft_url)
  df2 <- d[[2]]
  dfout <- df2[!is.na(df2$V3),]
  colnames(dfout) <- c("pick","name","team")
  dfout$year <- x
  return(dfout)
}

year <- 2008:2016

test <- lapply(year,read_draft_tables)

all_drafts <- rbind(test[[1]],test[[2]],test[[3]],test[[4]],test[[5]],test[[6]],
                    test[[7]],test[[8]],test[[9]])








