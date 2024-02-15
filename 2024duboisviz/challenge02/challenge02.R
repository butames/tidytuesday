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
library(ggtext)

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

# Data for the ripped effect on the side of the chart

rip <- function(N, x0, mu, variance) {
  z <- cumsum(rnorm(n = N, mean = 0, sd = sqrt(variance)))
  t <- 1:N
  x <- x0 + t*mu+z
  return(x)}


df2 <- tibble(year = seq(1790, 1870.1,length.out=3000),
             high = 3 - rip(3000, 0, 0, .00001))

# DEFINE COLORS -----------------------------------------------------------

brwn <- '#E1D6C8'

blak <- '#282422'

wine <- '#CF2C49'

yy <- c("", "1%", "2%", "3%")

xx <- c("1.3%", c(df1 %>% 
                    slice(2:8) %>% 
                    select(free) %>% 
                    deframe()), "100%")
# CREATE PLOT -----------------------------------------------------------

plt1 <- df1 %>% 
  add_row(year = 1863, slave=3, free = 3.1, .before = 9) %>% 
  mutate(free = ifelse(year == 1870, 3.1, free)) %>% 
  ggplot(aes(year,free)) +
  geom_area(data = df2, aes(year, high), fill = blak) +
  geom_line(col = brwn) +
  geom_area(fill = wine) +
  geom_ribbon(data = df2, aes(year,.5*high, ymin = high), ymax =-Inf, fill = brwn) +
  geom_line(data = df2, aes(year, high), col = blak) +
  geom_segment(data = df1 %>% 
                 slice(2:8),
               aes(x = year, xend = year, y=0, yend = 3), col = brwn, linewidth = .4) +
  coord_flip(ylim = c(3, 0)) +
  scale_x_reverse(n.breaks = 9, labels = df1$year,
                  sec.axis = sec_axis(~., breaks = df1$year, labels = xx),
                  expand = expansion(add = 0)
  ) +
  scale_y_reverse(n.breaks = 4, position = 'right', labels=yy) +
  labs(title = "SLAVES AND FREE NEGROES.", 
       subtitle  = "PERCENT \nOF \nFREE NEGROES") +
  theme(panel.background = element_rect(fill = brwn),
        panel.grid = element_blank(),
        axis.title = element_blank(),
        plot.background = element_rect(fill = brwn),
        text = element_text(family = font),
        axis.text.y = element_text(size = 12), 
        axis.text.x = element_text(size = 10),
        plot.title = element_text(hjust = .5, face = "bold", vjust = 3, size = 20),
        plot.subtitle = element_text(size= 8, hjust = 1.20, vjust = -1),
        plot.margin = margin(1.5, 4, 2, 4, "cm"), 
        axis.ticks.length.y.left = unit(.7, "cm"),
        axis.ticks.length.y.right = unit(.7, "cm"),
        axis.ticks.y= element_blank(),
  ) 

# Saving  ---------------------------------------------------

ggsave(paste0("challenge02_", format(Sys.time(), "%d%m%Y"), ".png"), dpi = 320, height=11, width = 8.5, limitsize = F)



