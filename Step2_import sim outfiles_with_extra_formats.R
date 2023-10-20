# This file is for importing summer weeds files.
library(tidyverse)
library(dplyr)
library(readr)
library(stringr)
library(lubridate)




#################################################################################
### add extra info on the day of emergence
df_for_all_data$Weed_emergedate <- as.numeric(df_for_all_data$Weed_emergedate)

df_for_all_data$origin <- as.Date(paste0(df_for_all_data$year, "-01-01"),tz = "UTC") - days(1)
df_for_all_data <- df_for_all_data %>%
  mutate(Weed_emergedate_date =  as.Date(df_for_all_data$Weed_emergedate , origin = df_for_all_data$origin, tz = "UTC"))
df_for_all_data <- df_for_all_data %>%
  mutate(Weed_emergedate_date = case_when(
    Weed_emergedate > 0 ~ Weed_emergedate_date,
    TRUE ~ NA_real_
  ))

df_for_all_data <- df_for_all_data %>%
  mutate(#Day = day(Weed_emergedate_date),
    Month = month(Weed_emergedate_date),
    DayMonth = format(as.Date(Weed_emergedate_date), "%d-%m"))


df_for_all_data <- df_for_all_data %>%
  mutate(weed_sow_window = case_when(
    Month==12 ~ "Dec",
    Month==1 ~ "Jan",
    Month==2 ~ "Feb",
    Month==3 ~ "March",
    TRUE ~ as.character(NA_real_)
  ))


#################################################################################
### save the file

### select clms I want
names(df_for_all_data)

df_for_all_data <- df_for_all_data %>% 
  select(- origin,
         -Month,              
         -DayMonth )


write.csv(df_for_all_data, paste0(file_directory, "/merged/merge_sim_output.csv"), row.names = FALSE)






