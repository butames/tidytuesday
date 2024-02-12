# DuboisChallenge2024 Chart #6 "NEGRO POPULATION OF GEORGIA BY COUNTIES."

library(tidyverse)
library(sf)
library(ggplot2)
library(patchwork)
library(showtext)


# Du Bois font
showtext_auto()
font_add_google("Public Sans", "Public Sans")


# read in data and format it
shpFile <-  sf::read_sf("georgia-1880-county-shapefile")
data <- shpFile %>% 
  mutate(d1880 = 
           case_when(data1880_P == "> 1000" ~ "UNDER 1,000", 
                     data1880_P == "1000 - 2500" ~ "1,000 TO 2,500", 
                     data1880_P == "2500 - 5000" ~ "2,500 TO 5,000", 
                     data1880_P == "5000 - 10000" ~ "5,000 TO 10,000", 
                     data1880_P == "10000 - 15000" ~ "10,000 TO 15,000", 
                     data1880_P == "15000 - 20000" ~ "15,000 TO 20,000", 
                     data1880_P == "20000 - 30000" ~ "BETWEEN 20,000 AND 30,000"
           ),
         d1870 = 
           case_when(`data1870 (` == "> 1000" ~ "UNDER 1,000", 
                     `data1870 (` == "1000 - 2500" ~ "1,000 TO 2,500", 
                     `data1870 (` == "2500 - 5000" ~ "2,500 TO 5,000", 
                     `data1870 (` == "5000 - 10000" ~ "5,000 TO 10,000", 
                     `data1870 (` == "10000 - 15000" ~ "10,000 TO 15,000", 
                     `data1870 (` == "15000 - 20000" ~ "15,000 TO 20,000", 
                     `data1870 (` == "20000 - 30000" ~ "BETWEEN 20,000 AND 30,000"
           )
  )


# 1870 map
plot1870 <- data %>%
  ggplot()+
  geom_sf(aes(fill=d1870), alpha=0.9, color="#2f2e2d")+
  scale_fill_manual(values = c("UNDER 1,000" = "#516456",
                               "1,000 TO 2,500" = "#e8b353",
                               "2,500 TO 5,000" = "#d88b87",
                               "5,000 TO 10,000" = "#d53151",
                               "10,000 TO 15,000" = "#bf9c80",
                               "15,000 TO 20,000" = "#654321", #86614b
                               "BETWEEN 20,000 AND 30,000" = "#35265a"
  ), na.value = "#e3cdbb")+
  coord_sf(crs=4326)+
  xlim(c(86, 76))+
  
  # theme and annotations
  labs(title="NEGRO POPULATION OF GEORGIA BY COUNTIES.")+
  theme_void()+
  theme(
    plot.background = element_rect(fill = "#e2d0be", color="#e2d0be"),
    panel.background = element_rect(fill = "#e2d0be", color="#e2d0be"),
    panel.border = element_blank(),
    legend.position = "none",
    plot.title = element_text(hjust=0.5, margin=margin(t=20)),
    text = element_text(family="Public Sans", face="bold", color="#413528")
    
  )+
  
  #create legend
  annotate("point", y=34.4, x=80.5, size=8, color="#66535e")+
  annotate("point", y=34.4, x=80.5, size=7.5, color="#35265a", alpha=0.9)+
  annotate("text" , y=34.4, x=80.0, size=3.5, label='BETWEEN 20,000 AND 30,000', hjust=0, family="Public Sans", color="#a4917f")+
  annotate("point", y=33.6, x=80.5, size=8, color="#593e26")+
  annotate("point", y=33.6, x=80.5, size=7.5, color="#654321", alpha=0.9)+
  annotate("text" , y=33.6, x=80.0, size=3.5, label="15,000 TO 20,000", hjust=0, family="Public Sans", color="#a4917f")+
  annotate("point", y=32.8, x=80.5, size=8, color="#ad937c")+
  annotate("point", y=32.8, x=80.5, size=7.5, color="#bf9c80", alpha=0.9)+
  annotate("text" , y=32.8, x=80.0, size=3.5, label="10,000 TO 15,000", hjust=0, family="Public Sans", color="#a4917f")+
  annotate("text", x=84.45, y=35.15, label="1870", size=4, fontface="bold", family="Public Sans", color = "#413528")


# 1880 map
plot1880 <- data %>%
  ggplot()+
  geom_sf(aes(fill=d1880), alpha = 0.9, color="#2f2e2d")+
  scale_fill_manual(values = c("UNDER 1,000" = "#516456",
                               "1,000 TO 2,500" = "#e8b353",
                               "2,500 TO 5,000" = "#d88b87",
                               "5,000 TO 10,000" = "#d53151",
                               "10,000 TO 15,000" = "#bf9c80",
                               "15,000 TO 20,000" = "#654321",
                               "BETWEEN 20,000 AND 30,000" = "#35265a"
  ), na.value = "#e3cdbb")+
  coord_sf(crs=4326)+
  xlim(c(91, 81))+
  
  # theme and annotations
  labs(caption = "#DuBoisChallenge2024     \nChart by Luca Picci | @lpicci96.     ")+
  theme_void()+
  theme(
    plot.background = element_rect(fill = "#e2d0be", color="#e2d0be"),
    panel.background = element_rect(fill = "#e2d0be", color="#e2d0be"),
    panel.border = element_blank(),
    legend.position = "none",
    plot.caption = element_text(face="plain", margin = margin(b = 20, t = 10)),
    text = element_text(family="Public Sans", face="bold", color="#413528")
  )+
  
  
  # create legend
  annotate("point", y=34.2, x=90, size=8, color="#99373b")+
  annotate("point", y=34.2, x=90, size=7.5, color="#d53151", alpha=0.9)+ 
  annotate("text" , y=34.2, x= 89.5, size=3.5, label="5,000 TO 10,000", hjust=0, family="Public Sans", color="#a4917f")+
  annotate("point", y=33.4, x=90, size=8, color="#b6887b")+
  annotate("point", y=33.4, x=90, size=7.5, color="#d88b87", alpha=0.9)+
  annotate("text" , y=33.4, x= 89.5, size=3.5, label="2,500 TO 5,000", hjust=0, family="Public Sans", color="#a4917f")+
  annotate("point", y=32.6, x=90, size=8, color="#bf9260")+
  annotate("point", y=32.6, x=90, size=7.5, color="#e8b353", alpha=0.9)+
  annotate("text" , y=32.6, x= 89.5, size=3.5, label="1,000 TO 2,500", hjust=0, family="Public Sans", color="#a4917f")+
  annotate("point", y=31.8, x=90, size=8, color="#41523b")+
  annotate("point", y=31.8, x=90, size=7.5, color="#516456", alpha=0.9)+
  annotate("text" , y=31.8, x= 89.5, size=3.5, label="UNDER 1,000", hjust=0, family="Public Sans", color="#a4917f")+
  annotate("text", x=84.45, y=35.15, label="1880", size=4, fontface="bold", family="Public Sans", color = "#413528")


#combine maps
final_plot <- plot1870 + plot1880 + plot_layout(ncol = 1)
final_plot

Source Github - Luca Picci