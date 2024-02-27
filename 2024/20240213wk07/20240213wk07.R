# -----------------------------------------------------------
# Author:   Seyram A. Butame
# Email:    butames@gmail.com
# Date:     2024-02-15
# Purpose:  TidyTuesday Week 06 Valentines Day Consumer Data
# -----------------------------------------------------------

## LIBRARY -----------------------------------------------------------

library(tidytuesdayR)
library(tidyverse)
library(ggstream)
library(showtext)
library(ggtext)
library(janitor)
library(snakecase)
library(glue)
library(monochromeR)


## LOAD DATA -----------------------------------------------------------

tuesdata <- tt_load(2024, week = 7)

historical_spending <- tuesdata$historical_spending %>%
  clean_names() %>%
  write_csv("data/historical_spending.csv")

gifts_age <- tuesdata$gifts_age  %>%
  clean_names() %>%
  write_csv("data/gifts_age.csv")


gifts_gender <- tuesdata$gifts_gender %>%
  clean_names() %>%
  write_csv("data/gifts_gender.csv")

## LOAD FONTS -----------------------------------------------------------

font_add_google(name = "Roboto", family = "Roboto")
fonts <- "Roboto"

font_add("fa6-brands", "fonts/6.4.2/Font Awesome 6 Brands-Regular-400.otf") 

font_add_google("Satisfy", family = "title")    

font_add_google("Roboto Condensed", family = "subtitle") 

font_add_google("Roboto Condensed", family = "text")  

font_add_google("Roboto Condensed", family = "caption")

# TURN ON SHOWTEXT --------------------------------------------------------

showtext_auto()

showtext_opts(dpi = 320, regular.wt = 300, bold.wt = 800)


## WRANGLE DATA -----------------------------------------------------------

df1 <- historical_spending %>%
  select(-percent_celebrating)  %>%
  rowwise()  %>%
  mutate(other = per_person - sum(c_across(candy:gift_cards))) %>% 
  mutate(across(-c(year), ~ .x / per_person)) %>%
  select(-c(per_person)) %>%
  pivot_longer(-year, names_to = "category", values_to = "amount") %>%
  mutate(category = to_mixed_case(category, sep_out = " "))

# Turn category column into a factor variable

df2 <- df1 %>%
  filter(year == 2011) %>%
  arrange(amount) %>%
  pull(category)

df3 <- df1 %>%
  mutate(category = factor(category, levels = df2))

df4 <- df3 |> 
  filter(year == 2011) %>%
  arrange(desc(category)) %>% 
  mutate(year1 = cumsum(amount)) %>% 
  arrange(category) %>% 
  mutate(year2 = 1 - cumsum(amount)) %>% 
  rowwise() %>% 
  mutate(y = mean(c(year1, year2))) %>% 
  mutate(y = case_when(
    category == "flowers" ~ y,
    TRUE ~ y
  ))

# DEFINE COLORS -------------------------------------------------

palette <- generate_palette(color = "#CC444B",
                            modification = "go_both_ways",
                            n_colours = length(unique(df3$category)))

bkgcol <- palette[1]
txtcol <- palette[8]
hltcol <- palette[5]

## DEFINE TITLE/CAPTION -----------------------------------------------------------

tt <- str_glue("#TidyTuesday: { 2024 } Week { 07 } &#124; Source: Valentine's Days Consumer Survey Data <br>")  

X  <- str_glue("<span style='font-family:fa6-brands'>&#xe61b;</span>")  

gh <- str_glue("<span style='font-family:fa6-brands'>&#xf09b;</span>")

mn <- str_glue("<span style='font-family:fa6-brands'>&#xf4f6;</span>")

ttltxt <- str_glue("Valentine's Day Spending Trends in the U.S.") 

subtxt <- str_glue("Ajusted Amount Spent, 2010-2022")

captxt <- str_glue("{tt} Visualization: {X} @butames &#124; {mn} @butames(graphic.social) Code: {gh} butames &#124; Tools: #rstats #tidytuesday #dataviz")

## CREATE PLOT THEME 

theme_set(theme_minimal(base_size = 12, base_family = "text"))                
theme_update(
  plot.title.position   = "plot",
  plot.caption.position = "plot",
  legend.position       = "plot",
  axis.title.x          = element_text(margin = margin(10, 0, 0, 0), size = rel(1), color = txtcol, family   = 'text', face = "bold"),
  axis.title.y          = element_markdown(margin = margin(0, 10, 0, 0), size = rel(1), color = txtcol, family   = 'text', face = "bold"),
  axis.text             = element_text(size = rel(1), color = txtcol, family   = 'text'),
  axis.line.x           = element_line(color = "black"),
  
  panel.grid.minor.y    = element_blank(),
  panel.grid.major.y    = element_blank(),
  
  panel.grid.minor.x    = element_blank(),
  panel.grid.major.x    = element_line(linetype = "dotted", linewidth = 0.4, color = 'gray'),
  plot.margin           = margin(t = 10, r = 10, b = 10, l = 10),
  plot.background       = element_rect(fill = bkgcol, color = bkgcol),
  panel.background      = element_rect(fill = bkgcol, color = bkgcol),
)



## CREATE PLOT -----------------------------------------------------------
# geom_richtext(data = label_data,
#               mapping = aes(x = Year - 0.8, y = y, label = Category),
#               family = body_font,
#               size = 9,
#               colour = text_col,
#               fill = bg_col,
#               hjust = 0)

plt1 <- df3 %>%
  ggplot(aes(x = year, y = amount, fill = category)) +
  geom_stream(aes(fill = category),
              bw = 0.8, 
              extra_span = 0.25, 
              type = "proportional",
              true_range = "both") +
  geom_stream_label(data = df4, 
                    x = year,
                    mapping = aes(label = category),
                    type = "ridge",
                    geom = "text",
                    position = "identity",
                    n_grid = 100,
                    hjust = 0)
plt1
                    # type     = "ridge",
                    # geom     = "text",
                    # position = "identity",
                    # n_grid   = 100,
                    # color    = txtcol,
                    # size     = 3
+
  labs(x        = "",
       y        = "",       
       title    = ttltxt,
       subtitle = subtxt,
       caption  = captxt
  ) +
  scale_fill_manual(values = rev(palette)) +
  coord_cartesian(expand = F) +
  theme_void(base_size = 16) +
  theme(
    
    plot.title         = element_text(
      size           = rel(2.5), 
      family         = "title",
      color          = txtcol,
      margin         = margin(t = 5, b = 5)), 
    
    plot.subtitle      = element_text(
      size           = rel(1), 
      family         = "subtitle",
      color          = txtcol,
      lineheight     = 1.1, 
      margin         = margin(t = 5, b = 10)),  
    
    plot.caption     = element_markdown(
      size           = rel(.6), 
      family         = "caption",
      color          = txtcol,
      lineheight     = 0.65,
      hjust          = 0.5,
      halign         = 0.5,
      margin         = margin(t = 5, b = 5)),
  )

plt1

## CREATE PLOT -----------------------------------------------------------


