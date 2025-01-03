---
title: "Tidy Tuesday Historical Markers"
author: "Erin Franke"
date: "2023-07-06"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
library(tidyverse)
library(skimr)
library(mapdata)
library(ggtext)
library(stopwords)
library(tidytext)
library(ggrepel)
library(showtext)

font_add_google("Gochi Hand", "g")
 
historical_markers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-07-04/historical_markers.csv')
no_markers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-07-04/no_markers.csv')
```
 
```{r}
skim(historical_markers)
```

```{r}
historical_markers %>%
  count(state_or_prov)
 
combined <- historical_markers %>%
  filter(!(state_or_prov %in% c("Alaska", "Hawaii", "Puerto Rico"))) %>%
  group_by(state_or_prov) %>%
  summarize(text = paste(title, collapse = " "))
combined$words <- str_replace_all(combined$text, "[[:punct:]]", "")
 
word_by_state <- combined %>%
  unnest_tokens(word, text) %>%
  select(-words) %>%
   mutate(word = str_replace(word, "</i>", ""),
         word = str_replace(word, "<i>", ""),
         word = str_trim(word, side = "both"),
         word = str_to_lower(word)) %>%
  filter(str_detect(word, "\\S"),
         !(word %in% c("la", "le", "de"))) %>%
  group_by(state_or_prov) %>%
  count(word) %>%
  filter(!(word %in% stopwords(source = "snowball"))) %>%
  group_by(state_or_prov) %>%
  mutate(most_popular = max(n)) %>%
  filter(n == most_popular, n >10) %>%
  mutate(word = str_to_title(word),
         word = case_when(state_or_prov == "Oklahoma" ~ "U.S.",
                          state_or_prov == "Illinois" ~ "St.",
                          state_or_prov == "District of Columbia" ~ "Park, Street",
                          state_or_prov == "Massachusetts" ~ "Knox Trail",
                          state_or_prov == "Oregon" ~ "Applegate Trail",
                          TRUE ~ word)) %>%
  distinct(state_or_prov, word) %>%
  mutate(state_or_prov = str_to_lower(state_or_prov))
```

```{r}
state_info <- map_data("state")

state_labels <- state_info %>%
   group_by(region) %>%
   summarise(min_long = min(long),
             max_long = max(long),
             min_lat = min(lat),
             max_lat = max(lat),
             range_long = max_long - min_long,
             range_lat = max_lat - min_lat,
             long = min_long + range_long/2,
             lat = min_lat + range_lat/2) %>%
  mutate(long= case_when(region %in% c("michigan", "florida") ~ long + 2,
                         region == "idaho" ~ long -1,
                         region == "virginia" ~ long + 1,
                         TRUE ~ long)) %>%
  mutate(lat = case_when(region == "maryland" ~ lat + 0.5,
                         TRUE ~ lat)) %>%
  select(region, long, lat) %>%
  right_join(word_by_state, by = c("region" = "state_or_prov"))

historical_markers %>%
  filter(!(state_or_prov %in% c("Alaska", "Hawaii", "Puerto Rico"))) %>%
  ggplot()+
  geom_polygon(aes(x=long, y=lat, group = group), data = state_info, fill = NA, color = "black", linewidth = 0.15)+
  coord_fixed(ratio = 1.3) +
  geom_density2d_filled(aes(x=longitude_minus_w, y=latitude_minus_s), show.legend = FALSE, alpha=0.4, bins=7)+
  scale_fill_manual(values = c("white", "#CEE9e9", "#84BBD8", "#F8F2BE", "#FEC376", "#F88A51", "#A50026"))+
  geom_text(data = state_labels %>% filter(!(region %in% c("massachusetts", "connecticut", "new jersey", "delaware", "maryland", "district of columbia", "new hampshire"))), aes(x = long, y = lat, label = word), size =2, inherit.aes = FALSE, family = "g")+
  geom_text_repel(data = state_labels %>% filter(region %in% c("massachusetts", "connecticut", "new jersey", "delaware", "maryland", "district of columbia", "new hampshire")), aes(x=long, y=lat, label = word), nudge_x = c(5, 3, 5, 4, 5, 4, 4), nudge_y = c(0, 0, -3, 0, 0, 0, 0), size = 2, min.segment.length = 0.2, family = "g")+
  theme_classic()+
  theme(axis.ticks = element_blank(),
        axis.line = element_blank(),
        axis.text = element_blank(),
        plot.title = element_text(size = 13, family = "g"),
        plot.subtitle = element_text(size = 8, family = "g", color = "grey50"),
        plot.background = element_rect(fill = "ivory"),
        panel.background = element_rect(fill = "ivory"), 
        plot.caption = element_text(family = "g"))+
  labs(x="", y="", title = "Where the historical markers and how are they commonly named?", subtitle = "Density plot shows where historical markers are most concentrated. States are marked with the most common word across all \ntheir historical marker titles (word must appear 10+ times to be labeled).", caption = "Erin Franke | Data from Historical Marker Database USA Index")
```