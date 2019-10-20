#####Chapter 12 work through #####

####Chapter 12: Scales, axes and legends ####

##12.1 Introduction ####
#scale control mapping from data to aesthetics.  they allow you to take data and turn it into something you can see, like sizse, color, position or shape.  They provide tools that let you read the plot: axes and legends.  Each scale is a function from a region in data space (domain of the scale) to a region in aesthetic space (range of the scale).  Axis or legend is the inverse: it allows you to convert visual properties back to the data.
library(tidyverse)
##12.2 Modifying scales ----
#a scale is required for every aesthetic used on the plot.  when you write: 
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) #it is the equivalent of:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) + 
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()

#default scales are named according to the aesthetic and variable type (ex. scale_y_continuous(), scale_color_discrete()).  if you want to override defaults you need to add the scale yourself:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  scale_x_continuous("A really awesome x axis label") +
  scale_y_continous("An amazingly great y axis label")

#to use a different scale all together:
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  scale_x_sqrt() +
  scale_color_brewer()

###naming scheme for scales: 
 #1: scale
 #2: the name of the aesthetic (ex. color, shape or x)
 #3: the name of the scale (ex. contiinuous, discrete, brewer)

###12.2.1 Exercises
#1. What happens if you pair a discrete variable to a continuous scale?  What happens if you pair a continuous variable to a discrete scale?

#Simplify the following plot specifications to make them easier to understand.
ggplot(mpg, aes(displ)) +
  scale_y_continuous("Highway map") +
  scale_x_continous() +
  geom_point(aes(y = hwy))

ggplot(mpg, aes(y = displ, x = class)) +
  scale_y_continuous("Displacement (1)") +
  scale_x_discrete("Car Type") +
  scale_x_discrete("Type of Car") +
  scale_color_discrete() +
  geom_point(aes(color = drv)) +
  scale_color_discrete("Drive\ntrain")

####12.3 Guides: Legends and axes----
#guide: the axis or legend associated with the scale.  Guides allow you to read observations from the plot and map them back to their original values.  In ggplot2, you don't have to driectly control the legend, you just set up the data sot hat there is clear mapping between data and aesthetics, and a legend is generated automatically.  #Axis     #Legend   #Arugment name
#Label      #Title   #name
#Ticks & grid line #Key  #breaks
#Tick label #Key label  #labels

###12.3.1 Scale title ----
#first argument to scale function, name, is the axes/legend title.  You can supply text strings (using \ for line breaks) or mathematical expressions in quote().
df <- data.frame(x = 1:2, y = 1, z = "a")
p <- ggplot(df, aes(x,y)) + geom_point()
p + scale_x_continuous("x axis")
p + scale_x_continuous(quote(a + mathematical ^ expression))

#xlab(), ylab() and labs():
p <- ggplot(df, aes(x, y)) + geom_point(aes(color = z))
p +
  xlab("X axis") +
  ylab("Y axis") 
p + labs(x = "X axis", y = "Y axis", color = "Color\nlegend")

#2 ways to remove an axis label.  Setting it to "" omits the labl, but still allocates space; NULL removes the label and its space.  

p <- ggplot(df, aes(x,y)) +
  geom_point() +
  theme(plot.background = element_rect(color = "grey50"))
p + labs(x = "", y = "")
p + labs (x = NULL, y = NULL)

###12.3.2 Breaks and labels
#breaks argument controls which values appear as tick marks on axes and keys on legends.  Each break has an associated label, controlled by the labels argument.  If you set labels, you must also set breaks; otherwise, if data changes, the breaks will no longer align with the labels.

#the following code shows some basic examples for both axes and legends:

df <- data.frame(x = c(1, 3, 5)) * 1000, y = 1)
axs <- ggplot(df, aes(x,y)) +
  geom_point() +
  labs(x = NULL, y = NULL)
axs
axs + scale_x_continuous (breaks = c(2000, 4000))
axs + scale_x_continuous (breaks = c(2000, 4000), labels = c("2k", "4k"))

leg <- ggplot(df, aes(y, x, fill = x)) +
  geom_tile() +
  labs (x = NULL, y = NULL)
leg
leg + scale_fill_continuous(breaks = c(2000, 4000))
leg + scale_fill_continuous(breaks = c(2000, 4000), labels = c("2k", "4k"))

#if you want to relabel the breaks in a categorical scale, you can use a named labels vector:
df2 <- data.frame (x = 1:3, y = c("a", "b", "c"))
ggplot(df2, aes(x, y)) +
  geom_point()
ggplot(df2, aes(x, y)) +
  geom_point() +
  scale_y_discrete(labels = c(a = "apple", b = "banana", c = "carrot"))

#to suppress breaks (and for axes, grid lines) or labels, set them to NULL:
axs + scale_x_continuous(breaks = NULL)
axs + scale_x_continuous(labels = NULL)

leg + scale_fill_continuous (breaks = NULL)
leg + scale_fill_continuous(labels = NULL)

#You can supply a function to breaks or labels.  The breaks function should have one argument, the limits (numeric vector of length two), and should return a numeric vector of breaks.  The labels function should accept a numeric vector of breaks and return a character vector of labels (the same length as the input). 
#The scales package provides a numbe of useful labelling function:
 #scales::comma_format() adds commas to make it easier to read large numbers.
 #scales::unit_format(unit, scale) adds a unit suffix, optionally scaling
 #scales::dollar_format(prefix, suffix) displays currency values, rounding to two decimal places and adding a prefix or suffix
 #scales::wrap_format() wraps long labels into multiple lines

axs + scale_y_continuous(labels = scales::percent_format())
axs + scale_y_continuous(labels = scales::dollar_format(prefix = "$"))
leg + scale_fill_continuous(labels = scales::unit_format(unit = "k", scale = 1e-3))

#You can adjust minor breaks (faint grid lines that appear between the major grid lines) by supplying a numeric vector of positions to the minor_breaks argument.

df <- data.frame (x = c(2, 3, 5, 10, 200, 3000), y = 1)
ggplot(df, aes(x, y)) +
  geom_point() +
  scale_x_log10()

mb <- as.numeric(1:10 %o% 10 ^ (0:4))
ggplot(df, aes(x, y)) +
  geom_point() +
  scale_x_log10(minor_breaks = mb)

#%o%: quickly generates the mulitplication table add that th eminor breaks must be supplied on the transformed scale

####12.3.3 Exercises ----
#1. Recreate the following graphic:

#adjust the y axis label so that the parentheses are the right size

#2. List the three different types of object you can supply to the breaks argument.  How do breaks and labels differ?

#3. Recreate the following plot:

#4. What label function allows you to create mathematical expressions? What label function converts 1 to 1st, 2 to 2nd, and so on?

#5. What are the three most important arguments that apply to both axes and legends? What do they do? Compare and contrast their operation for axes vs. legends.

####12.4 Legends ----
#Extra options that only apply to legends.  Legends are more complicated than axes because:
 #1. A legend can display multiple aesthetics(ex. color and shape), from multiple layers, and the symbol displayed in a legend varies based on the geom used in the layer.
 #2. Axes always appear in the same place.  Legends can appear in different places, so you need some global way of controlling them.
 #3. Legends have considerably more details that can be tweaks: should they be displayed vertically or horizontally? How many columns? How big should the keys be?

####12.4.1 Layers and legends ----
# A legend may need to draw sympbols from multiple layers.  By default, a layer will only appear if the correspondign aesthetic is mapped to a variable with aes().  You can override whether or not a layer appears in the legend with show.legend: FALSE to prevent a layer from appearing in the legend.  TRUE forces it to appear when it otherise wouldn't.  Using TRUE can be sueful in conjunction with the following trick to make points stand out:
ggplot(df, aes(y, y)) +
  geom_point(size = 4, color = "grey20") +
  geom_point(aes(color = z), size = 2)
ggplot(df, aes(y, y)) +
  geom_point(size = 4, color = "grey20", show.legend = TRUE) +
  geom_point(aes(color = z), size = 2)

#Sometimes you want the geoms in the legend to display differently to the geoms in the plot.  Very useful when you've used transparency or size to deal with moderate overplotting and also used color in the plot.  YOu can do this using the override.aes pararameter of guide_legend()

norm <- data.frame(x = rnorm(1000), y = rnorm(1000))
norm$z <- cut(norm$x, 3, labels = c("a", "b", "c"))
ggplot(norm, aes(x, y)) +
  geom_point(aes(color = z), alpha = 0.1)
ggplot(norm, aes(x, y)) +
  geom_point(aes(color = z), alpha = 0.1) +
  guides(color = guide_legend(override.aes = list(alpha = 1)))

#ggplot tries to use fewest number of legends to accurately convey aesthetics used in the plot.  It combines legends where the same variable is mapped to dfifferent aesthetics.  
ggplot(df, aes(x, y)) + geom_point(aes(color = z))
ggplot(df, aes(x, y)) + geom_point(aes(shape = z))
ggplot(df, aes(x, y)) + geom_point(aes(shape, z, color = z))

#in order for legends to be merged, they must have the same name.  If you change the name of one of the scale,s you need to change it for all.

####12.3.2 Legend Layout ----
#A number of settings that affect the overall display of the legends are controlled through the theme system.  You modify theme settings with the theme() function.
#position adn justification of legends are controlled by the theme setting legend.position, which takes valeues "right", "left", "top", "bottom", or "none" (no legend).

df <- data.frame(x = 1:3, y = 1:3, z = c("a", "b", "c"))
base <- ggplot(df, aes(x, y)) +
  geom_point(aes(color = z), size = 3) +
  xlab(NULL) +
  ylab(NULL)

base + theme(legend.position = "right") #default
base + theme(legend.position = "bottom")
base + theme(legend.position = "none")

#switching between left/right and top/bottom modifies how keys in each legend are laid out (horizontal or vertically) and how multiple legends are stacked (horizontal or vertically).  If needed, you can adjust those options independently:
#legend.direction: layout of items in legends ("horizontal" or "vertical")
#legend.box: arrangement of mulitple legends ("horizontal" or "vertical")
#legend.box.just: justification of each legend within the overall bounding box, when there are multiple legends ("top", "bottom", "left", or "right")

#control which corner of the legend the legend.position refers to with legend.justification, which is specified in a similar way.  

base <- ggplot(df, aes(x, y)) +
  geom_point(aes(color = z), size = 3)

base + theme(legend.position = c(0, 1), legend.justification = c(0, 1))
base + theme(legend.position = c(0.5, 0.5), legend.justification = c(0.5, 0.5))
base + theme(legend.position = c(1, 0), legend.justificiation = c(1, 0))

####12.4.3 Guide functions
#guide functions: guide_colorbar() and guide_legend(), offer additional control over the fine details of the legend.  Legend guides can be used for any aesthetic (discrete or continuous) while the color bar guide can only be used with continuous color scales.

#you can override the default guide using the guide argument of the correspondign scale function, or more conveniently, the guides() helper function.  guides() works like labs(): you can override the defualt guide associated with each aesthetic.

df <- data.frame(x = 1, y = 1:3, z = 1:3)
base <- ggplot(df, aes(x, y)) + geom_raster(aes(fill = z))
base
base + scale_fill_continuous(guide = guide_legend())
base + guides (fill = guide_legend())

#both functions have numerous examples in their documentation help pages that illustrate all of tehir arguments.  Most arugemnts to the guide function conrol the fine level details of the text color, size, font etc.  You'll learn about those in the themes chapter.  

#12.4.3.1 guide_legend()
#the legend guide displays individual keys in a table.  Most useful options:
 #nrow or ncol which specify the dimensons of the dimensions of the table.  byrow controls how the table is filled: FALSE fills it by column (the default), TRUE fills it by row

df <- data.frame(x = 1, y = 1:4, z = letters[1:4])
#base plot
p <- ggplot(df, aes(x,y)) + geom_raster(aes(fill = z))
p
p + guides(fill = guide_legend(ncol = 2))
p + guides(fill = guide_legend(ncol = 2, byrow = TRUE))

#reverse: reverses the order of the keys.  useful when you have stacked bars becuase the dfault stacking and legend orders are different

p <- ggplot(df, aes(1, y)) + geom_bar(stat = "identity", aes(fill = z))
p
p + guides(fill = guide_legend(reverse = TRUE))

#override.aes: override some of the aesthetic settings derived from each layer.
#keywidth and keyheight(along with default.unit) allow you to specify the sizse of the keys.  These are gride units, e.g. unit (1, "cm")

####12.4.3.2 guide_colorbar----
#color bar guide is designed for continous ranges of colors - as its name implies, it outputs a rectangel over which the color gradient varies.  Most impotant arguments:
 #barwidth and barheight (along with default.unit) allow yo to specify the sizse of the bar.  These are gride units, eg unit(1, "cm")
 #nbin controls the number of slices  #default value=20.
 #reverse flips the color bar to put the lowest values at th etop

df <- data.frame (x = 1, y = 1:4, z = 4:1)
p <- ggplot(df, aes(x, y)) + geom_tile(aes(fill = z))

p
p + guides(fill = guide_colorbar(reverse + TRUE))
p + guides(fill = guide_colorbar(barheight = unit(4, "cm")))

#12.4.4 Exercises
#1 How do you make legends appear to the left of the plot?


#2. What's gone wrong with this plot? How could you fix it?
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_color_discrete("Drive train")

#3. Can you recreate the code for this plot?

####12.5 Limits ----
#The limits, or domain, of a scale are usually derived from the range of the data.  There are 2 reasons you might want to specify limits rather than relying on the data:
 #1. You want to make limits smaller than the range of the data to focus on an interesting area of the plot.
 #2. You want to make the limits larger than the range of the data because you want multiple plots to match up.

#Limits of position scales: they map directly to the ranges of the axes.  Limits also apply to scales that have legends, like color, sizse, and shape.  
#you can modify the limits using the limits parameter of the scale:
 #for continuous scales: should be a numeric vector of length 2.  If you only want to set the upper or lower limit, you can set the other value to NA.
 #for discrete scales: character vector which enumerates all possible values.

df <- data.frame(x = 1:3, y = 1:3)
base <- ggplot(df, aes(x, y)) + geom_point()

basebase + scale_x_continuous(limits = c(1.5, 2.5))
#>Warning: Removed 2 rows containing missing values (geom_point)
base + scale_x_continuous(limits = c(0, 4))

#xlim(10,20): continous scale from 10 to 20
#ylim(20, 10): reversed continous scale from 20 to 10
#xlim("a", "b", "c"): a discrete scale
#xlim(as.Date(c("2000-05-01", "2008-08-01))): a date scale from May 1 to August 1 2008

base + xlim(0, 4)
base + xlim(4, 0)
base + lims(x = c(0, 4)) 

#to eliminate the space of the range of the axes that extend past the limits you've specific. expand = c(0, 0).  

ggplot(faithfuld, aes(waiting, eruptions)) +
  geom_raster(aes(fill = density)) + 
  theme(legend.position = "none")
ggplot(faithfuld, aes(waiting, eruptions)) +
  geom_raster(aes(fill = density)) +
  theme(legend.position = "none")
ggplot(faithfuld, aes(waiting, eruptions)) +
  geom_raster(aes(waiting, eruptions)) +
  geom_raster(aes(fill = density)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0,0)) +
  theme(legend.position = "none")

#by default, any data outside the limits is converted to NA. Thus, settting the limits is not the same as visually zooming in to a region of the plot.  To do that, you need to use the xlim and ylim arguments to coord_cartesian().  This performs purely visual zooming, and does not affect the underlying data.  You can override thsi with the oob(out of bounds) argument to the scale.  The default is scales::censor() which replaces any value outside limits with NA.  Another option is scales::squish() which squishes all values into the range:
df <- data.frame(x = 1:5)
p <- ggplot(df, aes(x, 1)) + geom_tile(aes(fill = x), color = "white")
p
p + scale_fill_gradient(limits = c (2, 4))
p + scale_fill_gradient(limits = c(2, 4), oob = scales::squish)

####12.5.1 Exercises ----
#1. The following code creates two plots of the mpg dataset.  Modify the code that the legend and axes match, without using facetting!
fwd <- subset(mpg, drv == "f")
rwd <- subset(mpg, drv == "r")

ggplot(fwd, aes(displ, hwy, color = class)) + geom_point()
ggplot(rwd, aes(displ, hwy, color = class)) + geom_point()

#2.  What does expand_limits() do and how does it work?  Read the source code

#3.  What happens if you add 2 xlim() calls to the same plot?  Why?

#4. What does scale_x_continuous(limits = c(NA, NA)) do?

####12.6 Scales Toolbox ----
#along with changing options of the default scales, you can also override them completely with new scales.  Scales can be divided into ~4 families:
 #Continuous position scales used to map integer, numeric, and data/time data to x and y position
 #Color scales, used to map continuous and discrete data to colors
 #Manual scales, used to map discrete variables to your choice of size, line type, shape, or color
 #Identity scale, paradoxically used to plot variables without scaling them.  Useful if you data is already a vector of color names

####12.6.1 Continuous position scales ----
#every plot has 2 position scales, x and y.  Most common continuous position scales are scale_x_continuous() and scale_y_continuous(), which linearly map data to the x and y axis.  Most interesting variations are produced usign transformations.  Every continuous scales takes a trans argument, allowing the use of a variety of transformations:
#convert from fuel economy to fuel consumption
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(trans = "reciprocal")

#Log transform x and y axes 
ggplot(diamonds, aes(price, carat)) +
  geom_bin2d() +
  scale_x_continuous(trans = "log10") +
  scale_y_continuous(trans = "log10")

#the transformatoin is carried out by a "transformer" which describes the transformation, its inverse, and how to draw the labels.  There are many variants.

#there are shortcuts for the most common: scale_x_log10(), scale_x_sqrt() and scale_x_reverse() (similarly for y)

#you can also perform the transformation yourself.  Ex. instead of using scale_x_log10(), you could plot log10(x).  The appearance of the geom will be the same but the tick labels will be different.  If you use a transformed scale the axes will be labelled in the original daa space; if you transform the data, axes will be labelled in the transformed space. transformation occurs before any statistical summaries.  To trasnform, AFTER statistical computation, use coord_trans()

#date and date/time data are continuous variables with special labels.  ggplot works with Date(for dates) and POSIXct (for date/times) classes: if dates are in a different format you will need to convert them with as.Date() or as.POSIXct().  scale_x_date() and scale_x_datetime() work similarly to scale_x_continuous() but have special date_breaks adn date_labels arguments that work in date-friendly units.
#date_breaks and date_minor_breaks() allows you to position breaks by date units (years, months, weeks, days, hours, minutes, and seconds). ex. date_breaks = "2 weeks" will place a minor tick mark every 2 weeks
#date_labels controls the display of labels using the same formatting strings as in strptime() and format()

#ex. if you wanted to dsiplay dates like 14/10/1979, you would use the string "%d/%m/%Y"
base <- ggplot(economics, aes(date, psavert)) +
  geom_line(na.rm = TRUE) +
  labs(x = NULL, y = NULL)

#base #default breaks and labels
base + scale_x_date(date_labels = "%y", date_breaks = "5 years")

base + scale_x_date(
  limits = as.Date(c("2004-01-01", "2005-01-01")),
  date_labels = "%b %y",
  date_minor_breaks = "1 month"
)

base + scale_x_date(
  limits = as.Date(c("2004-01-01", "2004-06-01")),
  date_labels = "%m/%d",
  date_minor_breaks = "2 weeks"
)

####12.6.2 Color----
#Many different ways of mapping values to colors in ggplot2: four different gradient-based methods for continuous values, and 2 methods for mapping discrete values.  
#color thory is complex.  At the physical level, color is produced by a mixture of wavelengths of light.  To characterize color completely, we need to know the complete mixture of wavelengths.  Here, using HCL color space, which has 3 components of hue, chroma and luminance:
 #hue: number between 0 and 360 (an angle) which gives the "color of the color: blue, red, orange, etc.
 #chorma: purity of a color.  A chroma of 0 is grey, and the maximum value of chroma varies with luminance.
 #luminance: the lightness of the color.  A luminance of 0 produces black, and a luminance of 1 produces white.

#Hues are not perceived as being ordered: ex. green does not seem "larger" than red. Perception of chroma and luminance are ordered.

#there are packages that take into account color-blindness.

####12.6.2.1 Continuous
#color gradients are often use dto show the height of a 2d surface.
erupt <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_x_continuous(NULL, expand = c(0, 0)) +
  scale_y_continuous(NULL, expand = c(0, 0)) +
  theme(legend.position = "none")

#4 continuous color scales
 #scale_color_gradient() and scale_fill_gradient(): 2-color gradient, low-high(light blue-dark blue).  Default scale for continuous color, and is the same as scale_color_continuous().  Arguments low/high control the colors at either end of the gradient. For continous color scales, you want to keep hue constant, and vary chroma and luminance. munsell::hue_slice("5Y") to see valid chroma and luminance values for a given hue

erupt

erupt + scale_fill_gradient(low = "white", high = "black")

erupt + scale_fill_gradient(
  low = munsell::mnsl("5G 9/2"),
  high = munsell::mnsl("5G 6/8")
)
#scale_color_gradient2() and scale_fill_gradient2(): a 3-color gradient, low-med-high(red-white-blue).  As well as the low/high colors, these scales also have a mid color for the color of the midpoint.  The midpoint defaults to 0 but can be set to any value with the midpoint argument.
mid <- median(faithfuld$density)
erupt + scale_fill_gradient2(midpoint = mid)

#scale_color_gradientn() and scale_fill_gradientn(): custom n-color gradient.  Useful if you ahve colors that are meaningful for your data, or you'd like to use a palette produced by another package.  Below code produces palettes generated from routines in the colorspace pacakage.
erupt + scale_fill_gradientn(colors = terrain.colors(7))
erupt + scale_fill_gradientn(colors = colorspace::heat_hcl(7))
erupt + scale_fill_gradientn(colors = colorspace::diverge_hcl(7))

#by defualt, colors will be evenly spaced along range of the data.  To make them unevenly spaced, use values argument, which should be a vector of values between 0 and 1.

#scale_color_distiller() and scale_fill_distiller() apply ColorBrewer color scales to continous data.  Use it the same way as scale_filL_brewer():
erupt + scale_fill_distiller()
erupt + scale_fill_distiller(palette = "RdPu")
erupt + scale_fill_distiller(palette + "Y10rBr")

#all continuous color scales have an na.value parameter that controls what color is used for missing values (including values outside the range of the scale limits).  Defulat is set to grey, which will stand out when you use a colorful scale. If yuse a black/white scale, you may want to set it to something else to make it more obvious.

df <- data.frame(x = 1, y = 1:5, z = c(1, 3, 2, NA, 5))
p <- ggplot (df, aes(x, y)) + geom_tile(aes(fill = z), size = 5)
p
#make missing colors invisible
p + scale_fill_gradient(na.value = NA)
#customize on a black/white scale
p + scale_fill_gradient(low = "black", high = "white", na.value = "red")

####12.6.2.2 Discrete
#there are 4 scales for discrete data.  
df <- data.frame(x = c("a", "b", "c", "d"), y = c(3, 4, 1, 2))
bars <- ggplot(df, aes(x, y, fill = x)) +
  geom_bar(stat = "identity") +
  labs(x = NULL, y = NULL) +
  theme(legend.position = "none")

#scale_color_hue(): default color scheme.  picks evenly spaced hues around the HCL color wheel.  Can control defulat chroma and luminance, and the range of hues, with the h, c, and l arguments.  Dafault color scheme has the colors all with same luminance and chroma: when you print in black/white, they all appear as an identical shade of grey.

bars 
bars + scale_fill_hue(c = 40)
bars + scale_fill_hue(h = c(180, 300))

#scale_color_brewer() uses "ColorBrewer" colors.  They are designed to work well in many situations, though they focus on maps so they work better when displayed on large areas.  Categorical data: best palettes are "Set1" and "Dark2"f for points and "Set2", "Pastel1", "Pastel2" and "Accent" for area.  RColorBrewer::display.brewer.all() to list all palettes

bars + scale_fill_brewer(palette = "Set1")
bars + scale_fill_brewer(palette = "Set2")
bars + scale_fill_brewer(palette = "Accent")

#scale_color_grey() maps discrete data to grays, from light to dark
bars + scale_fill_grey()
bars + scale_fill_grey(start = 0.5, end = 1)
bars + scale_fill_grey(start = 0, end = 0.5)

#scale_color_manual() useful if you have your own discrete color palette.  Examples from wesanderson movies:
library(wesanderson)
bars + scale_fill_manual(values = wes_palette("GrandBudapest1"))
bars + scale_fill_manual(values = wes_palette("Zissou1"))
bars + scale_fill_manual(values = west_palette("Rushmore1"))

#One set of colors is not uniformly good for all purposes: bright colors work well for points, but are overwhelming on bars. Subtle colors work well for bars, but are hard to see on points.

#Bright colors work best with points
df <- data.frame(x = 1:3 + runif(30), y = runif(30), z = c("a", "b", "c"))
point <- ggplot(df, aes(x, y)) +
  geom_point(aes(color = z)) +
  theme(legend.position = "none") +
  labs(x = NULL, y = NULL)
point + scale_color_brewer(palette = "Set1")
point + scale_color_brewer(palette = "Set2")
point + scale_color_brewer(palette = "Pastel1")

#Subler colors work better with areas
df <- data.frame(x = 1:3, y = 3:1, z = c("a", "b", "c"))
area <- ggplot(df, aes(x, y)) +
  geom_bar(aes(fill = z), state = "identity") +
  theme(legend.position = "none") +
  labs(x = NULL, y = NULL)
area + scale_fill_brewer(palette = "Set1")
area + scale_fill_brewer(palette = "Set2")
area + scale_fill_brewer(palette = "Pastel1")

####12.6.3: The manual discrete scale ----
#The discrete scales (ex. scale_linetype(), scale_shape(), and scale_color_discrete()) have basically non options.  The scales are just a list of valid values that are mapped to the unique discrete values.
#If you want to customize the scales, you need to create your own new scale with the "manual" version of each: scale_linetype_manual(), scale_shape_manual(), scale_color_manual() etc.  The manual scale has one important argument, values, where you specify the values that the scale should produce.  If this vecotr is name, it will match the values of the output to the values of the input; otherwise it will match in order of the levels of the discrete variable.  You will need some knowledge of the valid aesthetic values, described in vignette("ggplot2-specs")
#following code demonstrates the use of scale_color_manual():
plot <- ggplot(msleep, aes(brainwt, bodywt)) +
  scale_x_log10() +
  scale_y_log10()
plot +
  geom_point(aes(color = vore)) +
  scale_color_manual(
    values = c("red", "orange", "green", "blue"),
    na.value = "grey50"
)    

colors <- c(
  carni = "red",
  inscti = "orange",
  herbi = "green",
  omni = "blue"
  )

plot +
  geom_point(aes(color = vore)) +
  scale_color_manual(values = colors)

#examples below: display variableson the same plot and show a useful legend.  

huron <- data.frame(year = 1875:1972, level = as.numeric(LakeHuron))
ggplot(huron, aes(year)) +
  geom_line(aes(y = level + 5), color = "red") +
  geom_line(aes(y = level - 5), color = "blue")

#no way to add a legend manually for above plot.  Give lines informative labels:

ggplot(huron, aes(year)) +
  geom_line(aes(y = level + 5, color = "above")) +
  geom_line(aes(y = level - 5, color = "below"))

ggplot(huron, aes(year)) +
  geom_line(aes(y = level + 5, color = "above")) +
  geom_line(y = level - 5, color = "below") +
  scale_color_manual("Direction", 
                     values = c("above" = "red", "below" = "blue"))

####12.6.4 The identity scale ----
#The identity scale is used when your data is already scales, when the data and aesthetic spaces are the same.  Below code: example of where identity scale is useful.  luv_colors contain the location of all R's built-in colors in the LUV color space (the space the HCL is based on).  Legend is unnecessary, because the point color represents iself: data and aesthetic spaces are the same.
head(luv_colors)

ggplot(luv_colors, aes(u, v)) +
  geom_point(aes(color = col), size = 3) +
  scale_color_identity() +
  coord_equal()

####12.6.5 Exercises----
#1. Compare and contrast the four continous color scales with the four discrete color scales.
#2. Explore the distribution of the built-in colors() using the luv_colors dataset.
                          
                          
                          
                         

                         


