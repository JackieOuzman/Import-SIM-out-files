# This file is for importing summer weeds files.
library(tidyverse)
library(dplyr)
library(readr)
library(stringr)

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

test2 <- read_table(paste0(file_directory,"/",
                           "SWeeds;InitialWater=InitialWater5 pdk output.out"),
                    col_names = FALSE)



View(SWeeds_InitialWater_InitialWater5_pdk_output)

  
### split the file into 2 df

heading_all <- test2[1:5,]
APSIM_version <- heading_all[1,3]
APSIM_version

heading <- test2[4,]
heading

all_data <- test2[6:nrow(test2),] #subset the data from the 6 row to end of data frame
colnames(all_data)<- heading # add the column headings (ie row 4 from the original data)



### get some names into the file
all_data <- all_data %>% 
  mutate(APSIM_Version =heading_all[1,3],
         Sim_name = heading_all[2,3])
names(all_data)
# all_data <- all_data %>%
#   rename(APSIM_Version = APSIM_Version$X3,
#          Sim_name = Sim_name$X3 )


head(all_data)          
head(heading_all)

## next step split the sim name into clms

all_data[1,6]

all_data_test <- all_data %>%
  separate(Sim_name, c("chuck", "InititalWater"), ",", remove = FALSE) %>% 
  select(-chuck)
all_data_test 


all_data_test$Sim_name<-gsub("InitialWater=InitialWater","",as.character(all_data_test$Sim_name))
