

# Package Check and Install
pkg <- "reshape2"
if (!require(pkg, character.only = TRUE)) {
  install.packages(pkg)
  if (!require(pkg, character.only = TRUE)) 
    stop(paste("Load failure: ", pkg))
}


# Data Directories
primarydirectory <- "./UCI HAR Dataset/"
traindirectory <- "UCI HAR Dataset/train/"
testdirectory <- "./UCI HAR Dataset/test/"

#import labels and features
labels <- read.table(paste0(primarydirectory, "activity_labels.txt"), header=FALSE, 
                         stringsAsFactors=FALSE)
features <- read.table(paste0(primarydirectory, "features.txt"), header=FALSE, 
                       stringsAsFactors=FALSE)

message("Captain, we've imported labels and features")


# Train Data: import and add labels

message("Ok, be patient. Importing and adding labels to Train Data")
subject_train <- read.table(paste0(traindirectory, "subject_train.txt"), header=FALSE)
x_train <- read.table(paste0(traindirectory, "X_train.txt"), header=FALSE)
y_train <- read.table(paste0(traindirectory, "y_train.txt"), header=FALSE)
tmp <- data.frame(Activity = factor(y_train$V1, labels = labels$V2))
trainData <- cbind(tmp, subject_train, x_train)
message("done!")


# Test Data: Import data and add labels


message("Just wait a sec - we're importing and adding labels to Test Data")
subject_test <- read.table(paste0(testdirectory, "subject_test.txt"), header=FALSE)
x_test <- read.table(paste0(testdirectory, "X_test.txt"), header=FALSE)
y_test <- read.table(paste0(testdirectory, "y_test.txt"), header=FALSE)
tmp <- data.frame(Activity = factor(y_test$V1, labels = labels$V2))
testData <- cbind(tmp, subject_test, x_test)
message("done!")


# This is how you create tidy data, as they say

tmpTidyData <- rbind(testData, trainData)
names(tmpTidyData) <- c("Activity", "Subject", features[,2])
grabbing <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
tidydata <- tmpTidyData[c("Activity", "Subject", grabbing)]

# create the tidydata text file, then transform, then write to file
write.table(tidydata, file="./tidydata_looksgood.txt", row.names=FALSE)
melted<- melt(tidydata, id=c("Activity", "Subject"), measure.vars=grabbing)
meandata <- dcast(melted, Activity + Subject ~ variable, mean)
write.table(meandata, file="./tidyavedata.txt", row.names=FALSE)
