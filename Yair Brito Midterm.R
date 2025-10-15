# Part 1 useful code ------------------------------------------------------

#This Part is written in word and submitted on my Github seperately.

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

# Part 2 --------------------------------------pg 101 for table of functions

install.packages("readr")
library(readr)
library(bbmle)
library(tidyr)

twoa <- read_rds("https://github.com/bmaitner/Statistical_ecology_course/raw/refs/heads/main/midterm/2a.RDS")
twoa
#continuous data, Range: 0 - infinity, Distribution: Normal or lognormal, most likely lognormal. The histograms of the non transformed variables (below) show skewing to the right. all these characteristics are indicative of the lognormal distribution being appropriate.
#Function: I believe the Michaelis-Menten function is most appropriate for a couple reasons, 1) the shape of the non transformed plot looks similar to the example provided for the Michaelis-Menten function on pg. 84 of the book, also 2) it matches the characteristics listed on Table 3.1 of the book,
#with the left side appearing linear while the right side has an asymptote, and the range is 0 - infinity. 
summary(twoa)
str(twoa)
hist(twoa$Mass)
hist(twoa$Wing.Length)
hist(log10(twoa$Mass))
hist(log10(twoa$Wing.Length))
#Moreover, the histograms for the log10 transformation of the variables look more normally distributed.

plot(x = twoa$Mass, y = twoa$Wing.Length)
plot(x = log10(twoa$Mass),
     y = log10(twoa$Wing.Length),
     xlab = "log10(Mass)",
     ylab = "log10(Wing Length)"
)
trend_line <- lm(log10(twoa$Wing.Length)~log10(twoa$Mass)) 
abline(trend_line,col="blue",lwd=3)



twob <- read_rds("https://github.com/bmaitner/Statistical_ecology_course/raw/refs/heads/main/midterm/2b.RDS")
twob
#continuous data, Range: 0 - infinity, Distribution: Normal or lognormal, most likely lognormal, because despite the plot for twob$Beak.Width~twob$Beak.Length seeming to follow a linear trend and does not change much when transformed into their log10 values, 
#the histogram for both variables indicate a right skew, and the normal distribution on table 4.1 in the book states that for a normal distribution there should be no skew, but for the lognormal distribution there should be a right skew.
#Function: the plot for twob shows a linear relationship between Beak Length and Beak Width regardless of whether its transformed into the log10 values or not. issue is, table 3.1 of the book does not have "linear" as a listed function; 
#however, Figure 3.6 in the book looks at the expansion fourth-order polynomial with constant, linear, quadratic and cubic functions displayed on the graph. Since the graph here is liner as well, I believe the "Polynomials Lines" function is most appropriate despite the range being -infinity to infinity 
#and the graph here strictly deal with positive values since we can't have a negative beak length or width. however both the left and right ends of the graph have a constant slope and there does not seem to be an aymptote and none of the functions with a range of 0 to infinity matches this graph.
summary(twob)
str(twob)

plot(x = twob$Beak.Length, y = twob$Beak.Width)
trend_line1 <- lm(twob$Beak.Width~twob$Beak.Length) 
abline(trend_line1,col="blue",lwd=3)

hist(twob$Beak.Length)
hist(twob$Beak.Width)
hist(log10(twob$Beak.Length))
hist(log10(twob$Beak.Width))
#Just like twoa. the histograms for the non transformed variables are right skewed while those for the log10 transformed variables look more normal.


plot(x = log10(twob$Beak.Length),
     y = log10(twob$Beak.Width),
     xlab = "log10(Beak Length)",
     ylab = "log10(Beak Width)"
)
trend_line2 <- lm(log10(twob$Beak.Width)~log10(twob$Beak.Length)) 
abline(trend_line2,col="blue",lwd=3)



twoc <- read_rds("https://github.com/bmaitner/Statistical_ecology_course/raw/refs/heads/main/midterm/2c.RDS")
twoc
#continuous data, since Functional Evenness is our response variable, and it looks like it is out of a proportion of 1, the range is between 0 and 1. 
#This matches closely to Beta distribution, the example for Beta distribution in table 4.1 of the book is "Cover proportion", which Evenness seems to mimic. 
#Lastly, Beta distributions can have any kind of skew, which the histograms below seem to indicate skewing,
#Function: This one is interesting because it seems to follow a negative linear relationship, which would make me think the polynomials lines function would be appropriate again, 
#however (and this might be my brain playing tricks on me) it seems to flatten out towards the higher functional richness values forming a sort of asymptote, which would make the Negative exponential function more appropriate.
#Ultimately however I am going to choose the POlynomials lines function to be the best fit here because the data points only loosely follow the shape of the negative exponential curve (as seen on Figure 3.9 in the Book), and more strongly resembles a negative linear line.
summary(twoc)
str(twoc)

hist(twoc$Functional.Richness)
hist(twoc$Functional.Evenness)

plot(x = twoc$Functional.Richness, y = twoc$Functional.Evenness)
trend_line3 <- lm(twoc$Functional.Evenness~twoc$Functional.Richness) 
abline(trend_line3,col="blue",lwd=3)


plot(x = log10(twoc$Functional.Richness),
     y = log10(twoc$Functional.Evenness),
     xlab = "log10(Functional.Richness)",
     ylab = "log10(Functional.Evenness)"
)
trend_line4 <- lm(log10(twoc$Functional.Evenness)~log10(twoc$Functional.Richness)) 
abline(trend_line4,col="blue",lwd=3)
#I do not believe plotting the log10 transformations here makes sense because it yields negative values for Functional Evenness

# Part 3 example code -----------------------------------------------------

# how does slope and sample size impact power?  
#Assume a linear relationship
#x has a slope between -2 and 2
#intercept = 2
#sd = 8

#1. For sample size = 20 and slope = -2 to 2

sample_size <- 20
a <- 2 #intercept
sd <- 8

nsim <- 400
bvec <- seq(-2, 2, by = 0.1) #generates seq of various slopes between -2 and 2
power.b <- numeric(length(bvec))
pval <- numeric(nsim)


for(j in 1:length(bvec)){
  for(i in 1:nsim){
    
    x <- sample(x = 1:20,
                size = sample_size,
                replace = TRUE)
    
    b <- bvec[j]#b is the slope and comes from the vector bvec
    y_det <- a + b*x
    y <- rnorm(n = length(y_det),
               mean = y_det,
               sd = sd)
    
    m <- lm(y ~ x)
    
    #get p-value
    
    pval[i] <- coef(summary(m))["x","Pr(>|t|)"]
    
  }#end i loop
  power.b[j] <- sum(pval< 0.05)/nsim
  
}#end j loop

plot(power.b ~ bvec,main = sample_size)


#DOES NOT WORK: For sample size = 40 and slope = -2 to 2

sample_size1 <- 40
a1 <- 2 #intercept
sd1 <- 8

nsim1 <- 400
bvec1 <- seq(-2, 2, by = 0.1) #generates seq of various slopes between -2 and 2
power.b1 <- numeric(length(bvec1))
pval1 <- numeric(nsim1)


for(j in 1:length(bvec1)){
  for(i in 1:nsim1){
    
    x1 <- sample(x = 1:40,
                 size = sample_size1,
                 replace = TRUE)
    
    b1 <- bvec1[j]#b is the slope and comes from the vector bvec
    y_det1 <- a1 + b1*x1
    y1 <- rnorm(n = length(y_det1),
                mean = y_det1,
                sd = sd1)
    
    m1 <- lm(y ~ x)
    
    #get p-value
    
    pval1[i] <- coef(summary(m1))["x","Pr(>|t|)"]
    
  }#end i loop
  power.b1[j] <- sum(pval1< 0.05)/nsim1
  
}#end j loop

plot(power.b1 ~ bvec1,main = sample_size1)

#the above code broke and just yields a straight line at a power of 1.0 but I know that is incorrect because i tried changing the sample size in the first group of code before this and it yielded me an actual plot. 
#So i am unfortunately going to have to just use the same variable names and just change the values in the interest of time since I still have the results section for my Part 1 to finish at the time of writing this. 
#If you have any idea as to why the above code doesn't work I would love to know, I can't seem to find the issue.
#That being said I am going to have the different examples separated, each example is just going to have to be run independently to see how the power changes due to sample size and slope.

#2. For sample size = 40 and slope = -2 to 2

sample_size <- 40
a <- 2 #intercept
sd <- 8

nsim <- 400
bvec <- seq(-2, 2, by = 0.1) #generates seq of various slopes between -2 and 2
power.b <- numeric(length(bvec))
pval <- numeric(nsim)


for(j in 1:length(bvec)){
  for(i in 1:nsim){
    
    x <- sample(x = 1:40,
                size = sample_size,
                replace = TRUE)
    
    b <- bvec[j]#b is the slope and comes from the vector bvec
    y_det <- a + b*x
    y <- rnorm(n = length(y_det),
               mean = y_det,
               sd = sd)
    
    m <- lm(y ~ x)
    
    #get p-value
    
    pval[i] <- coef(summary(m))["x","Pr(>|t|)"]
    
  }#end i loop
  power.b[j] <- sum(pval< 0.05)/nsim
  
}#end j loop

plot(power.b ~ bvec,main = sample_size)

#3. For sample size = 20 and slope = -5 to 5

sample_size <- 20
a <- 2 #intercept
sd <- 8

nsim <- 400
bvec <- seq(-5, 5, by = 0.1) #generates seq of various slopes between -2 and 2
power.b <- numeric(length(bvec))
pval <- numeric(nsim)


for(j in 1:length(bvec)){
  for(i in 1:nsim){
    
    x <- sample(x = 1:20,
                size = sample_size,
                replace = TRUE)
    
    b <- bvec[j]#b is the slope and comes from the vector bvec
    y_det <- a + b*x
    y <- rnorm(n = length(y_det),
               mean = y_det,
               sd = sd)
    
    m <- lm(y ~ x)
    
    #get p-value
    
    pval[i] <- coef(summary(m))["x","Pr(>|t|)"]
    
  }#end i loop
  power.b[j] <- sum(pval< 0.05)/nsim
  
}#end j loop

plot(power.b ~ bvec,main = sample_size)

#ANALYSIS OF PART 3: When sample size increases the power increases as evident by the majority of values for the Sample size = 40 example residing on the Power = 1.0, the width of the "V" in the middle is narrower as well.
#As slope increases (either negative or positive) the power increases as well, as also seen by the majority of the values residing on the Power = 1.0. when we look at the sample size of 20 and the slope between -2 and 2, 
#there's more noise in the graph. the two plots afterwards have less noise.
