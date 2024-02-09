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
library(ggtext)
library(glue)

# LOAD DATA -----------------------------------------------------------

# Population Data
df1 <- read_csv("data/data1870.csv")
df2  <- read_csv("data/data1880.csv")

# Shapefile

gashp <- st_read("data/georgia-1880-county-shapefile/DuBoisChallenge - Georgia Counties w 1870 & 1880 data.shp")



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

# PLOT MAP ----------------------------------------------------------- 

plt1 <- ggplot() + 
  geom_sf(
    data = gashp,
    color = "#483c32",
    alpha = 0.9,
    linewidth) +
plt1

# CREATE LEGEND  ----------------------------------------------------------- 
# There are two legends in the WEB Dubois plate
# I wondered how to split up the legend the way it is done on the original plate
# But you can simply create the legend separately and paste it to 

lg1 <- tibble(x = 0,
              y = c(1,2,3),
              label = c("10,000 TO 15,000",
                        "15,000 TO 20,000",
                        "BETWEEN 20,000 AND 30,000")) 

lg2 <- tibble(x = 0,
              y = c(4,3,2,1),
              label = c("5,000 TO 10,000",
                        "2,500 TO 5,000",
                        "1000 TO 2,500",
                        "UNDER 1,000"))

# PLOT LEGENDS ----------------------------------------------------------- 
# There are two legends in the WEB Dubois plate

plt3 <- lg1 %>%
  ggplot(aes(x,y)) +
  geom_point(aes(fill = label),
             shape = 21,
             stroke = 0.1,
             size = 10,
             show.legend = FALSE)+
  scale_fill_manual(values = colorsa, 
                    breaks = c("10,000 TO 15,000",
                               "15,000 TO 20,000",
                               "BETWEEN 20,000 AND 30,000")) +
  coord_cartesian(xlim = c(-0.2, 7),
                  ylim = c(-1, 4)) +
  theme_void() +
  theme(plot.background = element_rect(color = backgrd, fill = backgrd),
        panel.background = element_rect(color= backgrd, fill = backgrd))
plt3

plt4 <- lg2 %>%
  ggplot(aes(x,y)) +
  geom_point(aes(fill = label),
             shape = 21,
             stroke = 0.1,
             size = 10,
             show.legend = FALSE)+
  scale_fill_manual(values = colorsb, 
                    breaks = c("5,000 TO 10,000",
                               "2,500 TO 5,000",
                               "1000 TO 2,500",
                               "UNDER 1,000")) +
  coord_cartesian(xlim = c(-0.2,1),
                  ylim = c(-0,5)) +
  theme_void() +
  theme(plot.background = element_rect(color = backgrd, fill = backgrd),
        panel.background = element_rect(color= backgrd, fill = backgrd))
plt4

# SAVE MAP ----------------------------------------------------------- 

ggsave(paste0("challenge01_", format(Sys.time(), "%d%m%Y"), ".png"), dpi = 320, width=11, height=8.5)
