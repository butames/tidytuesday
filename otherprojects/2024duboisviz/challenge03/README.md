# CHALLENGE 03 - Acres of Land Owned by Negroes in Georgia (plate 19)


## LIBRARY

- {tidyverse} --
- {camcorder} --
- {glue} --
- {ggtext} --
- {showtext} --

## NOTES

An interesting exercise for this week. I am going to argue that this is a horizontal barchart, and work from there. The difficult part will be getting the bar width correct (or as close as possible).

- I made use of the {colorspace} package. This is a new one, I had not been exposed to before. You can make adjustments to the way a color is displaced. For example, the code below takes the color #EFE3D7 (a light brown) and darkens it by 35%, resulting in a lighter shade of the same color.

```
colorspace::darken("#EFE3D7", 0.35)

```

- Another thing I have been experimenting with. Define the theme for your plot globally before creating the plot. This goes along with breaking down the steps for the viz into components, as opposed to a long wall of code. It makes it easier to understand, when you come back later. Moreover, you can make tweaks to certain areas of the code without struggling to find where you have made errors.


## REFERENCES

1. Hughes E, Scherer C, Karamanis G. camcorder: Record Your Plot History. Published online October 3, 2022. Accessed February 7, 2024. https://cran.r-project.org/web/packages/camcorder/index.html
2. Hester J, Bryan J, Software P, PBC. glue: Interpreted String Literals. Published online January 9, 2024. Accessed January 26, 2024. https://cran.r-project.org/web/packages/glue/index.html
4. Qiu Y. showtext. Published online January 20, 2024. Accessed January 21, 2024. https://github.com/yixuan/showtext
5. Wickham H, RStudio. tidyverse: Easily Install and Load the “Tidyverse.” Published online February 22, 2023. Accessed February 2, 2024. https://cran.r-project.org/web/packages/tidyverse/index.html
7. Wilke CO, Wiernik BM. ggtext: Improved Text Rendering Support for “ggplot2.” Published online September 16, 2022. Accessed January 26, 2024. https://cran.r-project.org/web/packages/ggtext/index.html

## COMPARISON

![plate-19](https://github.com/butames/tidytuesday/blob/main/otherprojects/2024duboisviz/challenge03/img/original-plate-19.jpg) ![plate-recreation](https://github.com/butames/tidytuesday/blob/main/otherprojects/2024duboisviz/challenge03/img/original-plate-19.jpg)