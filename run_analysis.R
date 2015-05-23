# load the dply library
library(dplyr)

# read in the data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read in data lables
features <- read.table("./UCI HAR Dataset/features.txt")
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# configure the data fromt the separate files by binding columns and rows appropriately
intersect(names(X_test),names(X_train))
mergedData <- rbind(X_test, X_train)
names(mergedData) <- features$V2
merged_y <- rbind(y_test,y_train)
mergedData <- cbind(merged_y, mergedData)
merged_subjects <- rbind(subject_test,subject_train)
mergedData <- cbind(merged_subjects, mergedData)

# create column names for the activity and subject columns
names(mergedData)[2] <- "activity_lables"
names(mergedData)[1] <- "subjects"

# rename the columns with descriptive information
mergedData[mergedData$activity_lables ==1,2] <- as.character(labels[1,2])
mergedData[mergedData$activity_lables ==2,2] <- as.character(labels[2,2])
mergedData[mergedData$activity_lables ==3,2] <- as.character(labels[3,2])
mergedData[mergedData$activity_lables ==4,2] <- as.character(labels[4,2])
mergedData[mergedData$activity_lables ==5,2] <- as.character(labels[5,2])
mergedData[mergedData$activity_lables ==6,2] <- as.character(labels[6,2])

# look for columns of interest (mean and std)
stdvars <- grep("std" , features[,2])
meanvars <- grep("mean" , features[,2])

# take a subset of the data, keeping only the columns of interest
meanstdData <- (mergedData[,c(1, 2, stdvars+2, meanvars+2)])

# group the data by subject and activity labels and summarize each column by taking the mean for each grouping
tidyData <-  meanstdData %>% group_by(subjects, activity_lables) %>% summarise_each(funs(mean))

# write the tidy data set to a txt file, kepping the column names
write.table(tidyData, file = "tidyDataSet.txt", row.name=FALSE, col.names = TRUE)

# use for reading in the data, remeber that header has to be TRUE
# X_tidy <- read.table("tidyDataSet.txt", header = TRUE)
# head(X_tidy)


