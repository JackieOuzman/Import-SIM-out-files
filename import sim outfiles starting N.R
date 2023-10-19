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
file_directory <- "X:/Summer_weeds/APSIM_7/starting_N_HH"

################################################################################
list_sim_out_file_all <-
  list.files(
    path = file_directory,
    pattern = ".out",
    all.files = FALSE,
    full.names = FALSE
  )
list_sim_out_file_all

list_sim_out_file2_3_5 <-list_sim_out_file_all[c(2, 3, 5)] #because the file have different number of clms
list_sim_out_file2_3_5


list_sim_out_file_1 <-list_sim_out_file_all[1] #because the file have different number of clms
list_sim_out_file_1

list_sim_out_file_4 <-list_sim_out_file_all[4] #because the file have different number of clms
list_sim_out_file_4

# file_name <- list_sim_out_file[1]
#  file_name



df_for_all_data <- data.frame(
  Date = character(),
  biomass           = as.double(),
  yield             = as.double(),
  no3_1             = as.double(),
  no3_2             = as.double(),
  no3_3             = as.double(),
  no3_4             = as.double(),
  no3_5             = as.double(),
  no3_6             = as.double(),
  no3_7             = as.double(),
  no3_8             = as.double(),
  no3_9             = as.double(),
  no3_10             = as.double(),
  no3_11             = as.double(),
  nh4_1             = as.double(),
  nh4_2             = as.double(),
  nh4_3             = as.double(),
  nh4_4             = as.double(),
  nh4_5             = as.double(),
  nh4_6             = as.double(),
  nh4_7             = as.double(),
  nh4_8             = as.double(),
  nh4_9             = as.double(),
  nh4_10            = as.double(),
  nh4_11            = as.double(),
  
  esw               = as.double(),
  no3_all           = as.double(),
  
  APSIM_Version     = as.character(),
  factors           = as.character(),
  title             = as.character(),
  soil              = as.character()
  
  #add more here
)

### set the heading names for the data you want to import
### heading names for file 2,3,5
heading <- c(
  "Date" ,
  "biomass",
  "yield"  ,
  "no3_1"  ,
  "no3_2"  ,
  "no3_3"  ,
  "no3_4"  ,
  "no3_5"  ,
  "no3_6"  ,
  "no3_7"  ,
  "no3_8"  ,
  "no3_9"  ,
  "no3_10" ,
  "no3_11" ,
  "nh4_1"  ,
  "nh4_2"  ,
  "nh4_3"  ,
  "nh4_4"  ,
  "nh4_5"  ,
  "nh4_6"  ,
  "nh4_7"  ,
  "nh4_8"  ,
  'nh4_9'  ,
  "nh4_10" ,
  "nh4_11" ,
  
  
  "esw"    ,
  'no3_all'  #add more here
)


### set the heading names for the data you want to import
### heading names for file 1
heading_1 <- c(
  "Date" ,
  "biomass",
  "yield"  ,
  "no3_1"  ,
  "no3_2"  ,
  "no3_3"  ,
  "no3_4"  ,
  "no3_5"  ,
  "no3_6"  ,
  "no3_7"  ,
  "no3_8"  ,
  "no3_9"  ,
  "no3_10" ,
  #"no3_11" ,
  "nh4_1"  ,
  "nh4_2"  ,
  "nh4_3"  ,
  "nh4_4"  ,
  "nh4_5"  ,
  "nh4_6"  ,
  "nh4_7"  ,
  "nh4_8"  ,
  'nh4_9'  ,
  "nh4_10" ,
  #"nh4_11" ,
  
  
  "esw"    ,
  'no3_all'  #add more here
)


### set the heading names for the data you want to import
### heading names for file 1
heading_4 <- c(
  "Date" ,
  "biomass",
  "yield"  ,
  "no3_1"  ,
  "no3_2"  ,
  "no3_3"  ,
  "no3_4"  ,
  "no3_5"  ,
  "no3_6"  ,
  "no3_7"  ,
  "no3_8"  ,
  "no3_9"  ,
  "no3_10" ,
  "no3_11" ,
  "no3_12" ,
  "nh4_1"  ,
  "nh4_2"  ,
  "nh4_3"  ,
  "nh4_4"  ,
  "nh4_5"  ,
  "nh4_6"  ,
  "nh4_7"  ,
  "nh4_8"  ,
  'nh4_9'  ,
  "nh4_10" ,
  "nh4_11" ,
  "nh4_12" ,
  
  "esw"    ,
  'no3_all'  #add more here
)

################################################################################
###############################################################################
##########               As a loop - When the clm are the same       ##########
################################################################################



for (list_sim_out_file2_3_5 in list_sim_out_file2_3_5){

df <- read_table(paste0(file_directory,"/",
                        list_sim_out_file2_3_5 ), #change this back to list when your ready to run as loop (list_sim_out_file OR file_name
                   col_names = FALSE, skip = 5)
  
colnames(df)<- heading # add the column headings (as set above - before the loop)

### pull out the simulation infomation so I can create some new clms

version = read.csv(paste0(file_directory,"/",
                          list_sim_out_file2_3_5), skip = 0, header = F, nrows = 1, as.is = T)

factors = read.csv(paste0(file_directory,"/",
                          list_sim_out_file2_3_5), skip = 1, header = F, nrows = 1, as.is = T)

title_a = read.csv(paste0(file_directory,"/",
                          list_sim_out_file2_3_5), skip = 2, header = F, nrows = 1, as.is = T)


### formatting the above information
APSIM_version <- version[1,1]
APSIM_version<-gsub("ApsimVersion = ","",as.character(APSIM_version))


soil = factors[1,1]
soil<-gsub("factors = Soil=","",as.character(soil))
### might need to add more here if we have more factors


factor = factors[1,1]
factor<-gsub("factors = ","",as.character(factor))

title = title_a[1,1]
title<-gsub("Title = ","",as.character(title))


### This is where I would add more factors
#class
#date1
#density
#killdoe
#Met
#Soils


### get sim settings into the df
df <- df %>% 
  mutate(APSIM_Version =APSIM_version,
         factors = factor,
         title = title,
         soil = soil
         #add more here if needed
         )
names(df)

#name <- paste0("APSIM","_", 'output")
#assign(name,all_data)

df_for_all_data <- rbind(df_for_all_data, df)
}


#################################################################################



################################################################################
###############################################################################
##########               As a loop - When the clm are the same pale sand       ##########
################################################################################

for (list_sim_out_file_1 in list_sim_out_file_1){
  
  df_1 <- read_table(paste0(file_directory,"/",
                          list_sim_out_file_1 ), #change this back to list when your ready to run as loop (list_sim_out_file OR file_name
                   col_names = FALSE, skip = 5)
  
  
  
  
  colnames(df_1)<- heading_1 # add the column headings (as set above - before the loop)
  
  ### pull out the simulation infomation so I can create some new clms
  
  version = read.csv(paste0(file_directory,"/",
                            list_sim_out_file_1), skip = 0, header = F, nrows = 1, as.is = T)
  
  factors = read.csv(paste0(file_directory,"/",
                            list_sim_out_file_1), skip = 1, header = F, nrows = 1, as.is = T)
  
  title_a = read.csv(paste0(file_directory,"/",
                            list_sim_out_file_1), skip = 2, header = F, nrows = 1, as.is = T)
  
  
  ### formatting the above information
  APSIM_version <- version[1,1]
  APSIM_version<-gsub("ApsimVersion = ","",as.character(APSIM_version))
  
  
  soil = factors[1,1]
  soil<-gsub("factors = Soil=","",as.character(soil))
  ### might need to add more here if we have more factors
  
  
  factor = factors[1,1]
  factor<-gsub("factors = ","",as.character(factor))
  
  title = title_a[1,1]
  title<-gsub("Title = ","",as.character(title))
  
  
  ### This is where I would add more factors
  #class
  #date1
  #density
  #killdoe
  #Met
  #Soils
  
  
  ### get sim settings into the df
  df_1 <- df_1 %>% 
    mutate(APSIM_Version =APSIM_version,
           factors = factor,
           title = title,
           soil = soil
           #add more here if needed
    )
  names(df_1)
  
  #name <- paste0("APSIM","_", 'output")
  #assign(name,all_data)
  
  #df_for_all_data <- rbind(df_for_all_data, df_1)
}


#################################################################################



################################################################################
###############################################################################
##########               As a loop - When the clm are the same pale sand       ##########
################################################################################

for (list_sim_out_file_1 in list_sim_out_file_1){
  
  df_4 <- read_table(paste0(file_directory,"/",
                            list_sim_out_file_4 ), #change this back to list when your ready to run as loop (list_sim_out_file OR file_name
                     col_names = FALSE, skip = 5)
  
  
  
  
  colnames(df_4)<- heading_4 # add the column headings (as set above - before the loop)
  
  ### pull out the simulation infomation so I can create some new clms
  
  version = read.csv(paste0(file_directory,"/",
                            list_sim_out_file_4), skip = 0, header = F, nrows = 1, as.is = T)
  
  factors = read.csv(paste0(file_directory,"/",
                            list_sim_out_file_4), skip = 1, header = F, nrows = 1, as.is = T)
  
  title_a = read.csv(paste0(file_directory,"/",
                            list_sim_out_file_4), skip = 2, header = F, nrows = 1, as.is = T)
  
  
  ### formatting the above information
  APSIM_version <- version[1,1]
  APSIM_version<-gsub("ApsimVersion = ","",as.character(APSIM_version))
  
  
  soil = factors[1,1]
  soil<-gsub("factors = Soil=","",as.character(soil))
  ### might need to add more here if we have more factors
  
  
  factor = factors[1,1]
  factor<-gsub("factors = ","",as.character(factor))
  
  title = title_a[1,1]
  title<-gsub("Title = ","",as.character(title))
  
  
  ### This is where I would add more factors
  #class
  #date1
  #density
  #killdoe
  #Met
  #Soils
  
  
  ### get sim settings into the df
  df_4 <- df_4 %>% 
    mutate(APSIM_Version =APSIM_version,
           factors = factor,
           title = title,
           soil = soil
           #add more here if needed
    )
  
  
  #name <- paste0("APSIM","_", 'output")
  #assign(name,all_data)
  
  #df_for_all_data <- rbind(df_for_all_data, df_4)
}


#################################################################################



### add extra info 
names(df_4)
names(df_for_all_data)
names(df_1)


df_for_all_data <- df_for_all_data %>%  mutate(no3_12 = NA,
                                                           nh4_12 = NA)

df_1 <- df_1 %>%  mutate(no3_11 = NA,
                                                   no3_12 = NA,
                                                   nh4_11 = NA,
                                                   nh4_12 = NA)

df_all <- rbind(df_1, df_for_all_data, df_4) 
#################################################################################
### clean up ####

rm(list=(ls()[ls()!="df_all"]))


#################################################################################
names(df_all)
df_all <- df_all %>% select(
  "APSIM_Version",
  "factors",
  "title" ,
  "soil",
  "Date" ,
  "biomass",
  "yield"  ,
  "no3_1"  ,
  "no3_2"  ,
  "no3_3"  ,
  "no3_4"  ,
  "no3_5"  ,
  "no3_6"  ,
  "no3_7"  ,
  "no3_8"  ,
  "no3_9"  ,
  "no3_10" ,
  "no3_11" ,
  "no3_12" ,
  "nh4_1"  ,
  "nh4_2"  ,
  "nh4_3"  ,
  "nh4_4"  ,
  "nh4_5"  ,
  "nh4_6"  ,
  "nh4_7"  ,
  "nh4_8"  ,
  'nh4_9'  ,
  "nh4_10" ,
  "nh4_11" ,
  "nh4_12" ,
  
  "esw"    ,
  'no3_all'  
)

str(df_all)

#backup <- df_all
#df_all <- backup

df_all$Date <- dmy(df_all$Date)
df_all$year <- format(as.Date(df_all$Date), format = "%Y")









################################################################################
### site  ###########
site <- "CONDOBOLIN"
df_all <- df_all %>% mutate(site = site)
################################################################################
#ensure soil N is getting bigger... or stable or something!


ggplot(df_all, mapping = aes(year, no3_all))+
  geom_point()+
  facet_wrap(.~soil)+
  labs( title = site)+
  theme(axis.text.x = element_text(angle = 90)) 

ggsave(
  device = "png",
  filename = paste0("no3_",   site,".png"),
  path= "X:/Summer_weeds/APSIM_7/starting_N_outputs/plots/",
  width=9.5,
  height = 6.28,
  dpi=600
) 

ggplot(df_all, mapping = aes(year, yield/1000))+
  geom_point()+
  facet_wrap(.~soil)+
  labs( title = site)+
  theme(axis.text.x = element_text(angle = 90)) 

ggsave(
  device = "png",
  filename = paste0("yield",   site,".png"),
  path= "X:/Summer_weeds/APSIM_7/starting_N_outputs/plots/",
  width=9.5,
  height = 6.28,
  dpi=600
) 
### save the file

write.csv(df_all, paste0("X:/Summer_weeds/APSIM_7/starting_N_outputs/all_year/", site, "starting_N_runs.csv"), row.names = FALSE)


df_all_year_1998 <- df_all %>% filter(year == 1998)


write.csv(df_all_year_1998, paste0("X:/Summer_weeds/APSIM_7/starting_N_outputs/final_set/", site, "starting_N_1998.csv"), row.names = FALSE)


