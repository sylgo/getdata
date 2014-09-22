In this one R script called `run_analysis.R` we will do the following.

# Merge the training and the test sets to create one data set

## Provide required packages

All of the packages that I use are defined in `technical.md` in the `.Rprofile`
section. I attempted to install of the mandatory packages here and load them. If
any part of this fails, then please correct it and run the script again.

```R
if(! require("assertthat")) {
    install.packages("assertthat")
}
library(assertthat)

if(! require("stringr")) {
    install.packages("stringr")
}
library(stringr)

if(! require("devtools")) {
    install.packages("devtools")
}
library(devtools)
devtools::install_github("devtools")

if(! require("magrittr")) {
    install.packages("magrittr")
}
devtools::install_github("smbache/magrittr")
library(magrittr)

if(! require("plyr")) {
    install.packages("plyr")
}
library(dplyr)

if(! require("dplyr")) {
    install.packages("dplyr")
}
library(dplyr)
```

## Get the data archive and extract it

If the data archive does not exist, then download it.

```R
if (! file.exists("./UCI HAR Dataset.zip")) {
    download.file(
       "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
        destfile="./UCI HAR Dataset.zip",
        method="curl")
}
```

If the data archive has not been extracted, then extract it.

```R
if (! file.exists("./UCI HAR Dataset")) {
    unzip("./UCI HAR Dataset.zip")
    list.files()
}
```

## Prepare the working environment

Make sure that the workspace is empty every time that this program executes.

```R
rm(list=ls())
```

Remove the generated file.

```R
if(file.exists("./dfTidy.txt")) {
    file.remove("./dfTidy.txt")
}
```

Be aware of the working directory.

```R
getwd()
```

## Read the raw data files

Having viewed the data files we find that they are not CSV and are just plain
tabular data that can be loaded with `read.table`. None of the files have
header lines in them.

Note the order here, firs train then test, it is very important. It is also easy
to remember. We see things in terms of subject, activity, then sensor readings.

```R
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
```

## Assemble a single sample set from all of the available data

There are two sets of data, testing and training. Their samples live in X.
Additional columns live in Y and subject.

Do some checking on the additional columns to get a sense of how the additional
data will match up when it is merged with the samples and when the samples
themselves are merged.

Reminder:
-   subject: subject IDs
-   Y: activity IDs
-   X: sensor samples

```R
assert_that(length(dfTrainSubject) == length(dfTestSubject))
assert_that(nrow(dfTrainSubject) != nrow(dfTestSubject))
```

Sames goes for subject IDs.

```R
assert_that(length(dfTrainY) == length(dfTestY))
assert_that(nrow(dfTrainY) != nrow(dfTestY))
```

Sames goes for activity IDs.

```R
assert_that(length(dfTrainX) == length(dfTestX))
assert_that(nrow(dfTrainX) != nrow(dfTestX))
```

The X training and test sensor data have the same number of columns, but not
samples,which is OK.

The thing to note is that the same numbers are in place for the rows of X and
length of Y and subject because they will be column bound soon.

```R
assert_that(nrow(dfTrainX) == nrow(dfTrainY))
assert_that(nrow(dfTrainY) == nrow(dfTrainSubject))
assert_that(nrow(dfTestX) == nrow(dfTestY))
assert_that(nrow(dfTestY) == nrow(dfTestSubject))
```

The subject IDs, activity IDs, and sensor data are now ready to be attached
together.

The process in order is:

-   Stack the subject and activity ids on top of each other for train and test

```R
dfSubject <- rbind(dfTrainSubject, dfTestSubject)
assert_that(nrow(dfSubject) == (nrow(dfTrainSubject) + nrow(dfTestSubject)))
dfY <- rbind(dfTrainY, dfTestY)
assert_that(nrow(dfY) == (nrow(dfTrainY) + nrow(dfTestY)))
```

-   Stick those subject and activity ids next to each other

```R
dfSubjidActivid <- cbind(dfSubject, dfY)
```

-   Stack X sensor samples from training and test on top of each other

```R
dfX <- rbind(dfTrainX, dfTestX)
assert_that(nrow(dfX) == (nrow(dfTrainX) + nrow(dfTestX)))
```

-   Column bind the subject ID, sensor ID, and sensor sample data together

```R
dfSamples <- cbind(dfSubjidActivid, dfX)
```

# Extract only the measurements on the mean and standard deviation for each measurement

Before we may collect values from the samples, we need to give the columns names.
We know the first two, subjectID and activity ID. We also have a list of all
of the sensor variables names from the file `features.txt`. We can set the
column names directly using them.

The names be read directly into a character vector. Keeping the sensor number
in the names seems like it could be useful.

```R
getwd()
vFeaturesNames <- readLines("./features.txt")
head(vFeaturesNames, n=10)
```

Set the column names to the known two, and the ones read from file.

```R
names(dfSamples)[1:5]
colnames(dfSamples) <- c("subjectID", "activityID", vFeaturesNames)
names(dfSamples)[1:5]
```

`grep` will search for matching patterns, and we can use that with `colnames` to
get all of the matching sensor sample column names according to what we learned
in `features_info.txt`. It can be difficult to remember how to use
[regular expressions](https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html) keep that page open a lot. `fixed` can make it a lot easier to
define them.

```R
vDesiredColumns <- c(
    grep("mean()", colnames(dfSamples), fixed=TRUE),
    grep("std()", colnames(dfSamples), fixed=TRUE)) %>%
        sort
length(vDesiredColumns)
```

Obtain minimal data set of subjectID, activityID, and only desired columns..

```R
dfMinSamples <- dfSamples[, c(1, 2, vDesiredColumns)]
length(names(dfMinSamples))
names(dfMinSamples)[1:5]
```

# Use descriptive activity names to name the activities in the data set

The activity names live in here. Their primary keys are stored in the file, so
we don't need to keep the key name here.

```R
vActivityNamesForId <- readLines("./activity_labels.txt")
vActivityNamesForId
vActivityNamesForId %<>% (function(x){str_replace(x, perl("^\\d+\\s+"), "")})
vActivityNamesForId
```

The activity ID column needs to be a factor, so convert given its current type
and values for the activity labels for ID.

```R
dfMinSamples$activityID %>% class
dfMinSamples$activityID %>% unique %>% sort
dfMinSamples$activityID %>% levels
dfMinSamples$activityID %<>% factor
dfMinSamples$activityID %>% levels
levels(dfMinSamples$activityID) <- vActivityNamesForId
dfMinSamples$activityID %>% levels
```

# Appropriately label the data set with descriptive variable names

`features_info.txt` covertly provides a detailed description of what abbreviations
are used for the various sample names. It does so by first talking about the
source of the samples, which are an accelerometer and gyroscope. It then
provides an example data name of `tAcc` and `tGyro`. That is how it reveals to us
how the abbreviations are defined for two parts of the data.

It then goes on to talk about `tBodyAcc` and `tGravityAcc` are actually "time and
body acceleration signals". That is another abbreviation.

Because we have a map of sorts to identify abbreviations, we can do this a
little more easily by visually scanning column names and reading them. Each
time we see something not pretty, we know that we need to "make it more
descriptive".

The simplest way to perform this work is with regular-expression.

This work could have been performed earlier on during assignment of the column
names. However, that would have been out-of-order according to the approach
defined in assignment. There are always exceptions, but it makes more sense to
do it all in order. This is even more important given that grading is one by
peer review. The peer reviewers will have to read a bunch of other folks
assignments, so anything that makes it a more pleasant process will help.

I had to stare at the file for a while to make sense of how to transform the
names. It is kind of an iterative process of going back and forth between the
data and the definitions to determine how to phrase them.

The data is collected over time and processed as such:
-   XYZ data is collected from two sensors
    -   Accelerometer
    -   Gyroscope
-   Sensor XYZ data is processed into, per moment
    -   Body acceleration
        -   Including angular velocity
    -   Gravity acceleration
-   Body acceleration, and angular velocity which is also collected, identifies
    "jerks" in the motion, both at the body level and gyro level, in 3 dimensions
    -   Levels
        -   Body
        -   Gyroscope
    -   Kinds
        -   (Body|Gravity)AccelerationMagnitude
        -   Body
            -   Acceleration Jerk Magnitude
            -   Gyro magnitude
            -   Gyro jerk magnitude

Surely it would be easier if we were working with the study and could see what
really happens!

Start by looking at the column names and figuring out what to change. This is
doable having already read the column description document. The order of this
code is quite specific and surely a *regex-master* could do this in only a few
lines!

The short version is that columns will be made human readable how you would
read a sentence.

Start by looking at their current names.

```R
newNames <- colnames(dfMinSamples)
newNames
```

Remove the sample column number. That was from the original data frame and it
not correct for this one.

```R
newNames %<>% (function(x){str_replace(x, perl("^\\d+\\s+"), "")})
newNames
```

The `mean` and `std` indicators will get pulled from the middle to the start. Using
`sapply` has an interesting "side effect" that you may track the original name
that it began with. Since I relied upon vectorized operations previously though,
the true original is lost. Perhaps this could be a design choice.

```R
newNames %<>% sapply(simplify=TRUE,
    FUN=function(x) {
        if (str_detect(x, perl("-mean\\(\\)"))) {
            n <- str_replace(x, perl("-mean\\(\\)"), "")
            x <- paste("Mean of ", n, sep="")

        }
        x
    })
newNames
```

```R
newNames %<>% sapply(simplify=TRUE,
    FUN=function(x) {
        if (str_detect(x, perl("-std\\(\\)"))) {
            n <- str_replace(x, perl("-std\\(\\)"), "")
            x <- paste("Standard deviation of ", n, sep="")

        }
        x
    })
newNames
```

The events locations are measured in 3 dimensions. Make those human readable.

```R
newNames %<>% sapply(simplify=TRUE,
    FUN=function(x) {
        x %>%
        str_replace(perl("-X$"), " on the X axis.") %>%
        str_replace(perl("-Y$"), " on the Y axis.") %>%
        str_replace(perl("-Z$"), " on the Z axis.")
    })
newNames
```

That has probably been the easy stuff. The next stuff should be too much harder.
It all has to do with the breakdown of the samples by sensor and then by measure.
That list above makes sense of things if you read it out loud. Everything has
to do with a mean or std of the DEVICE's MEASURE on which axis. First start by
processing the device, and then the measure for them. The problem is that the
naming convention for variables it no consistent, so we have to deal with that
too. One of the keys for naming these things is that they are all occurring
either in the time or frequency domain.

Deal with body and gravity acceleration on all axes.

```R
newNames %<>% str_replace(perl("\\stBodyAcc\\s"), " body acceleration by time ")
newNames
```

```R
newNames %<>% str_replace(perl("\\stGravityAcc\\s"), " gravity acceleration by time ")
newNames
```

Deal with with jerk measurements on all axes for all types.

```R
newNames %<>% str_replace(perl("\\stBodyAccJerk\\s"), " body acceleration jerk by time ")
newNames
```

This is getting really tedious, now I'm just going to "get er done".

**By time**:

```R
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
```

**By frequency**:

```R
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

newNames %<>% str_replace(perl("\\sfBodyAcc\\s"), " body acceleration frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyAccMag\\s"), " body acceleration magnitude frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyBodyGyroJerkMag\\s*"), " body gyroscopic jerk magnitude by body frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyBodyAccJerkMag\\s*"), " body acceleration jerk magnitude frequency ")
newNames

newNames %<>% str_replace(perl("\\sfBodyBodyGyroMag\\s*"), " body gyroscopic magnitude by body frequency ")
newNames
```

In real life you would work with a subject matter expert I suppose. Once we
get to reporting it is easy to identify columns that you forgot to rename.

Rename the columns.

```R
colnames(dfMinSamples) <- newNames
names(dfMinSamples)
```

# Create a second, independent tidy data set with the average of each variable for each activity and each subject.

The task here is to split up the samples by every permutation of subjectID and
activityID to obtain the average of each of the columns. That permutation looks
like this.

```R
class(dfMinSamples$subjectID)
dfMinSamples$subjectID %>% unique %>% sort
class(dfMinSamples$activityID)
dfMinSamples$activityID %>% unique %>% sort
```

Subject ID should really be a factor, as it is not a quantitative value.

```R
dfMinSamples$subjectID <- as.factor(dfMinSamples$subjectID)
class(dfMinSamples$subjectID)
dfMinSamples$subjectID %>% unique %>% sort
```

Assuming that data were available for each group here, there would be this many
groups to report on by subjectID and activityID.

```R
subs <- length(levels(dfMinSamples$subjectID))
subs
acts <- length(levels(dfMinSamples$activityID))
acts
groupcheck <- subs * acts
groupcheck
```

You can see why we are pasting our tidy dataframe into the browser for evaluation.

Group by then summarize on all columns.

```R
dfTidy <- dfMinSamples %>%
         group_by(subjectID, activityID) %>%
         summarise_each(funs(mean))
assert_that(groupcheck == nrow(dfTidy))
dfTidy
```

Make sure it may run again.

```R
setwd("../")
```

Save it to a file.

```R
getwd()
list.files()
write.table(dfTidy, "./dfTidy.txt", row.name=FALSE)
list.files()
```
