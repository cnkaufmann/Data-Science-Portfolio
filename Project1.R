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




