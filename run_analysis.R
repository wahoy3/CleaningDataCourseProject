#-------------------------------------------------------#
# Script for course project on Coursera course "Getting
# and cleaning data", producing tidy data set with
# averages across certain features by subject and
# activity
#-------------------------------------------------------#
# This script needs to be stored in a folder together
# with the unzipped original data. In particular, the
# folder "UCI HAR Dataset" and the script need to be
# in the same folder.
#-------------------------------------------------------#
# Author: Walter Hoyer
# Last change: 2015-06-21
#-------------------------------------------------------#
setwd("UCI HAR Dataset")

library(dplyr)
library(reshape2)
#---------------------------------------------------------
# Reading feature list and activity labels
#---------------------------------------------------------
# 561 features extracted from raw data
features <- read.table("features.txt", stringsAsFactors=FALSE,
                      col.names=c("featID", "Feature"))
# six activity labels with legend
actLabels <- read.table("activity_labels.txt", stringsAsFactors=FALSE,
                        col.names=c("ActID","Activity"))

#---------------------------------------------------------
# Reading feature list and activity labels
# for 7352 subjects in training group
#---------------------------------------------------------
# 7352 subjects performing the activities while being video-recorded
trainSubj <- read.table("train/subject_train.txt", col.names="Subject")

# vector with 7352 activities
trainY <-  read.table("train/Y_train.txt", col.names="ActID")

# 7352 rows (subjects) x 561 columns (derived results)
trainX <-  read.table("train/X_train.txt",  colClasses="numeric")

train <- cbind(Group="training", trainSubj, trainY, trainX)

#---------------------------------------------------------
# Reading feature list and activity labels
# for 2947 subjects in test group
#---------------------------------------------------------
# 2947 subjects performing the activities while being video-recorded
testSubj <- read.table("test/subject_test.txt", col.names="Subject")

# vector with 2947 activities
testY <-  read.table("test/Y_test.txt", col.names="ActID")

# 2947 rows (subjects) x 561 columns (derived results)
testX <-  read.table("test/X_test.txt", colClasses="numeric")

test <- cbind(Group="test", testSubj, testY, testX)

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

