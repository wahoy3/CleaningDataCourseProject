### CleaningDataCourseProject

#### Background

Course project is on activity data taken from the accelerometers of the Samsung Galaxy S smartphone. 
A full description is available at [the original 
site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
This README file references the original data, gives a brief description of the original data files, and gives
a summary of what has been done for the course project of the Coursera course "Getting andn Cleaning Data".

#### Files
In addition to the readme file this repository contains

 * this README file describing the overall structure of the repo, the files, the data origin, etc.
 * an [R script](run_analysis.R) which reads the data if it is stored in the same directory in which the original zipped data set has been extracted
 * a [code book](CodeBook.md) describing the tidy data set with all its columns, as well as the steps to get there.

#### Structure of original data

The original data has been captured on a number of 30 subjects who have been video taped while performing one of six activities. 
The accelerometer and gyroscope data within their Samsung smart phone has been sampled and preprocessed as described in
detail in the ´README.txt´ of the original data set. During the study the 30 subjects had been separated in two groups - a
training and a test group. In the present exercise both groups are merged. 

In summary, the original data folder already contains three types of data:

1. Preprocessed raw data from the accelerometers and gyroscopes; those files are available for the train and test data.
and stored in the subfolder subfolder ´Intertial signals´ within the folders ´train´ and ´test´, respectively. 
Files are available for three dimensions labeled X, Y, and Z and are carry names such as ´total_acc_x_train.txt´, ´body_acc_x_train.txt´
and ´body_gyro_x_train.txt´.

2. Derived data sets with a 561 feature vector extracted for each observation.
	- ´train/X_train.txt´: Training set with 7352 observations of a 561-element feature list.
	- ´train/y_train.txt´: Training labels with the actity ID for the 7352 observations.
	- ´train/subject_train.txt´: Training subject ID, linking the subject to each of the 7352 observations.
	- ´test/X_test.txt´: Test set with 2947 observations of a 561-element feature list.
	- ´test/y_test.txt´: Test labels with the actity ID for the 2947 observations.
	- ´test/subject_test.txt´: Test subject ID, linking the subject to each of the 2947 observations.

3. Explanatory files
	- ´README.txt´
	- ´features_info.txt´: Shows information about the variables used on the feature vector.
	- ´features.txt´: List of all features.
	- ´activity_labels.txt´: Links the class labels with their activity name.

The present exercise treats the derived feature list as the new raw data, reading it into R and reshaping it into a 
tidy data set which contains summary statistics, summarized over subject and activity. (This is possible since data from
each subject has been split into several time windows such that multiple observations are available for each subject-activity 
combination. In the original data set those individual samples are kept separate.)

Within the original data, there are two folders called ´train´ and ´test´ which contain equally structured files, as described
under point 2 above. The length of each of the three files is identical and corresponds to the number of observations in the
respective group. There were 2947 observations from 9 subjects performing 6 activities for the test group, and 7352 observations
from 21 subjects performing the same 6 activities in the training group. On average there were 57 individual observations (corresponding
to one of the sampled time-windows) for each subject-activity combination.

#### Processing of original data

The following steps have been performed and are commented in the R code. A full description can be found in the ´CodeBook.md´.
 * Reading of meta data, i.e. feature list and activities by ID
 * Reading of training data
	 - subject ID
	 - activity ID
	 - data frame with feature vectors
 * Reading of test data, structured as before
 * Combining test and training data set, merging by activity labels, sorting by subject ID
 * Subsetting data set to features which are mean or standard deviation of a measurement
 * Creating final tidy data of size 2370 x 9:
	 - Unique key to each observation is contained in first 3 columns ´Subject´, ´Group´ (´training´ or ´test´) and ´Feature´
	 - The remaining 6 columns contain the average across all available observations for each feature
 * Storing the final data in a separate folder ´UCI HAR tidy data´, including the date in the file name (e.g. ´tidy 1900-01-01.txt´

####Reference
The dataset has originally been published in the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 

