# Challenge 01 - NEGRO POPULATTION OF GEORGIA BY COUNTIES

> The Paris Exposition of 1900 included a display devoted to the history and "present conditions" of African Americans. W.E.B. Du Bois and special agent Thomas J. Calloway spearheaded the planning, collection and installation of the exhibit materials, which included 500 photographs. The Library of Congress holds approximately 220 mounted photographs reportedly displayed in the exhibition (LOTs11293-11308), as well as material specially compiled by Du Bois: four photograph albums showing "Types" and "Negro Life" (LOT 11930); three albums entitled "The Black Code of Georgia, U.S.A.," offering transcriptions of Georgia state laws relating to blacks, 1732-1899 (LOT 11932); and 72 drawings charting the condition of African Americans at the turn of the century (LOT 11931). The materials cataloged online include all of the photos in LOT 11930, and any materials in the other groups for which copy negatives have been made.

For Challenge one we are supposed to recreate the plates that show the population of black people in Goergia by state. The original plates are beautifully colored. Essentially a choropleth map h

## LIBRARY

- {sf} -- Simple Features for R Support for simple features, a standardized way to encode spatial vector data.
- {tidyverse} -- A set of packages that work in harmony because they share common data representations and 'API' design. This package is designed to make it easy to install and load multiple 'tidyverse' packages in a single step.
- {patchwork} -- The patchwork package makes it very easy to create layouts in {ggplot} that have multiple panels.
- {camcorder} -- This is an R package to track and automatically save graphics generated with {ggplot2} that are created across one or multiple sessions with the eventual goal of creating a GIF showing all the plots saved sequentially during the design process.
- {ggtext} -- A {ggplot2} extension that enables the rendering of complex formatted plot labels (titles, subtitles, facet labels, axis labels, etc.).
- {glue} -- Glue offers interpreted string literals that are small, fast, and dependency-free. Glue does this by embedding R expressions in curly braces.

## LEARNED ITEMS

I picked up on an interesting bit of code when using {stringr} the tidyverse package that manipulates strings or characters. In the data the variable *1870* there are values such as ">1000" and "2500 - 5000". I am attempting to split these characters so there is an upper limit and a lower limit. But first I have to remove the non letter characters (i.e., ">" and "-" as well as the space " ").

I employed `mutate(data1870 = str_remove_all(data1870, "[>-]"))`. Which removes **all** the instances ">" and "-".

Another note, when using the {sf} package, working on the dataframe during data wrangling. The conversion to a tibble (i.e., a form of a dataframe employed in the tidyverse) strips the special geospatial information that `st_as_sf()` had added, and ggplot2 uses that information to automatically find the geometry column. To solve this when creating your map plot it is best to specify **geometry** in the aes() function.

Ultimately, I did not employ the `str_remove_all()` function, as it was not necessary. The data we were given was very clean, and I could simply use specific categories. However, I am preserving the code below for my future notes.

```
df3 <- gashp %>%
  mutate(data1870 = str_remove_all(data1870, "[>-]")) %>%
  mutate(data1880_p = str_remove_all(data1880_p, "[>-]")) %>%
  separate_wider_regex(data1870, c(ll70 = ".*", " ", up70 = ".*")) %>%
  separate_wider_regex(data1880_p, c(ll80 = ".*", " ", up80 = ".*")) %>%
  mutate(ll70 = as.numeric(ll70),
         up70 = as.numeric(up70),
         ll80 = as.numeric(ll80),
         up80 = as.numeric(up80)) %>%
  replace(is.na(.), 0) %>%
  rowwise() %>% 
  mutate(mean70 = mean(up70, ll70),
         mean80 = mean(up80, ll80)) %>%
  arrange(mean70, mean80)
```

## REFERENCE

1. Hughes E, Scherer C, Karamanis G. camcorder: Record Your Plot History. Published online October 3, 2022. Accessed February 7, 2024. https://cran.r-project.org/web/packages/camcorder/index.html
2. Hester J, Bryan J, Software P, PBC. glue: Interpreted String Literals. Published online January 9, 2024. Accessed January 26, 2024. https://cran.r-project.org/web/packages/glue/index.html
3. Pebesma E, Bivand R, Racine E, et al. sf: Simple Features for R. Published online December 18, 2023. Accessed January 21, 2024. https://cran.r-project.org/web/packages/sf/index.html
4. Qiu Y. showtext. Published online January 20, 2024. Accessed January 21, 2024. https://github.com/yixuan/showtext
5. Wickham H, RStudio. tidyverse: Easily Install and Load the “Tidyverse.” Published online February 22, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidyverse/index.html
6. Pedersen TL. patchwork: The Composer of Plots. Published online January 8, 2024. Accessed January 26, 2024. https://cran.r-project.org/web/packages/patchwork/index.html
7. Wilke CO, Wiernik BM. ggtext: Improved Text Rendering Support for “ggplot2.” Published online September 16, 2022. Accessed January 26, 2024. https://cran.r-project.org/web/packages/ggtext/index.html


