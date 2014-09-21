
if(! require("assertthat")) {
    install.packages("assertthat")
}
library(assertthat)

if(! require("stringr")) {
    install.packages("stringr")
}
library(stringr)

if(! require("magrittr")) {
    install.packages("magrittr")
}
library(magrittr)

if(! require("plyr")) {
    install.packages("plyr")
}
library(dplyr)

if(! require("dplyr")) {
    install.packages("dplyr")
}
library(dplyr)

if (! file.exists("./UCI HAR Dataset.zip")) {
    download.file(
       "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
        destfile="./UCI HAR Dataset.zip",
        method="curl")
}

if (! file.exists("./UCI HAR Dataset")) {
    unzip("./UCI HAR Dataset.zip")
    list.files()
}

rm(list=ls())

if(file.exists("./dfTidy.txt")) {
    file.remove("./dfTidy.txt")
}

getwd()

list.files()
setwd("./UCI HAR Dataset")
list.files()
setwd("./train")
list.files()
dfTrainY <- read.table("./Y_train.txt", header=FALSE)
dfTrainSubject <- read.table("./subject_train.txt", header=FALSE)
dfTrainX <- read.table("./X_train.txt", header=FALSE)
setwd("../")
setwd("./test")
list.files()
dfTestY <- read.table("./Y_test.txt", header=FALSE)
dfTestSubject <- read.table("./subject_test.txt", header=FALSE)
dfTestX <- read.table("./X_test.txt", header=FALSE)
setwd("../")
list.files()

assert_that(length(dfTrainSubject) == length(dfTestSubject))
assert_that(nrow(dfTrainSubject) != nrow(dfTestSubject))

assert_that(length(dfTrainY) == length(dfTestY))
assert_that(nrow(dfTrainY) != nrow(dfTestY))

assert_that(length(dfTrainX) == length(dfTestX))
assert_that(nrow(dfTrainX) != nrow(dfTestX))

assert_that(nrow(dfTrainX) == nrow(dfTrainY))
assert_that(nrow(dfTrainY) == nrow(dfTrainSubject))
assert_that(nrow(dfTestX) == nrow(dfTestY))
assert_that(nrow(dfTestY) == nrow(dfTestSubject))

dfSubject <- rbind(dfTrainSubject, dfTestSubject)
assert_that(nrow(dfSubject) == (nrow(dfTrainSubject) + nrow(dfTestSubject)))
dfY <- rbind(dfTrainY, dfTestY)
assert_that(nrow(dfY) == (nrow(dfTrainY) + nrow(dfTestY)))

dfSubjidActivid <- cbind(dfSubject, dfY)

dfX <- rbind(dfTrainX, dfTestX)
assert_that(nrow(dfX) == (nrow(dfTrainX) + nrow(dfTestX)))

dfSamples <- cbind(dfSubjidActivid, dfX)

getwd()
vFeaturesNames <- readLines("./features.txt")
head(vFeaturesNames, n=10)

names(dfSamples)[1:5]
colnames(dfSamples) <- c("subjectID", "activityID", vFeaturesNames)
names(dfSamples)[1:5]

vDesiredColumns <- c(
    grep("mean()", colnames(dfSamples), fixed=TRUE),
    grep("std()", colnames(dfSamples), fixed=TRUE)) %>%
        sort
length(vDesiredColumns)

dfMinSamples <- dfSamples[, c(1, 2, vDesiredColumns)]
length(names(dfMinSamples))
names(dfMinSamples)[1:5]

vActivityNamesForId <- readLines("./activity_labels.txt")
vActivityNamesForId
vActivityNamesForId %<>% (function(x){str_replace(x, perl("^\\d+\\s+"), "")})
vActivityNamesForId

dfMinSamples$activityID %>% class
dfMinSamples$activityID %>% unique %>% sort
dfMinSamples$activityID %>% levels
dfMinSamples$activityID %<>% factor
dfMinSamples$activityID %>% levels
levels(dfMinSamples$activityID) <- vActivityNamesForId
dfMinSamples$activityID %>% levels

newNames <- colnames(dfMinSamples)
newNames

newNames %<>% (function(x){str_replace(x, perl("^\\d+\\s+"), "")})
newNames

newNames %<>% sapply(simplify=TRUE,
    FUN=function(x) {
        if (str_detect(x, perl("-mean\\(\\)"))) {
            n <- str_replace(x, perl("-mean\\(\\)"), "")
            x <- paste("Mean of ", n, sep="")

        }
        x
    })
newNames

newNames %<>% sapply(simplify=TRUE,
    FUN=function(x) {
        if (str_detect(x, perl("-std\\(\\)"))) {
            n <- str_replace(x, perl("-std\\(\\)"), "")
            x <- paste("Standard deviation of ", n, sep="")

        }
        x
    })
newNames

newNames %<>% sapply(simplify=TRUE,
    FUN=function(x) {
        x %>%
        str_replace(perl("-X$"), " on the X axis.") %>%
        str_replace(perl("-Y$"), " on the Y axis.") %>%
        str_replace(perl("-Z$"), " on the Z axis.")
    })
newNames

newNames %<>% str_replace(perl("\\stBodyAcc\\s"), " body acceleration by time ")
newNames

newNames %<>% str_replace(perl("\\stGravityAcc\\s"), " gravity acceleration by time ")
newNames

newNames %<>% str_replace(perl("\\stBodyAccJerk\\s"), " body acceleration jerk by time ")
newNames

newNames %<>% str_replace(perl("\\stBodyGyroJerk\\s*"), " body gyroscopic jerk by time ")
newNames

newNames %<>% str_replace(perl("\\stBodyGyroJerk\\s*"), " body gyroscopic jerk by time ")
newNames

newNames %<>% str_replace(perl("\\stBodyAccMag\\s*"), " body acceleration magnitude by time ")
newNames

newNames %<>% str_replace(perl("\\stGravityAccMag\\s*"), " gravity acceleration magnitude by time ")
newNames

newNames %<>% str_replace(perl("\\stBodyAccJerkMag\\s*"), " body acceleration jerk magnitude by time ")
newNames

newNames %<>% str_replace(perl("\\s\\s*"), " gravity acceleration magnitude by time ")
newNames

newNames %<>% str_replace(perl("\\stBodyGyroMag\\s*"), " body gyroscope magnitude by time ")
newNames

newNames %<>% str_replace(perl("\\s\\s*"), " gravity acceleration magnitude by time ")
newNames

newNames %<>% str_replace(perl("\\sfBodyAccJerk\\s"), " body acceleration jerk frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyGyro\\s"), " body acceleration frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyBodyGyroJerkMag\\s"), " body gyroscope jerk magnitude frequency ")
newNames

newNames %<>% str_replace(perl("\\stBodyGyro\\s"), " body gyroscope frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyGyroJerk\\s"), " body gyroscope jerk frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyAccMag\\s*"), " body acceleration magnitude frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyAccJerkMag\\s"), " body acceleration jerk magnitude frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyAcc\\s"), " body acceleration frequencyy ")
newNames

newNames %<>% str_replace(perl("\\sfBodyAccMag\\s"), " body acceleration magnitude frequencyy ")
newNames

newNames %<>% str_replace(perl("\\sfBodyBodyGyroJerkMag\\s*"), " body gyroscopic jerk magnitude by body frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyBodyAccJerkMag\\s*"), " body acceleration jerk magnitude frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyBodyGyroMag\\s*"), " body gyroscopic magnitude by body frequency ")
newNames

colnames(dfMinSamples) <- newNames
names(dfMinSamples)

class(dfMinSamples$subjectID)
dfMinSamples$subjectID %>% unique %>% sort
class(dfMinSamples$activityID)
dfMinSamples$activityID %>% unique %>% sort

dfMinSamples$subjectID <- as.factor(dfMinSamples$subjectID)
class(dfMinSamples$subjectID)
dfMinSamples$subjectID %>% unique %>% sort

subs <- length(levels(dfMinSamples$subjectID))
subs
acts <- length(levels(dfMinSamples$activityID))
acts
groupcheck <- subs * acts
groupcheck

dfTidy <- dfMinSamples %>%
         group_by(subjectID, activityID) %>%
         summarise_each(funs(mean))
assert_that(groupcheck == nrow(dfTidy))
dfTidy

setwd("../")

getwd()
list.files()
write.table(dfTidy, "./dfTidy.txt", row.name=FALSE)
list.files()
