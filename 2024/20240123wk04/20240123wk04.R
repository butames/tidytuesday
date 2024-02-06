# -----------------------------------------------------------
# Author:   Seyram A. Butame
# Email:    butames@gmail.com
# Date:     2024-02-02
# Purpose:  TidyTuesday Week 04 - English Education Attainment
# -----------------------------------------------------------

# LIBRARY -----------------------------------------------------------

library(tidytuesdayR)
library(tidyverse)
library(showtext)

# LOAD DATA -----------------------------------------------------------

tuesdata <- tt_load(2024, week = 4)

english_education <- tuesdata$english_education %>%
  clean_names() %>%
  as_tibble()

# Save Data
english_education <- write_csv(english_education, "data/english_education.csv")

# DEFINE COLORS -----------------------------------------------------------
# There are three colors

wine <- "#871A5B"

grey <- "#D3D3D3"

blue <- "#206095"

greytx <- "#414042"
greytk <- "#D9D9D9"



## SELECT FONTS -----------------------------------------------------

font_add_google(name = "Open Sans", family = "Open Sans")
font <- "Open Sans"

font_add_google(name = "Roboto", family = "Roboto")
fonts <- "Roboto"

# TURN ON SHOWTEXT --------------------------------------------------------
showtext_auto()
showtext_opts(dpi = 320)

options(scipen = 999) 


# DATA WRANGLING -----------------------------------------------------------
# Relevant variables:
# size_flag <- Size category of the built-up area or built-up area subdivision based on resident population (from Census 2011) 
# income_flag <- Variable used to describe towns as lower income deprivation, mid income deprivation or higher income deprivation

df1 <- english_education %>%
  select("size_flag", "income_flag") %>%
  drop_na() %>%
  mutate(size_flag = case_when(
    size_flag == "City" ~ "Cities",
    size_flag == "Large Towns" ~ "Large towns",
    size_flag == "Medium Towns" ~ "Medium towns",
    size_flag == "Small Towns" ~ "Small towns"
  )) %>%
  mutate(income_flag = case_when(
    income_flag == "Cities" ~ "Higher income deprivation",
    income_flag == "Higher deprivation towns" ~ "Higher income deprivation",
    income_flag == "Mid deprivation towns" ~ "Mid income deprivation",
    income_flag == "Lower deprivation towns" ~ "Lower income deprivation"
  )) %>%
  count(size_flag, income_flag) %>%
  group_by(size_flag) %>%
  rename(
   "Size" = "size_flag",
    "Deprivation" = "income_flag",
    "Freq" = "n"
  )
# Convert Deprivation variable to a factor or categorical variable.

df1 <- df1 %>%
  mutate_at(vars(Deprivation), factor, levels = c("Lower income deprivation", "Mid income deprivation", "Higher income deprivation"))
  
# CREATE PLOT -----------------------------------------------------------

pt1 <- df1 %>%
  ggplot(
    aes(x = Freq,
        y = Size,
        fill = Deprivation,
        color = Deprivation)
  ) +
  geom_bar(position = "fill", stat = "identity", width = 0.7, key_glyph = draw_key_point) +
  scale_x_continuous(labels = function(x) paste0(x*100), breaks = seq(0, 1, 0.2)) +
  scale_color_manual(values = c(blue, grey, wine)) +
  scale_fill_manual(values = c(blue, grey, wine))
pt1

# LABEL PLOT -----------------------------------------------------------

pt2 <- pt1 + labs(
  x = "",
  y = "",
  title = "Levels of Income Deprivation based on Town Size in the UK",
  caption = "#TidyTuesday | Design: Seyram A. Butame | Data:  UK Office for National Statistics (Longitudinal Educational Outcomes (LEO) data"
)

pt2

# MODIFY THEME -----------------------------------------------------------
pt3 <- pt2 +
  theme_void() +
  theme(
    legend.position = "top",
    legend.justification = "center",
    legend.box = "horizontal",
    legend.spacing = unit(0.1, 'in'),
    legend.margin = margin(0),
    legend.title = element_blank(),
    legend.text = element_text(size = 10, color = greytx, family = fonts),
    axis.text.y = element_text(size = 13, color = greytx, family = fonts, hjust=1),
    axis.text.x = element_text(size = 13, color = greytx, family = fonts, vjust=-1),
    plot.title =  element_text(size = 13, vjust= 6, hjust = 0.5, color = greytx, family = fonts, face = "bold"),
    plot.caption = element_text(size = 6, vjust = -5, hjust = 0.5, color = greytx, family = fonts),
    plot.caption.position = "plot",
    plot.title.position = "plot",
    aspect.ratio = 1/3,
    panel.grid.major.x = element_line(color = greytk,
                                      size = 0.5,
                                      linetype = "dotted"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "inches")
  ) +
  geom_vline(xintercept = 0, linetype = 1, color = greytk, linewidth = 0.75) + 
  guides(color = guide_legend(reverse = TRUE, keywidth = unit(10, units="mm")), fill = FALSE)
pt3


# SAVE -----------------------------------------------------------

ggsave(paste0("barchart", format(Sys.time(), "%d%m%Y"), ".png"), dpi = 320, width = 11, height = 8.5)

