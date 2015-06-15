library(dplyr)
##Read in files
features <- read.table("features.txt", strip.white=TRUE)
features <- as.character(features[,2])
activitylabels <-read.table("activity_labels.txt")
subject_test <- read.table("test/subject_test.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_train <- read.table("train/subject_train.txt")
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

##Combine the tables
data <- subject_test
data <- cbind(data,x_test, y_test)
datatemp <- cbind(subject_train, x_train, y_train)
data<- rbind (data,datatemp)

##Add column headers
names(data) <- c ("subject", features, "Activity")

##Drop column
data <- cbind(data[,c("subject","Activity")],data[,as.logical(grepl("mean()", names(data)) + grepl("std()",names(data)), ignore.case=TRUE)])

##Add descriptive activity labels
data<-merge (data, activitylabels, by.x="Activity", by.y="V1")
data <- data[,c(2,82,3:81)]
names(data)[2] <- "activity"

##Creates a data set with the average of each variable for each activity and each subject
sumdata<-group_by(data,subject, activity)
sumdata<-summarise_each(sumdata, funs(mean))

##Output data into a table
write.table(sumdata, file="assignmentdata.txt", row.names=FALSE)
