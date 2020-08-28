library(dplyr)

#Set the working space, in my case is in a folder called "project3"
setwd("../project3")

#Loads a vector with the activity codes in the "activity_labels.txt" file
activity.code <- c(WALKING=1, WALKING_UPSTAIRS=2, WALKING_DOWNSTAIRS=3, SITTING=4, STANDING=5, LAYING=6)

#Loads the features to be used as column names
features <- read.csv("features.txt", sep=" ", header=FALSE)

#This code, loads the "test" files and forms a new Data Frame with them
test_data <- read.fwf("./test/X_test.txt", widths=c(rep(16, 561)), header=FALSE)
test_act <- read.csv("./test/y_test.txt", header=FALSE)
test_sub <- read.csv("./test/subject_test.txt", header = FALSE)
test_df <- data.frame(test_sub, test_act, test_data)

#This code, loads the "train" files and forms a new Data Frame with them
train_data <- read.fwf("./train/X_train.txt", widths=c(rep(16, 561)), header=FALSE)
train_act <- read.csv("./train/y_train.txt", header=FALSE)
train_sub <- read.csv("./train/subject_train.txt", header = FALSE)
train_df <- data.frame(train_sub, train_act, train_data)

#Joins the two data frames (one of the objectives of the project [1])
data <- rbind(test_df, train_df)

#This is optional, but here I am removing the unused data frames from memory
rm(test_data, test_act, test_sub, test_df)
rm(train_data, train_act, train_sub, train_df)

#This line of code assigns the names of the columns to the data frame. Here we use 
#the values loaded from the features file. (other of the objective of the project [4])
names(data) <- c("subject", "activity", features$V2)

#Here I am extracting the unused measurements. The objective is to use only the mean and
#standard deviation (This is other of the objectives of the project [2])
data <- data[names(data[grep("mean\\()|std\\()|subject|activity", names(data))])]

#Here we assign the descriptive activity names to name the activities in the data set
#(Other of the objectives of the project [3])
data$activity <- names(activity.code)[match(data$activity, activity.code)]

#Finally, we create the tidy data set with the average of each variable for
#each activity and each subject (Objective [5])
tidy_data <- data %>% group_by(subject, activity) %>% summarise_all(list(mean))

#Writes the TXT file to the WD (File needed to submit the project)
write.table(tidy_data, "./tidy_dataset.txt", row.names = FALSE)
