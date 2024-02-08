# -----------------------------------------------------------
# Author:   Seyram A. Butame
# Email:    butames@gmail.com
# Date:     2024-02-01
# Purpose:  R Script for 2024 TidyTuesday Week 05 (Ground Hog's Day)
# -----------------------------------------------------------

## LIBRARY -----------------------------------------------------------

library(tidytuesdayR)
library(tidyverse)
library(showtext)
library(glue)
library(gt)
library(gtExtras)


## LOAD DATA -----------------------------------------------------------

tuesdata <- tt_load(2024, week = 5)

# The data object contains two data files. One with data on the individual grounds and one on their predictions

groundhogs <- tuesdata$groundhogs

predictions <- tuesdata$predictions

## LOAD DATA -----------------------------------------------------------

groundhogs <- write_csv(groundhogs, "data/groundhogs.csv")
predictions <- write_csv(predictions, "data/predictions.csv")

## SELECT FONTS -----------------------------------------------------

font_add_google(name = "Roboto", family = "Roboto")
fonts <- "Roboto"

# TURN ON SHOWTEXT --------------------------------------------------------
showtext_auto()
showtext_opts(dpi = 320)

options(scipen = 999) 

# DEFINE COLORS --------------------------------------------------------

oran <- "#fc7d0b"
grey <- "#D3D3D3"

blue <- "#206095"

greytx <- "#414042"
greytk <- "#57676C"

# DATA WRANGLING --------------------------------------------------------

# Create dataframe with 2 columns, such that results from the 'shadow' column are placed into lists within each id group.

df1 <- predictions %>% 
  mutate(shadow = case_match(
    shadow,
    TRUE ~ 0,
    FALSE ~ 1,
    NA ~ 0.5
  )) %>% 
  group_by(id) %>% 
  reframe(preds = list(shadow)) 

# Create dataframe showing number of predictions, total predictions and percentage of early predictions.
df2 <- predictions %>%
  group_by(id) %>% 
  count(shadow) %>% 
  filter(!is.na(shadow)) %>% 
  mutate(
    total = sum(n),
    early = n / total * 100
  ) %>% 
  filter(!shadow)

#Create dataframe of non groundhog critters that predict for table.

df3 <- groundhogs %>% 
  filter(!is_groundhog) %>% 
  left_join(df1, by = join_by(id == id)) %>%
  left_join(df2, by = join_by(id == id)) %>%
  arrange(-early, -n) %>% 
  mutate(region_country = paste0(region, ", ", country)) %>% 
  select(image, name, type, city, region_country, total, preds, early) %>%
  mutate(early = replace_na(early, 0))

# Create dataframe of groundhogs that predict for table

df4 <- groundhogs %>% 
  filter(is_groundhog) %>% 
  left_join(df1, by = join_by(id == id)) %>%
  left_join(df2, by = join_by(id == id)) %>%
  arrange(-early, -n) %>% 
  mutate(region_country = paste0(region, ", ", country)) %>% 
  select(image, name, type, city, region_country, total, preds, early) %>%
  mutate(early = replace_na(early, 0))


# CREATE PLOT --------------------------------------------------------

tb1 <- df3 %>%
  gt() %>%
  tab_options(table.background.color = "#F7F3EF") %>%
  opt_table_font(font = fonts) %>%
  tab_header(
    title = "Non-Groundhogs Predicting Spring",
    subtitle = "This table shows all non-ground hog creatures and non-creatures that have predicted spring"
  ) %>%
  gt_img_circle(image, height = 50, border_color = NA) %>% #Create circular border around an image
  gt_merge_stack(name, type, font_weight = c("bold", "normal"), small_cap = FALSE, palette = c(greytx, greytk)) %>%
  gt_merge_stack(city, region_country, font_weight = c("normal", "normal"), small_cap = FALSE, palette = c(greytx, greytk)) %>%
  gt_plt_bar_pct(early, width = 100, fill = blue, scaled = TRUE, labels = TRUE, label_cutoff = 0.2, decimals = 0) %>%
  gt_plt_winloss(preds, palette = c(blue, oran, grey)) %>%
  gt_theme_nytimes() %>%
  cols_width(
    image ~ px(50),
    name ~ px(100),
    city ~ px(100),
    total ~ px(50),
    preds ~ px(150),
    early ~ px(100)
  ) %>% 
  cols_label(
    image = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
    name = "Mascot",
    city = "Region",
    total = "Predictions",
    preds = "Positive Predictions",
    early = "% early spring",
    .fn = md
  ) %>%
  tab_source_note(
    source_note = "Source: groundhog-day.com | Design: Seyram A. Butame | #TidyTuesday #ggplot #gt ")
tb1

# EXPORT AS HTML & PNG  -----------------------------------------------------------

gtsave(tb1, "table/groundhogs_full.html")

gtsave(tb1, "table/groundhogs_full.png")

# CREATE PLOT GROUNDHOG PLOTS  -----------------------------------------------------------

tb2 <- df4 %>%
  gt() %>%
  tab_options(table.background.color = "#F7F3EF") %>%
  opt_table_font(font = fonts) %>%
  tab_header(
    title = "Groundhogs Predicting Spring",
    subtitle = "This table shows all ground hogs that have predicted spring"
  ) %>%
  gt_img_circle(image, height = 50, border_color = NA) %>% #Create circular border around an image
  gt_merge_stack(name, type, font_weight = c("bold", "normal"), small_cap = FALSE, palette = c(greytx, greytk)) %>%
  gt_merge_stack(city, region_country, font_weight = c("normal", "normal"), small_cap = FALSE, palette = c(greytx, greytk)) %>%
  gt_plt_bar_pct(early, width = 100, fill = blue, scaled = TRUE, labels = TRUE, label_cutoff = 0.2, decimals = 0) %>%
  gt_plt_winloss(preds, palette = c(blue, oran, grey)) %>%
  gt_theme_nytimes() %>%
  cols_width(
    image ~ px(50),
    name ~ px(100),
    city ~ px(100),
    total ~ px(50),
    preds ~ px(150),
    early ~ px(100)
  ) %>% 
  cols_label(
    image = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",
    name = "Mascot",
    city = "Region",
    total = "Predictions",
    preds = "Positive Predictions",
    early = "% early spring",
    .fn = md
  ) %>%
  tab_source_note(
    source_note = "Source: groundhog-day.com | Design: Seyram A. Butame | #TidyTuesday #ggplot #gt ")
tb2

# EXPORT AS HTML & PNG  -----------------------------------------------------------

gtsave(tb2, "table/groundhogsb_full.html")

gtsave(tb2, "table/groundhogsb_full.png")
