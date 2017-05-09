library(dplyr)
library(tidyverse)

#Passing, rushing, receiving bonuses
gid_pid <- nfl_data$play %>% 
  select(gid,pid)

rush_bonus <- nfl_data$td %>% 
  filter(type == "RUSH", yds > 40) %>% 
  mutate(rush_bonus = 1) %>% 
  left_join(gid_pid, by = "pid") %>% 
  group_by(gid,player) %>% 
  summarize(rush_bonus = sum(rush_bonus))

rec_bonus <- nfl_data$td %>% 
  filter(type == "REC", yds > 40) %>% 
  mutate(rec_bonus = 1) %>% 
  left_join(gid_pid, by = "pid") %>% 
  group_by(gid,player) %>% 
  summarize(rec_bonus = sum(rec_bonus))

pass_bonus <- nfl_data$td %>% 
  filter(type == "REC", yds > 40) %>% 
  mutate(rec_bonus = 1) %>% 
  left_join(gid_pid, by = "pid") %>%  
  left_join(nfl_data$pass, by = "pid") %>%
  rename(pass_bonus = rec_bonus) %>% 
  group_by(gid,psr) %>% 
  summarize(pass_bonus = sum(pass_bonus))

#Kick return yards
kr2 <- nfl_data$koff[!is.na (nfl_data$koff$kr), 1:7] %>% 
  select(pid,kr,kry) %>% 
  left_join(gid_pid, by = "pid") %>% 
  select(gid,pid,kr,kry) %>% 
  group_by(gid,kr) %>% 
  summarize(kry = sum(kry))
  
#punt return yards
punt2 <- nfl_data$punt[!is.na (nfl_data$punt$pr), 1:7] %>% 
  select(pid,pr,pry) %>% 
  left_join(gid_pid, by = "pid") %>% 
  select(gid,pid,pr,pry) %>% 
  group_by(gid,pr) %>% 
  summarize(pry = sum(pry))

# Convert all NAs to 0s so fantasy points can be calculated
na.zero <- function (x) {
  x[is.na(x)] <- 0
  return(x)
}

offense2 <- nfl_data$offense %>% 
  left_join(rush_bonus, by = c("gid","player")) %>% 
  left_join(rec_bonus, by = c("gid","player")) %>%
  left_join(pass_bonus, by = c("gid","player" = "psr")) %>% 
  left_join(kr2, by = c("gid","player" ="kr")) %>% 
  left_join(punt2, by = c("gid","player" ="pr")) %>%
  
offense2[is.na(offense2)] <- 0
  
offense3 <- offense2 %>% 
  mutate(fp_espn = (py/25) + tdp*4 + conv*2 + ry/10 + recy/10 + tdrec*6 + 
         tdr*6 + ints*-2 + tdret*6 + rush_bonus + rec_bonus + pass_bonus +
         kry/25 + pry*0.1)










