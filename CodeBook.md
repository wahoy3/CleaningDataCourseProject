---
title: Course project for Coursera "Getting and Cleaning Data"
author: Walter Hoyer
date: 2015-06-21
---
 
## Project Description
Course project using Samsung S accelerometer and gyroscope data
 
##Study design and data processing

For all details regarding the study itself, please refer to [README file](README.md) within the same repository.
 
##Creating the tidy datafile
 
###Guide to create the tidy data file
The tidy data file is created using the R-script `run_analysis.R` within this repository. 
The following steps have been performed and are commented in the R code.

#### Prerequisites
#
* The file has to be stored in the same folder as the folder `UCI HAR Dataset` unzipped from the
[original data source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
* packages `dplyr` and `reshape2`need to be installed.


#### Reading data

##### Reading of meta data, i.e. feature list and activities by ID

File | Description |Comment | R data frame
-----|-------------|--------|-------------
features.txt  | text file without header, containing 561 different features with their feature ID | imported by `read.table`, assigning column headers "featID" and "Feature" | features
activity_labels.txt | text file without header containing 6 activities with their activity ID  | imported by `read.table`, assigning column headers "ActID" and "Activity" | actLabels

##### Reading off data related to training data set.
* All three following files have 7352 observations.
* All three following files are stored in folder "UCI HAR Dataset/train/" in the unzipped original data.

File | Description |Comment | R data frame
-----|-------------|--------|-------------
subject_train.txt | text file without header, containing one subject ID per line. | imported by `read.table`, assigning column header "Subject" | trainSubj
Y_train.txt | text file without header, containing one activity ID per line. | imported by `read.table`, assigning column header "ActID" | trainY
X_train.txt | text file without headers, containing 561-element feature vector for each observation | imported by `read.table` with option `colClasses="numeric"` | trainX

* All three files are combined into one data frame `train` via
`train <- cbind(Group="training", trainSubj, trainY, trainX)`

##### Reading off data related to test data set.
* Three files have the same structure and content as the data for training data
* All three following files have 2947 observations.
* All three following files are stored in folder "UCI HAR Dataset/test/" in the unzipped original data.

File | Description |Comment | R data frame
-----|-------------|--------|-------------
subject_test.txt | text file without header, containing one subject ID per line. | imported by `read.table`, assigning column header "Subject" | testSubj
Y_test.txt | text file without header, containing one activity ID per line. | imported by `read.table`, assigning column header "ActID" | testY
X_test.txt | text file without headers, containing 561-element feature vector for each observation | imported by `read.table` with option `colClasses="numeric"` | testX

* All three files are combined into one data frame `test` via
`test <- cbind(Group="test", testSubj, testY, testX)`



 * Combining test and training data set, merging by activity labels, sorting by subject ID
 * Subsetting data set to features which are mean or standard deviation of a measurement
 * Creating final tidy data of size 2370 x 9:
	 - Unique key to each observation is contained in first 3 columns ´Subject´, ´Group´ (´training´ or ´test´) and ´Feature´
	 - The remaining 6 columns contain the average across all available observations for each feature
 * Storing the final data in a separate folder ´UCI HAR tidy data´, including the date in the file name (e.g. ´tidy 1900-01-01.txt´

Description on how to create the tidy data file (1. download the data, ...)/
 
###Cleaning of the data
Short, high-level description of what the cleaning script does. [link to the readme document that describes the code in greater detail]()
 
##Description of the variables in the tiny_data.txt file
General description of the file including:
 - Dimensions of the dataset
 - Summary of the data
 - Variables present in the dataset
 
(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)
 
###Variable 1 (repeat this section for all variables in the dataset)
Short description of what the variable describes.
 
Some information on the variable including:
 - Class of the variable
 - Unique values/levels of the variable
 - Unit of measurement (if no unit of measurement list this as well)
 - In case names follow some schema, describe how entries were constructed (for example time-body-gyroscope-z has 4 levels of descriptors. Describe these 4 levels). 
 
(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)
 
####Notes on variable 1:
If available, some additional notes on the variable not covered elsewehere. If no notes are present leave this section out.
 

#-------------------------------------------------------#
#-------------------------------------------------------#

#---------------------------------------------------------
# combining training and test data-set
#---------------------------------------------------------
total <- rbind(test,train)
total <- merge(actLabels,total, by="ActID")
totalSorted <- total[order(total$Subject),]

names(totalSorted)[5:565] <- as.character(features$Feature)

tidy <- totalSorted[,c(1:4,sort(c(grep("std",names(totalSorted)),
                    grep("mean", names(totalSorted)))))]

tidyMelt <- melt(tidy, id=c("ActID", "Activity", "Subject", "Group"),
                    measure.vars=c(5:83))

tidyFinal <- dcast(tidyMelt, formula = Subject + Group + variable ~ Activity,
                    fun.aggregate=mean)

names(tidyFinal)[3] <- "Feature"

#---------------------------------------------------------
# creating output directory and saving data
#---------------------------------------------------------
setwd("..")
if (!file.exists("UCI HAR tidy data")) dir.create("UCI HAR tidy data")
setwd("UCI HAR tidy data")
write.table(tidyFinal, file=paste0("tidy ",Sys.Date(),".txt"),
                              quote=FALSE, sep="\t", dec=".", row.names=FALSE)





##Sources
Sources you used if any, otherise leave out.
 
##Annex
If you used any code in the codebook that had the echo=FALSE attribute post this here (make sure you set the results parameter to 'hide' as you do not want the results to show again)