library(emdbook)
library(ggplot2)
library(readr)
library(tidyverse)
library(bbmle)



bbs <- read.csv("https://raw.githubusercontent.com/rymeb98/statistical-ecology/refs/heads/main/FL_BBS.csv")

#The code between the lines are example code for lm and mle that I am taking referance for
#----------------------------------------------------------------------------------
avo.mle <- mle2(data = avo,
                minuslogl = Beak.Width ~ dnorm(mean = int + a*Beak.Depth,
                                               sd = sd),
                start = list(int = 0,
                             a = 1,
                             sd = 1))

avo.mle
summary(avo.mle)

avo.lm <- lm(data = avo,
             formula = Beak.Width ~ Beak.Depth)
avo.lm

#polynomial
avo.mle.poly <- mle2(data = avo,
                     minuslogl = Beak.Width ~
                       dnorm(mean = int + a*Beak.Depth + b*Beak.Depth^2,
                             sd = sd),
                     start = list(int = 0, a = 1, b = 0, sd = 1))

avo.lm.poly.1 <- lm(data = avo,
                    formula = Beak.Width ~ poly(Beak.Depth, 2))

#multiple preditors
avo.mle.mr <- mle2(data = avo,
                   minuslogl = Beak.Width ~ dnorm(mean = int + a*Beak.Depth +
                                                    b*Beak.Depth^2 + c*Beak.Length_Nares,
                                                  sd = sd),
                   start = list(int = 0,
                                a = 1,
                                b = 0,
                                c = 0,
                                sd = 1))

avo.lm.mr <- lm(data = avo,
                formula = Beak.Width ~ poly(Beak.Depth, 2) + Beak.Length_Nares)

#Analysis of variats
avo.lm.multianova.1 <- lm(dat = avo,
                          formula = Beak.Width ~ Habitat + Trophic.Niche - 1)

#Analysis of covariates
#Any idea how we would construct a model where:--
#  Slope of Beak.Width vs Beak.Length varies by trophic niche?
#  Each trophic niche has their own intercept

avo.ancova.1 <- lm(data = avo,
                   formula = Beak.Width ~ Beak.Depth + 
                     Trophic.Niche - 1)
#----------------------------example code ends------------------------------------------


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
bbs.fit.mle <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                y*Year_s +
                                                l1*Lat_s +
                                                l2*Long_s +
                                                map*Precip_s +
                                                fb*frac_built  +
                                                mat*Temp_s)),
                    start = list(int = 1, y = 0.1, l1 = 0.1, l2 = 0.1, map = 0.1, fb = 0.1, mat = 0.1),
                    data = bbs
)


bbs.fit.mle
#ASSIGNMENT 3 begins here:
#I am doing an analysis of covariates (ANCOVA) modeling TotalSpp as a function of multiple variables, those being:
#Year, latitude, longitude, mean annual precipitation, fraction built of the route, and mean annual temperature. 
#Since there are likely multiple factors (variables) at play in how the total species seen at a location is determined/affected,
#and the variables I picked all could have affects on total Spp, like Year to Year, with changes in lat and long, 
#with increasing and decreasing mean annual precip and temp, and the varying degree in which the location is urbanized.
#So, the question I am asking here is: "Is total species of birds a function of the aforementioned variables, and if so, to what degree do the variables affect the prediction?"

#I am opting to use ancova since I am looking at how multiple variables variables affect total spp. and for all of the models in this assignment I am using/assuming a normal distribution, 
#since the response variable (TotalSpp) is numeric, and continuous as well. 
#This model assumes that TotalSpp is a function of Year, latitude, longitude, mean annual precipitation, fraction built of the route, and mean annual temperature.
bbs.fit.ancova <- lm(data = bbs,
                 formula = TotalSpp ~ Year_s + Lat_s + Long_s + Precip_s + frac_built + Temp_s)
bbs.fit.ancova
#Coefficients:
#(Intercept)   Year_s        Lat_s       Long_s      Precip_s   frac_built      Temp_s  
#48.9709      -0.2058      15.3206      -6.7926      -2.1037     -16.1206      15.8794 

#Now I do multiple covariate models, each only excluding one of the variables in the original formula to see if that makes the model better or worse,
#in order to determine if the formula is being over-fit, and some variables may not have a significant impact on TotalSpp.
#I constructed the formulas as follows since I wanted to see if they multiple variables all play a role on TotalSpp, but not checking to see if any 2+
#predictor variables have an interaction with each other
bbs.fit.ancova.1 <- lm(data = bbs,
                       formula = TotalSpp ~ Year_s + Lat_s + Long_s + Precip_s + Temp_s)
bbs.fit.ancova.1

bbs.fit.ancova.2 <- lm(data = bbs,
                     formula = TotalSpp ~ Year_s + Lat_s + Long_s + frac_built + Temp_s)
bbs.fit.ancova.2

bbs.fit.ancova.3 <- lm(data = bbs,
                     formula = TotalSpp ~ Year_s + Lat_s + Precip_s + frac_built + Temp_s)
bbs.fit.ancova.3

bbs.fit.ancova.4 <- lm(data = bbs,
                     formula = TotalSpp ~ Year_s + Long_s + Precip_s + frac_built + Temp_s)
bbs.fit.ancova.4

bbs.fit.ancova.5 <- lm(data = bbs,
                     formula = TotalSpp ~ Lat_s + Long_s + Precip_s + frac_built + Temp_s)
bbs.fit.ancova.5

bbs.fit.ancova.6 <- lm(data = bbs,
                     formula = TotalSpp ~ Year_s + Lat_s + Long_s + Precip_s + frac_built)
bbs.fit.ancova.6

#Linear Models
#I  try looking at various linear models to model total spp as a function of various 1 variable(s).
#The following description of the models can be used for the following models with the described variable before each code
#inserting for the "<insert variable>": This model assumes that Total Spp is a function of <insert variable>:

#Total species as a function of Year
bbs.fit.lm <- lm(data = bbs,
                     formula = TotalSpp ~ Year_s)
bbs.fit.lm

#Total species as a function of latitude
bbs.fit.lm.1 <- lm(data = bbs,
                 formula = TotalSpp ~ Lat_s)
bbs.fit.lm.1

#Total species as a function of longitude
bbs.fit.lm.2 <- lm(data = bbs,
                 formula = TotalSpp ~ Long_s)
bbs.fit.lm.2

#Total species as a function of mean annual precipitation
bbs.fit.lm.3 <- lm(data = bbs,
                 formula = TotalSpp ~ Precip_s)
bbs.fit.lm.3

#Total species as a function of fraction built
bbs.fit.lm.4 <- lm(data = bbs,
                 formula = TotalSpp ~ frac_built)
bbs.fit.lm.4

#Total species as a function of mean annual temperature
bbs.fit.lm.5 <- lm(data = bbs,
                   formula = TotalSpp ~ Temp_s)
bbs.fit.lm.5

#I constructed the codes for the linear model the way I did since they were only looking at the relationship between TotalSpp and 1 other variable.


AICtab(bbs.fit.ancova, bbs.fit.ancova.1, bbs.fit.ancova.2, bbs.fit.ancova.3, bbs.fit.ancova.4,
       bbs.fit.ancova.5, bbs.fit.ancova.6, bbs.fit.lm, bbs.fit.lm.1, bbs.fit.lm.2, bbs.fit.lm.3, 
       bbs.fit.lm.4, bbs.fit.lm.5)

#dAIC    df
#bbs.fit.ancova       0.0 8 
#bbs.fit.ancova.2  1345.4 7 
#bbs.fit.ancova.5  1982.7 7 
#bbs.fit.ancova.1  2352.8 7 
#bbs.fit.ancova.6  3566.1 7 
#bbs.fit.ancova.4  4459.8 7 
#bbs.fit.ancova.3  8245.1 7 
#bbs.fit.lm.1     11468.0 3 
#bbs.fit.lm.5     12672.0 3 
#bbs.fit.lm.2     12684.3 3 
#bbs.fit.lm.3     21479.3 3 
#bbs.fit.lm       22436.5 3 
#bbs.fit.lm.4     22808.2 3 

#The AICs of all of the linear models where worse than that of the ancovas, suggesting that multiple factors to play a role in determining TotalSpp,
#Moreover, the original (bbs.fit.ancova) had the best AIC suggesting that Total Spp is a function of Year, latitude, longitude, 
#mean annual precipitation, fraction built of the route, and mean annual temperature, all playing a role. 

#since the bbs.fit.ancova yielded the best AIC, now I want to check if certin predictor variables have an interaction with eachother

#This model assumes that TotalSpp is a function of Year, latitude, longitude, mean annual precipitation, fraction built of the route, and mean annual temperature, 
#with all of these predictor variables having an interaction with each other, in other words saying that as any predictor variable changes, all the other predictor 
#variables will also change their affect on TotalSpp. 
bbs.fit.ancova.r <- lm(data = bbs,
                     formula = TotalSpp ~ Year_s * Precip_s * Temp_s * frac_built * Lat_s * Long_s)
bbs.fit.ancova.r

#This model assumes that unlike the previous model, only mean annual precipitation and mean annual temperature have an interaction with each other
bbs.fit.ancova.r1 <- lm(data = bbs,
                       formula = TotalSpp ~ Year_s + Precip_s * Temp_s + frac_built + Lat_s + Long_s)
bbs.fit.ancova.r1

#This model assumes that TotalSpp is a function of Year and mean annual precipitation, but the predictor variables have an interaction with each other
bbs.fit.ancova.r2 <- lm(data = bbs,
                       formula = TotalSpp ~ Year_s * Precip_s)
bbs.fit.ancova.r2

#This model assumes that TotalSpp is a function of Year and mean annual temperature, but the predictor variables have an interaction with each other
bbs.fit.ancova.r2 <- lm(data = bbs,
                        formula = TotalSpp ~ Year_s * Temp_s)
bbs.fit.ancova.r2

#This model assumes that TotalSpp is a function of Year and fraction built, but the predictor variables have an interaction with each other
bbs.fit.ancova.r3 <- lm(data = bbs,
                        formula = TotalSpp ~ Year_s * frac_built)
bbs.fit.ancova.r3

#This model assumes that TotalSpp is a function of Year and latitude, but the predictor variables have an interaction with each other
bbs.fit.ancova.r4 <- lm(data = bbs,
                        formula = TotalSpp ~ Year_s * Lat_s)
bbs.fit.ancova.r4

#This model assumes that TotalSpp is a function of Year and longitude, but the predictor variables have an interaction with each other
bbs.fit.ancova.r5 <- lm(data = bbs,
                        formula = TotalSpp ~ Year_s * Long_s)
bbs.fit.ancova.r5

#comparing the previous best fit model (bbs.fit.ancova) with the new models above with varying predictors, with relationships to each other
AICtab(bbs.fit.ancova, bbs.fit.ancova.r, bbs.fit.ancova.r1, bbs.fit.ancova.r2, bbs.fit.ancova.r3,
       bbs.fit.ancova.r4, bbs.fit.ancova.r5)
#                     dAIC df
#bbs.fit.ancova.r      0.0 65
#bbs.fit.ancova.r1 23076.7 9 
#bbs.fit.ancova    24766.7 8 
#bbs.fit.ancova.r4 33932.6 5 
#bbs.fit.ancova.r2 35159.3 5 
#bbs.fit.ancova.r5 35238.4 5 
#bbs.fit.ancova.r3 45657.5 5 

AIC(bbs.fit.ancova.r)

#This now suggests that the model where all of the predictor variables have an interaction with each other is the best model for predicting TotalSpp

#Now I want to try to look at some other models.
#Since Total species changes by Year and Route this model will be stating that Total species is a function of Year and Route
bbs.fit.ancova.YR <- lm(data = bbs,
                       formula = TotalSpp ~ Year_s + Route)
bbs.fit.ancova.YR

#Now looking at TotalSpp as a function of Year and Route, where year and route have an interaction with each other
bbs.fit.ancova.YR1 <- lm(data = bbs,
                        formula = TotalSpp ~ Year_s * Route)
bbs.fit.ancova.YR1

#Now where year is a polynomial (^2)
bbs.fit.poly <- lm(data = bbs,
                        formula = TotalSpp ~ poly(Year_s, 2) + Route)
bbs.fit.poly

#Now where year is a polynomial (^3)
bbs.fit.poly1 <- lm(data = bbs,
                   formula = TotalSpp ~ poly(Year_s, 3) + Route)
bbs.fit.poly1

AICtab(bbs.fit.ancova.r, bbs.fit.ancova, bbs.fit.ancova.YR, bbs.fit.ancova.YR1, bbs.fit.poly,
       bbs.fit.poly1)

#                  dAIC    df
#bbs.fit.ancova.r       0.0 65
#bbs.fit.ancova     24766.7 8 
#bbs.fit.poly1      46506.1 6 
#bbs.fit.ancova.YR1 46820.3 5 
#bbs.fit.poly       46890.5 5 
#bbs.fit.ancova.YR  47053.0 4 

#This suggests that the new models I made looking at just Year and Route, 
#as well as the polynomial models are notably worse than the ancova with all of the previous predictor variables having an interaction with each other,
#So, there is more playing a role in TotalSpp than just Year and Route.

#I am leaving room here below for me to add in models predicting total sightings of birds if i have time to do it.

#doing a poisson regression to see if assuming non-linearity produces a better model
poisbbs = function(Year_s, Route) {
   bbs = exp(Year_s + Route * x)
   -sum(dpois(y, lambda = Y.pred, log = TRUE))
}

