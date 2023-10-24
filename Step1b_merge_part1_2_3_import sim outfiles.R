library(tidyverse)
library(dplyr)
library(readr)
library(stringr)
library(lubridate)


site <- "Katanning"
file_directory <- paste0("X:/Summer_weeds/APSIM_7/WA_sites/output_csv/", site) 

part1 <- load("X:/Summer_weeds/APSIM_7/WA_sites/output_csv/Katanning_part1.RData")
part1 <- df_for_all_data
rm(df_for_all_data)
part2 <- load("X:/Summer_weeds/APSIM_7/WA_sites/output_csv/Katanning_part2.RData")
part2 <- df_for_all_data
rm(df_for_all_data)
part3 <- load("X:/Summer_weeds/APSIM_7/WA_sites/output_csv/Katanning_part3.RData")
part3 <- df_for_all_data
rm(df_for_all_data)


Katanning <-rbind(part1, part2, part3)
write.csv(Katanning, paste0("X:/Summer_weeds/APSIM_7/WA_sites/output_csv/", site, "_all.csv"), row.names = FALSE)
save(Katanning, 
     file = paste0("X:/Summer_weeds/APSIM_7/WA_sites/output_csv/", site, "_all",".RData")) 
