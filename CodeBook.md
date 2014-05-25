#Data Science: Getting and Cleaning Data

You should also include a README.md in the repo with your scripts. 
This repo explains how all of the scripts work and 
how they are connected. 

You will be required to submit: 

1) a tidy data set as described below, 

2) a link to a Github repository with your script for performing the analysis, and 

3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 

You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 


## Directory or subdirectory
These are variables that indicate which directory or subdirectory to open

primarydirectory 
traindirectory 
testdirectory 

## import labels and features

First, the labels and features are read in using read.table. 

labels <- read.table(paste0(primarydirectory, "activity_labels.txt"), header=FALSE, 
                         stringsAsFactors=FALSE)
features <- read.table(paste0(primarydirectory, "features.txt"), header=FALSE, 
                       stringsAsFactors=FALSE)


## Train Data: import and add labels

subject_train <- read.table(paste0(traindirectory, "subject_train.txt"), header=FALSE)

This uses the train directory variable to read in subject_train.txt

x_train <- read.table(paste0(traindirectory, "X_train.txt"), header=FALSE)

This uses the train directory variable to read in X_train.txt

y_train <- read.table(paste0(traindirectory, "y_train.txt"), header=FALSE)

This uses the train directory variable to read in y_train.xt

tmp <- data.frame(Activity = factor(y_train$V1, labels = labels$V2))

This creates a factor called Activity out of the first variable of y_train and the labels variable, defined above. Then it saves this in a data frame called tmp. Basically, we’re labeling the numbers in y_train with the labels from the labels variable. 

trainData <- cbind(tmp, subject_train, x_train)

This binds together the labeling factor (tmp) with subject train and x train. 


## Test Data: Import data and add labels

subject_test <- read.table(paste0(testdirectory, "subject_test.txt"), header=FALSE)
x_test <- read.table(paste0(testdirectory, "X_test.txt"), header=FALSE)
y_test <- read.table(paste0(testdirectory, "y_test.txt"), header=FALSE)
tmp <- data.frame(Activity = factor(y_test$V1, labels = labels$V2))
testData <- cbind(tmp, subject_test, x_test)
message("done!")

This is essentially the same as above, but with the test data, instead of train data. 


## This is how you create tidy data, as they say.  Look how tidy it is!

tmpTidyData <- rbind(testData, trainData)

This command is row-binding the test data and train data, saving it to a temporary file. 

names(tmpTidyData) <- c("Activity", "Subject", features[,2])

This is giving us some variable names

grabbing <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]

This says, “Dear R, please look for mean() or std() within the second variable of the features dataset. Then save it to the grabbing variable. 

tidydata <- tmpTidyData[c("Activity", "Subject", grabbing)]

Subset the temporary datafile to only include Activity, Subject, or any variable with mean() or std(). Hooray for subsetting!

## create the tidydata text file, then transform, then write to file

write.table(tidydata, file="./tidydata_looksgood.txt", row.names=FALSE)

write the tidy data to file. 

melted<- melt(tidydata, id=c("Activity", "Subject"), measure.vars=grabbing)

melt the data , so we have id variable Activity and Subject, and one row for every variable with a mean() or std() in the name. 

meandata <- dcast(melted, Activity + Subject ~ variable, mean)

recast the data, taking the melted dataset, break it down by variable and take the mean for each. 

write.table(meandata, file="./tidyavedata.txt", row.names=FALSE)

save this to a text file. 

