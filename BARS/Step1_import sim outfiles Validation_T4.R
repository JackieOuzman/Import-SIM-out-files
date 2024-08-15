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

site <-"/ButeDune"
  
file_directory <- paste0("X:/Summer_weeds/Validation_data/Yvettee_sites",site)

file_directory



################################################################################
list_sim_out_file <-
  list.files(
    path = file_directory,
    pattern = ".out",
    all.files = FALSE,
    full.names = FALSE
  )

list_sim_out_file #12
#list_sim_out_file <- list_sim_out_file[c(1:3)]


## create a empty data frame
#str(all_data)
df_for_all_data <- data.frame(
  
  Date = character(),
  Year =  character(),
  Day_of_year = character(),
  Rain = double(),
  Weed_emergedate = character(),
  Plant_weed_cover = character(),
  Plant_wheat_cover = character(),
  Plant_canola_cover = character(),
  Cover_surface_run_off = character(),
  Plant_weed_cover_ep = character(),
  Plant_wheat_cover_ep= character(),
  Plant_canola_cover_ep = character(),
  ES = character(),
  WeedBiomass = double(),
  WheatBiomass = double(),
  CanolaBiomass=double(),
  WeedBiomass_n = double(),
  WheatBiomass_n = double(),
  CanolaBiomass_n =double(),
  Weed_yield = double(),
  Wheat_yield = double(),
  Canola_yield = double(),
  NO3_1 = double(),
  NO3_2 = double(),
  NO3_3 = double(),
  NO3_4 = double(),
  NO3_5 = double(),
  NH4_1=double(),
  NH4_2=double(),
  NH4_3=double(),
  NH4_4=double(),
  NH4_5=double(),
  SW_1=double(),
  SW_2=double(),
  SW_3=double(),
  SW_4=double(),
  SW_5=double(),
  APSIM_Version     = as.character(),
  Simulation           = as.character()#,
  # title             = as.character(),
  # days_since_last_cohort  = as.character(),
  # weed_type         = as.character(),
  # weed_sow_date     = as.character(),
  # weed_density      = as.character(),
  # weed_type         = as.character()
  
  )

### set the heading names for the data you want to import
### heading names for file 2,3,5
heading <- c(
  "Date",
  "Year",
  "Day_of_year",
  "Rain",
  "Weed_emergedate",
  "Plant_weed_cover",
  "Plant_wheat_cover",
  "Plant_canola_cover",
  "Cover_surface_run_off",
  "Plant_weed_cover_ep",
  "Plant_wheat_cover_ep",
  "Plant_canola_cover_ep",
  "ES",
  "WeedBiomass",
  "WheatBiomass",
  "CanolaBiomass",
  "WeedBiomass_n",
  "WheatBiomass_n",
  "CanolaBiomass_n",
  "Weed_yield",
  "Wheat_yield",
  "Canola_yield",
  "NO3_1",
  "NO3_2",
  "NO3_3",
  "NO3_4",
  "NO3_5",
  "NH4_1",
  "NH4_2",
  "NH4_3",
  "NH4_4",
  "NH4_5",
  "SW_1",
  "SW_2",
  "SW_3",
  "SW_4",
  "SW_5"
 
  
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
#list_sim_out_file <- "ButeDune_dicot_delay 2plants Data.out"
                     #"X:/Summer_weeds/Validation_data/Yvettee_sites/ButeDune/ButeDune_dicot_delay 2plants Data.out"
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

# title = title_a[1,1]
# title<-gsub("Title = ","",as.character(title))




### split the factors based on ;
factor_split <- str_split_fixed(factors$V1, '=', 4)#change back to 6 for other sites not katanning
factor_split <- factor_split[,2]
###weed_type
# weed_type <- factor_split[1]
# weed_type<-gsub("factors = class=","",
#                 as.character(weed_type))

###weed_date
# weed_date <- factor_split[2]
# weed_date<-gsub("date1=","",
#                 as.character(weed_date))

###days since last cohort
# days_since_last_cohort <- factor_split[3]
# days_since_last_cohort<-gsub("density=","",
#                    as.character(days_since_last_cohort))

###weed_density
# weed_density <- factor_split[4]
# weed_density<-gsub("density=","",
#                    as.character(weed_density))





### get sim settings into the df
df <- df %>% 
  mutate( APSIM_Version = APSIM_version,
     Simulation = factor_split#,
     # title = title,
     # weed_type = weed_type ,
     # weed_sow_date = weed_date,
     # weed_density = weed_density,
     # days_since_last_cohort
     
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
  "X:/Summer_weeds/Validation_data/Boorowa_APSIM_7/Outputs/", 
  site, 
  "_all.csv"), row.names = FALSE)




