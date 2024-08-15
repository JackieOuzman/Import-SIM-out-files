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

site <-"/Sim_T3"
                          #"X:\Summer_weeds\Validation_data\Birchip_APSIM_7\Sim_T1"
file_directory <- paste0("X:/Summer_weeds/Validation_data/Birchip_APSIM_7",site)

file_directory

################################################################################
list_sim_out_file <-
  list.files(
    path = file_directory,
    pattern = ".out",
    all.files = FALSE,
    full.names = FALSE
  )

list_sim_out_file #160
#list_sim_out_file <- list_sim_out_file[c(1:3)]


## create a empty data frame
#str(all_data)
df_for_all_data <- data.frame(
  
  Year =  character(),
  Date = character(),
  Weed_emergedate = character(),
  Weed_biomass = character(),
  Rain = double(),
  Soil_water_SOWSW = character(),
  Soil_No3_1 = double(),
  Soil_No3_2 = double(),
  Soil_No3_3 = double(),
  Soil_No3_4 = double(),
  Soil_No3_5 = double(),
  Soil_No3_6 = double(),
  Soil_No3_7 = double(),
  Soil_No3_8 = double(),
  Soil_No3_9 = double(),
  Soil_No3_10 = double(),
  Soil_No3_11 = double(), 
  Soil_nh4_1 = double(),
  Soil_nh4_2 = double(),
  Soil_nh4_3 = double(),
  Soil_nh4_4 = double(),
  Soil_nh4_5 = double(),
  Soil_nh4_6 = double(),
  Soil_nh4_7 = double(),
  Soil_nh4_8 = double(),
  Soil_nh4_9 = double(),
  Soil_nh4_10 = double(),
  Soil_nh4_11 = double(),
  Soil_sw_1 = double(),
  Soil_sw_2 = double(),
  Soil_sw_3 =double(),
  Soil_sw_4 = double(),
  Soil_sw_5 = double(),
  Soil_sw_6 = double(),
  Soil_sw_7 = double(),
  Soil_sw_8 = double(),
  Soil_sw_9 = double(),
  Soil_sw_10 = double(),
  Soil_sw_11 = double(),
  
  APSIM_Version     = as.character(),
  factors           = as.character(),
  title             = as.character(),
  days_since_last_cohort  = as.character(),
  weed_type         = as.character(),
  weed_sow_date     = as.character(),
  weed_density      = as.character(),
  weed_type         = as.character()
  
  
  )

### set the heading names for the data you want to import
### heading names for file 2,3,5
heading <- c(
  "Year",
  "Date",
  "Weed_emergedate",
  "Weed_biomass",
  "Rain",
  "Soil_water_SOWSW",
  "Soil_No3_1",
  "Soil_No3_2",
  "Soil_No3_3",
  "Soil_No3_4",
  "Soil_No3_5",
  "Soil_No3_6",
  'Soil_No3_7',
  'Soil_No3_8',
  'Soil_No3_9',
  'Soil_No3_10',
  'Soil_No3_11',
  'Soil_nh4_1',
  'Soil_nh4_2',
  'Soil_nh4_3',
  'Soil_nh4_4',
  'Soil_nh4_5',
  'Soil_nh4_6',
  'Soil_nh4_7',
  'Soil_nh4_8',
  'Soil_nh4_9',
  'Soil_nh4_10',
  'Soil_nh4_11',
  'Soil_sw_1',
  'Soil_sw_2',
  'Soil_sw_3',
  'Soil_sw_4',
  'Soil_sw_5',
  'Soil_sw_6',
  'Soil_sw_7',
  'Soil_sw_8',
  'Soil_sw_9',
  'Soil_sw_10',
  'Soil_sw_11'
  
  
  # "APSIM_Version",
  # "factors",
  # "title",
  # "soil",
  # "weed_type",
  # "weed_sow_date",
  # 'weed_density' ,
  # 'weed_kill' ,
  # 'initial_water',
  # 'days_since_last_cohort'
  )
  
  
list_sim_out_file
## worked example
#list_sim_out_file <- "T1_validation;class=summer_grass;date1=01-Dec;daysLastCohort=20;density=1 pdk output.out"

################################################################################
###############################################################################
##########               As a loop                                    ##########
################################################################################



for (list_sim_out_file in list_sim_out_file){



df <- read_table(paste0(file_directory,"/",
                        list_sim_out_file ), #change this back to list when your ready to run as loop (list_sim_out_file OR file_name
                 col_names = FALSE, skip = 5)


colnames(df)<- heading # add the column headings (as set above - before the loop)

### pull out the simulation infomation so I can create some new clms

version = read.csv(paste0(file_directory,"/",
                          list_sim_out_file), skip = 0, header = F, nrows = 1, as.is = T)

factors = read.csv(paste0(file_directory,"/",
                          list_sim_out_file), skip = 1, header = F, nrows = 1, as.is = T)

title_a = read.csv(paste0(file_directory,"/",
                          list_sim_out_file), skip = 2, header = F, nrows = 1, as.is = T)


### formatting the above information
APSIM_version <- version[1,1]
APSIM_version<-gsub("ApsimVersion = ","",as.character(APSIM_version))

factor = factors[1,1]
factor<-gsub("factors = ","",as.character(factor))

title = title_a[1,1]
title<-gsub("Title = ","",as.character(title))




### split the factors based on ;
factor_split <- str_split_fixed(factors$V1, ';', 4)#change back to 6 for other sites not katanning

###weed_type
weed_type <- factor_split[1]
weed_type<-gsub("factors = class=","",
                as.character(weed_type))

###weed_date
weed_date <- factor_split[2]
weed_date<-gsub("date1=","",
                as.character(weed_date))

###days since last cohort
days_since_last_cohort <- factor_split[3]
days_since_last_cohort<-gsub("density=","",
                   as.character(days_since_last_cohort))

###weed_density
weed_density <- factor_split[4]
weed_density<-gsub("density=","",
                   as.character(weed_density))





### get sim settings into the df
df <- df %>% 
  mutate( APSIM_Version = APSIM_version,
     factors = factor,
     title = title,
     weed_type = weed_type ,
     weed_sow_date = weed_date,
     weed_density = weed_density,
     days_since_last_cohort
     
         )
names(df)


df_for_all_data <- rbind(df_for_all_data, df)




}




#################################################################################
### save the file

### select clms I want
names(df)






## all files on list 1-14400
write.csv(df_for_all_data, paste0(
  "X:/Summer_weeds/Validation_data/Birchip_APSIM_7/Outputs/", 
  site, 
  "_all.csv"), row.names = FALSE)




