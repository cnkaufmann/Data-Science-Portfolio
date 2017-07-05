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
for (year in c_years) {
  dofile_act <- paste("/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_", year, "/atusact_", year, ".do", sep="")
  fileold <- readLines(dofile_act)
  filenew <- gsub(pattern = paste("c:\\\\atusact_", year, ".dat", sep=""), replace = paste("\"/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/atusact_", year, "/atusact_", year, ".dat\"", sep=""), x=fileold)
  filepath <- paste('save \"/Users/christopherkaufmann/Datasets/Time Use Survey/DataSciencePort/FilesToImport/atusact_', year, '.dta\", replace', sep="")
  filenew <- append(filenew, filepath)
  writeLines(filenew, con=dofile_act)
}

#Using R Package: RStata
install.packages("RStata")
options("RStata.StataPath" = "/Applications/Stata/StataSE.app/Contents/MacOS/stata-se") #Setup Path
options("RStata.StataVersion" = 13) #Setup Version



