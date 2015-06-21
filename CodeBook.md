---
title: Course project for Coursera "Getting and Cleaning Data"
author: Walter Hoyer
date: 2015-06-21
---
 
### Project Description
Course project using Samsung S accelerometer and gyroscope data (reference **[1]** below)
 
### Study design and data processing

For all details regarding the study itself, please refer to [README file](README.md) within the same repository.
 
### Creating and storing the tidy datafile

The tidy data file is created using the R-script [run_analysis.R](run_analysis.R) within this repository. 
The following steps have been performed by and are largely commented within the R code.

#### Prerequisites

* The file has to be stored in the same folder as the folder `UCI HAR Dataset` unzipped from the
[original data source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
* packages `dplyr` and `reshape2`need to be installed.


#### Reading data

##### Reading of meta data, i.e. feature list and activities by ID

File | Description |Comment | R data frame
-----|-------------|--------|-------------
features.txt  | text file without header, containing 561 different features with their feature ID | imported by `read.table`, assigning column headers "featID" and "Feature" | features
activity_labels.txt | text file without header containing 6 activities with their activity ID  | imported by `read.table`, assigning column headers "ActID" and "Activity" | actLabels

##### Reading of data related to training data set

* All three following files have 7352 observations.
* All three following files are stored in folder "UCI HAR Dataset/train/" in the unzipped original data.

File | Description |Comment | R data frame
-----|-------------|--------|-------------
subject_train.txt | text file without header, containing single column with one subject ID per line. | imported by `read.table`, assigning column header "Subject" | trainSubj
Y_train.txt | text file without header, containing single column withone activity ID per line. | imported by `read.table`, assigning column header "ActID" | trainY
X_train.txt | text file without headers, containing 561-element feature vector for each observation | imported by `read.table` with option `colClasses="numeric"` | trainX

* All three files are combined into one data frame `train` via

	`train <- cbind(Group="training", trainSubj, trainY, trainX)`
* Resulting data set contains additional grouping variable "Group" (set to "training") as well as subject and activity ID

##### Reading of data related to test data set.
* The three files have the same structure and content as the data for training data.
* The difference lies in the number of observations (2947 observations for each file) as well as file and folder names.
* All three following files are stored in folder "UCI HAR Dataset/test/" in the unzipped original data.

File | Description |Comment | R data frame
-----|-------------|--------|-------------
subject_test.txt | text file without header, containing single column with one subject ID per line. | imported by `read.table`, assigning column header "Subject" | testSubj
Y_test.txt | text file without header, containing single column with one activity ID per line. | imported by `read.table`, assigning column header "ActID" | testY
X_test.txt | text file without headers, containing 561-element feature vector for each observation | imported by `read.table` with option `colClasses="numeric"` | testX

* All three files are combined into one data frame `test` via

	`test <- cbind(Group="test", testSubj, testY, testX)`
* Resulting data set contains additional grouping variable "Group" (set to "test") as well as subject and activity ID

#### Reshaping data towards the tidy data set

Test and training data are actually two parts of a larger data set; in the original experiment data had been collected on a number
of 30 test persons, 21 of which have been used as training data set and the remaining 9 as test data set.

 * Both parts are combined in a new data frame via `total <- rbind(test,train)`
 * A new column with the activity labels (in plain English) is introduced by merging with the "actLabels" data set
 via `total <- merge(actLabels,total, by="ActID")`
 * The resulting data set is sorted by subject ID and stored as new data frame "totalSorted"
 * The non-descriptive column names "V1" up to "V561" are replaced by the individual features via 

	names(totalSorted)[5:565] <- as.character(features$Feature)

##### Subsetting to desired columns

Only columns containing means or standard deviations of measurements should be summarized in the final tidy data frame.
Those column IDs are extracted via `grep` with the key words "mean" or "std",

	tidy <- totalSorted[,c(1:4,sort(c(grep("std",names(totalSorted)),
                    grep("mean", names(totalSorted)))))]

Using melt and dcast the final tidy data frame is obtained via

	tidyMelt <- melt(tidy, id=c("ActID", "Activity", "Subject", "Group"),
                    measure.vars=c(5:83))

	tidyFinal <- dcast(tidyMelt, formula = Subject + Group + variable ~ Activity,
                    fun.aggregate=mean)

and the column "variable" is renamed to the more descriptive name "Feature".

#### Storing final tidy data frame as txt file

In the original folder in which the R script and the data folder "UCI HAR Dataset" are located, a new folder
"UCI HAR tidy data" is created if it does not exist.

In this folder the final data set is saved via the `write.table` command. The decimal separator is the "." and
the columns are separated by a tabulator. The final txt file follows the naming convention **tidy data 1900-01-01.txt**
with the date replaced by the date of creation.


### Description of the variables in the tidy data txt file

The final tidy data set is stored as a tab-separated txt fie in the foder "UCI HAR tidy data". The dimension of
the corresponding data frame "tidyFinal" created by the script [run_analysis.R](run_analysis.R) is 2370 rows by 9 columns.

The 2370 rows contain average values of 79 different features for 30 subjects (30 x 79 = 2370). The 9 columns
are 3 descriptor variables and 6 numeric columns containing the averages for the 6 different activities as
described in the table below.

Column name | class | Comment
------------|-------|--------
Subject	| integer	| Subject ID randing from 1 to 30. Data frame is sorted by this ID.
Group	| factor	| Two-level factor with levels "test" and "training" describing the assignment of the subject to the two groups.
Feature	| factor	| Factor with 79 levels corresponding to those features which are mean or standard deviation of a measurement.
LAYING	| numeric	| Average result for subject-feature combination while laying.
SITTING	| numeric	| Average result for subject-feature combination while sitting.
STANDING	| numeric	| Average result for subject-feature combination while standing.
WALKING	| numeric	| Average result for subject-feature combination while walking.
WALKING_DOWNSTAIRS	| numeric	| Average result for subject-feature combination while walking downstairs.
WALKING_UPSTAIRS	| numeric	| Average result for subject-feature combination while walking upstairs.

The 79 (out of the total 561) features corresponding to means and standard deviations of measurements are listed in the
file [featureList.md](featureList.md) also contained in this repository.


### References
The dataset has originally been published in the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 
