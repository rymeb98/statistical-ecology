library(emdbook)
library(ggplot2)
library(readr)
library(tidyverse)
library(bbmle)

#---------------------------------Part 1

# 1a ----------------------------------------------------------------------

# This model is focused on explaining how often papers are cited as a function of different factors.
# r_scripts_available is a binary variable, where papers either share their code (1) or don't (0)
# age_y is the age, in years, of a publication
# open access is a binary variable that tells whether the paper is free to access (1) or not (0)


#load and reformat the data

citation_data <- readr::read_rds("https://github.com/bmaitner/R_citations/raw/refs/heads/main/data/cite_data.RDS") %>%
  mutate(age_y = 2022-year) %>%
  mutate(r_scripts_available = case_when(r_scripts_available == "yes" ~ 1,
                                         r_scripts_available == "no" ~ 0)) %>%
  mutate(citations = as.numeric(citations),
         open_access = as.numeric(open_access)) %>%
  ungroup()%>%
  select(r_scripts_available,citations,open_access,age_y) %>%
  na.omit()

# plot if you like 

citation_data %>%
  ggplot(mapping = aes(x = age_y,y = citations))+
  geom_point()

# Fit a full model

cites.fit <- mle2(citations ~ dpois(lambda = a*age_y^b +
                                      int +
                                      rsa*r_scripts_available^d +
                                      oa*open_access^c),
                  start = list(a=0.17,
                               int=1,
                               rsa=0.1,
                               oa=0.1,
                               b=1,
                               c=1,
                               d=1),
                  data = citation_data)

# AIC initial
AIC(cites.fit)

#modify params we are taking into account:
#just a
cites.fita <- mle2(citations ~ dpois(lambda = a),
                  start = list(a=0.17),
                  data = citation_data)
#just int
cites.fiti <- mle2(citations ~ dpois(lambda = int),
                  start = list(int=1),
                  data = citation_data)
#just rsa
cites.fitr <- mle2(citations ~ dpois(lambda =
                                      rsa),
                  start = list(
                               rsa=0.1),
                  data = citation_data)
#just oa
cites.fito <- mle2(citations ~ dpois(lambda =
                                      oa),
                  start = list(
                               oa=0.1),
                  data = citation_data)
#just b, does not work needs more params
cites.fitb <- mle2(citations ~ dpois(lambda = age_y^b),
                   start = list(b=1),
                   data = citation_data)
#just c does not work needs more params
cites.fitc <- mle2(citations ~ dpois(lambda = open_access^c),
                  start = list(
                               c=1),
                  data = citation_data)
#just d does not work needs more params
cites.fitd <- mle2(citations ~ dpois(r_scripts_available^d),
                  start = list(
                               d=1),
                  data = citation_data)
# a and int
cites.fitai <- mle2(citations ~ dpois(lambda = a + int),
                  start = list(a=0.17,
                               int=1),
                  data = citation_data)
#a and rsa
cites.fit <- mle2(citations ~ dpois(lambda = a + rsa),
                  start = list(a=0.17,
                               rsa=0.1),
                  data = citation_data)
#a and oa
cites.fitao <- mle2(citations ~ dpois(lambda = a + oa),
                  start = list(a=0.17,
                               oa=0.1),
                  data = citation_data)
#a and b does not work
cites.fitab <- mle2(citations ~ dpois(lambda = a*age_y^b),
                  start = list(a=0.17,
                               b=1),
                  data = citation_data)
#a and c
cites.fitac <- mle2(citations ~ dpois(lambda = a + open_access^c),
                  start = list(a=0.17,
                               c=1),
                  data = citation_data)
#a and d
cites.fitad <- mle2(citations ~ dpois(lambda = a + r_scripts_available^d),
                  start = list(a=0.17,
                               d=1),
                  data = citation_data)
#Because this would take way too long to look at every possible combination of parametrs, 
#I am going to now just take the original code and look at the param combos by simply taking a param out each time
#no d param
cites.fitNd <- mle2(citations ~ dpois(lambda = a*age_y^b +
                                      int +
                                      rsa +
                                      oa*open_access^c),
                  start = list(a=0.17,
                               int=1,
                               rsa=0.1,
                               oa=0.1,
                               b=1,
                               c=1),
                  data = citation_data)
#no c or d param
cites.fitNcd <- mle2(citations ~ dpois(lambda = a*age_y^b +
                                      int +
                                      rsa +
                                      oa),
                  start = list(a=0.17,
                               int=1,
                               rsa=0.1,
                               oa=0.1,
                               b=1),
                  data = citation_data)
#no b, c or d param
cites.fitNbcd <- mle2(citations ~ dpois(lambda = a +
                                      int +
                                      rsa +
                                      oa),
                  start = list(a=0.17,
                               int=1,
                               rsa=0.1,
                               oa=0.1),
                  data = citation_data)
#no oa, b, c, or d param
cites.fitNobcd <- mle2(citations ~ dpois(lambda = a +
                                      int +
                                      rsa),
                  start = list(a=0.17,
                               int=1,
                               rsa=0.1),
                  data = citation_data)
#no rsa, oa, b, c or d param = cites.fitai, and only a was also previously done (cites.fita)
#now to pick random params to take out:
#no rsa
cites.fitNr <- mle2(citations ~ dpois(lambda = a*age_y^b +
                                      int +
                                      r_scripts_available^d +
                                      oa*open_access^c),
                  start = list(a=0.17,
                               int=1,
                               oa=0.1,
                               b=1,
                               c=1,
                               d=1),
                  data = citation_data)
#no oa
cites.fitNo <- mle2(citations ~ dpois(lambda = a*age_y^b +
                                      int +
                                      rsa*r_scripts_available^d +
                                      open_access^c),
                  start = list(a=0.17,
                               int=1,
                               rsa=0.1,
                               b=1,
                               c=1,
                               d=1),
                  data = citation_data)
#no int does not work because the value in vmmin is not finite
cites.fitNi <- mle2(citations ~ dpois(lambda = a*age_y^b +
                                      rsa*r_scripts_available^d +
                                      oa*open_access^c),
                  start = list(a=0.17,
                               rsa=0.1,
                               oa=0.1,
                               b=1,
                               c=1,
                               d=1),
                  data = citation_data)
#no a
cites.fitNa <- mle2(citations ~ dpois(lambda = age_y^b +
                                      int +
                                      rsa*r_scripts_available^d +
                                      oa*open_access^c),
                  start = list(int=1,
                               rsa=0.1,
                               oa=0.1,
                               b=1,
                               c=1,
                               d=1),
                  data = citation_data)
#no a or b
cites.fitNab <- mle2(citations ~ dpois(lambda = int +
                                      rsa*r_scripts_available^d +
                                      oa*open_access^c),
                  start = list(int=1,
                               rsa=0.1,
                               oa=0.1,
                               c=1,
                               d=1),
                  data = citation_data)
#no rsa or d
cites.fitNrd <- mle2(citations ~ dpois(lambda = a*age_y^b +
                                      int +
                                      oa*open_access^c),
                  start = list(a=0.17,
                               int=1,
                               oa=0.1,
                               b=1,
                               c=1),
                  data = citation_data)
#no oa or c
cites.fitNoc <- mle2(citations ~ dpois(lambda = a*age_y^b +
                                      int +
                                      rsa*r_scripts_available^d),
                  start = list(a=0.17,
                               int=1,
                               rsa=0.1,
                               b=1,
                               d=1),
                  data = citation_data)
#no rsa, d, oa, or c
cites.fitNrdoc <- mle2(citations ~ dpois(lambda = a*age_y^b +
                                      int),
                  start = list(a=0.17,
                               int=1,
                               b=1),
                  data = citation_data)
#no a, b, oa or c
cites.fitNaboc <- mle2(citations ~ dpois(lambda = int +
                                      rsa*r_scripts_available^d),
                  start = list(int=1,
                               rsa=0.1,
                               d=1),
                  data = citation_data)
#Now to compare the AICs of the models that worked
AICtab(cites.fit, cites.fita, cites.fitac, cites.fitad, cites.fitai, cites.fitao, cites.fiti, 
       cites.fitNa, cites.fitNab, cites.fitNaboc, cites.fitNbcd, cites.fitNcd, cites.fitNd, 
       cites.fitNo, cites.fitNobcd, cites.fitNoc, cites.fitNr, cites.fitNrd, cites.fitNrdoc, 
       cites.fito, cites.fitr)
# this is the output:
#                 dAIC df
#cites.fit         0.0 7 
#cites.fitNo      24.8 6 
#cites.fitNoc     90.7 5 
#cites.fitNr     135.7 6 
#cites.fitNrd    197.6 5 
#cites.fitNd     199.6 6 
#cites.fitNrdoc  342.8 3 
#cites.fitNcd    346.8 5 
#cites.fitNa     415.1 6 
#cites.fitNab   8785.8 5 
#cites.fitNaboc 9065.5 3 
#cites.fitac    9330.6 2 
#cites.fitad    9383.0 2 
#cites.fito     9444.7 1 
#cites.fitr     9444.7 1 
#cites.fiti     9444.7 1 
#cites.fita     9444.7 1 
#cites.fitai    9446.7 2 
#cites.fitao    9446.7 2 
#cites.fitNobcd 9448.7 3 
#cites.fitNbcd  9450.7 4 

#This suggests that the original code with all of the initial parameters provides the best fit since its AIC is 0.0, 
#but moreover that pretty much taking out any parameter makes the model notably worse, even though I did not check for every possible combination of parameters


#the following code did not work, i wanted to see if I could automate looking at all possible combinations to eliminate time
install.packages("MuMIn")
library(MuMIn)
nobs.mle2 <- function(object, ...) {
  nrow(object@data)
}
dredge(cites.fit)

# 1b ----------------------------------------------------------------------

# This model is focused on what determines rates of R code sharing by authors.
# r_scripts_available is a binary variable, where papers either share their code (1) or don't (0)
# year is the year of publication (relative to 2010).
# open_access is a binary variable that tells whether the paper is free to access (1) or not (0)
# data_available is a binary variable that tells whether the data are publicly available (1) or not (0)


code_data <- readr::read_rds("https://github.com/bmaitner/R_citations/raw/refs/heads/main/data/cite_data.RDS") %>%
  mutate(r_scripts_available = case_when(r_scripts_available == "yes" ~ 1,
                                         r_scripts_available == "no" ~ 0)) %>%
  mutate(data_available = case_when(data_available == "yes" ~ 1,
                                    data_available == "no" ~ 0)) %>%
  
  mutate(citations = as.numeric(citations),
         open_access = as.numeric(open_access)) %>%
  mutate(year = year-2010)


# note that for this function I use a logistic transform to ensure the probability stays between 0 and 1 during optimization

#all of the params 
sharing.fit <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int +
                                               y * year^b +
                                               d * data_available^e +
                                               o * open_access^p
                               )),
  start = list(int = 0,
               y = 0,
               b = 1,
               d = 0,
               e = 1,
               o = 0,
               p = 1),
  data = code_data
)

#just int
sharing.fiti <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int
                               )),
  start = list(int = 0),
  data = code_data
)
#just y
sharing.fity <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(y
                               )),
  start = list(y = 0),
  data = code_data
)
#just b does not work
sharing.fitb <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(year^b
                               )),
  start = list(b = 1),
  data = code_data
)
#just d
sharing.fitd <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(d
                               )),
  start = list(d = 0),
  data = code_data
)
#just e
sharing.fite <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(data_available^e
                               )),
  start = list(e = 1),
  data = code_data
)
#just o
sharing.fit <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(o
                               )),
  start = list(o = 0),
  data = code_data
)
#just p
sharing.fitp <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(open_access^p
                               )),
  start = list(p = 1),
  data = code_data
)
#no int does not work
sharing.fitNi <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(y * year^b +
                                               d * data_available^e +
                                               o * open_access^p
                               )),
  start = list(y = 0,
               b = 1,
               d = 0,
               e = 1,
               o = 0,
               p = 1),
  data = code_data
)
#No y and b
sharing.fitNyb <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int + d * data_available^e +
                                               o * open_access^p
                               )),
  start = list(int = 0,
               d = 0,
               e = 1,
               o = 0,
               p = 1),
  data = code_data
)
#no d and e
sharing.fitNde <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int +
                                               y * year^b + o * open_access^p
                               )),
  start = list(int = 0,
               y = 0,
               b = 1,
               o = 0,
               p = 1),
  data = code_data
)
#No o and p
sharing.fitNop <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int +
                                               y * year^b +
                                               d * data_available^e
                               )),
  start = list(int = 0,
               y = 0,
               b = 1,
               d = 0,
               e = 1),
  data = code_data
)
#no b, e or p
sharing.fitNbep <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int +
                                               y +
                                               d +
                                               o
                               )),
  start = list(int = 0,
               y = 0,
               d = 0,
               o = 0),
  data = code_data
)
#No y, d or o
sharing.fitNydo <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int + year^b + data_available^e + open_access^p
                               )),
  start = list(int = 0,
               b = 1,
               e = 1,
               p = 1),
  data = code_data
)
# just int, y and b
sharing.fitiyb <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int +
                                               y * year^b
                               )),
  start = list(int = 0,
               y = 0,
               b = 1),
  data = code_data
)
#just int, d and e
sharing.fitide <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int +
                                               d * data_available^e
                               )),
  start = list(int = 0,
               d = 0,
               e = 1),
  data = code_data
)
#just int, o and p
sharing.fitiop <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(int +
                                               o * open_access^p
                               )),
  start = list(int = 0,
               o = 0,
               p = 1),
  data = code_data
)
#just o and p
sharing.fitop <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(o * open_access^p
                               )),
  start = list(o = 0,
               p = 1),
  data = code_data
)
#just y and b does not work
sharing.fityb <- mle2(
  r_scripts_available ~ dbinom(size = 1,
                               prob = plogis(y * year^b
                               )),
  start = list(y = 0,
               b = 1),
  data = code_data
)


AICtab(sharing.fit, sharing.fitd, sharing.fite, sharing.fiti, sharing.fitide, 
       sharing.fitiop, sharing.fitiyb, sharing.fitNbep, sharing.fitNde, sharing.fitNop,
       sharing.fitNyb, sharing.fitNydo, sharing.fitp, sharing.fity, sharing.fitop)
#Results:
#                  dAIC df
#sharing.fitNop     0.0 5 
#sharing.fitide     0.1 3 
#sharing.fit        1.9 7 
#sharing.fitNyb     2.0 5 
#sharing.fitNydo   32.7 4 
#sharing.fitNde    69.9 5 
#sharing.fitiyb    73.0 3 
#sharing.fitiop    79.6 3 
#sharing.fitd      82.3 1 
#sharing.fiti      82.3 1 
#sharing.fity      82.3 1 
#sharing.fitNbep   88.3 4
#sharing.fitop    809.4 2
#sharing.fite    1140.6 1 
#sharing.fitp    1358.5 1

#According to this AIC table the model that did not have the o and p params (so the int + y * year^b + d * data_available^e)
#yielded the best model of the combinations I tried. but what is interesting is that the model with only the int, d, and e params was very close having an AIC value of 0.1
#the original model with all of the params had an AIC value of 1.9 and the model that did not have the y or b param had an AIC of 2.0.
#This would suggest that any of those 4 models could be appropriate to use here even though ultimately the one without the o and p params is suggested to be the best model.
#Something interesting to note is that since the model with only the int, d and e params yields a similar score to that that just doesnt have the o and p params, 
#suggests that the o and p params are not only not very helpful (further evident by the fact that the model with just the o and p params had a high AIC value), but actually make the model worse
#Moreover, the y and b params could be left out since they don't help the model much either (in fact the model gets an error when only including those two params)
#This is all a very long winded explanation for why the model that excludes the o and p param is likely the best model.


# 1c ----------------------------------------------------------------------

# This model attempts to explain size variation in the wings of birds
# Wing.length is mean adult wing length
# Mass is mean adult body mass
# Range.size is the area of the geographic range of each species
# Order1 is a categorical variable that lists the taxonomic Order each species fall into.

# Note that I provide two ways to load the avonet dataset in case the csv file won't load for some of you.

avonet <- read_rds("https://github.com/bmaitner/Statistical_ecology_course/raw/refs/heads/main/data/Avonet/AVONET1_BirdLife.rds") %>%
  select(Order1, Wing.Length, Mass, Range.Size) %>%
  na.omit()

avonet  <- read.csv("https://github.com/bmaitner/Statistical_ecology_course/raw/refs/heads/main/data/Avonet/AVONET1_BirdLife.csv") %>%
  select(Order1, Wing.Length, Mass, Range.Size) %>%
  na.omit()

avonet %>%
  ggplot(mapping = aes(y=Wing.Length,x=Mass))+
  geom_point()

# Note: there is a lot of data here, it may take a while to fit the full model

avonet.fit <- mle2(Wing.Length ~ dlnorm(meanlog = int +
                                          m*log(Mass)^b +
                                          rs*Range.Size,
                                        sdlog = sd),
                   start = list(m = 1,
                                b = 1,
                                sd = 1,
                                int = 0,
                                rs = 10),
                   data = avonet,
                   parameters = list(int ~ Order1))
#just int 
avonet.fiti <- mle2(Wing.Length ~ dlnorm(meanlog = int,
                                          sdlog = sd),
                     start = list(sd = 1,
                                  int = 0),
                     data = avonet)
#just int (and varies by order)
avonet.fiti2 <- mle2(Wing.Length ~ dlnorm(meanlog = int,
                                          sdlog = sd),
                   start = list(sd = 1,
                                int = 0),
                   data = avonet,
                   parameters = list(int ~ Order1))
#just mass
avonet.fitm <- mle2(Wing.Length ~ dlnorm(meanlog = m*log(Mass)^b,
                                         sdlog = sd),
                   start = list(m = 1,
                                b = 1,
                                sd = 1),
                   data = avonet)
#mass and int that varies by order
avonet.fitmi <- mle2(Wing.Length ~ dlnorm(meanlog = int + m*log(Mass)^b,
                                          sdlog = sd),
                     start = list(m = 1,
                                  b = 1,
                                  sd = 1,
                                  int = 0),
                     data = avonet)
#mass and int that varies by order
avonet.fitmi2 <- mle2(Wing.Length ~ dlnorm(meanlog = int + m*log(Mass)^b,
                                        sdlog = sd),
                   start = list(m = 1,
                                b = 1,
                                sd = 1,
                                int = 0),
                   data = avonet,
                   parameters = list(int ~ Order1))
#Range size only
avonet.fitr <- mle2(Wing.Length ~ dlnorm(meanlog = rs*Range.Size,
                                        sdlog = sd),
                   start = list(sd = 1,
                                rs = 10),
                   data = avonet)
#Range size and int
avonet.fitri <- mle2(Wing.Length ~ dlnorm(meanlog = int +
                                            rs*Range.Size,
                                          sdlog = sd),
                     start = list(sd = 1,
                                  int = 0,
                                  rs = 10),
                     data = avonet)
#Range size and intercept and Order 1
avonet.fitri2 <- mle2(Wing.Length ~ dlnorm(meanlog = int +
                                          rs*Range.Size,
                                        sdlog = sd),
                   start = list(sd = 1,
                                int = 0,
                                rs = 10),
                   data = avonet,
                   parameters = list(int ~ Order1))
#no int
avonet.fitNi <- mle2(Wing.Length ~ dlnorm(meanlog = m*log(Mass)^b +
                                          rs*Range.Size,
                                        sdlog = sd),
                   start = list(m = 1,
                                b = 1,
                                sd = 1,
                                rs = 10),
                   data = avonet)

AICtab(avonet.fit, avonet.fiti, avonet.fiti2, avonet.fitm, 
       avonet.fitmi, avonet.fitmi2, avonet.fitNi, avonet.fitr, 
       avonet.fitri, avonet.fitri2)
#The results are as follows:
#                  dAIC df
#avonet.fitmi2      0.0 39
#avonet.fitmi    4227.1 4 
#avonet.fitm     5277.1 3 
#avonet.fiti2   13009.1 37
#avonet.fiti    21703.4 2 
#avonet.fit    171645.4 40
#avonet.fitNi  173377.6 4 
#avonet.fitr   177540.0 2 
#avonet.fitri  177568.2 3 
#avonet.fitri2 177781.1 38
#The avonemt.fitmi2 model (which has mass and the intercept as it varies by Order) 
#seems to be the best model by a wide margin, so the range size param could be taken out of the model.


#--------------------------------------Part 2

bbs <- read.csv("https://raw.githubusercontent.com/rymeb98/statistical-ecology/refs/heads/main/FL_BBS.csv")

# quick peek
str(bbs)
head(bbs)

#because there are NAs in my dataset
bbs <- na.omit(bbs)
#I have to rescale a number of the predictor variables because of their size
bbs$Year_s   <- scale(bbs$Year, scale = FALSE)
bbs$Lat_s    <- scale(bbs$Latitude)
bbs$Long_s   <- scale(bbs$Longitude)
bbs$Precip_s <- scale(bbs$mean_annual_precip)
# frac_built stays as-is since it's already 0–1

#----------------Model 1: Trying to predict total spp------------------------
#base model
bbs.fit <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                  y*Year_s +
                                  l1*Lat_s +
                                  l2*Long_s +
                                  map*Precip_s +
                                  fb*frac_built)),
  start = list(int = 1, y = 0.1, l1 = 0.1, l2 = 0.1, map = 0.1, fb = 0.1),
  data = bbs
)

AIC(bbs.fit)
#Intercept and year
bbs.fitiy <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                y*Year_s)),
                start = list(int = 1, y = 0.1),
                data = bbs
)
#int and latitude
bbs.fitil1 <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                l1*Lat_s)),
                start = list(int = 1, l1 = 0.1),
                data = bbs
)
#int and longitude
bbs.fitil2 <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                l2*Long_s)),
                start = list(int = 1, l2 = 0.1),
                data = bbs
)
#int and mean annual precipitation
bbs.fitimap <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                map*Precip_s)),
                start = list(int = 1, map = 0.1),
                data = bbs
)
#int and fraction built
bbs.fitifb <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                fb*frac_built)),
                start = list(int = 1, fb = 0.1),
                data = bbs
)
#No y
bbs.fitNy <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                l1*Lat_s +
                                                l2*Long_s +
                                                map*Precip_s +
                                                fb*frac_built)),
                start = list(int = 1, l1 = 0.1, l2 = 0.1, map = 0.1, fb = 0.1),
                data = bbs
)
#No l1
bbs.fitNl1 <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                y*Year_s +
                                                l2*Long_s +
                                                map*Precip_s +
                                                fb*frac_built)),
                start = list(int = 1, y = 0.1, l2 = 0.1, map = 0.1, fb = 0.1),
                data = bbs
)
#No l2
bbs.fitNl2 <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                y*Year_s +
                                                l1*Lat_s +
                                                map*Precip_s +
                                                fb*frac_built)),
                start = list(int = 1, y = 0.1, l1 = 0.1, map = 0.1, fb = 0.1),
                data = bbs
)
#No map
bbs.fitNmap <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                y*Year_s +
                                                l1*Lat_s +
                                                l2*Long_s +
                                                fb*frac_built)),
                start = list(int = 1, y = 0.1, l1 = 0.1, l2 = 0.1, fb = 0.1),
                data = bbs
)
#No fb
bbs.fitNfb <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                y*Year_s +
                                                l1*Lat_s +
                                                l2*Long_s +
                                                map*Precip_s)),
                start = list(int = 1, y = 0.1, l1 = 0.1, l2 = 0.1, map = 0.1),
                data = bbs
)


AICtab(bbs.fit, bbs.fitifb, bbs.fitil1, bbs.fitil2, bbs.fitimap, bbs.fitiy, bbs.fitNfb, 
       bbs.fitNl1, bbs.fitNl2, bbs.fitNmap, bbs.fitNy)
#Results:
#               dAIC df
#bbs.fit         0.0 6 
#bbs.fitNfb   1189.0 5 
#bbs.fitNl1   2917.9 5 
#bbs.fitNy    3337.1 5 
#bbs.fitNmap  6501.6 5 
#bbs.fitNl2   8216.0 5 
#bbs.fitil1  12836.9 2 
#bbs.fitil2  15568.0 2 
#bbs.fitimap 30638.3 2 
#bbs.fitiy   32377.6 2 
#bbs.fitifb  33019.7 2 

#Adding mean annual temp as a predictor since the original model (bbs.fit) seems to be the best model for the TotalSpp predictor
#As shown by the AIC value for bbs.fit being 0.0
bbs$Temp_s <- scale(bbs$mean_annual_temp)
bbs.fitWmat <- mle2(TotalSpp ~ dpois(lambda = exp(int +
                                                y*Year_s +
                                                l1*Lat_s +
                                                l2*Long_s +
                                                map*Precip_s +
                                                fb*frac_built +
                                                mat*Temp_s)),
                start = list(int = 1, y = 0.1, l1 = 0.1, l2 = 0.1, map = 0.1, fb = 0.1, mat = 0.1),
                data = bbs
)

AICtab(bbs.fit, bbs.fitWmat)
#Results:
#              dAIC df
#bbs.fitWmat    0.0 7 
#bbs.fit     5207.6 6 

#Adding the mean_annual_temp predictor actually made the model notably better than the original one as evident by the 
#AIC for bbs.fitWmat being 0.0

#-------------------------Model 2: Total sightings-------------------

#due to time I am submitting this as of right now with just 1 response variable, but I will resubmit it with a second response variable later.

