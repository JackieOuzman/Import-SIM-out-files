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
file_directory_plots <- "X:/Summer_weeds/APSIM_7/starting_N_outputs/final_set/"
                    
list_file_all <-
  list.files(
    path = file_directory_plots,
    pattern = ".csv",
    all.files = FALSE,
    full.names = FALSE
  )
list_file_all


df_1 <- read.csv(paste0(file_directory_plots, "BIRCHIPstarting_N_1998.csv"))
df_2 <- read.csv(paste0(file_directory_plots, "CONDOBOLINstarting_N_1998.csv"))
df_3 <- read.csv(paste0(file_directory_plots, "COOTAMUNDRAstarting_N_1998.csv"))
df_4 <- read.csv(paste0(file_directory_plots, "KATANNINGstarting_N_1998.csv"))
df_5 <- read.csv(paste0(file_directory_plots, "LOXTONstarting_N_1998.csv"))
df_6 <- read.csv(paste0(file_directory_plots, "MECKERINGstarting_N_1998.csv"))
df_7 <- read.csv(paste0(file_directory_plots, "MERREDINstarting_N_1998.csv"))
df_8 <- read.csv(paste0(file_directory_plots, "MERRIWAGGAstarting_N_1998.csv"))
df_9 <- read.csv(paste0(file_directory_plots, "MECKERINGstarting_N_1998.csv"))
df_10 <- read.csv(paste0(file_directory_plots, "ROSEWORTHYstarting_N_1998.csv"))
df_11 <- read.csv(paste0(file_directory_plots, "TEMORAstarting_N_1998.csv"))



all_site <- rbind(df_1,
                  df_2,
                  df_3,
                  df_4,
                  df_5,
                  df_6,
                  df_7,
                  df_8,
                  df_9,
                  df_10,
                  df_11
                  )
names(all_site)

all_site_tidy <- all_site %>% select(
  -APSIM_Version,
  -factors,
  -title,
  -Date,
  -biomass,
  -yield,
  -esw,
  -no3_all, 
  -year)
names(all_site_tidy)

all_site_tidy_no3 <-all_site_tidy %>% select(site, soil,no3_1:no3_12)

all_site_tidy_no3_long <- all_site_tidy_no3 %>% 
  pivot_longer(
    col= no3_1:no3_12,
    values_to = "depth_no3")
all_site_tidy_no3_long$name<-gsub("no3_","",as.character(all_site_tidy_no3_long$name))


all_site_tidy_nh4 <-all_site_tidy %>% select(site, soil,nh4_1:nh4_12)

all_site_tidy_nh4_long <- all_site_tidy_nh4 %>% 
  pivot_longer(
    col= nh4_1:nh4_12,
    values_to = "depth_nh4")
all_site_tidy_nh4_long$name<-gsub("nh4_","",as.character(all_site_tidy_nh4_long$name))




all_site_tidy_long <- left_join(all_site_tidy_no3_long, all_site_tidy_nh4_long)

all_site_tidy_long <- all_site_tidy_long %>% rename(
  depth = name,
  no3 = depth_no3,
  nh4 = depth_nh4)

write.csv(all_site_tidy_long, "X:/Summer_weeds/APSIM_7/starting_N_outputs/final_set/all_sites_starting_N_1998.csv"
          , row.names = FALSE)




