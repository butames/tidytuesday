# -----------------------------------------------------------
# Author:   Seyram A. Butame
# Email:    butames@gmail.com
# Date:     2024-01-21
# Purpose:  TidyTuesday 2024 Week 03 Map of California
# -----------------------------------------------------------

## RELEVANT LIBRARIES -----------------------------------------------------

library(giscoR)
library(tidyverse) #Using `dplyr` and `ggplot2`
library(sf)
library(tidytuesdayR)
library(showtext)
library(leaflet)

## SELECT FONTS -----------------------------------------------------

font_add_google(name = "Open Sans", family = "Open Sans")
font <- "Open Sans"

font_add_google(name = "Overpass", family = "Overpass")
font_s <- "Overpass"

# TURN ON SHOWTEXT --------------------------------------------------------
showtext_auto()
showtext_opts(dpi = 320)

options(scipen = 999) 

## LOAD DATA -----------------------------------------------------

polling_places <- read_csv("data/polling_places.csv")

## WRANGLE DATA -----------------------------------------------------

df1 <- polling_places %>%
  filter(election_date == "2020-11-03", state == "CA") %>% 
  group_by(jurisdiction) %>% #There appears to be a spelling error "Contra Coasta" instead of "Contra Costa" which I need to fix
  mutate(jurisdiction = case_when(
    jurisdiction == "Contra Coasta" ~ "Contra Costa",
    TRUE ~ jurisdiction
  )) %>%
  summarize(count = n()) %>% 
  na.omit()

ca <- read_sf("data/CA_Counties/CA_Counties_TIGER2016.shp") %>%
  st_transform("+proj=longlat +datum=WGS84") %>%
  left_join(., df1, by = c("NAME"= "jurisdiction"))

# Calculate geographic center of each CA County
county_centroid_lat_long <- as_tibble(st_coordinates(st_centroid(ca))) %>% 
  rename(centr_long = X, 
         centr_lat = Y)
# Create subset data that contains county name and count of polling places
ca_centroid_county <- st_drop_geometry(ca) %>% 
  select(NAME, count)

ca_centroid <-  county_centroid_lat_long %>% 
  bind_cols(ca_centroid_county)

## CREATE COLOR -----------------------------------------------------

mybins <- seq(1, 800, by=100)
mypalette <- colorBin( palette="YlOrBr", domain=ca_centroid$count, na.color="transparent", bins=mybins)

pal <- colorNumeric("viridis", 
                    domain = ca$count) 

## CREATE MAP -----------------------------------------------------

map <- leaflet(ca) %>%
  addTiles("Stamen.Terrain") %>%
  addPolygons(
    stroke = TRUE,
    weight = 0.25,
    smoothFactor = 0.5,
    highlight = highlightOptions(
      weight = 1,
      color = "white",
      fillOpacity = 0.6,
      bringToFront = TRUE
    )
  ) %>%
  addCircleMarkers(
    data = ca_centroid,
    lng = ~centr_long, 
    lat =  ~centr_lat,
    radius = ~(count)*.02,
    stroke = FALSE,
    fillOpacity = 0.6
  )
map



  
