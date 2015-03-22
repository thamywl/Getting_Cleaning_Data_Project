# Getting_Cleaning_Data_Project

Introduction
============
The data presented here comes from the Human Activity Recognition Using Smartphones Experiment carried out by Smart Lab <www.smartlab.ws>. Details of the data and the procedures of the experiment can be obtained from the following website: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

How the Script Works
====================
- Step 1- Clears all existing variables in the environment
- Step 2- Define location for the required data download, if not available, create the folder
- Step 3- Specify url location and download file to specified directory
- Step 4- Unzip the downloaded file and show the files extracted
- Step 5- Extract Activity Decription summary and corresponding unique ID
- Step 6- Extract the Variable List and Optimize the nameing convention to remove unnecessary wordings/symbols
- Step 7- Extract the "Test" data table for the measurements, matching the relevant measurement factor to the header
- Step 8- Extract the "Train" data table for the measurements, matching the relevant measurement factor to the header
- Step 9- Extract/Subset the relevant mean and standard deviation measurements from the "Train" and "Test" dataset
- Step 10- Binding the corresponding test "Subject" and "Activity ID" to the "Test" and "Train" data set
- Step 11- Match the "Activity ID" to the corresponding descriptive of the activity to the "Test" and "Train" data set
- Step 12- Specify the source of the data by adding a "Type" column
- Step 13- Stack the "Test" and "Train" data set into one complete data set
- Step 14- Group the data by the test "Subject", "Activity" and "Type" (since there are no overlapping test subject conducting experiment in Test and Train portion of the experiment)
- Step 15- Summarize the complete data set to obtain the mean of all the relevant variables for each activity that each of the subject has conducted
- Step 16- Save the summary data (Tidy Data) into a text file

Relevant details:
=================
- 'code_book.txt': Shows information on the relevant variables produced from this script