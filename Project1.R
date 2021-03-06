#Data Setup:
setwd("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort")

#Downloading the 2003-2015 years of the ATUS. This includes the "activity" and "respondent" files.
c_years <- c(2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015)
for (year in c_years) {
  datafile_act <- paste("https://www.bls.gov/tus/special.requests/atusact_", year, ".zip", sep="")
  download.file(datafile_act, destfile=print(paste("atusact_", year, ".zip", sep="")))
  unzip(zipfile = paste("atusact_", year, ".zip", sep=""), exdir = paste("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_", year, sep=""))
  datafile_resp <- paste("https://www.bls.gov/tus/special.requests/atusresp_", year, ".zip", sep="")
  download.file(datafile_resp, destfile=print(paste("atusresp_", year, ".zip", sep="")))
  unzip(zipfile = paste("atusact_", year, ".zip", sep=""), exdir = paste("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusresp_", year, sep=""))
}

#In each exported folder, change the .do file to be linked to the correct file [Notice the regular expressions!!!]:
#Decided to go a different approach, so will not use this section. Commenting out for now:
#for (year in c_years) {
#  dofile_act <- paste("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_", year, "/atusact_", year, ".do", sep="")
#  fileold <- readLines(dofile_act)
#  filenew <- gsub(pattern = paste("c:\\\\atusact_", year, ".dat", sep=""), replace = paste("\"/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_", year, "/atusact_", year, ".dat\"", sep=""), x=fileold)
#  filepath <- paste('save \"/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/FilesToImport/atusact_', year, '.dta\", replace', sep="")
#  filenew <- append(filenew, filepath)
#  filenew <- append(filenew, "clear all")
#  filenew <- append(filenew, "exit")
#  writeLines(filenew, con=dofile_act)
#}

atuact_2003 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2003/atusact_2003.dat")
atuact_2004 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2004/atusact_2004.dat")
atuact_2005 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2005/atusact_2005.dat")
atuact_2006 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2006/atusact_2006.dat")
atuact_2007 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2007/atusact_2007.dat")
atuact_2008 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2008/atusact_2008.dat")
atuact_2009 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2009/atusact_2009.dat")
atuact_2010 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2010/atusact_2010.dat")
atuact_2011 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2011/atusact_2011.dat")
atuact_2012 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2012/atusact_2012.dat")
atuact_2013 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2013/atusact_2013.dat")
atuact_2014 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2014/atusact_2014.dat")
atuact_2015 <- read.csv("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_2015/atusact_2015.dat")

#Appending Datasets with dplyr
#install.packages("dplyr")
library(dplyr)
atus_allyears <- bind_rows(atuact_2003, atuact_2004, atuact_2005, atuact_2006, atuact_2007, atuact_2008, atuact_2009, atuact_2010, atuact_2011, atuact_2012, atuact_2013, atuact_2014, atuact_2015, .id = "year")
atus_allyears <- filter(.data = atus_allyears, TUTIER1CODE == 1 & TUTIER2CODE == 1)
atus_allyears <- select(.data = atus_allyears, matches("TUSTARTTIM"), matches("TUSTOPTIME"), matches("year"), matches("TUCASEID"), matches("TUACTDUR"))

#Using packge chron to turn times (stored at string) to times (stored as times)
#install.packages("chron")
library(chron)
atus_allyears$TUSTARTTIM <- chron(times = atus_allyears$TUSTARTTIM)
atus_allyears$TUSTOPTIME <- chron(times = atus_allyears$TUSTOPTIME)

#The ATUS was weird in that it started times at 4am, so I need to get the records that are the highest in each group. Will use dplyr.
atus_allyears <- atus_allyears %>% group_by(TUCASEID) %>% top_n(1, TUSTARTTIM)
summary(atus_allyears$TUSTARTTIM)

#There are some people who didn't go to sleep until after 4am, so I am going to just take those folks out...
atus_allyears <- filter(.data = atus_allyears, TUSTARTTIM != times("04:00:00")) # Lost 26,000 records but oh well... It's all about the Big T!

#Checking how many records per year:
table(atus_allyears$year)

#Creating data frame that creates the mean by each year:
atus_allyears$year <- as.numeric(atus_allyears$year) # Making year numeric... for some reason was string.
timeseries <- summarise(group_by(atus_allyears, year), mean(TUSTARTTIM, na.rm = TRUE))

#Graph:
plot(timeseries$year, timeseries$`mean(TUSTARTTIM, na.rm = TRUE)`)

#Why is it going down? (e.g., people are going to bed earlier???)
#Maybe it is because I deleted all those people who were night owls? (didn't sleep until later?)

#Let me try this with keeping those 4am'ers.

#OK... it goes up now? I think we need to check to see whether there is an increase in "Super Night Owls". Let's look at percentage:
atus_allyears$nightowl[which(atus_allyears$TUSTARTTIM == times("04:00:00"))] <- 1
atus_allyears$nightowl[which(is.na(atus_allyears$nightowl))] <- 0

#Checking proportions, and then checking by year
mytable <- table(atus_allyears$year, atus_allyears$nightowl)
prop.table(mytable, 1)
model <- glm(nightowl ~ year, family=binomial(link='logit'), data=atus_allyears)
model

#How about the tech geeks???
#Stratifying by those who spend <2, 3-6, 7+ hours on computer?



#Now visualizing the to bed times:
#install.packages("ggplot2")
library(ggplot2)
atus_allyears$linenum <- seq.int(nrow(atus_allyears))
plot(atus_allyears$TUSTARTTIM, atus_allyears$linenum, groups = atus_allyears$year)

atus_allyears <- atus_allyears[order(atus_allyears$year),]
atus_allyears %>% group_by(year) %>% summarise(avg = mean(TUSTARTTIM))
