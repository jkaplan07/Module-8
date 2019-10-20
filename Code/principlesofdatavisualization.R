#Practical principles of data visualization video

#key principles:
 #choose an effective plot type
 #use color wisely
 #keep it simple

#choose an effective plot type
 #boxplot: distribution
 #bar: magnitude
 #line: change
 #scatter: correlation/relationship
 #heat map: pattern
 #pie: proportion

#each plot type come with trade offs, particularly in people being able to read/interpret your plot.

#different representations = different perceptions
#color: different colors, color intensity
#volume
#area
#angle
#length
#position

#people are not as good as good at differentiating between colors or color intensity.  much better at interpreting position (bar, boxplot, scatterplot are much better at showing subtle differences).

#colors may be good at showing trends comparatively to position.

#interpretability of pie charts is better when there is a straight up/down axis comparared to one that isn't

#stacked bar plots - easy to see the bottom one. ones on top, however, are harder to interpret.

#filled in line graphs - can obscure detail.

#using color wisely
#only use a color if you are mapping an attribute OR if you have a coordinated color scheme


#use "semantically - resonant" colors whenever possible
#ex. blue below sea level. green for areas low lying, and white for peaks of mountains.

#consider how the colors you use in your visualization will be interpreted by those with color blindness, and those who print in black and white

#colorbrewer: webpage.  specifically used for discrete color scale.
#print friendly: can be printed in greyscale.

#viridis package - for continuous color scales.  also shows how colors will look for color blind people and in greyscale.

#equal changes on ramp do not necessarily correspond to equal changes in value.
 #the only color ramp that addresses this issue is a 10%-90% black ramp

#improprer use of color is confusing/potentially misleading


#Keep it simple!
#create the simplest graph that conveys the information you want to convey.
#data-ink ratio = data-ink/total ink used to print the graphic



