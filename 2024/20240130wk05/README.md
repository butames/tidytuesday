# TidyTuesday 2024 - Week 05

This week we are using data on Groundhog predictions. There is a common traddition in mainly NE US like Pennsylvannia, where tradition employs a Groundhog to predict the end of winter. Festivals have built up around this festival and in Pennsylvania the famous Punxsutawney Phil is the official harbinger of Spring.

> See if you can find a better way to present the annual data than their table of predictions by year! For anyone not familiar with the Groundhog Day tradition, if the groundhog sees its shadow and goes back into its burrow, that is a prediction of six more weeks of winter. Otherwise spring will come early. We attempted to provide weather data to accompany this dataset, but so far we've been unsuccessful. Watch for a follow-up dataset in the future! (Hughes et al., 2019)

## RELEVANT LIBRARY

- {tidytuesdayR} -- Access 'TidyTuesday' Weekly Projects

- {tidyverse} --  A collection of open source packages for the R programming language

- {showtext} -- Using Fonts More Easily in R Graphs

- {gt} -- Build display tables from tabular data with an easy-to-use set of functions

- {gtExtras} -- A package that extends the {gt} package to aid in the creation of HTML tables.


## CHART TYPE

Data tables often get a bad rap as static and dull, but they don't have to be! They're a fantastic way to condense information clearly and efficiently. Thanks to innovative R packages, tables can become interactive experiences incorporating images, charts, and dynamic formatting.

After making my way through Tanya Shapiro's (data science and visualization consultant) insightful tutorial using the {reactable} and {htmlwidget} packages, I am thinking I want to create a table based on the groundhog data. While {reactable} produces beautiful results, I have recently been using the {gt} package for my table creation needs (I used to rely heavily on Kable and KableExtra. However, {gt} offers exciting possibilities as it blends elements from many of the popular R table creation packages. So I thought to myself, why not try the groundhog data with the gt package. So, here we go.

Side note I came across this version done by **Georgios Karamanis**. So pretty 

## REFERENCES

1. Iannone R, Cheng J, Schloerke B, et al. gt: Easily Create Presentation-Ready Display Tables. Published online January 17, 2024. Accessed February 6, 2024. https://cran.r-project.org/web/packages/gt/index.html

2. Qiu Y. showtext. Published online January 20, 2024. Accessed January 21, 2024. https://github.com/yixuan/showtext

3. Hughes E, Harmon J, Mock T, Community ROL. tidytuesdayR: Access the Weekly “TidyTuesday” Project Dataset. Published online December 13, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidytuesdayR/index.html

4. Wickham H, RStudio. tidyverse: Easily Install and Load the “Tidyverse.” Published online February 22, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidyverse/index.html

5. Mock T, Sjoberg DD. gtExtras: Extending “gt” for Beautiful HTML Tables. Published online September 15, 2023. Accessed February 6, 2024. https://cran.r-project.org/web/packages/gtExtras/index.html



