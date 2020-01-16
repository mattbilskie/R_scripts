############################################
# Matthew V. Bilskie, PhD
# Copyright 2019
# Louisiana State University
# Center for Coastal Resiliency
# www.lsu.edu/ccr
# www.mattbilskie.com
############################################
#
# R function to gather NOAA Co-ops
# tidal harmonic data
# https://tidesandcurrents.noaa.gov/api/
#
############################################

getNOSHarmonics <- function(gageID){
  
require(rvest) # For web-scraping
require(NISTunits) # For radians/degrees conversion\

# Load the NOS full constituent database of Names
NOS_constit <- readRDS(file = "NOS_Constituents.rds")

# Scrape NOS Tides/Currents Harmonics Page to obtain a table of harmonic constituent information
#nosID <- '8741041'
url <- paste('https://www.tidesandcurrents.noaa.gov/harcon.html?unit=0&timezone=0&id=',gageID,sep="")
webpage <- read_html(url)
#Using CSS selectors to scrap the rankings section
text <- html_nodes(webpage,'td')
#Converting the ranking data to text
data <- toString(html_text(text)) # toString converts it to a single line
# parse data and move to data frame
data.df <- read.table(text=data,sep = ",",col.names=c("ID", "Name", "Amp_m","Pha_deg","Speed_deg_hr","Desc"))

# Compare obtained NOS constituents to the full NOS set that should be present (37 constituents)
if (nrow(NOS_constit) != nrow(data.df)) {
  
  # we need to fill in the blanks
  i <- 1
  while (i <= nrow(NOS_constit)) {
    if (i != data.df[i,]$ID || is.na(data.df[i,]$ID)) {
      row <- NOS_constit[i,]
      data.df <- rbind(data.df[1:i-1,],row,data.df[-(1:i-1),])
      #i <- i + 1
    } else {
      i <- i + 1
    }
    
  }
  
}

# Prepare data for plotting
const.df <- data.df
# Convert phase from degrees to radians and speed to rad/sec
const.df$Pha_rad <- NISTdegTOradian(data.df$Pha_deg)
const.df$Speed_rad_sec <- NISTdegTOradian(data.df$Speed_deg_hr) / 3600.0
# Clean up data frame and re-order
const.df$Pha_deg <- NULL
const.df$Speed_deg_hr <- NULL
# Reorder data frame
const.df <- const.df[c("ID","Name","Amp_m","Pha_rad","Speed_rad_sec","Desc")]

return(const.df)

}
