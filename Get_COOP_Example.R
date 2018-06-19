############################################
# Matthew V. Bilskie, PhD
# Copyright 2018
# Louisiana State University
# Center for Coastal Resiliency
# www.lsu.edu/ccr
# www.mattbilskie.com
############################################
#
# Example R-script to gather and plot NOAA water level data
# https://tidesandcurrents.noaa.gov/api/
#
############################################

library(ggplot2)
library(lubridate)
source("getCOOPS.R")

setwd("D:/Documents/PROJECTS/EESLR+N2E2/NuisanceFlooding/Mobile")

gageID = "8736897"
sdate = "20170510"
edate = "20170525"
datum = "mhhw"
units = "metric"
interval = ""
time_zone = "gmt"

product = "water_level"
wl_6min <- getCOOPS(gageID, sdate, edate, product, datum, units, interval, time_zone)
plot_6min <- ggplot(wl_hr, aes(x = Date.Time, y = Water.Level)) +
  geom_line(group = 1)
plot_6min

product = "predictions"
prwl <- getCOOPS(gageID, sdate, edate, product, datum, units, interval, time_zone)
prwl <- subset(prwl,minute(as.POSIXct(prwl$Date.Time)) < 1) # Keeps only hourly data
plot_prwl <- ggplot(prwl, aes(x = Date.Time, y = Prediction)) +
  geom_line(group = 1)
plot_prwl

product = "hourly_height"
wl_hr <- getCOOPS(gageID, sdate, edate, product, datum, units, interval, time_zone)
plot_wl <- ggplot(wl_hr, aes(x = Date.Time, y = Water.Level)) +
  geom_line(group = 1)
plot_wl

# Add prediction to wl_hr data frame
wl_hr$Prediction <- prwl$Prediction
wl_hr$Diff <- wl_hr$Water.Level - wl_hr$Prediction
wl_hr[["Sigma"]] <- NULL
wl_hr[["I"]] <- NULL
wl_hr[["L"]] <- NULL

wl_hr$Date.Time <- as.POSIXct(wl_hr$Date.Time, format = "%Y-%m-%d %H:%M")

plot_wl <- ggplot(wl_hr, aes(x = Date.Time, y = Water.Level, color = "Observed")) +
  geom_line(group = 1, size = 1.25) +
  geom_line(data = wl_hr, aes(x = Date.Time, y = Prediction,color = "Predicted"), group = 1, size = 1.25) +
  geom_line(data = wl_hr, aes(x = Date.Time, y = Diff,color = "Residual"), group = 1, size = 1.25) +
  scale_color_manual(values = c("blue","red","orange")) +
  scale_x_datetime(date_breaks="2 day") +
  scale_y_continuous(limits=c(-0.75,0.75)) +
  labs(y = "Water Level (m, MHHW)") +
  theme_bw() +
  theme(legend.position = "top",legend.margin=margin(t=0,unit="cm"),legend.title=element_blank())
plot_wl
ggsave("WaterLevel_Plot.png", dpi = 300, width = 10, height = 5, units = "in")
