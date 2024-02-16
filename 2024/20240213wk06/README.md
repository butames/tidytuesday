# TidyTuesday 2024 - Week 06

This week we are using Valentin's Day Consumer Data from the National Retail Federation Valentine's Day Data Center.

> The NRF has surveyed consumers about how they plan to celebrate Valentine’s Day annually for over a decade. Take a deeper dive into the data from the last 10 years, and use the interactive charts to explore a demographic breakdown of total spending, average spending, types of gifts planned and spending per type of gift.
[TidyTuesday, 2024](https://github.com/rfordatascience/tidytuesday/blob/master/data/2024/2024-02-13/readme.md)

## RELEVANT LIBRARY

- {tidytuesdayR} -- Access 'TidyTuesday' Weekly Projects

- {tidyverse} --  A collection of open source packages for the R programming language

- {showtext} -- Using Fonts More Easily in R Graphs

- {gt} -- Build display tables from tabular data with an easy-to-use set of functions

- {gtExtras} -- A package that extends the {gt} package to aid in the creation of HTML tables.


It recently came to my attention that you can just use the {pacman} package to load multiple libraries. The process would look like `pacman::p_load(tidytuesdayR, tidyverse, ggtext, showtext, janitor)`, rather than using library() function. Just something to think about when it comes to workflow.

## CHART TYPE

I saw a rather pretty stream plot and I want to try my hands at it. I have seen streamplots often in glossy magazines and journals. They are often elegant and quite captiavating, the way the colors blend together. However, I have sometimes confused them with area plots. But this weak of tidytuesday, I saw a couple of great looking submssions and I want to try my hand at it.



## REFERENCES

1. Iannone R, Cheng J, Schloerke B, et al. gt: Easily Create Presentation-Ready Display Tables. Published online January 17, 2024. Accessed February 6, 2024. https://cran.r-project.org/web/packages/gt/index.html

2. Qiu Y. showtext. Published online January 20, 2024. Accessed January 21, 2024. https://github.com/yixuan/showtext

3. Hughes E, Harmon J, Mock T, Community ROL. tidytuesdayR: Access the Weekly “TidyTuesday” Project Dataset. Published online December 13, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidytuesdayR/index.html

4. Wickham H, RStudio. tidyverse: Easily Install and Load the “Tidyverse.” Published online February 22, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidyverse/index.html

5. Mock T, Sjoberg DD. gtExtras: Extending “gt” for Beautiful HTML Tables. Published online September 15, 2023. Accessed February 6, 2024. https://cran.r-project.org/web/packages/gtExtras/index.html



