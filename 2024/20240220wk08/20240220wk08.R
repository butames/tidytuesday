# -----------------------------------------------------------
# Author:   Seyram A. Butame
# Email:    butames@gmail.com
# Date:     2024-02-25
# Purpose:  TidyTuesday Week 08 2024 (R Consortium ISC Grants)
# -----------------------------------------------------------

## LIBRARY -----------------------------------------------------------
p_load(tidyverse, tidytuesdayR, glue, ggtext, showtext, camcorder, janitor, skimr, ghibli)

## LOAD DATA -----------------------------------------------------------

tuesdata <- tt_load(2024, week = 8)

isc_grants <- tuesdata$isc_grants %>%
  write_csv("data/isc_grants.csv")

df1 <- skim(isc_grants)

## SHOWTEXT SETTINGS (TEXT RESOLUTION) -----------------------------------------------------------
showtext_auto()
showtext_opts(dpi = 320, regular.wt = 300, bold.wt = 800)

## LOAD FONTS -----------------------------------------------------------
font_add("fa6-brands", "fonts/6.4.2/Font Awesome 6 Brands-Regular-400.otf") #Enables symbols such as twitter etc.
font_add_google("Roboto Condensed", "title")
font_add_google("Roboto Condensed", "subtitle")
font_add_google("Roboto Condensed", "caption")

## DEFINE TITLES & CAPTION -----------------------------------------------------------

tt <- str_glue("TidyTuesday: { 2024 } Week { 08 } &vert; Source: R Consortium Infrastructure Steering Committee (ISC) <br>")
X  <- str_glue("<span style='font-fmaily: fa6-brands'>&#xe61b;</span>")
gh <- str_glue("<span style='font-fmaily: fa6-brands'>&#xf09b;</span>")
mn <- str_glue("<span style='font-fmaily: fa6-brands'>&#xf4f6;</span>")

## DATA WRANGLING -----------------------------------------------------------

df1 <- isc_grants %>%
  clean_names() %>%
  group_by(year, group) %>%
  summarise(total = sum(funded, rm.na = TRUE),
            count = n())

## CREATE PLOT -----------------------------------------------------------

plt1 <- df1 %>%
  ggplot(aes(x = year, y = total, size = count, color = group, fill = group )) +
  geom_point(alpha = 0.5, shape = 21, show.legend = T) +
  scale_size(range = c(.1, 16), name = "Total Awardees") +
  scale_fill_viridis(discrete=F, option="A")

plt1

