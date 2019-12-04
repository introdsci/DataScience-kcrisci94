## ----results = "hide", message=FALSE-------------------------------------
library(tidyverse)
data <- read_csv("./Concentration - Weekly.csv")



## ------------------------------------------------------------------------
library(dplyr)
data <- data %>%
  na.omit


## ------------------------------------------------------------------------
colnames(data)[colnames(data)=="SO2_CONC"] <- "SO2" #Sulfur Dioxide
colnames(data)[colnames(data)=="SO4_CONC"] <- "SO4" #Sulfate
colnames(data)[colnames(data)=="NO3_CONC"] <- "NO3" #Nitrates
colnames(data)[colnames(data)=="HNO3_CONC"] <- "HNO3" #Nitric Acid
colnames(data)[colnames(data)=="TNO3_CONC"] <- "TNO3" #Total Nitrate
colnames(data)[colnames(data)=="NH4_CONC"] <- "NH4" #Ammonium
colnames(data)[colnames(data)=="CA_CONC"] <- "Ca" #Calcium
colnames(data)[colnames(data)=="NA_CONC"] <- "Na" #Soduim
colnames(data)[colnames(data)=="MG_CONC"] <- "Mg" #Magnesium
colnames(data)[colnames(data)=="K_CONC"] <- "K" #Potassioum
colnames(data)[colnames(data)=="CL_CONC"] <- "Cl" #Chlorine
colnames(data)[colnames(data)=="YEAR"] <- "Year"
colnames(data)


## ------------------------------------------------------------------------
data <- gather(data, key = "Molecule", value = "Concentration", "SO2":"Cl", convert = FALSE, factor_key = TRUE)
head(data)


## ------------------------------------------------------------------------
data$SITE_ID <- as.factor(data$SITE_ID)
data$YEAR <- as.factor(data$SITE_ID)
levels(data$SITE_ID)


## ------------------------------------------------------------------------
index <- c("CON186", "DEV412", "JOT403", "LAV410", "PIN414", "SEK402", "SEK430", "YOS404")
values <- c("San Bernardino", "Inyo", "San Bernadino", "Shasta", "San Benito", "Tulare", "Tulare", "Mariposa")

#create new column
data$County <- values[match(data$SITE_ID, index)] 


## ------------------------------------------------------------------------
data$DATEON <- as.POSIXct(parse_date(data$DATEON, format="%m/%d/%Y %H:%M:%S"))

data$DATEOFF <- as.POSIXct(parse_date(data$DATEOFF, format="%m/%d/%Y %H:%M:%S"))


## ------------------------------------------------------------------------
ggplot() + geom_boxplot(data, mapping=aes(x = Molecule, y = Concentration))


## ------------------------------------------------------------------------
years <- group_by(data, Year, Molecule)
summary <- summarize(years, ave_concentration = mean(Concentration))
ggplot() + geom_line(summary, mapping=aes(x = Year, y = ave_concentration, colour = Molecule))

