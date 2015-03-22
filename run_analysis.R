library(R.utils)
library(plyr)
library(dplyr)

## Remove everything within the environment
rm(list = ls())

## Cheeck if the folder "data" exist in the working directory, if not available, create it
if (!file.exists("data")) {
        dir.create("data")
}

## Specify url location and download file to specified directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./getnclean_proj_data/getnclean_proj.zip")

## Unzip the downloaded file and show the files extracted
unzip("./getnclean_proj_data/getnclean_proj.zip", exdir = "./getnclean_proj_data")
list.files("./getnclean_proj_data")

## Extract all relevant tables
## 1) Extract the table correlating the activity ID to the activity description
activities_id <- read.table("./getnclean_proj_data/UCI HAR Dataset/activity_labels.txt", sep = " ", 
                          header = FALSE, col.names = c("Activity_ID", "Activity"))

## 2) Extract the table indicating all measurement factors
factors_id <- read.table("./getnclean_proj_data/UCI HAR Dataset/features.txt", sep = " ", 
                            header = FALSE, col.names = c("No.", "Factors"))
## Renaming the variable convention to remove unnecessary characters
factors_id$Variable <- gsub("tBody","t" ,factors_id$Factors)
factors_id$Variable <- gsub("fBody","FFT" ,factors_id$Variable)
factors_id$Variable <- gsub("FFTBody","FFT" ,factors_id$Variable)
factors_id$Variable <- gsub("\\()-","\\." ,factors_id$Variable)
factors_id$Variable <- gsub("\\()","\\" ,factors_id$Variable)

## 3) Extract the "Test" data table for the measurements, matching the relevant measurement factor to the header
test_data <- read.table("./getnclean_proj_data/UCI HAR Dataset/test/X_test.txt", sep = "",
                        header = FALSE, col.names = factors_id$Variable)

## 4) Extract the "Train" data table for the measurements, matching the relevant measurement factor to the header
train_data <- read.table("./getnclean_proj_data/UCI HAR Dataset/train/X_train.txt", sep = "",
                         header = FALSE, col.names = factors_id$Variable)

## Extract the relevant mean and standard deviation measurements
## Free up the memory by replacing the existing file with the relevant data set
## Extract the relevant column number that has "mean" or "std" in the column name, case sensitive, 
## hence need to check if the table column names are unique
## Assumption that both "test" and "train" data have the same convention for the measured factors and are
## placed in the same order 
i <- grep("mean|std", colnames(test_data))

## Extract the relevant data from the test data set based on selected columns
test_data <- select(test_data, i)

## Extract the relevant data from the train data set based on selected columns
train_data <- select(train_data, i)


## Binding the corresponding test subject and activity to the "test" / "train" data set, 
## each row represents an attempt by a specific test subjet for a specific activity
## "Test" Dataset
## Relating to the Subject for each row of data
temp <- read.table("./getnclean_proj_data/UCI HAR Dataset/test/subject_test.txt", sep = "",
                   header = FALSE, col.names = "Test_Subject")
test_data <- cbind.data.frame(test_data, temp)
rm(temp)

## Relating to the activity ID for each row of data
temp <- read.table("./getnclean_proj_data/UCI HAR Dataset/test/y_test.txt", sep = "",
                   header = FALSE, col.names = "Activity_ID")
test_data <- cbind.data.frame(test_data, temp)
rm(temp)

## Adding descriptive to the respective activity ID
test_data <- join(test_data,activities_id)

## Adding the TYPE column to identify the source of data
test_data$Type <- "TEST"

## "Train" Dataset
## Relating to the Subject for each row of data
temp <- read.table("./getnclean_proj_data/UCI HAR Dataset/train/subject_train.txt", sep = "",
                   header = FALSE, col.names = "Test_Subject")
train_data <- cbind.data.frame(train_data, temp)
rm(temp)

## Relating to the activity ID for each row of data
temp <- read.table("./getnclean_proj_data/UCI HAR Dataset/train/y_train.txt", sep = "",
                   header = FALSE, col.names = "Activity_ID")
train_data <- cbind.data.frame(train_data, temp)
rm(temp)

## Adding descriptive to the respective activity ID
train_data <- join(train_data,activities_id)

## Adding the TYPE column to identify the source of data
train_data$Type <- "TRAIN"

## Combining both Types ("Test"/"Train") of data set
combined_data <- rbind(test_data,train_data)
combined_data <- group_by(combined_data, Test_Subject, Activity_ID, Activity, Type)

## Summarizing the combined data to mean for each activity for each subject
tidy_data <- summarise_each(combined_data, funs(mean))

## Save tidy_data into a .txt file
write.table(tidy_data, file = "./getnclean_proj_data/tidy_data.txt", sep = ";", 
            row.names = FALSE, col.names = TRUE)