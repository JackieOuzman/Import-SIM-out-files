# This file is for importing summer weeds files.
library(tidyverse)
library(dplyr)
library(readr)
library(stringr)
library(lubridate)

#################################################################################
## import data
#################################################################################
#site <- "Katanning_reset_water_yes" #Katanning
#site <- "Meckering_reset_water_yes" # "Meckering
#site <- "Merredin_reset_water_yes"# Merredin_reset_water_yes_extra20percN" #"#"Merredin"


#site <- "Katanning_top_up"
#site <-"Meckering_top_up"
#site <-"Merredin_top_up"
#site <- "Birchip/Birchip_top_up"
#site <- "Loxton_top_up"
#site <- "Roseworthy_top_up"
#site <- "Minnipa_top_up"

site <-"Temora_top_up"

df <- read.csv(paste0("X:/Summer_weeds/APSIM_7/NSW_sites/output_csv/", site, "_all.csv"))


names(df)


#################################################################################
### add extra info on the day of emergence
df$Weed_emergedate <- as.numeric(df$Weed_emergedate)

df$origin <- as.Date(paste0(df$year, "-01-01"),tz = "UTC") - days(1)
df <- df %>%
  dplyr::mutate(Weed_emergedate_date =  as.Date(df$Weed_emergedate , origin = df$origin, tz = "UTC"))



df <- df %>%
  mutate(
    Month_weed_emerg = month(Weed_emergedate_date),
    DayMonth_weed_emerg = format(as.Date(Weed_emergedate_date), "%d-%m"))


df <- df %>%
  mutate(Month_weed_emergedate = case_when(
    Month_weed_emerg==12 ~ "Dec",
    Month_weed_emerg==1 ~ "Jan",
    Month_weed_emerg==2 ~ "Feb",
    Month_weed_emerg==3 ~ "Mar",
    TRUE ~ as.character(NA_real_)
  ))

### tidy up
df <- df %>% 
  select(- origin,
         -Month_weed_emerg,              
         -DayMonth_weed_emerg )



head(df)




# remove the zero values

df <- df %>%
  mutate(Month_weed_emergedate = case_when(
    Weed_emergedate > 0 ~  Month_weed_emergedate,
    TRUE ~ NA
  ))

str(df)

df <- df %>%
  mutate(
    Month_start_weed_window = gsub("01-","",as.character(weed_sow_date)))



#### if the start of the sowing window and the weed eme date has the same date then give it the sow window date
str(df)

df <- df %>% 
  mutate(weed_sow_and_emergedate_month = case_when(
    Month_start_weed_window == Month_weed_emergedate ~ Month_start_weed_window,
    TRUE ~ NA
  ))

str(df)

### this is the clm that will get used Month_start_weed_window

#################################################################################
### save the file

### select clms I want
names(df)
write.csv(df, paste0("X:/Summer_weeds/APSIM_7/NSW_sites/output_csv/", site, "extra_Clm_step2.csv"), row.names = FALSE)


unique(df$soil)
unique(df$weed_density)
unique(df$weed_kill)
unique(df$initial_water)

unique(df$weed_sow_date) #open window eg the start of the weed sowing window
unique(df$weed_sow_and_emergedate_month) # only weeds that are emerged in the weed sow month

