# # TidyTuesday 2024 - Week 08

I think this week I will attempt a Bubble Chart (or Bubble Plot). To my understanding it is an extension of the scatter plot and is primarily used to look at relationships between three numeric variables. 

I also recently came across the {gibli} package, which allows you to create palettes using the colors that are favored by Miyazaki and Studio Gibli in their animated classics (e.g., Spirited Away, Princess Mononoke, and Howl's Moving Castle). I want to try using some of those beautiful colors and since, a bubble chart relies on bubble sizes, colors, and positions, it makes for a good exercise.

Note ([JasperSoft - What is a Bubble Chart?](https://www.jaspersoft.com/articles/what-is-a-bubble-chart)):
- Bubble charts are uselful when you have three or more variables to compare. 
-  Although bubble charts are great for comparing data points, displaying too many points simultaneously can be overwhelming. Stick to no more than 20 bubbles on a chart and ensure that the bubbles have an appropriate size to demonstrate the significance of the data point.
- Bubble charts are great for tracking large data sets over time and showing how variables influence each other.
- Bubble charts are also effective when comparing two different data sets.
- Since bubble charts have a third dimension, they can effectively display much data in a single chart and showcase relationships between data points.

I ams slowly getting comfortable trying to create a gif that shows how the project was assembled using the {camcorder} package and the `gg_playback()`function. The snipette of code used to achieve this is as follows (Thank you to Nicola Rennie for introducing me to it):

```
gg_playback(
  name = file.path("2024", "2024-02-20", paste0("20240220", ".gif")),
  first_image_duration = 4,
  last_image_duration = 20,
  frame_duration = .25,
  background = bkgcol
)
```

## RELEVANT LIBRARY

- {pacman} -- 
- {tidytuesdayR} -- Access 'TidyTuesday' Weekly Projects
- {tidyverse} --  A collection of open source packages for the R programming language
- {showtext} -- Using Fonts More Easily in R Graphs
- {ggtext} -- 
- {camcorder} -- 
- {glue} -- 


## REFERENCES
1. Wilke CO, Wiernik BM. ggtext: Improved Text Rendering Support for “ggplot2.” Published online September 16, 2022. Accessed January 26, 2024. https://cran.r-project.org/web/packages/ggtext/index.html
2. Hester J, Bryan J, Software P, PBC. glue: Interpreted String Literals. Published online January 9, 2024. Accessed January 26, 2024. https://cran.r-project.org/web/packages/glue/index.html
3. Hughes E, Scherer C, Karamanis G. camcorder: Record Your Plot History. Published online October 3, 2022. Accessed February 7, 2024. https://cran.r-project.org/web/packages/camcorder/index.html
4. Wickham H, RStudio. tidyverse: Easily Install and Load the “Tidyverse.” Published online February 22, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidyverse/index.html
5. Hughes E, Harmon J, Mock T, Community ROL. tidytuesdayR: Access the Weekly “TidyTuesday” Project Dataset. Published online December 13, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidytuesdayR/index.html
6. Qiu Y. showtext. Published online January 20, 2024. Accessed January 21, 2024. https://github.com/yixuan/showtext

```
library(tidytuesdayR)
library(dplyr)
library(tidyr)
library(ggplot2)
library(packcircles) # To create the circles 
library(MoMAColors)
library(plotly)
library(ggtext)

# Download data 
tuesdata <- tidytuesdayR::tt_load('2024-02-20')
isc_grants <- tuesdata$isc_grants

# Summarize total funded by year 
isc_summary <- isc_grants |> 
  group_by(year) |> 
  summarise(total_funded = sum(funded)) |> 
  arrange(total_funded)

# Create the area of each circle (year)
packing <- circleProgressiveLayout(isc_summary$total_funded, sizetype='area')
data <- cbind(isc_summary, packing)
data <- data |> 
  rename(xcirc = x, 
         ycirc = y, 
         radius_circ = radius) |> 
  tibble::rowid_to_column('id')
# Calculate the 50 vertices points for each circle
dat.gg <- circleLayoutVertices(packing, npoints=50)
final_data <- left_join(data, dat.gg, by = join_by(id)) |> 
  mutate(total_funded = scales::dollar(total_funded, 
                                       largest_with_cents = 0))


# Bubble plot 
sysfonts::font_add_google("Montserrat", "montserrat")
sysfonts::font_add_google("Poppins", "poppins")
sysfonts::font_add_google("Josefin Sans", "josefinsans")
showtext::showtext_auto()

subt <- "<b>The R Consortium ISC</b> has been awarding grants since 2016.<br> 
The plot shows the total amount of funding awarded each year. In 2018 the<br> 
total amount awarded was <b style = 'color:#251c4a;'>$289,972</b> whereas in recent years it has been<br> 
significantly less with only <b style = 'color:#4c9a77;'>$51,015</b> in 2023 and <b style = 'color:#78adb7;'>$111,000</b> in 2022.<br>"

ggplot(data = final_data) + 
  geom_polygon(aes(x, 
                   y, 
                   group = year,
                   fill = as.factor(year), 
                   text = total_funded), 
               colour = "white", 
               # alpha = 0.7
               ) +
  scale_fill_manual(values = moma.colors("Sidhu", 10))+
  geom_text(aes(xcirc, 
                ycirc, 
                size = total_funded, 
                label = year), 
            size = 22, 
            family = 'josefinsans', 
            fontface = 'bold',
            color = 'white') +
  labs(title = "ISC grants awarded by year",
       subtitle = subt,
       x = NULL,
       y = NULL,
       caption = "\n#TidyTuesday 2024 | week 8 - 2024-02-20 | @gabbspalomo") +
  coord_equal() +
  theme_void() + 
  theme(legend.position="none", 
        plot.title = element_text(family = 'josefinsans', 
                                  size = 90, 
                                  face = 'bold', 
                                  color = 'gray20'), 
        plot.subtitle = element_markdown(family = 'montserrat', 
                                         colour = 'gray20',
                                         size = 42, 
                                         lineheight = 0.5, 
                                         hjust = 0, 
                                         vjust = 0, 
                                         margin = margin(t=0.3, unit = 'in')), 
        plot.caption = element_text(size = 38, 
                                    color = 'gray40',
                                    margin = margin(b=0.3, unit = 'in')), 
        plot.margin = margin(t=0.5, unit = 'in')) -> my_plot

ggsave(filename = here::here('2024_02_20_isc_grants', 'plots', 'my_plot.jpg'), 
       plot = my_plot, 
       scale = 0.6,
       width = 14, 
       height = 14, 
       units = 'in', 
       dpi = 300)  


## Interactive plot using ggplotly 
# ggplotly(my_plot, 
#          tooltip = 'text') %>% 
#   layout(hoverlabel = list(font = list(size = 20)))
```

