# This file is for importing summer weeds files.
library(tidyverse)
library(dplyr)
library(readr)
library(stringr)
library(lubridate)

#################################################################################
## import data
site <- "Katanning"
df <- read.csv(paste0("X:/Summer_weeds/APSIM_7/WA_sites/output_csv/", site, ".csv"))


names(df)


#################################################################################
### add extra info on the day of emergence
df$Weed_emergedate <- as.numeric(df$Weed_emergedate)

df$origin <- as.Date(paste0(df$year, "-01-01"),tz = "UTC") - days(1)
df <- df %>%
  dplyr::mutate(Weed_emergedate_date =  as.Date(df$Weed_emergedate , origin = df$origin, tz = "UTC"))
df <- df %>%
  mutate(Weed_emergedate_date = case_when(
    Weed_emergedate > 0 ~ Weed_emergedate_date,
    TRUE ~ NA_real_
  ))

df <- df %>%
  mutate(
    Month = month(Weed_emergedate_date),
    DayMonth = format(as.Date(Weed_emergedate_date), "%d-%m"))


df <- df %>%
  mutate(weed_sow_window = case_when(
    Month==12 ~ "Dec",
    Month==1 ~ "Jan",
    Month==2 ~ "Feb",
    Month==3 ~ "March",
    TRUE ~ as.character(NA_real_)
  ))

### tidy up
df <- df %>% 
  select(- origin,
         -Month,              
         -DayMonth )








#################################################################################
### save the file

### select clms I want
names(df)
write.csv(df, paste0("X:/Summer_weeds/APSIM_7/WA_sites/output_csv/", site, "extra_Clm_step2.csv"), row.names = FALSE)






