# Part 1 --------------------------------------

install.packages("readr")
library(readr)
library(bbmle)
library(tidyr)
library(ggplot2)
library(tidyverse)
install.packages("ggpubr")
library(ggpubr)

bbs <- read.csv("https://raw.githubusercontent.com/rymeb98/statistical-ecology/refs/heads/main/FL_BBS.csv", header = TRUE)

#BBS data mle2 models
#because there are NAs in my dataset
bbs <- na.omit(bbs)
#I have to rescale a number of the predictor variables because of their size
bbs$Year_s   <- scale(bbs$Year, scale = FALSE)
bbs$Lat_s    <- scale(bbs$Latitude)
bbs$Long_s   <- scale(bbs$Longitude)
bbs$Precip_s <- scale(bbs$mean_annual_precip)
bbs$Temp_s <- scale(bbs$mean_annual_temp)
# frac_built stays as-is since it's already 0–1

#The following model was previously (Assignment 4) determined to be the best model I found to determine TotalSpp.
#This model assumes that TotalSpp is a function of Year, latitude, longitude, mean annual precipitation, fraction built of the route, and mean annual temperature, 
#with all of these predictor variables having an interaction with each other, in other words saying that as any predictor variable changes, all the other predictor 
#variables will also change their affect on TotalSpp. 
bbs.fit.ancova.r <- lm(data = bbs,
                       formula = TotalSpp ~ Year_s * Precip_s * Temp_s * frac_built * Lat_s * Long_s)
bbs.fit.ancova.r

bbs.fit.ancova.r1 <- lm(data = bbs,
                       formula = TotalSpp ~ Year_s * Precip_s * Temp_s)
bbs.fit.ancova.r1

bbs.fit.ancova.r2 <- lm(data = bbs,
                        formula = TotalSpp ~ Year_s + Precip_s + Temp_s)
bbs.fit.ancova.r2

bbs.fit.ancova.r3 <- lm(data = bbs,
                        formula = TotalSpp ~ Year_s * Precip_s * Temp_s * frac_built)
bbs.fit.ancova.r3

bbs.fit.ancova.r4 <- lm(data = bbs,
                        formula = TotalSpp ~ Year_s + Precip_s + Temp_s + frac_built)
bbs.fit.ancova.r4

AICtab(bbs.fit.ancova.r, bbs.fit.ancova.r1, bbs.fit.ancova.r2, bbs.fit.ancova.r3, bbs.fit.ancova.r4)
#This still states that the bbs.ancova.r model is the best, but due to its confusing nature it may be better to use bbs.ancova.r1 or bbs.ancova.r3,
#where the only predictors are Year, mean annual precip and mean annual temp, potentially also adding frac_built 
#all of which having an interaction with each other. So to try to understand this interaction I will do multiple scatter plots.

#classes
sapply(bbs, class)

class(bbs$Route)
#class for Route is integer however it should be a character so the following code changes it to that
bbs$Route<-as.character(bbs$Route)
class(bbs$Route)

class(bbs$Year)
#class for Year is integer

class(bbs$ORDER)
#class for ORDER is character

class(bbs$Family)
#class for Family is character

class(bbs$Genus)
#class for Genus is character

class(bbs$Scientific_Name)
#class for Scientific_Name is character

class(bbs$total_sightings)
#class for total_sightings is integer

class(bbs$TotalSpp)
#class for TotalSpp is integer

class(bbs$footprint)
#class for footprint is integer


#I wanted to try to plot how the TotalSpp in 1997 changes over location (Route). So I ran the following code. 
#Note: this did not yield me valuable info bc of the amount of Routes and more specifically bc of the fact that there are a lot of gaps in Route #
#Scatterplot showing how the TotalSpp in Route 1 changes over time (Year). 
#Note: this showed what seems to be a relative up trend in total spp over time; however 2015 and 2016 had notably less total spp.
#which begs the questions of what happened those years to yield notably less total spp in that Route.

#^ in a paper I would redo this for each route to see if I can spot trends.
#The following code is an example of how to view the total spp distribution of each route in a given year
bbs_1997 <- bbs %>% filter(Year == 1997)
bbs_1997
class(bbs_1997)
summary(bbs_1997)
class(bbs_1997$Route)
class(bbs_1997$TotalSpp)
bbs_1997$Year <- as.numeric(bbs_1997$Year)
class(bbs_1997$Year)
bbs_1997$TotalSpp <- as.numeric(bbs_1997$TotalSpp)
class(bbs_1997$TotalSpp)
bbs_1997$total_sightings <- as.numeric(bbs_1997$total_sightings)
class(bbs_1997$total_sightings)

plot(bbs_1997$Route, bbs_1997$TotalSpp)

#Figure 1: histogram showing the distribution of Total Spp across the observation period
bbs |> 
  ggplot(mapping = aes(x = TotalSpp)) +
  geom_histogram()
#Shows a normal distribution

#Scatterplot showing how the TotalSpp changes over time (Year). 
#I tried a couple ggplots with it (below) but it proved to still not yield any valuable information, 
#leading me to believe that I would need to have many different figures picking this figure apart.

#line graph
bbs |>
  group_by(Year) |>
  ggplot(aes(x = Year, y = TotalSpp, colour = Route)) +
  geom_line()

#scatterplot
bbs |>
  group_by(Year) |>
  ggplot(aes(x = Year, y = TotalSpp, colour = Route)) +
  geom_point()
#The results here are far too cluttered,
#So, instead of going wide scale with this data for this project, I am going to home in on specific attributes.

#Figure 2 geom_bar for mean_sightings of each ORDER not discriminating by year or route, just the study as a whole
summary(unique(bbs$ORDER)) #this was to determine what the n = value should be in the slice_max portion of the geom_barcode
#n = 20

bbs |>
  group_by(ORDER) |>
  summarise(mean_sightings = mean(total_sightings)) |>
  slice_max(n = 20, order_by = mean_sightings) |>
  ggplot(aes(x = ORDER, y = mean_sightings, fill = ORDER)) +
  geom_col() +
  guides(fill = guide_legend(title = "ORDER")) +
  labs(
    x = "Bird Order",
    y = "Mean Total Sightings") +
  theme(
    axis.text.x  = element_blank(),      # hide category labels
    axis.ticks.x = element_blank(),      # hide ticks below bars
  ) 

#Figure 3: geom_bar for total_sightings of each ORDER
bbs |>
  group_by(ORDER) |>
  summarise(total_sightings = total_sightings) |>
  slice_max(n = 20, order_by = total_sightings) |>
  ggplot(aes(x = ORDER, y = total_sightings, fill = ORDER)) +
  geom_col() +
  guides(fill = guide_legend(title = "ORDER")) +
  labs(
    x = "Bird Order",
    y = "Total Sightings") +
  theme(
    axis.text.x  = element_blank(),      # hide category labels
    axis.ticks.x = element_blank(),      # hide ticks below bars
  ) 


#Figure 4: The code below prints out a scatter plot that looks at how the mean Total species changes over the years of the observations, not really caring for Route differences.
#I try out a version of the code with a linear model for the trend line and one without, for completions sake
bbs |>
  group_by(Year) |>
  summarise(mean_tspp = mean(TotalSpp)) |>
  ggplot(aes(x = Year, y = mean_tspp)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) + #this is so the trend line is linear
  labs(
    x = "Year of Surveys",
    y = "Mean Total Number of Species"
  )

bbs |>
  group_by(Year) |>
  summarise(mean_tspp = mean(TotalSpp)) |>
  ggplot(aes(x = Year, y = mean_tspp)) +
  geom_point() +
  geom_smooth(se = TRUE) + #This is so the trend line is not linear
  labs(
    x = "Year of Surveys",
    y = "Mean Total Number of Species"
  )

cor.test(bbs$Year, bbs$TotalSpp, method = "pearson")
# -0.1526262 : weak negative cor, but has a significant p val.


#Figure 5: Scatter plot comparing Total spp by mean_annual_precip (MAP). I also do a version of the code with and without an lm method for the trend line, and will be doing so for the next few analyses.
bbs |>
  group_by(mean_annual_precip) |>
  summarise(mean_tspp = mean(TotalSpp)) |>
  ggplot(aes(x = mean_annual_precip, y = mean_tspp)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    x = "Mean Annual Precipitation (MAP)",
    y = "Mean Total Species")

bbs |>
  group_by(mean_annual_precip) |>
  summarise(mean_tspp = mean(TotalSpp)) |>
  ggplot(aes(x = mean_annual_precip, y = mean_tspp)) +
  geom_point() +
  geom_smooth(se = TRUE) +
  labs(
    x = "Mean Annual Precipitation (MAP)",
    y = "Mean Total Species")

cor(bbs$mean_annual_precip, bbs$TotalSpp)
#0.1885603 : weak positive cor.

cor.test(bbs$mean_annual_precip, bbs$TotalSpp, method = "pearson")
#same results but also shows that the p - val is significant (2.2*10^-16)

#Figure 6: Scatter plot looking at the relationship between Mean Annual Temp (MAT) and Mean Total Spp
bbs |>
  group_by(mean_annual_temp) |>
  summarise(mean_tspp = mean(TotalSpp)) |>
  ggplot(aes(x = mean_annual_temp, y = mean_tspp)) +
  geom_point() +
  geom_smooth(se = TRUE) +
  labs(
    x = "Mean Annual Temperature (MAT)",
    y = "Mean Total Species")


bbs |>
  group_by(mean_annual_temp) |>
  summarise(mean_tspp = mean(TotalSpp)) |>
  ggplot(aes(x = mean_annual_temp, y = mean_tspp)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    x = "Mean Annual Temperature (MAT)",
    y = "Mean Total Species")

cor(bbs$TotalSpp, bbs$mean_annual_temp)
#-0.3760006, weak-moderate negative cor.
cor.test(bbs$mean_annual_temp, bbs$TotalSpp, method = "pearson")
#Same results but again shows that the p-val is significant (2.2*10^-16)

#Figure 7: Scatterplot looking at the relationship between Mean Annual Precipitation (MAP) and Mean Annual temp (MAT)
bbs |>
  group_by(mean_annual_precip) |>
  reframe(mean_annual_temp = mean_annual_temp) |>
  ggplot(aes(x = mean_annual_precip, y = mean_annual_temp)) +
  geom_point() +
  geom_smooth(se = TRUE) + #error shades are there, just very small
  labs(
    x = "Mean Annual Precipitation (MAP)",
    y = "Mean Annual Temperature (MAT)")

bbs |>
  group_by(mean_annual_precip) |>
  reframe(mean_annual_temp = mean_annual_temp) |>
  ggplot(aes(x = mean_annual_precip, y = mean_annual_temp)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    x = "Mean Annual Precipitation (MAP)",
    y = "Mean Annual Temperature (MAT)")

cor.test(bbs$mean_annual_precip, bbs$mean_annual_temp, method = "pearson")
#Pearson's product-moment correlation

#data:  bbs$mean_annual_precip and bbs$mean_annual_temp
#t = -237.21, df = 75778, p-value < 2.2e-16 (This suggests a statistical relationship)
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
# -0.6568544 -0.6486825
#sample estimates:
#       cor 
#-0.6527875 

cor(bbs$mean_annual_precip, bbs$mean_annual_temp)
#-0.6527875 : Moderate-Strong negative cor.

#Figure 8: Scatter plot looking at how Total Spp changes based on fraction built.
bbs |>
  group_by(frac_built) |>
  summarise(mean_tspp = mean(TotalSpp)) |>
  ggplot(aes(x = frac_built, y = mean_tspp)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    x = "Fraction Built of Location",
    y = "Mean Total Species")

bbs |>
  group_by(frac_built) |>
  summarise(mean_tspp = mean(TotalSpp)) |>
  ggplot(aes(x = frac_built, y = mean_tspp)) +
  geom_point() +
  geom_smooth(se = TRUE) +
  labs(
    x = "Fraction Built of Location",
    y = "Total Species")

cor.test(bbs$frac_built, bbs$TotalSpp, method = "pearson")

cor(bbs$frac_built, bbs$TotalSpp)
# -0.1359886 : Weak neg cor, however also has a significant p-value

#Figure 9: Scatter plot looking at the relationship between fraction built and MAT
bbs |>
  group_by(frac_built) |>
  ggplot(aes(x = frac_built, y = mean_annual_temp)) +
  geom_point() +
  geom_smooth(se = TRUE) +
  labs(
    x = "Fraction Built of Location",
    y = "mean Annual temperature (MAT)")

bbs |>
  group_by(frac_built) |>
  ggplot(aes(x = frac_built, y = mean_annual_temp)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    x = "Fraction Built of Location",
    y = "mean Annual temperature (MAT)")

cor.test(bbs$frac_built, bbs$mean_annual_temp, method = "pearson")

cor(bbs$frac_built, bbs$mean_annual_temp)
# 0.1829762 : Weak positive cor, however also has a significant p-value

#I tried to do a histogram to look at the distribution of total sightings for each ORDER, but my code doesnt seem to produce the results i am looking for, so disregard this. i wantd to keep this in so I can work on it later.
bbs |> 
  group_by(ORDER) |>
  ggplot(mapping = aes(x = total_sightings)) +
  geom_histogram()

#The code below is NOT related to this assignment, I wanted to have this sample code in here in case I want(ed) to use a ridgeplot for my analyses.
#Joy plots / density ridges EDIT
install.packages("ggridges")
library(ggridges)
bbs |>
  group_by(ORDER) |>
  mutate(mean_sightings = mean(total_sightings)) |>
  ggplot(mapping = aes(x = mean_sightings,
                       y = ORDER, 
                       group = ORDER,
                       fill = ORDER)) +
  geom_density_ridges()


filter(Order1 %in% c("Struthioniformes",
                     "Cathartiformes",
                     "Gaviiformes",
                     "Sphenisciformes",
                     "Ciconiiformes")) |>
  



# Part 2 Writing about data ------------------------------------------------------
# Useful code

#This Part is written in word and submitted on my Github separately.
# Citing R

citation()

# Citing an R package

citation("bbmle")


#cite R
#cite packages
citation("ggplot2")
citation("bbmle")
citation("tidyr")
citation("readr")
citation("reshape")
citation("gplots")
citation("plotrix")
citation("dplyr")
citation("lattice")
citation("e1071")

#cite any papers you use
#cite chatgpt
