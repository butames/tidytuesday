# -----------------------------------------------------------
# Author:   Seyram A. Butame
# Email:    butames@gmail.com
# Date:     2024-02-07
# Purpose:  Create a Choropleth map of Georgia for WEB DuBois Challenge
# -----------------------------------------------------------

# LIBRARY -----------------------------------------------------------

library(sf)
library(tidyverse)
library(patchwork)
library(camcorder)
library(showtext)
library(janitor)
library(ggtext)
library(glue)

# LOAD DATA -----------------------------------------------------------

# Population Data
df1 <- read_csv("data/data1870.csv") %>%
  clean_names()
df2  <- read_csv("data/data1880.csv") %>%
  clean_names() 


# Shapefile

gashp <- st_read("data/georgia-1880-county-shapefile/DuBoisChallenge - Georgia Counties w 1870 & 1880 data.shp") %>%
  clean_names()



# DEFINE COLORS -----------------------------------------------------------



colorsa <- c("#392859", "#BE9C80", "#6B442C")

colorsb <- c("#CD2A4A", "#E09991", "#E9B455", "#566859")

backgrd <- "#e4cfbd"
textcl <- "#3e2b22"

# ADD FONTS ----------------------------------------------------------------
font_add_google(name = "Exo 2", family = "Exo 2")
font <- "Exo 2"

font_add_google(name = "Overpass", family = "Overpass")
font_s <- "Overpass"

# TURN ON SHOWTEXT --------------------------------------------------------
showtext_auto()
showtext_opts(dpi = 320)

#Libre Franklin
# Advent Pro
#SAira
#Exo 2

# DATA WRANGLING ----------------------------------------------------------- 

# data wrangling was not necessary. I just renamed the dataframe from gashp to df3, so I would not corrupt the shapefile.

df3 <- gashp
  

# PLOT MAP ----------------------------------------------------------- 


plt1 <- df3 %>%
  ggplot()+
  geom_sf(aes(geometry = geometry,
              fill = data1870),
          show.legend = F,
          color="#3e2b22",alpha = 0.9,
          linewidth = 0.1) +
  scale_fill_manual(values = c("> 1000" = "#566859",
                               "1000 - 2500" = "#E9B455",
                               "2500 - 5000" = "#E09991",
                               "5000 - 10000" = "#CD2A4A",
                               "10000 - 15000" = "#BE9C80",
                               "15000 - 20000" = "#6B442C",
                               "20000 - 30000" = "#392859"), na.value = "#e4cfbd") +
  annotate("text", x = -84.45, y = 35.1,
           label = "1870",
           size = 3.5,color="#3e2b22",
           fontface = "bold",
           family =  font ) +
  coord_sf(crs=4326, clip = "off")+
  ggthemes::theme_map()+
  theme(plot.background = element_rect(color="#e4cfbd",fill="#e4cfbd"),
        panel.background = element_rect(color="#e4cfbd",fill="#e4cfbd"))

plt1


plt2 <- df3 %>%
  ggplot()+
  geom_sf(aes(geometry = geometry,
              fill = data1880_p),
          show.legend = F,
          color="#3e2b22",alpha=0.9,
          linewidth=0.1) +
  scale_fill_manual(values = c("> 1000" = "#566859",
                               "1000 - 2500" = "#E9B455",
                               "2500 - 5000" = "#E09991",
                               "5000 - 10000" = "#CD2A4A",
                               "10000 - 15000" = "#BE9C80",
                               "15000 - 20000" = "#6B442C",
                               "20000 - 30000" = "#392859"), na.value = "#e4cfbd")  +
  annotate("text", x = -84.45, y = 35.1,
           label = "1880",
           size = 3.5, color="#3e2b22",
           fontface = "bold",
           family =  font ) +
  coord_sf(crs = 4326, clip = "off")+
  ggthemes::theme_map()+
  theme(plot.background = element_rect(color="#e4cfbd",fill="#e4cfbd"),
        panel.background = element_rect(color="#e4cfbd",fill="#e4cfbd"))

plt2


plt1 + ggplot() + ggplot()+ plt2 + plot_layout(ncol = 2,nrow = 2)


# CREATE LEGEND  ----------------------------------------------------------- 
# There are two legends in the WEB Dubois plate
# I wondered how to split up the legend the way it is done on the original plate
# But you can simply create the legend separately and paste it to 

lg1 <- tibble(x = 0,
              y = c(1,2,3),
              label = c("BETWEEN 20,000 AND 30,000",
                        "15,000 TO 20,000",
                        "10,000 TO 15,000")) 

lg2 <- tibble(x = 0,
              y = c(4,3,2,1),
              label = c("5,000 TO 10,000",
                        "2,500 TO 5,000",
                        "1000 TO 2,500",
                        "UNDER 1,000"))

# PLOT LEGENDS ----------------------------------------------------------- 
# There are two legends in the WEB Dubois plate.

plt3 <- lg1 %>%
  ggplot(aes(x, y)) +
  geom_point(aes(fill = label),
             shape = 21,
             stroke = 0.1,
             size = 8.5,
             show.legend = FALSE)+
  scale_fill_manual(values = colorsa, 
                    breaks = c("10,000 TO 15,000",
                               "15,000 TO 20,000",
                               "BETWEEN 20,000 AND 30,000")) +
  coord_cartesian(xlim = c(-0.2, 7),
                  ylim = c(-1, 4)) +
  annotate("text", x = 1.25, y = 3, label = "BETWEEN 20,000 AND 30,000", family = font, size = 3, color="#3e2b22", hjust = 0) +
  annotate("text", x = 1.25, y = 2, label = "15,000 TO 20,000", family = font, size = 3, color="#3e2b22", hjust = 0) +
  annotate("text", x = 1.25, y = 1, label = "10,000 TO 15,000", family = font, size = 3, color="#3e2b22", hjust = 0) +
  theme_void() +
  theme(plot.background = element_rect(color = backgrd, fill = backgrd),
        panel.background = element_rect(color= backgrd, fill = backgrd))
plt3

plt4 <- lg2 %>%
  ggplot(aes(x, y)) +
  geom_point(aes(fill = label),
             shape = 21,
             stroke = 0.1,
             size = 8.5,
             show.legend = FALSE)+
  scale_fill_manual(values = colorsb, 
                    breaks = c("5,000 TO 10,000",
                               "2,500 TO 5,000",
                               "1000 TO 2,500",
                               "UNDER 1,000")) +
  coord_cartesian(xlim = c(-0.2, 1),
                  ylim = c(0, 5)) +
  annotate("text", x = 0.15, y = 4, label = "5,000 TO 10,000", family = font, size = 3, color="#3e2b22", hjust = 0) +
  annotate("text", x = 0.15, y = 3, label = "2,500 TO 5,000", family = font, size = 3, color="#3e2b22", hjust = 0) +
  annotate("text", x = 0.15, y = 2, label = "1000 TO 2,500", family = font, size = 3, color="#3e2b22", hjust = 0) +
  annotate("text", x = 0.15, y = 1, label = "UNDER 1,0000", family = font, size = 3, color="#3e2b22", hjust = 0) +
  theme_void() +
  theme(plot.background = element_rect(color = backgrd, fill = backgrd),
        panel.background = element_rect(color= backgrd, fill = backgrd))
plt4

plt1 + plt3 + plt4 + plt2 + plot_layout(ncol = 2,nrow = 2) + 
  plot_annotation(
  title = "NEGRO POPULATION OF GEORGIA BY COUNTIES.",
  caption = "#DuBoisChallenge2024 | Challenge01 | by Seyram A. Butame",
  theme = theme_void(base_family = font)) &
  theme(text = element_text(color = "#3e2b22"),
        plot.title = element_text(hjust=0.5, face="bold"),
        plot.caption = element_text(size=8, hjust = 0.5, face = "plain", family = font_s),
        plot.background = element_rect(color ="#e4cfbd", fill ="#e4cfbd"),
        panel.background = element_rect(color ="#e4cfbd", fill ="#e4cfbd"))

# SAVE MAP ----------------------------------------------------------- 

ggsave(paste0("challenge01_", format(Sys.time(), "%d%m%Y"), ".png"), dpi = 320, height=8.8)
