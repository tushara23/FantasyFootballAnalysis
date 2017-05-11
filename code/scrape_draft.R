library(dplyr)
library(tidyverse)
library(rvest)
library(XML)
library(stringr)

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

#Owners table

owners <- read.csv("FantasyFootballAnalysis/data/owners.csv")

#Join owners table with all_drafts
all_drafts$team <- as.character(all_drafts$team)
owners$TEAM.NAME <- as.character(owners$TEAM.NAME)

drafts <- all_drafts %>% 
  left_join(owners, by = c("team" = "TEAM.NAME","year" = "YEAR"))

#Fix some discrepancies

rahul <- drafts$team == 'Ceño Fruncido Enmascarado'
brett <- grepl("Reel McCoys",drafts$team)
drafts[rahul,"OWNER.NAME"] <- "Rahul Bhanot"
drafts[brett,"OWNER.NAME"] <- "Brett Hermans"

grouped <- group_by(tblPlayers, posd)
test <- summarize(grouped)

#Add in player IDs
tblPlayers <- nfl_data$player %>% 
  select(player,fname,lname,posd,start,cteam) %>%
  filter(posd == "QB" | posd == "RB" | posd == "SWR" | posd == "LWR" |
           posd == "RWR" | posd == "TE" | posd == "INA") %>% 
  mutate(comma = paste0(lname,",")) %>% 
  mutate(comb_player = paste(fname,lname, sep = " ")) %>% 
  select(-comma)

drafts_new <- drafts %>% 
  separate(name,c("name_new","pos"), ",")


#Join owners table with all_drafts
drafts_new$name_new <- as.character(drafts_new$name_new)
tblPlayers$comb_player <- as.character(tblPlayers$comb_player)


old_name <- c("Beanie Wells","Benjamin Watson","Benjamin Cunningham",
              "Boobie Dixon","Cecil Shorts III","Daniel Herron",
              "Donte Stallworth","Duke Johnson Jr.","EJ Manuel",
              "Mike Sims-Walker","Robert Griffin III","Robert Kelley",
              "Roy E. Williams","Steve Smith Sr.","Stevie Johnson",
              "T.Y. Hilton","Ted Ginn Jr.","Terrelle Pryor Sr.",
              "Will Fuller V")

new_name <- c("Chris Wells","Ben Watson","Benny Cunningham",
              "Kenneth Dixon","Cecil Shorts","Dan Herron",
              "Donte' Stallworth","Duke Johnson","E.J. Manuel",
              "Mike Walker","Robert Griffin","Rob Kelley",
              "Roy Williams","Steve Smith","Steve Johnson",
              "Ty Hilton","Ted Ginn","Terrelle Pryor",
              "Will Fuller")


drafts_new[drafts_new$name_new == "Beanie Wells","name_new"] <- "Chris Wells"
drafts_new[drafts_new$name_new == "Benjamin Watson","name_new"] <- "Ben Watson"
drafts_new[drafts_new$name_new == "Beanie Wells","name_new"] <- "Chris Wells"
drafts_new[drafts_new$name_new == "Beanie Wells","name_new"] <- "Chris Wells"
drafts_new[drafts_new$name_new == "Beanie Wells","name_new"] <- "Chris Wells"
drafts_new[drafts_new$name_new == "Beanie Wells","name_new"] <- "Chris Wells"

cleanup_names <- function(df,dfcol,old_name,dfcol1,new_name){
  df[dfcol == old_name,dfcol1] <- new_name
}

cleanup_names(drafts_new,drafts_new$name_new,"Will Fuller V",
                      "name_new","Will Fuller")

final_drafts <- drafts_new %>% 
  left_join(tblPlayers, by = c("name_new" = "comb_player"))


test <-  final_drafts %>% 
  group_by(name_new,year) %>% 
  filter(n()>1)