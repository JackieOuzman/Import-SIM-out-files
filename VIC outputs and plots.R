

#install.packages("tidyverse")
library(tidyverse)
#library(tidyr)
library(dplyr)
library(readr)
library(stringr)
library(lubridate)



## import data
site <- "Birchip_top_up"
Birchip <- read.csv(paste0("X:/Summer_weeds/APSIM_7/VIC_sites/output_csv/", "Birchip_top_upextra_Clm_step2.csv"))
Birchip <- Birchip %>% mutate(site = "Birchip")

df <- Birchip


##################################################################################


df_uncontrolled_weeds <- df %>%
  filter(weed_type == "summer_grass") %>%
  # filter(weed_sow_and_emergedate_month == "Feb") %>%
  filter(
    weed_sow_and_emergedate_month == "Dec" |
      weed_sow_and_emergedate_month == "Jan" |
      weed_sow_and_emergedate_month == "Feb" |
      weed_sow_and_emergedate_month == "Mar" 
  ) %>%
  filter(weed_density == 10) %>%
  filter(weed_kill == 200) 


unique(df_uncontrolled_weeds$soil)
unique(df_uncontrolled_weeds$weed_type)
unique(df_uncontrolled_weeds$weed_sow_date)
unique(df_uncontrolled_weeds$weed_density)
unique(df_uncontrolled_weeds$weed_kill)
unique(df_uncontrolled_weeds$initial_water)


df_uncontrolled_weeds_summary <-
  df_uncontrolled_weeds %>%
  group_by(site, soil, initial_water, weed_sow_and_emergedate_month) %>%
  summarise(
    Av_weed_biomass =  mean(Weed_biomass, na.rm = TRUE),
    Av_weed_yield =    mean(Wheat_yield, na.rm = TRUE),
    Av_NO3 =           mean(sownNO3_60, na.rm = TRUE)
  )


df_uncontrolled_weeds_summary <- ungroup(df_uncontrolled_weeds_summary)
df_uncontrolled_weeds_summary <- df_uncontrolled_weeds_summary %>% mutate(grouping = "Uncontrolled")

##################################################################################



df_controlled_weeds <- df %>%
  filter(weed_type == "summer_grass") %>%
  # filter(weed_sow_and_emergedate_month == "Feb") %>%
  filter(
    weed_sow_and_emergedate_month == "Dec" |
      weed_sow_and_emergedate_month == "Jan" |
      weed_sow_and_emergedate_month == "Feb" |
      weed_sow_and_emergedate_month == "Mar" 
  ) %>%
  filter(weed_density == 10) %>%
  filter(weed_kill == 10) 

df_controlled_weeds_summary <-
  df_controlled_weeds %>%
  group_by(site,soil, initial_water, weed_sow_and_emergedate_month) %>%
  summarise(
    Av_weed_biomass =  mean(Weed_biomass, na.rm = TRUE),
    Av_weed_yield =    mean(Wheat_yield, na.rm = TRUE),
    Av_NO3 =           mean(sownNO3_60, na.rm = TRUE)
  )


df_controlled_weeds_summary <- ungroup(df_controlled_weeds_summary)
df_controlled_weeds_summary <- df_controlled_weeds_summary %>% mutate(grouping = "Controlled")

#################################################################################

df_weeds_summary <- rbind(df_controlled_weeds_summary, df_uncontrolled_weeds_summary)
names(df_weeds_summary)

df_weeds_summary$soil <- factor(df_weeds_summary$soil, levels = c("PaleSand", "Loam", "ClayLoam", "Clay", "Duplex"))
df_weeds_summary$grouping <- factor(df_weeds_summary$grouping, levels = c("Uncontrolled", "Controlled"))


################################################################################
Biomass_max <- max(df_weeds_summary$Av_weed_biomass)
Biomass_min <- min(df_weeds_summary$Av_weed_biomass)

Yld_max <- max(df_weeds_summary$Av_weed_yield)
Yld_min <- min(df_weeds_summary$Av_weed_yield)

NO3_max <- max(df_weeds_summary$Av_NO3)
NO3_min <- min(df_weeds_summary$Av_NO3)

################################################################################
### Biomass
df_weeds_summary %>% 
  filter(site == "Birchip") %>% 
  #filter(grouping == "Controlled") %>% 
  ggplot( aes(x=as.factor(initial_water), y = Av_weed_biomass, colour = as.factor(weed_sow_and_emergedate_month)))+
  geom_point()+
  #ylim(Biomass_min, Biomass_max)+
  facet_grid(grouping~soil)+
  theme_bw()+
  labs(title = "Birchip",
       #subtitle = "Weed type  = summer_grass,  \nweed density = 12, weed kill = 200",
       x= "inital water", y = "weed biomass kg/ha",
       colour = "Weed window")+
  theme(
    axis.text.x = element_text(angle = 90),
    legend.position = "bottom",
    plot.title = element_text(color="black", size=14, face="bold"))

ggsave(
  device = "png",
  filename = "Birchip_Biomass.png",
  path= "X:/Summer_weeds/APSIM_7/VIC_sites/plots/",
  width=8.62,
  height = 6.28,
  dpi=600
)



################################################################################
### Yield
df_weeds_summary %>% 
  filter(site == "Birchip") %>%
  ggplot( aes(x=as.factor(initial_water), y = Av_weed_yield, colour = as.factor(weed_sow_and_emergedate_month)))+
  geom_point()+
  ylim(Yld_min, Yld_max)+
  facet_grid(grouping~soil)+
  theme_bw()+
  labs(title = "Birchip",
       x= "inital water", y = "wheat yield kg/ha",
       colour = "Weed window")+
  theme(
    axis.text.x = element_text(angle = 90),
    legend.position = "bottom",
    plot.title = element_text(color="black", size=14, face="bold"))

ggsave(
  device = "png",
  filename = "Birchip_Yld.png",
  path= "X:/Summer_weeds/APSIM_7/VIC_sites/plots/",
  width=8.62,
  height = 6.28,
  dpi=600
)


################################################################################


### SownNO3  
df_weeds_summary %>% 
  filter(site == "Birchip") %>%
  ggplot( aes(x=as.factor(initial_water), y = Av_NO3, colour = as.factor(weed_sow_and_emergedate_month)))+
  geom_point()+
  ylim(NO3_min, NO3_max)+
  facet_grid(grouping~soil)+
  theme_bw()+
  labs(title = "Birchip",
        x= "inital water", y = "No3 top 60cm kg/ha",
       colour = "Weed window")+
  theme(
    axis.text.x = element_text(angle = 90),
    legend.position = "bottom",
    plot.title = element_text(color="black", size=14, face="bold"))

ggsave(
  device = "png",
  filename = "Birchip_NO3.png",
  path= "X:/Summer_weeds/APSIM_7/VIC_sites/plots/",
  width=8.62,
  height = 6.28,
  dpi=600
)




################################################################################
## controlled biomass plots only


### Biomass
df_weeds_summary %>% 
  #filter(site == "Birchip") %>% 
  filter(grouping == "Controlled") %>% 
  ggplot( aes(x=as.factor(initial_water), y = Av_weed_biomass, colour = as.factor(weed_sow_and_emergedate_month)))+
  geom_point()+
  #ylim(Biomass_min, Biomass_max)+
  facet_grid(site~soil)+
  theme_bw()+
  labs(title = "Controlled only",
       #subtitle = "Weed type  = summer_grass,  \nweed density = 12, weed kill = 200",
       x= "inital water", y = "weed biomass kg/ha",
       colour = "Weed window")+
  theme(
    axis.text.x = element_text(angle = 90),
    legend.position = "bottom",
    plot.title = element_text(color="black", size=14, face="bold"))

ggsave(
  device = "png",
  filename = "site_Biomass_controlled.png",
  path= "X:/Summer_weeds/APSIM_7/VIC_sites/plots/",
  width=8.62,
  height = 6.28,
  dpi=600
)




#################################################################################
### differences in yield #######################################################

str(df_uncontrolled_weeds_summary)
str(df_controlled_weeds_summary)


yld_diff_uncontrolled_step1 <- df_uncontrolled_weeds_summary %>% 
  select(- Av_weed_biomass,- Av_NO3, -grouping) %>% 
  rename(Av_weed_yield_uncontrolled = Av_weed_yield )

yld_diff_controlled_step1 <- df_controlled_weeds_summary %>% 
  select(- Av_weed_biomass,- Av_NO3, -grouping) %>% 
  rename(Av_weed_yield_controlled = Av_weed_yield )

str(yld_diff_uncontrolled_step1)
str(yld_diff_controlled_step1)

##clm to join
yld_diff_uncontrolled_step1 <- yld_diff_uncontrolled_step1 %>% 
  mutate(for_join = paste0(site,"_", soil, "_", initial_water,"_",weed_sow_and_emergedate_month))
yld_diff_controlled_step1 <- yld_diff_controlled_step1 %>% 
  mutate(for_join = paste0(site,"_", soil, "_", initial_water,"_",weed_sow_and_emergedate_month))

yld_diff_df <- left_join( yld_diff_uncontrolled_step1, yld_diff_controlled_step1,)


yld_diff_df <- yld_diff_df %>% mutate(Yld_diff =(Av_weed_yield_controlled -Av_weed_yield_uncontrolled)/1000) 
  
yld_diff_df$Yld_diff <- round(yld_diff_df$Yld_diff, digits = 2)


yld_diff_df$soil <- factor(yld_diff_df$soil, levels = c("PaleSand", "Loam", "ClayLoam", "Clay", "Duplex"))

yld_diff_df %>% 
  ggplot( aes(x=as.factor(initial_water), y = Yld_diff, colour = as.factor(weed_sow_and_emergedate_month)))+
  geom_point()+
  facet_grid(site~soil)+
  theme_bw()+
  labs(title = "Yield difference",
        x= "inital water", y = "Yield differnce t/ha",
       colour = "Weed window")+
  theme(
    axis.text.x = element_text(angle = 90),
    legend.position = "bottom",
    plot.title = element_text(color="black", size=14, face="bold"))

ggsave(
  device = "png",
  filename = "yld_diff.png",
  path= "X:/Summer_weeds/APSIM_7/VIC_sites/plots/",
  width=8.62,
  height = 6.28,
  dpi=600
)
