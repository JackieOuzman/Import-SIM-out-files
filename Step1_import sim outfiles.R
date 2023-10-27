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
#site <- "Katanning"
#site <- "Merredin"
#site <- "Meckering"
site <- "Birchip"

file_directory <- paste0("X:/Summer_weeds/APSIM_7/VIC_sites/",site)

file_directory

################################################################################
list_sim_out_file <-
  list.files(
    path = file_directory,
    pattern = ".out",
    all.files = FALSE,
    full.names = FALSE
  )

list_sim_out_file #14400
#list_sim_out_file <- list_sim_out_file[c(1:3)]


## create a empty data frame
#str(all_data)
df_for_all_data <- data.frame(
  year = character(),
  Weed_emergedate = character(),
  Weed_biomass    = character(),
  Wheat_yield     = character(),
  sownNO3_60      = character(),
  sowsw_1         = character(),
  sowsw_2         = character(),
  sowsw_3         = character(),
  sowsw_4         = character(),
  sowsw_5         = character(),
  APSIM_Version     = as.character(),
  factors           = as.character(),
  title             = as.character(),
  soil              = as.character(),
  weed_type         = as.character(),
  weed_sow_date     = as.character(),
  weed_density      = as.character(),
  weed_type         = as.character(),
  weed_kill         = as.character(),
  initial_water     = as.character()
  )

### set the heading names for the data you want to import
### heading names for file 2,3,5
heading <- c(
  "year", 
  "Weed_emergedate",
  "Weed_biomass",
  "Wheat_yield",
  "sownNO3_60",
  "sowsw_1",
  "sowsw_2",
  "sowsw_3",
  "sowsw_4",
  "sowsw_5"#,
  # "APSIM_Version",
  # "factors",
  # "title",
  # "soil",
  # "weed_type",
  # "weed_sow_date",
  # 'weed_density' ,
  # 'weed_kill' ,
  # 'initial_water'
  )
  
  
  
  
  

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
factor_split <- str_split_fixed(factors$V1, ';', 6)#change back to 6 for other sites not katanning

###weed_type
weed_type <- factor_split[1]
weed_type<-gsub("factors = class=","",
                as.character(weed_type))

###weed_date
weed_date <- factor_split[2]
weed_date<-gsub("date1=","",
                as.character(weed_date))

###weed_density
weed_density <- factor_split[3]
weed_density<-gsub("density=","",
                   as.character(weed_density))

###initial_water
initial_water <- factor_split[4]
initial_water<-gsub("InitialWater=IW","",
                    as.character(initial_water))

###weed_kill
weed_kill <- factor_split[5]
weed_kill<-gsub("killdoe=","",
                as.character(weed_kill))

###soil
soil <- factor_split[6] #change back to 6 for other sites not Katanning
soil<-gsub("Soils=","",
           as.character(soil))

### get sim settings into the df
df <- df %>% 
  mutate( APSIM_Version = APSIM_version,
     factors = factor,
     title = title,
     soil = soil,
     weed_type = weed_type ,
     weed_sow_date = weed_date,
     weed_density = weed_density,
     weed_kill = weed_kill,
     initial_water = initial_water
         )
names(df)


df_for_all_data <- rbind(df_for_all_data, df)




}




#################################################################################
### save the file

### select clms I want
names(df)






## all files on list 1-14400
write.csv(df_for_all_data, paste0("X:/Summer_weeds/APSIM_7/VIC_sites/output_csv/", site, "_all.csv"), row.names = FALSE)
save(df_for_all_data, 
     file = paste0("X:/Summer_weeds/APSIM_7/VIC_sites/output_csv/", site, "_all",".RData")) 


