#------------------------------Part 1
#1. Number of surviving individuals within a forest plot
#A: Binomial, because it matches the example given for the binomial distribution in Table 4.1. 
# Moreover, the term "number of surviving individuals" indicates they are discrete numbers that could range from 0 to N (total number of individuals in the sample).

#2. Species abundance (counts of individuals in a plot)
#A: Poisson or Negative binomial, since number of individuals is discrete, and its looking at the number of individuals in an area, as explained in Table 4.1.
# In this case we don't have information on the variance or mean of this example so I am unable to differentiate which of the two distributions is more correct, but with the information given it could be either one.

#3. Species richness (number of species in a sample)
#A: Poisson or Negative binomial, like #2, number of species is discrete, and looking at number of species in a sample is functionally equivalent to looking at number of individuals in an area.
# Table 4.1 helped me arrive to this conclusion as well by its listed example.

#4. Ages (in years) of surviving individuals within a reserve
#A: Geometric. This one is a little tricky since it mentions the sample area being a reserve, however I believe that geometric distribution fits it more correctly since 
# the example provided in Table 4.1 lists "discrete lifetimes", and Age is discrete. Since This question focuses on the ages of the surviving individuals, we do not care about total sample size that includes deceased individuals, so Binomial does not work.

#5. Body size (e.g., body mass, length)
#A: Normal, various body sizes are continuous variables, and the example for Normal Distribution in table 4.1 is "Mass". 

#6. Population growth rate
#A: Normal, This one was also a little tricky, because various distributions could work for population growth rate, but since in my head I can see growth rates being negative (indicating a population decline), Normal distribution (as seen in table 4.1) is the only one that can have a range in the negatives.
# Also obviously growth rate is a continuous variable which helped me narrow in on my answer of Normal.

#7. Proportion of habitat covered by vegetation
#A: Beta, to start off, proportion instantly indicates its a continuous variable, moreover Table 4.1 has "Cover proportion" listed as its example.
# The reason I believe beta distribution fits better than a Uniform one is because Beta distributions can have skewing, and the proportion of a habitat covered in vegetation could be skewed depending on the habitat.

#8. Biomass per unit area
#A: Lognormal, Biomass is a continuous variable, that can never be lower than 0, and table 4.1 lists mass as an example, which biomass is fictionally mass.  

#9. Seed counts per plant
#A: Poisson, seed counts are discrete, and looking at the number of them per plant is the same as looking at number of individuals per sampling area. I would imagine that if we are looking at one species of plant, most individuals would contain seeds close to their mean,
# These characteristics are listed for the Poisson distribution in Table 4.1. (note: if we are looking at different species of plants, the variance would probably be higher which would make the Negative binomial distribution fit better).

#10. Time to germination
#A: Gamma, time is continuous, with a range of 0 - infinity, moreover in section 4.5.2.3 the book explains that gamma distributions are good for looking at the distribution of waiting times until a
# certain number of events take place. Where in this case it would be the amount of time it takes for germination to occur.

#11. Distance moved by an animal (step lengths in movement data)
#A: Gamma (or exponential), distance is always going to be positive so we know the range is 0 - infinity, its also a continuous variable. Also, in Table 4.1, the example for Gamma (as well as exponential) distribution is
# distance to nearest edge, which one could extrapolate that here, since distance moved by an animal is looking at the distance from the "edge" which would be a set point from their movement starting. 
# I believe Gama over exponential however because i would imagine there would be a higher count of shorter distances traveled rather than longer ones since it is easier for animals to move short distances than long distances.

#12. Pollinator visitation rate (visits per flower per unit time)
#A: Negative Binomial, visits are discrete values, where the range is 0 - infinity, in Table 4.1 Poisson and negative binomial fit this, but I believe a negative binomial fits it better because I would imagine that there would be high variance.
# Also, this example is similar to looking at number of individuals in an area, which is the example given for negative binomial in Table 4.1.

#13. Leaf area measurements
#A: Gamma, area is continuous and the range would be 0 - infinity since area can't be negative. This does also match lognormal and exponential (as seen on Table 4.1), but I am choosing gamma because online it mentions that gamma distribution can be flexible when looking at leaves that vary widely in size (and thus area).

#14. Environmental variables (temperature, rainfall, pH)
#A: Gamma, these variables are continuous, rainfall and pH can't have a negative, but temperature can depending on the scale (F vs C vs K), as long as you convert temperature to kelvin you can use the Gamma distribution. This best matches the gamma distribution on Table 4.1.

#15. Prey consumed per day
#A: Poisson, This would be a discrete variable, that is akin to "# of individuals in a given sample" where the number of prey are the number of individuals, and the sample is a day. Moreover, in section 4.5.1.2 the book explains that Poisson distributions are good at the number of individuals in a given time frame, which also matches up with the characteristics of Negative bionomial on table 4.1.

#16. Fish counts on reef transects
#A: Poisson, similar to #15, this is discrete, with a range of 0 - infinity. Fish counts would be the number of individuals and reef transects are the sampling area. also like #15, section 4.5.1.2 explains that this example matches the use cases for a Poisson.
# I was between Poisson and negative binomial, but in section 4.5.1.3 the book explains that a negative binomial is better at lookin at number of failures rather than number of successes.

#17. Proportion of coral cover on a reef
#A: Beta, right away looking at proportion means the range is going to be between 0 and 1, and proportions are continuous variables. On table 4.1 this matches Uniform and beta distributions (they also have cover proportion listed as their examples); however, in real life examples the proportion of coral coverage on a reef is not going to be uniform since it affected by many different environmental factors.
# thus meaning that the distribution is likely to be skewed in some way. and Uniform distributions don't have any skew (again as expressed on table 4.1).

#18. Larval settlement success (number settled out of larvae released)
#A: Binomial, this would be discrete with a range of 0 - N, where N is the total number of larvae released. Table 4.1 shows that either binomial or beta binomial could work, however in section 4.5.1.5, the book explains that a beta binomial has two additional parameters, but this example is just looking for number of larvae that settle out of the total amount released.
# Moreover this is similar to the example given for binomial distribution in Table 4.1, where it says "number of surviving, number killed. In this case it would be number settled.

#19. Time to mortality under hypoxia experiments (fish, invertebrates)
#A: Exponential, time is a continuous variable, and the range would be 0 - infinity. Table 4.1 has survival time listed for its example for both gamma and exponential distributions, however section 4.5.2.4 more specifically lists survival time as an example, especially since we would expect mortality rate to increase exponentially as time increases under hypoxia conditions, 
# while 4.5.2.3 explains that a gamma distribution will look at waiting times until a certain number of events take place, but this example doesn't specify what number of events we are looking for, just time for hypoxia to occur in general.

#20. Proportion of infected fish in a population (parasite prevalence)
#A: Beta, since we are looking for the proportion of the population that is infected, the range is going to be between 0 and 1, and proportion is a continuous variable, and Table 4.1 indicates that only uniform or beta distributions can have this. Further in section 4.5.2.1 the book explains that uniform distributions are used more as a building block for other distributions and are rarely used in ecology outside of that.
# Since we are only looking at the proportion of infected fish in a single population, and not the probability of a given fish being infected the binomial distribution would not work, therefore beta distribution is more correct.

#----------------------------Part 2

#read.csv("C:/Users/yairb/Desktop/R related softwares/Assignment 1/FL_BBS.csv", header = TRUE)
fl_bbs <- read.csv("C:/Users/yairb/Desktop/R related softwares/Assignment 1/FL_BBS.csv", header = TRUE)
fl_bbs

summary(fl_bbs)

class(fl_bbs)

class(fl_bbs$Year)

class(fl_bbs$total_sightings)

class(fl_bbs$TotalSpp)

class(fl_bbs$mean_annual_precip)

class(fl_bbs$mean_annual_temp)

class(fl_bbs$frac_built)

class(fl_bbs$Latitude)

class(fl_bbs$Longitude)

#Numeric variables I'm interested in: mean_annual_temp (is in C), frac_built, Latitude, Longitude 
#Integer variables I'm interested in are: Year, total_sightings, totalSpp, mean_annual_precip
  
#Despite most of the numeric variables in the fl_bbs dataset not really being something i am interested in, the variables i am interested in are mainly integers (discrete) and since the prompt specifically asks us to look at the numeric variables, and moreover in class you specified we should look at continuous data,
#I am going to look at the distributions for mean_annual_temp, fraction built (frac_built), Latitude, and Longitude. However, as we discussed in class, we could look at distributions for discrete variables.
install.packages("e1071")
library(e1071)

#I am opting to use the unique function when looking at the distributions because the same value for for instance Year = 1997 and Route = 1 where inserted for each species row, but are not distinct values, so unique helped me clump each Year and route combination into one value.
hist(unique(fl_bbs$mean_annual_temp), breaks = 6)
hist(unique(fl_bbs$mean_annual_temp), breaks = 20)
qqnorm(fl_bbs$mean_annual_temp); qqline(fl_bbs$mean_annual_temp)
skewness(unique(fl_bbs$mean_annual_temp), na.rm = TRUE)
#Skewness = O.129671 which indicates that the distribution for mean annual temperature is roughly symmetrical
#For mean_annual_temp I believe a log-Normal distribution would be correct since the histograms for both a break of 6 and 20 show a relative bell-curve; however, it does seem to have 2 peaks (one at ~19.5 C and one at ~23 C). 
#That being said, the skewness test indicated that the distribution is roughly symmetrical, and considering the peak at ~23 C is lower than that at ~19.5 C I was thinking a normal distribution may be more appropriate. However, ince the values start low at ~18 C, go up to a pek at ~19.5 C, then down as it reaches ~21 C, then back up at ~23 C, I am going with log-normal distribution.

hist(unique(fl_bbs$frac_built), breaks = 6)
hist(unique(fl_bbs$frac_built), breaks = 20)
skewness(unique(fl_bbs$frac_built), na.rm = TRUE)
#Skewness = 2.001979 which indicates a strong right skew for fraction built, meaning most of the areas in the study had a fraction built between 0.0 and 0.1 in the Histogram with 6 breaks, and 0.0 - 0.02 in the Histogram with 20 breaks
#For frac_built I believe a Beta distribution is more correct for a number of reasons: 1) it being a continuous variable whose range is going to be between 0 and 1 (since fraction built can only go from 0 [no buildings at all] to 1 [only buildings present]) ; 2) this is akin to "cover proportion" which was the example given for both Uniform and Beta distributions in table 4.1 ; and 
#3) the heavy right skewing would not be present in a Uniform distribution, but could be present in a Beta distribution.

hist(unique(fl_bbs$Latitude), breaks = 6)
hist(unique(fl_bbs$Latitude), breaks = 20)
skewness(unique(fl_bbs$Latitude), na.rm = TRUE)
#Skewness = -0.4245433 which according to ChatGPT means it is roughly symmetrical, however the histograms for both 6 and 20 breaks displays more of a left skewing. So I am saying this distribution has a slight left skew, meaning that the data tends to concentrate more on higher latitudes.
range(fl_bbs$Latitude)
scaled_lat <- (fl_bbs$Latitude + 90) / 180
scaled_lat
#I am opting to rescale it since latitude, despite having the possibility of negative and positive values, is still bound between -90 degree and +90 degrees. The rescaling will put the values between 0 and 1, with 0 being south pole, and 1 being north pole.
unique(scaled_lat)
hist(unique(scaled_lat), breaks = 6)
hist(unique(scaled_lat), breaks = 20)
skewness(unique(scaled_lat), na.rm = TRUE)
#As expected, after rescaling, the skewness stays the same.
#Since the distribution is bounded between the latitudes of 24.59770 and 30.96569 and has a slight left skewing, and now is scaled to have a range between 0 and 1, a Beta distribution would be more appropriate for this data set. This is because of the range, the fact its a continuous data set, and the fact it has left skewing and beta distributions are flexible and can handle left skews.
#Moreover, beta distribution is the only one that fits these parameters on table 4.1

hist(unique(fl_bbs$Longitude), breaks = 6)
hist(unique(fl_bbs$Longitude), breaks = 20)
skewness(unique(fl_bbs$Longitude), na.rm = TRUE)
#Skewness = -0.946358 meaning there is heavy left skewing in the data, meaning the data concentrates more on higher longitudes. 
range(unique(fl_bbs$Longitude))

long_rescaled <- (fl_bbs$Longitude - min(fl_bbs$Longitude)) / (max(fl_bbs$Longitude) - min(fl_bbs$Longitude))
unique(long_rescaled)
range(unique(long_rescaled))
hist(unique(long_rescaled), breaks = 6)
hist(unique(long_rescaled), breaks = 20)
skewness(unique(long_rescaled), na.rm = TRUE)
#As expected, after rescaling the longitude data, the skewness stays the same.
#Just like latitude, the longitude data is bound regionally (between -87.40794 degrees and -80.22930), so rescaling it seems appropriate so it can better fit the beta distribution, whose range is between 0 and 1. In this case however, 0 relates to -87.40794 degrees and 1 relates to -80.22930 degrees. The heavier left skewing indicates that the data is concentrated around the higher longitude values.
#Just like for latitude, the Beta distribution fits best for the longitude data because now its range is between 0 and 1, has a left skew, and is continuous data.

#ALSO for both latitude and longitude distributions, one can argue that they are akin to cover proportion, since the globe is the total area (like a field if we were looking at cover proportion of some variable in a field) and we are trying to see what portion of the earth, and where on the earth our data encompasses. So, we can extrapolate that it is similar to the example provided for Beta distribution in table 4.1.


#-----------------------The code below is me looking at the distribution of the integer variables of interest to me for my own knowledge

hist(fl_bbs$TotalSpp, breaks = 10)
hist(unique(fl_bbs$TotalSpp), breaks = 20)
#this seems to fit a normal distribution when i dont use the unique function, however, when i do use the unique function one could suppose a normal distribution would still fit, however with a very wide peak.

hist(fl_bbs$total_sightings, breaks = 3)
hist(unique(fl_bbs$TotalSpp), breaks = 20)
range(fl_bbs$total_sightings)
hist(fl_bbs$total_sightings, xlim = c(0, 3200), breaks = 6)
#i can't seem to make the histogram make sense for this

