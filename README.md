# Getting and Cleaning Data Course Project
## Using samsung smartphone data set 
Version 1.0

### Author: Ganesan Alagu Ganesh
***
## Study Design
The raw data for the course project was obtained from accelerometers from the Samsung Galaxy S smarphone. A full description of the [*samsung data*](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) is available at the site where the data was obtained.

The data for the project was downloaded from the [*source URL*](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
 below [*https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip*] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

#### How to use the script?
The samsung [*dataset*](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is unzipped. There will be a folder named "UCI HAR Dataset". This is set as the working directory.
The run_analysis.R script is added and run from the "UCI HAR Dataset" folder

#### What the script does?

The script [*run_analysis.R*] does the following. 

1. Merge the training and the test sets to create one data set  
    * Read the feature data from X_test.txt and X_train.txt
    * Tidy the column names by removing hyphens, commas, underscores, open/close parenthesis and change all letters to lower case
    * Merge the test and train data into one data set
2. Append the subject id and activity for each record from the y_test.txt and y_train.txt to the merged data with column names "subjectid" and "activity"
3. Assign descriptive names to the activity
4. Extract only the measurements on the mean and standard deviation for each measurement and store in a data set as "mean_std.txt" in the working directory.
5. Create a second, independent tidy data set named as "tidy_data.txt" with the average of each variable for each activity and each subject in the working directory