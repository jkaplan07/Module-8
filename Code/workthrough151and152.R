#Work through Chp 15.1 adn 15.2.
#15: Themes

#15.1 Introduction ----
#ggplot theme system: aloows you to exercise fine control over the non-data elements of your plot.  Does not affect how the data is renered by geoms, or how it is transformed by scales.  Themes do not change perceptual properties of the plot, but htey help make plot aesthetically pleasing or match an existing style guide.  They give you control over things like fonts, thicks, panel strips adn backgrounds.
#separation of control into data and non-data parts is quite different from base and lattice graphics.  ggplot: when creating the plot you determine how the data are displace, then after it has been created you edit every detail of the rendering, using the theming system.
#The theming system is composed of 4 main components:
 #elemtnts: specify the non-data elements that you can control.  Ex. plot.title element controls the appearance of the plot title; axis.ticks.x, the ticks on the x axis; legend.key.height, heigh of the keys in the legend.
 #element function: describes the visual properties of the elemtn. Ex. element_text() sets the font size, color and face of text elements like plot.title.
 #theme() function allows you to override the default theme elements by calling element functions, like theme(plot.title = element_text(color = "red"))
 #complete themes, like theme_grey() set all theme elements to values designed to work together harmoniously.

##15.3 Modifying theme components ----
#to modify an individual theme component you use code like plot + theme(element.name = element_function()).  
#four basic types of built-in element functions: text, lines, rectangels, and blanck.  Each element function has a set of parameters that control the appearance:
 #element_text() draws labels and headings.  You can control the font family, face, color, sizse (in points), hjust, vjust, angle (in degrees) and linehight(as ratio of fontcase).  Details can be found in vignette("ggplto2-specs")  SEtting the font face is particularly challenging
base_t <- base + labs(title = "This is a ggplot") + xlab(NULL) + y_lab(NULL)
base_t + theme(plot.title = element_text(size = 16))
base_t + theme(plot.title = element_text(face = "bold", color = "red"))
base_t + theme(plot.title = element_text(hjust = 1))

#you can control the margins around the text with the margin argument and margin() function.  margin() has 4 arguments: the amount of space(in points) to the top, right, bottom, and left sides of the text.  Any elements not specified default to 0

#the margins here look asymmetric becasue there are also plot margins
base_t + theme(plot.title = element_text(margin = margin()))
base_t + theme(plot.title = element_text(margin = margin(t = 10, b = 10)))
base_t + theme(axis.title.y = element_text(margin = margin(r = 10)))

 #element_line() draws lines parameterized by color, sigze and linetype:
base + theme(panel.grid.major = element_line(color = "black"))
base + theme(panel.grid.major = element_line(size = 2))
base + theme(panel.grid.major = element_line(linetype = "dotted"))
 #element_rect() draws rectangles, mostly used for backgrounds, parameterized by fille color and border color, size, and linetype
base + theme(plot.background = element_rect(fill = "grey80", color = NA))
base + theme(plot.background = element_rect(color = "red", size = 2))
base + theme(panel.background = element_rect(fill = "linen"))

#element_blank() draws nothing.  Use this if you don't want anything drawn, and no space allocated for the element.  The plot will automatically relcaim the space previously used by these elemtns: if you don't want this to happen, use color = NA, fill = NA to create invisible elemtns that still take up space

base
last_plot() + theme(panel.grid.minor = element_blank())
last_plot() + theme(panel.grid.major = element_blank())

last_plot() + theme(panel.background = element_blank())
last_plot() + theme(
  axis.title.x = element_blank(),
  axis.title.y = element_blank()
)
last_plot() + theme(axis.ine = element_line(color = "grey50"))

#a few other settings take grid units. create them with unit(1, "cm" or unit(0.25, "in"))

#to modify theme elements for all future plots, use theme_update().  It reutrns the previous theme settings, so you can restore to the original parameters once you're done.

old_theme <- theme_update(
  plot.background = element_rect(fill = "lightblue3", color = NA),
  panel.background = element_rect(fill = "lightblue", color = NA),
  axis.title = element_text (color = "linen"),
  axis.title = element_text (color = "linen")
)
base
theme_set(old_theme)
base

####15.4 theme elements ----
#there are ~40 unique elements that control the appearance of the plot.  They can be roughly grouped into 5 categories: plot, axis, legend, panel and facet.

####15.4.1 Plot elements
#some elements affect the plot as a whole:
#Element          Setter           Description
#plot.background  element_rect()   plot background
#plot.title       element_text()   plot title
#plot.margin      nargin()         margins around plot

#plot.background: draws a rectangle that underlies everything else on the plot.  by defualt, ggplot2 uses a white background which ensures that hte plot is usable wherever it might end up.  
base + theme(plot.background = element_rect(color = "grey50", size = 2))
base + theme(
  plot.background = element_rect(color = "grey50", size = 2),
  plot.margin = margin(2, 2, 2, 2)
)
base + theme(plot.background = element_rect(fill = "lightblue"))

#15.4.2 Axis Elements
#The axis elemnts control the appearance of the axes.
#Axis.text (and axis.title) come in three forms: axis.text, axis.tex.s and axis.text.y.  Use the first form if you want to modify the properties of box axes at ones: any properties that you don't explicitly set in axis.tex.x and axis.tex.y will be inherited from axis.text.

df <- data.frame(x = 1:3, y = 1:3)
base <- ggplot(df, aes(x, y) + geom_point())

#accentuate the axes
base + theme(axis.line = element_line(color = "grey50", size = 1))
#style both x and y axis labels
base + theme(axis.text = element_text(color = "blue", size = 13))
#useful for long labels
base + theme(axis.text.x = element_text(angle = -90, vjust = 0.5))

#most common adjustment is to rotate the x-axis labels to avoid long overlapping lables.  If you do this, note negative angles tend to look best and you should set hust = 0 and vjust = 1.
df <- dataframe(
  x = c("lable", "a long label", "an even longer label"),
  y = 1:3
)
base <- ggplot(df, aes(x, y)) + geom_point()
base
base +
  theme(axis.text.x = element_text(angle = -30, vjust = 1, hjust = 0)) +
  xlab(NULL) +
  ylab(NULL)

#15.4.3 Legend elements
#the legend elements control the appearance of all elgends. You can also modify the appearance of individual legends by modifying the same elements in guide_legend() or guide_colorbar()

df <- data.frame(x = 1:4, y = 1:4, z = rep(c("a", "b"), each = 2))
base <- ggplot(df, aes(x, y, color = z)) + geom_point()

base + theme(
  legend.background = element_rect(
    fill = "lemonchiffon",
    color = "grey50",
    size = 1
  )
)

base + theme(
  legend.key = element_rect(color = "grey50"),
  legend.key.width = unit(-.9, "cm"),
  legend.key.height = unit(-0.75, "cm")
)
base + theme(
  legend.text = element_text(size = 15),
  legend.title = element_text(size = 15, face = "bold")
)

#there are 4 other properties that control how legends are laid out in teh context of the plot (legend.position, legend.direction, legend.justification, legend.box)

#15.4.4 Panel elments.
#panel elements control the appearance of the plotting panels.
#the main difference between panel.background and panel.border is that the background is drawn underneath the data, and the border is drawn on top of it.  For that reason, you always need to assign fill = NA when overriding panel.border.

base <- ggplot(df, aes(x.y)) + geom_point()

#modify background
base + theme(panel.background = element_rect(fill = "lightblue"))

#tweak major grid lines
base + theme(
  panel.grid.major = element_line(color = "gray60", size = 0.8)
)

#just in one direction
base + theme(
  panel.grid.major.x = element_line(color = "gray60", size = 0.8)
)

#aspect ratio controls the aspect ratio of the panel, not the overall plot:

base2 <- base + theme(plot.background = element_rect(color = "grey50"))

#widescreen
base2 + theme(aspect.ratio = 9/16)
#long and skinny
base2 + theme(aspect.ratio = 2/1)
#square
base2 + theme(aspect.ratio = 1)


#15.4.5 Facetting elements
#element strip.text.x affects both facet_wrap() or face_grid(); strip.text.y only affects facet_grid()

df <- data.frame(x = 1:4, y = 1:4, z = c("a", "a", "b", "b"))
bae_f <- ggplot(df, aes(x, y)) + geom_point() + facet_wrap(~z)

base_f
base_f + theme(panel.margin = unit(0.5, "in"))

base_f + theme(
  strip.background = element_rect(fill = "grey", color = "grey80", sizse = 1),
  strip.text = element_text(color = "white")
)

