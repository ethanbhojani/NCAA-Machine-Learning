##Clear the workspace
ls()
rm(list=ls())


##get working directory
getwd()
setwd("C:/Users/ethan/Desktop/ncaa raw data/DataFiles/")
list.files()

#install.packages("openxlsx")

library("openxlsx")

teamStats <- read.xlsx("mSchoolYearlyData.xlsx", 1, colNames = TRUE)

##compile packages
library("dplyr")
library("stringr")
library("tidyr")
#install.packages("gmodels")
library("gmodels")
head(schooldata)
colnames(schooldata)

##Import school IDS

teamID <- read.csv("Teams.csv")

##Alternate Team Names
alternateNames <- read.csv("TeamSpellings.csv")

head(teamID)
head(teamStats)
head(alternateNames)

##Need to match these names
#Format alternateNames
colnames(alternateNames)[1] <- "School"
alternateNames$School <- str_squish(tolower(as.character(alternateNames$School)))
alternateNames$School <- str_squish(gsub("[()]", "", alternateNames$School))
alternateNames$School[746] <- "purdue-fort wayne"
#Format teamStats
teamStats$School <- tolower(as.character(teamStats$School))
teamStats$School <- gsub(paste0("\\b(",paste("ncaa", collapse="|"),")\\b"), "", teamStats$School)
teamStats$School <- gsub("[()]", "", teamStats$School)
teamStats$School <- str_squish(teamStats$School)

##Checking
missing_names <- rep(NA, length(teamStats$School))
for (i in 1:length(teamStats$School)) {
  if (sum(str_detect(alternateNames$School, teamStats$School[i])) == 0) {
    missing_names[i] <- teamStats$School[i]
  }
}
missing_names2 <- missing_names[!is.na(missing_names)]
missing_names3 <- unique(missing_names2)
missing_names3

##Now that all id's are accounted for, we will add in the ids
teamStats <- cbind(teamStats, rep(NA, nrow(teamStats)))
colnames(teamStats)[47] <- "teamID"

for (i in 1:length(teamStats$School)) {
  if (sum(str_detect(alternateNames$School, teamStats$School[i])) == 1) {
    teamStats$teamID[i] <- alternateNames[which(str_detect(alternateNames$School, teamStats$School[i])), 2]
  }
}

teamStats <- teamStats[, c(1, 47, 2:46)]