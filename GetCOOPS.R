############################################
# Matthew V. Bilskie, PhD
# Copyright 2018
# Louisiana State University
# Center for Coastal Resiliency
# www.lsu.edu/ccr
# www.mattbilskie.com
############################################
#
# R function to gather NOAA Co-ops data
# https://tidesandcurrents.noaa.gov/api/
#
############################################

getCOOPS <- function(gageID, sdate, edate, product, datum, units, interval, time_zone){
  library(RCurl)
  fileURL <- paste("http://tidesandcurrents.noaa.gov/api/datagetter?begin_date=",sdate,"&end_date=",edate,"&station=",gageID,"&product=",product,"&datum=",datum,"&units=",units,"&interval=",interval,"&time_zone=",time_zone,"&application=web_services&format=csv", sep='')
  
  csv_file <- getURL(fileURL, .opts=curlOptions(followlocation = TRUE))
  return(read.csv(textConnection(csv_file), header = T))
}
