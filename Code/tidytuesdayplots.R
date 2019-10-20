#tidytuesday

####Clear workspace and load packages ----
rm(list=ls(all=TRUE))
library(tidyverse)
library(lubridate)
library(viridis)
library(colorspace)
library(dplyr)

#get the data
student_ratio <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-07/student_teacher_ratio.csv")

# look at the data
str(student_ratio) #looks at structure of the data
head(student_ratio) #check top of data 
tail(student_ratio) #check bottom of data 
dim(student_ratio) #check n's
summary(student_ratio)

#plot 1: line graph of world primary education teacher-student ratio
student_ratio %>%
  filter(country == "World") %>%
  #hcl_rainbow(indicator, n = 5) %>%
  ggplot (aes(x = year, y = student_ratio, color = indicator)) +
  geom_line() +
  geom_point() +
  theme_bw() + 
  labs (
    x = "Year", 
    y = "Teacher:Student Ratio", 
    title = "Global Secondary Education \n Teacher:Student Ratio"
  ) +
  theme (axis.text.x = element_text(angle = 90)) +
  scale_color_manual(name = "Education Type", values=c("goldenrod", "blueviolet", "firebrick1", "darkturquoise", "forestgreen"))

#plot 2

