#tidytuesday

####Clear workspace and load packages ----
rm(list=ls(all=TRUE))
library(RColorBrewer)
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
  ggplot (aes(x = year, y = student_ratio, color = indicator)) +
  geom_line() +
  geom_point() +
  theme_classic() + 
  labs (
    x = "Year", 
    y = "Student: Teacher Ratio", 
    title = "Global Education Student: Teacher Ratio by Education Type"
  ) +
  theme(plot.title=element_text(hjust = 0.5)) +
  scale_color_manual(name = "Education Type", values=c("goldenrod", "blueviolet", "firebrick1", "darkturquoise", "forestgreen"))

#plot 2
student_ratio %>%
  filter(country_code == "USA") %>%
  filter(year == 2015) %>%
  select(indicator, student_ratio) %>%
  ggplot(aes(x = indicator, y = student_ratio)) + 
  geom_col(col = "grey9", fill="grey9") +
  theme_classic() +
  labs (
    x = "Education Level", 
    y = "Student: Teacher Ratio", 
    title = "USA Student: Teacher Ratio by Education Level in 2015" 
  ) +
  theme(plot.title=element_text(hjust = 0.5)) 

#plot 3: Extra Credit
student_ratio %>%
  filter(indicator == "Secondary Education") %>%
  filter(country %in% c("Lower middle income countries",
                      "World",
                      "High income countries",
                      "Latin America and the Caribbean",
                      "Middle income countries",
                      "Sub-Saharan Africa",
                      "Central and Eastern Europe",
                      "North America and Western Europe",
                      "Upper middle income countries")) %>%
  ggplot (aes(x = year, y = student_ratio, color = country)) +
  geom_line(size=2, linetype="12345678") +
  geom_point(size=5, shape=19) +
  theme_minimal() + 
  scale_y_log10() +
  labs (
    x = "Year", 
    y = "Student: Teacher Ratio", 
    title = "Global Education Teacher:Student Ratio by Region"
  )  + 
  theme(plot.title=element_text(hjust = 0.5)) +
  theme(panel.background = element_rect(fill = "maroon1",
                                  colour = "olivedrab1",
                                  size = 0.5, linetype = "solid"),
  panel.grid.major = element_line(
    size = 0.5, 
    linetype = 'dotdash',
    colour = "yellow"), 
  panel.grid.minor = element_line(size = 0.75, 
                                  linetype = 'dashed',
                                  colour = "orchid1")
) +
  scale_color_manual(name = "Region", values=c("#08306b", "#4292c6","#f7fbff","#2171b5","#08519c","#c6dbef","#6baed6","#9ecae1","#deebf7"))

