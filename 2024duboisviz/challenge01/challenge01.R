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


navy <- "#392859"
brwn <- "#BE9C80"
darb <- "#6B442C"
wine <- "#CD2A4A"

pink <- "#E09991"
yell <- "#E9B455"
gree <- "#566859"

backgrd <- "#e4cfbd"
textcl <- "#3e2b22"

# DEFINE FONT -----------------------------------------------------------

#Libre Franklin
# Advent Pro
#SAira
#Exo 2

# PLOT MAP ----------------------------------------------------------- 

ggplot() + 
  geom_sf(
    data = gashp,
    color = "#b3cbdc")

# CREATE LEGEND  ----------------------------------------------------------- 



# SAVE MAP ----------------------------------------------------------- 

ggsave(paste0("challenge01_", format(Sys.time(), "%d%m%Y"), ".png"), dpi = 320, width=11, height=8.5)
