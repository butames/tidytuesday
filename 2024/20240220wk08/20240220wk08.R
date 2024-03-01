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
#Enables symbols such as twitter etc.

font_add("fa6-brands", "Users/seyramb/Library/Fonts/Font Awesome 6 Brands-Regular-400.otf") 
font_add_google("Roboto Condensed", "title")
font_add_google("Roboto Condensed", "subtitle")
font_add_google("Roboto Condensed", "caption")
font_add_google("Roboto Condensed", "text")


## DEFINE TITLES & CAPTION -----------------------------------------------------------



tt <- str_glue("TidyTuesday: { 2024 } Week { 08 } &vert; Source: R Consortium Infrastructure Steering Committee (ISC) <br>")
X  <- str_glue("<span style='font-family:fa6-brands'>&#xe61b;</span>")   
gh <- str_glue("<span style='font-family:fa6-brands'>&#xf09b;</span>")
mn <- str_glue("<span style='font-family:fa6-brands'>&#xf4f6;</span>")

ttltxt <- str_glue("Bubble Chart Showing Grants Awarded")
subtxt <- str_glue("R Consortium Steering Committee (ISC) Grants as a Function of Time and Amount")
captxt <- str_glue("{tt} Visualization: {X} @butames &bull; {mn} @butames(mastodon.cloud) Code: {gh} butames &bull; Tools: #rstats #ggplot2")

## DEFINE COLORS -----------------------------------------------------------

palette <- c("#278B9AFF", "#590514FF", "#B50A2AFF")

## DATA WRANGLING -----------------------------------------------------------

df1 <- isc_grants %>%
  clean_names() %>%
  group_by(year, group) %>%
  summarise(total = sum(funded, rm.na = TRUE),
            count = n()) %>%
  mutate(fillgroup = case_when(
    group == "1" ~ palette[1],
    group == "2" ~ palette[2],
    TRUE ~ palette[3]  # Default value for other groups (optional)
  ))

## DEFINE THEME/AESTHETICS -----------------------------------------------------------

bkgcol <- "#F4E3D3FF"

ttlcol <- "#85898AFF"
subcol <- "#85898AFF"
capcol <- "#85898AFF"
txtcol <- "#85898AFF"

theme_set(theme_minimal(base_size = 12, base_family = "text"))
theme_update(
  plot.title.position = "plot",
  plot.caption.position = "plot",
  axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0), size = rel(1), color = txtcol, family = "text", face = "bold"),
  axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0), size = rel(1), color = txtcol, family = "text", face = "bold"),
  axis.text = element_text(size = rel(1), color = txtcol, family = "text"),
  axis.line.x = element_blank(),
  panel.grid.minor.y = element_blank(),
  panel.grid.major.y = element_blank(),
  panel.grid.minor.x = element_blank(),
  panel.grid.major.x = element_blank(),
  plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
  plot.background = element_rect(fill = bkgcol, color = bkgcol),
  panel.background = element_rect(fill = bkgcol, color = bkgcol)
)


## CREATE PLOT -----------------------------------------------------------

plt1 <- df1 %>%
  ggplot() +
  geom_point(aes(x = year, y = total, size = count, color = group, fill = fillgroup), alpha = 0.8, shape = 21, show.legend = T) +
  scale_y_continuous(limits=c(10000,200000)) +
  scale_x_continuous(limits=c(2014,2024)) +
  scale_size(range = c(.1, 24), name = "Total Awardees", guide = "none") +
  # scale_fill_manual(values = group, labels = c("Spring", "Fall"), name = "Award Cycle"))  
  guides(color = guide_legend("Award Cycle")) +
  guides(color = "none") +
  labs(x = "",
       y = "Grant Award Amount (USD)",
       fill = "Award Cycle",
       title = ttltxt,
       subtitle = subtxt,
       caption = captxt) 
  theme(
    plot.title = element_markdown(
      size    = rel(1.5),
      family  = "title",
      color   = ttlcol,
      hjust   = 0.5,
      halign  = 0.5,
      margin  = margin(t = 5, b = 5)
    ),
    plot.subtitle = element_markdown(
      size    = rel(1.5),
      family  = "subtitle",
      color   = ttlcol,
      hjust   = 0.5,
      halign  = 0.5,
      margin  = margin(t = 5, b = 5)
    ),
    plot.caption = element_markdown(
      size    = rel(1),
      family  = "caption",
      color   = ttlcol,
      hjust   = 0.5,
      halign  = 0.5,
      margin  = margin(t = 5, b = 5)
    )
  )

plt1

ggsave(paste0("bubblechart_", format(Sys.time(), "%d%m%Y"), ".png"), dpi = 320, height = 8.5, width = 11, limitsize = F)


