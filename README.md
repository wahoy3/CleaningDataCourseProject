## CleaningDataCourseProject

### Readme file describing the files in the repository and how they work together

#### Background

Course project is on activity data taken from the accelerometers of the Samsung Galaxy S smartphone. 
A full description is available at [the original 
site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

#### Files
In addition to the readme file this repository contains

 * this README file describing the overall structure of the repo, the files, the data origin, etc.
 * an R script which reads the data if it is stored in the same directory in which the original zipped data set has been extracted
 * a code book describing the tidy data set with all its columns

#### Structure of original data
The original data folder already contains two kinds of data:

1. The raw data from the accelerometer and gyroscopes, all txt files stored in the subfolder "Intertial signals"
2. Derived data sets with a 561 feature vector extracted for each observation.

A number of 30 subjects have been video taped while performing one of six activities. 

The present exercise treats the derived feature list as the new raw data, reading it into R and reshaping it into a 
tidy data set which contains summary statistics, summarized over subject and activity. (This is possible since each 
subject has performed each activity multiple times. In the original data set the individual observations are still
kept separate.)

During the original study the 30 subjects had been separated in two groups - a training and a test group. In the present
exercise both groups are recombined. More specifically, there are two folders called "train" and "test" which contain 
equally structured files. Both folders contain

1. A 561-feature vector with time and frequency domain variables. 
2. Its activity label. 
3. An identifier of the subject who carried out the experiment.

The length of each of the three files is identical and corresponds to the number of observations in the respective group. There
were 2947 observations from 9 subjects performing 6 activities for the test group, and 7352 observations from 21 subjects performing
the same 6 activities in the training group. On average there were 57 observations for each subject-activity combination.
