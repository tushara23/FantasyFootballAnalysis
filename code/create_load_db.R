library(dplyr)
library(tidyverse)
library(stringr)
#install.packages("RPostgreSQL")
require("RPostgreSQL")

# create a connection
# save the password that we can "hide" it as best as we can by collapsing it
pw <- {
  "ekanaya1"
}

# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")
# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = "NFL",
                 host = "localhost", port = 5432,
                 user = "postgres", password = pw)
rm(pw) # removes the password

# check for the cartable
dbExistsTable(con, "")
# TRUE

write_db <- function(x,y) {
  dbWriteTable(con, x, 
       value = y, append = T, row.names = FALSE)
}

mapply(write_db,nfl_df_names,nfl_data)











