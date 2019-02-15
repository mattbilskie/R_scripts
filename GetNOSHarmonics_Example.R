############################################
# Matthew V. Bilskie, PhD
# Copyright 2018
# Louisiana State University
# Center for Coastal Resiliency
# www.lsu.edu/ccr
# www.mattbilskie.com
############################################
#
# Gather NOAA NOS water levels
# https://tidesandcurrents.noaa.gov/api/
#
############################################

library(ggplot2)
library(lubridate)
source("get_NOAA_Harmonics.R")

setwd("./")

stationList <- list("8741041","8741196")

for(station in stationList){
  print(paste("Working on",station))

  # Grab the data!
  data <- getNOSHarmonics(station)
  data$Pha_deg <- NISTradianTOdeg(data$Pha_rad)
  data$Station <- station
  
  # Save to CSV file
  write.table(format(data[,c("Amp_m","Pha_deg")], digits=4), file = paste("NOAA",station,"_Resynthesis",".txt", sep = ""),
              col.names = FALSE, row.names = FALSE, sep = "\t", quote = FALSE)

  
  time <- seq(0, 86400*14, 60*60)
  watlev <- vector(mode="numeric", length=length(time))
  for (c in 1:length(data$Name)) {
    for (t in 1:length(time)) {
      watlev[t] <- watlev[t] + data$Amp_m[c] * cos(time[t]*data$Speed_rad_sec[c] + data$Pha_rad[c])
    }
  }
  
  plotter.df <- data.frame(time,watlev)
  plot <- ggplot(plotter.df, aes(x = time/86400, y = watlev, color = "Resynthesis")) +
    geom_line(group = 1, size = 1.25) +
    scale_color_manual(values = c("black")) +
    scale_y_continuous(limits=c(-1,1)) +
    ylab("Water Level (m)") +
    xlab("Days") +
    labs(title = paste("NOAA",station)) +
    theme_bw() +
    theme(legend.position = c(0.075,0.9),legend.margin=margin(t=0,unit="cm"),legend.title=element_blank())
  plot
  ggsave(paste("NOAA",station,"_Resynthesis.png",sep=""), dpi = 300, width = 10, height = 5, units = "in")
  
}

