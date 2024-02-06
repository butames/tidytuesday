# TidyTuesday 2024 - Week 03

This week we have data on US Polling Stations.

> The dataset comes from The Center for Public Integrity. You can read more about the data and how it was collected in their September 2020 article "National data release sheds light on past polling place changes". Thank you Kelsey E Gonzalez for the dataset suggestion back in 2020! (Hughes et al., 2019)


## RELEVANT LIBRARY

1. {ggchicklet} -- Create Chicklet (Rounded Segmented Column) Charts
2. {tidytuesdayR} -- Access 'TidyTuesday' Weekly Projects
3. {tidyverse} --  A collection of open source packages for the R programming language
4. {showtext} -- Using Fonts More Easily in R Graphs
5. {sf} -- Support for simple features, a standardized way to encode spatial vector data
6. {giscoR} -- An API package that helps to retrieve data from **Eurostat - GISCO (the Geographic Information System of the Commission)**

## Chart Types

- The first chart I craeted is like a street sign. Ryan Heart suggests creating a modified version 
  - Saved as *pollingstations21012024.png*

- The second chart I created is a proportional symbol map of the polling locations in California during the November 03, 2020 elections.

## NOTES ON MAPPING

**C**oordinate **R**eference **S**ystem (i.e., CRS). In layman's term, map projections try to transform the earth from its spherical shape (3D) to a planar shape (2D). A coordinate reference system (CRS) then defines how the two-dimensional, projected map in your GIS relates to real places on the earth. The .prj file normally contains the CRS for a shapefile.
After doing some Google, I found that, projecting the polygon to **WGS84** works, especially when using the sf package. It is described as being more striaight forward than the {rgdal} package[^1].

## REFERENCES

- Rudis  boB. hrbrmstr/ggchicklet. Published online December 28, 2023. Accessed January 21, 2024. https://github.com/hrbrmstr/ggchicklet
- Hughes E, Harmon J, Mock T, R4DS Online Learning Community. Access the Weekly TidyTuesday Project Dataset (tidytuesday). tidytuesdayR. Published 2019. Accessed October 22, 2022. https://thebioengineer.github.io/tidytuesdayR/
- Wickham H, Averick M, Bryan J, et al. Welcome to the Tidyverse. JOSS. 2019;4(43):1686. doi:10.21105/joss.01686
- Qiu Y. yixuan/showtext. Published online January 20, 2024. Accessed January 21, 2024. https://github.com/yixuan/showtext
- Pebesma E, Bivand R, Racine E, et al. sf: Simple Features for R. Published online December 18, 2023. Accessed January 21, 2024. https://cran.r-project.org/web/packages/sf/index.html
- Hernangómez D. giscoR | R package for download geodata from GISCO - Eurostat. Published online 2023. Accessed January 21, 2024. https://ropengov.github.io/giscoR/


[^1]: [Stackoverflow - How to apply spatial polygons to leaflet map using](https://stackoverflow.com/questions/57223853/how-to-apply-spatial-polygons-to-leaflet-map-using-shp)
