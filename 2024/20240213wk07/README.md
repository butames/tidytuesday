# TidyTuesday 2024 - Week 07

This week we are using Valentin's Day Consumer Data from the National Retail Federation Valentine's Day Data Center.

> The NRF has surveyed consumers about how they plan to celebrate Valentine’s Day annually for over a decade. Take a deeper dive into the data from the last 10 years, and use the interactive charts to explore a demographic breakdown of total spending, average spending, types of gifts planned and spending per type of gift.
[TidyTuesday, 2024](https://github.com/rfordatascience/tidytuesday/blob/master/data/2024/2024-02-13/readme.md)


## RELEVANT LIBRARY

- {tidytuesdayR} -- Access 'TidyTuesday' Weekly Projects

- {tidyverse} --  A collection of open source packages for the R programming language

- {showtext} -- Using Fonts More Easily in R Graphs

- {gt} -- Build display tables from tabular data with an easy-to-use set of functions

- {gtExtras} -- A package that extends the {gt} package to aid in the creation of HTML tables.

- {ggstream} -- A package to create streamplots in ggplot2


It recently came to my attention that you can just use the {pacman} package to load multiple libraries. The process would look like `pacman::p_load(tidytuesdayR, tidyverse, ggtext, showtext, janitor)`, rather than using library() function. Just something to think about when it comes to workflow.   

I rarely use this but the {skimr} package is very useful. Similar to the `glimpse()` and `str()` and `view()` functions. the `skim()` function from the {skimr} package will give you a breakdown of the data. However, it will give you a breakdown of the mean, sd, p0, 025, p50, p75, p100 and a miniature histogram of the spread, for each row fo the data. I think I need to consider using it more.

When working with data for plotting it is sometimes better to simplify the dataframe. I have been forgetting that of late as I work with data. It is easier to plot data that is in the long format and not the wide format wich dataframe (think excel sheets) typically come as.

I learned the use of the {snakecase} package. It was developed to help with naming conventions for programming languages.But essentially it converts a string to any case. The use in this exercise, converts the strings in the category column into two words. It helps with labeling down the line.

Picked up another interesting tactic. To assign factors to a column you can do it separately by first creating a vector designating that as a factor and then applying that factor to the dataframe you are working with.



## CHART TYPE

I saw a rather pretty stream plot and I want to try my hands at it. I have seen stream plots often in glossy magazines and journals. They are often elegant and quite captivating, the way the colors blend together. However, I have sometimes confused them with area plots. But for this week, I saw a couple of great looking submissions and I want to try my hand at it.

To create the actual stream plot, I need to use the package {ggstream}



## REFERENCES

1. Iannone R, Cheng J, Schloerke B, et al. gt: Easily Create Presentation-Ready Display Tables. Published online January 17, 2024. Accessed February 6, 2024. https://cran.r-project.org/web/packages/gt/index.html

2. Qiu Y. showtext. Published online January 20, 2024. Accessed January 21, 2024. https://github.com/yixuan/showtext

3. Hughes E, Harmon J, Mock T, Community ROL. tidytuesdayR: Access the Weekly “TidyTuesday” Project Dataset. Published online December 13, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidytuesdayR/index.html

4. Wickham H, RStudio. tidyverse: Easily Install and Load the “Tidyverse.” Published online February 22, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidyverse/index.html

5. Mock T, Sjoberg DD. gtExtras: Extending “gt” for Beautiful HTML Tables. Published online September 15, 2023. Accessed February 6, 2024. https://cran.r-project.org/web/packages/gtExtras/index.html

6. Sjoberg D. ggstream: Create Streamplots in “ggplot2.” Published online May 6, 2021. Accessed February 20, 2024. https://cran.r-project.org/web/packages/ggstream/index.html

```
# Load packages -----------------------------------------------------------

library(tidyverse)
library(showtext)
library(patchwork)
library(camcorder)
library(ggtext)
library(nrBrand)
library(glue)
library(ggstream)
library(snakecase)


# Load data ---------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load("2024-02-13")
historical_spending <- tuesdata$historical_spending
gifts_age <- tuesdata$gifts_age
gifts_gender <- tuesdata$gifts_gender


# Load fonts --------------------------------------------------------------

font_add_google("Sacramento", "sacramento")
font_add_google("Ubuntu", "ubuntu")
showtext_auto()


# Define colours and fonts-------------------------------------------------

col_palette <- monochromeR::generate_palette("#CC444B", "go_both_ways",
  n_colours = length(unique(plot_data$Category))
)
bg_col <- col_palette[1]
text_col <- col_palette[8]
highlight_col <- col_palette[5]

body_font <- "ubuntu"
title_font <- "sacramento"


# Data wrangling ----------------------------------------------------------

spending_data <- historical_spending |>
  select(-PercentCelebrating) |>
  rowwise() |>
  mutate(Other = PerPerson - sum(c_across(Candy:GiftCards))) |>
  mutate(across(-c(Year), ~ .x / PerPerson)) |>
  select(-c(PerPerson)) |>
  pivot_longer(-Year, names_to = "Category", values_to = "Amount") |>
  mutate(Category = to_mixed_case(Category, sep_out = " "))

cat_levels <- spending_data |>
  filter(Year == 2011) |>
  arrange(Amount) |>
  pull(Category)

plot_data <- spending_data |>
  mutate(Category = factor(Category, levels = cat_levels))

label_data <- plot_data |> 
  filter(Year == 2011) |> 
  arrange(desc(Category)) |> 
  mutate(y1 = cumsum(Amount)) |> 
  arrange(Category) |> 
  mutate(y2 = 1 - cumsum(Amount)) |> 
  rowwise() |> 
  mutate(y = mean(c(y1, y2))) |> 
  mutate(y = case_when(
    Category == "Flowers" ~ y,
    TRUE ~ y
  ))


# Start recording ---------------------------------------------------------

gg_record(
  dir = file.path("2024", "2024-02-13", "recording"),
  device = "png",
  width = 6,
  height = 6,
  units = "in",
  dpi = 300
)


# Define text -------------------------------------------------------------

social <- nrBrand::social_caption(
  bg_colour = bg_col,
  icon_colour = highlight_col,
  font_colour = text_col,
  font_family = body_font
)
title <- glue::glue("<span style='font-family:{body_font}; font-size: 32pt; font-weight: bold;'>**How do people spend (money on) Valentine's Day?**</span>")
st <- glue::glue("Valentine's Day spending has increased from an average of $103 
                 per person in 2010 to a high of $196 in 2020, according to the 
                 US National Retail Federation. However, the breakdown 
                 of what people spend that money on has remained relatively 
                 unchanged over the last decade.")
cap <- paste0(
  "**Graphic**: ", social
)
txt <- glue::glue("{title}<br>{st}<br>{cap}")


# Plot --------------------------------------------------------------------

ggplot(
  data = plot_data,
  mapping = aes(x = Year, y = Amount)
) +
  geom_stream(aes(fill = Category),
    bw = 0.8, extra_span = 0.25, type = "proportional"
  ) +
  geom_richtext(data = label_data,
            mapping = aes(x = Year - 0.8, y = y, label = Category),
            family = body_font,
            size = 9,
            colour = text_col,
            fill = bg_col,
            hjust = 0) +
  labs(tag = txt) +
  scale_fill_manual(values = rev(col_palette)) +
  coord_cartesian(expand = FALSE) +
  theme_void(base_size = 21) +
  theme(
    plot.margin = margin(0, 0, 0, 0),
    plot.background = element_rect(fill = bg_col, colour = bg_col),
    panel.background = element_rect(fill = bg_col, colour = bg_col),
    plot.tag.position = c(0.97, 0.09),
    legend.position = "none",
    plot.tag = element_textbox_simple(
      colour = text_col,
      hjust = 1,
      halign = 1,
      margin = margin(b = 10, t = 5),
      lineheight = 0.5,
      family = body_font,
      maxwidth = 0.90
    )
  )


# Save gif ----------------------------------------------------------------

gg_playback(
  name = file.path("2024", "2024-02-13", paste0("20240213", ".gif")),
  first_image_duration = 4,
  last_image_duration = 20,
  frame_duration = .25,
  background = bg_col
)
```




