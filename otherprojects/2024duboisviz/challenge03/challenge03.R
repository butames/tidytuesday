# -----------------------------------------------------------
# Author:   Seyram A. Butame
# Email:    butames@gmail.com
# Date:     2024-02-21
# Purpose:  Dubois Challenge2024 - Challenge 03
# -----------------------------------------------------------


## LOAD PACKAGES -----------------------------------------------------------
# Use the pacman package to load multiple packages.
# pacman::p_load(tidyverse, 
#                ggtext, 
#                showtext, 
#                janitor, 
#                scales,
#                glue,
#                camcorder,
#                colorspace)

library(tidyverse)
library(ggtext)
library(showtext)
library(janitor)
library(scales)
library(glue)
library(camcorder)
library(colorspace)


## CREATE CANVAS AND RECORD

gg_record( 
  dir    = here::here("img"), 
  device = "png",
  width  = 8.5,
  height = 11,
  units  = "in",
  dpi    = 320) 


## LOAD DATA -----------------------------------------------------------

df1 <- read_csv("data/data.csv") %>%
  clean_names()


## DEFINE PLOT AESTHETICS ----------------------------------------------------------- 
#EFE3D7 - alternative background color

bkgcol <- colorspace::lighten("#DCC6B3", 0.05) 

ttlcol <- "gray10"              
capcol <- "gray20"  
txtcol <- "gray20" 

## DEFINE TITLES AND CAPTION ----------------------------------------------------------- 

tt <- str_glue("#DuboisChallenge: { 2024 } Challenge { 03 } &bull; Source: Du Bois Viz Challenge  <br>")  
X  <- str_glue("<span style='font-family:fa6-brands'>&#xe61b;</span>")   
gh <- str_glue("<span style='font-family:fa6-brands'>&#xf09b;</span>")
mn <- str_glue("<span style='font-family:fa6-brands'>&#xf4f6;</span>")

ttltxt <- str_glue("ACRES OF LAND OWNED BY NEGROES <br> IN GEORGIA.<br>") 
captxt <- str_glue("{tt} Visualization: {X} @butames &bull; {mn} @butames(mastodon.cloud) Code: {gh} butames &bull; Tools: #rstats #ggplot2")

## DEFINE FONTS ----------------------------------------------------------- 

font_add("fa6-brands", "fonts/6.4.2/Font Awesome 6 Brands-Regular-400.otf") 
font_add_google("Exo 2", family = "title")
font_add_google("Exo 2", family = "text")  
font_add_google("Roboto Condensed", family = "caption")

## DEFINE TEXT RESOLUTION ----------------------------------------------------------- 
showtext_auto()
showtext_opts(dpi = 320, regular.wt = 300, bold.wt = 800)


## SET THEME ----------------------------------------------------------- 

theme_set(theme_minimal(base_size = 12, base_family = "text"))
theme_update(
  plot.title.position   = "plot",
  plot.caption.position = "plot",
  legend.position       = "plot",
  axis.title.x          = element_text(margin = margin(10, 0, 0, 0), size = rel(1), color = txtcol, family   = "text", face = "bold"),
  axis.title.y          = element_markdown(margin = margin(0, 10, 0, 0), size = rel(1), color = txtcol, family   = "text", face = "bold"),
  axis.text           = element_text(size = rel(1), color = txtcol, family   = "text"),
  axis.text.x = element_blank(),
  axis.line.x           = element_blank(),
  panel.grid.minor.y    = element_blank(),
  panel.grid.major.y    = element_blank(),
  panel.grid.minor.x    = element_blank(),
  panel.grid.major.x    = element_blank(),
  plot.margin           = margin(t = 10, r = 10, b = 10, l = 10),
  plot.background       = element_rect(fill = bkgcol, color = bkgcol),
  panel.background      = element_rect(fill = bkgcol, color = bkgcol),
)


## DATA WRANGLING -----------------------------------------------------------

#typically with a wide data set I would pivot longer to make it easier to plot. I don't I need to do that

df2 <- df1 %>%
  mutate(date = as.character(date)) %>%
  arrange(desc(date)) %>%
  mutate(date = factor(date, levels=date))


## CREATE PLOT  -----------------------------------------------------------

plt1 <- df2 %>%
    group_by(land) %>%
  ggplot() +
  geom_col(aes(x = date , y = land ), fill = "#E62A48", width = 0.6) +
  annotate("text", x = 25, y = 200000, label = "338,789") +
  annotate("text", x = 1, y = 450000, label = "1,062,223") +
  coord_flip() +
  labs(x        = "",
       y        = "",       
       title    = ttltxt,
       caption  = captxt
  ) +
  theme(
    plot.title      = element_markdown(
      size           = rel(1.5), 
      family         = "title",
      face           = "bold",
      color          = ttlcol,
      hjust = 0.5,
      halign = 0.5,
      margin         = margin(t = 5, b = 5)), 
    plot.caption     = element_markdown(
      size           = rel(.8), 
      family         = "caption",
      color          = capcol,
      lineheight     = 0.65,
      hjust          = 0.5,
      halign         = 0.5,
      margin         = margin(t = 5, b = 5)),
  )

plt1

# Saving  ---------------------------------------------------

ggsave(paste0("challenge03_", format(Sys.time(), "%d%m%Y"), ".png"), dpi = 320, height=11, width = 8.5, limitsize = F)

