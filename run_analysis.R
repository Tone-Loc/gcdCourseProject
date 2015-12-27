##This R Script does the following:
##1) Merges the training and the test sets to create one data set.
##2) Extracts only the measurements on the mean and standard deviation for each measurement. 
##3) Uses descriptive activity names to name the activities in the data set
##4) Appropriately labels the data set with descriptive variable names. 
##5) From the data set in step 4, creates a second, 
##independent tidy data set with the average of each variable for each activity 
##and each subject.

##Download the file into your working directory's data folder
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./data")){
        dir.create("./data")
}

if(!file.exists("./data/courseProject.zip")){
        download.file(url, "./data/courseProject.zip")
        unzip("./data/courseProject.zip", exdir = "./data")
}

rm(url)

##Install and load required r packages
if (!require("data.table")) { 
        install.packages("data.table") 
} 

if (!require("dplyr")) { 
        install.packages("dplyr") 
}

if (!require("reshape2")) { 
        install.packages("reshape2") 
} 
library(data.table)
library(dplyr)
library(reshape2)

##Read & combine subject & activity label files
subTrain <- data.table(read.table("./data/UCI HAR Dataset/train/subject_train.txt"))
YTrain <- data.table(read.table("./data/UCI HAR Dataset/train/Y_train.txt"))

dTrain <- data.table(cbind(subTrain, YTrain))
names(dTrain) <- c("TestSubject", "ActivityIndex")

rm(subTrain, YTrain)

##Add human-friendly lables for activities.
activityLabels <- data.table(read.table("./data/UCI HAR Dataset/activity_labels.txt"))
names(activityLabels) <- c("ActivityIndex", "ActivityName")
dTrain <- merge(activityLabels, dTrain, by.x = "ActivityIndex", by.y = "ActivityIndex")

##Identify measurements of the mean and standard deviation.
features <- data.table(read.table("./data/UCI HAR Dataset/features.txt"))
features <- as.character(features$V2)
measureSet <- paste(c("mean", "std"), collapse = "|")
measureSet <- grepl(measureSet, features)

##Read, name & subset measurements
xTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
names(xTrain) <- features
xTrain <- xTrain[,measureSet]

##Add measurement data to classification data
dTrain <- cbind(dTrain, xTrain)
rm(xTrain)

###################################################
##REPEAT THE STEPS ABOVE TO CREATE A TEST DATASET##
###################################################

##Read & combine subject & activity label files
subTest <- data.table(read.table("./data/UCI HAR Dataset/test/subject_test.txt"))
YTest <- data.table(read.table("./data/UCI HAR Dataset/test/Y_test.txt"))

dTest <- data.table(cbind(subTest, YTest))
names(dTest) <- c("TestSubject", "ActivityIndex")

rm(subTest, YTest)

##Add human-friendly lables for activities.
dTest <- merge(activityLabels, dTest, by.x = "ActivityIndex", by.y = "ActivityIndex")
rm(activityLabels)

##Read, name & subset measurements
xTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
names(xTest) <- features
xTest <- xTest[,measureSet]

##Add measurement data to classification data
dTest <- cbind(dTest, xTest)
rm(xTest, features, measureSet)

##Merge training and test sets
dAll <- rbind(dTrain, dTest)
rm(dTest, dTrain)

##Melt data to convert from wide format to long format
dAll <- melt(dAll, id = names(dAll)[1:3], measure.vars = names(dAll)[-1:-3])

##dcast to create tidy data set with the average of each variable for each activity and each subject.
dAll <- dcast(dAll, TestSubject + ActivityName ~ variable, mean)

##Write tidy data to file called "tidyData.txt"
write.table(dAll, "./data/UCI HAR Dataset/tidyData.txt", row.names = FALSE)
rm(dAll)