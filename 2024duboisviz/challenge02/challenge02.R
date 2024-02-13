# -----------------------------------------------------------
# Author:   Seyram A. Butame
# Email:    butames@gmail.com
# Date:     2024-02-12
# Purpose:  Create 100% stacked bar charts #DuboisChallenge2024
# -----------------------------------------------------------

# LIBRARY -----------------------------------------------------------

library(tidyverse)
library(janitor)
library(showtext)

# ADD FONTS ----------------------------------------------------------------
font_add_google(name = "Exo 2", family = "Exo 2")
font <- "Exo 2"

font_add_google(name = "Overpass", family = "Overpass")
font_s <- "Overpass"

# TURN ON SHOWTEXT --------------------------------------------------------
showtext_auto()
showtext_opts(dpi = 320)

options(scipen = 999) 


# LOAD DATA -----------------------------------------------------------

df1 <- read_csv("data/data.csv") %>%
  clean_names()

# DATA WRANGLING -----------------------------------------------------------

df1 <- df1



# CREATE PLOT -----------------------------------------------------------

plt1 <- df1 %>%
  ggplot(aes(y = Year, x = Free, fill = Slave )) +
  geom_bar(position = "fill", stat = "identity", width = 0.7, key_glyph = draw_key_point)

plt1
