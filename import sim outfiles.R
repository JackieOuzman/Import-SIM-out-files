# This file is for importing summer weeds files.
library(tidyverse)
library(dplyr)
library(readr)
library(stringr)
library(lubridate)

### create a list of files
### create a list of headers
### put file name into df

#################################################################################
file_directory <- "X:/Summer_weeds/APSIM_7/Testing_v3_soil_water_reset/test_script_import"
#file_directory <- "X:/Summer_weeds/APSIM_7/Factorial_generic_soil"


################################################################################
list_sim_out_file <-
  list.files(
    path = file_directory,
    pattern = ".out",
    all.files = FALSE,
    full.names = FALSE
  )

list_sim_out_file
file_name <- list_sim_out_file[2]
file_name

## create a empty data frame
#str(all_data)
df_for_all_data <- data.frame(
  year = character(),
  Weed_emergedate = character(),
  Weed_biomass    = character(),
  Wheat_yield     = character(),
  APSIM_Version   = character(),
  Sim_name          = character(),
  InitalWater       = character() #add more here
)


# df <- read_table(paste0(file_directory,"/",
#                         file_name), col_names = FALSE)
################################################################################
###############################################################################
##########               As a loop                                    ##########
################################################################################



for (list_sim_out_file in list_sim_out_file){


df <- read_table(paste0(file_directory,"/",
                        list_sim_out_file),
                    col_names = FALSE)



heading <- df[4,]


all_data <- df[6:nrow(df),] #subset the data from the 6 row to end of data frame
colnames(all_data)<- heading # add the column headings (ie row 4 from the original data)

  
### pull out the simulation infomation so I can create some new clms

heading_all <- df[1:5,]
APSIM_version1 <- heading_all[1,3]
APSIM_version2 <- heading_all[1,4]
APSIM_version <- paste0(APSIM_version1,"_", APSIM_version2)
APSIM_version

Sim_name <- heading_all[2,3]
Sim_name <- Sim_name[[1,1]]
str(Sim_name)

InitialWater<-gsub("InitialWater=InitialWater","",as.character(Sim_name))
InitialWater

### This is where I would add 
#class
#date1
#density
#killdoe
#Met
#Soils


### get sim settings into the df
all_data <- all_data %>% 
  mutate(APSIM_Version =APSIM_version,
         Sim_name = Sim_name,
         InitalWater = InitialWater
         #add more here if needed
         )
names(all_data)

#name <- paste0("APSIM","_", 'output")
#assign(name,all_data)

df_for_all_data <- rbind(df_for_all_data, all_data)




}


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






