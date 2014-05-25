{\rtf1\ansi\ansicpg1252\cocoartf1265\cocoasubrtf190
{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset0 HelveticaNeue;}
{\colortbl;\red255\green255\blue255;\red38\green38\blue38;}
\margl1440\margr1440\vieww13720\viewh9340\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural

\f0\fs24 \cf0 #Data Science: Getting and Cleaning Data\
\
\pard\pardeftab720\sl420

\f1\fs28 \cf2 You should also include a README.md in the repo with your scripts. \
This repo explains how all of the scripts work and \
how they are connected.\'a0\
\
You will be required to submit: \
\
1) a tidy data set as described below, \
\
2) a link to a Github repository with your script for performing the analysis, and \
\
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. \
\
You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.\'a0\
\
\
## Directory or subdirectory\
These are variables that indicate which directory or subdirectory to open\
\
primarydirectory \
traindirectory \
testdirectory \
\
## import labels and features\
\
First, the labels and features are read in using read.table. \
\
labels <- read.table(paste0(primarydirectory, "activity_labels.txt"), header=FALSE, \
                         stringsAsFactors=FALSE)\
features <- read.table(paste0(primarydirectory, "features.txt"), header=FALSE, \
                       stringsAsFactors=FALSE)\
\
\
## Train Data: import and add labels\
\
subject_train <- read.table(paste0(traindirectory, "subject_train.txt"), header=FALSE)\
\
This uses the train directory variable to read in subject_train.txt\
\
x_train <- read.table(paste0(traindirectory, "X_train.txt"), header=FALSE)\
\
This uses the train directory variable to read in X_train.txt\
\
y_train <- read.table(paste0(traindirectory, "y_train.txt"), header=FALSE)\
\
This uses the train directory variable to read in y_train.xt\
\
tmp <- data.frame(Activity = factor(y_train$V1, labels = labels$V2))\
\
This creates a factor called Activity out of the first variable of y_train and the labels variable, defined above. Then it saves this in a data frame called tmp. Basically, we\'92re labeling the numbers in y_train with the labels from the labels variable. \
\
trainData <- cbind(tmp, subject_train, x_train)\
\
This binds together the labeling factor (tmp) with subject train and x train. \
\
\
## Test Data: Import data and add labels\
\
subject_test <- read.table(paste0(testdirectory, "subject_test.txt"), header=FALSE)\
x_test <- read.table(paste0(testdirectory, "X_test.txt"), header=FALSE)\
y_test <- read.table(paste0(testdirectory, "y_test.txt"), header=FALSE)\
tmp <- data.frame(Activity = factor(y_test$V1, labels = labels$V2))\
testData <- cbind(tmp, subject_test, x_test)\
message("done!")\
\
This is essentially the same as above, but with the test data, instead of train data. \
\
\
## This is how you create tidy data, as they say.  Look how tidy it is!\
\
tmpTidyData <- rbind(testData, trainData)\
\
This command is row-binding the test data and train data, saving it to a temporary file. \
\
names(tmpTidyData) <- c("Activity", "Subject", features[,2])\
\
This is giving us some variable names\
\
grabbing <- features$V2[grep("mean\\\\(\\\\)|std\\\\(\\\\)", features$V2)]\
\
This says, \'93Dear R, please look for mean() or std() within the second variable of the features dataset. Then save it to the grabbing variable. \
\
tidydata <- tmpTidyData[c("Activity", "Subject", grabbing)]\
\
Subset the temporary datafile to only include Activity, Subject, or any variable with mean() or std(). Hooray for subsetting!\
\
## create the tidydata text file, then transform, then write to file\
\
write.table(tidydata, file="./tidydata_looksgood.txt", row.names=FALSE)\
\
write the tidy data to file. \
\
melted<- melt(tidydata, id=c("Activity", "Subject"), measure.vars=grabbing)\
\
melt the data , so we have id variable Activity and Subject, and one row for every variable with a mean() or std() in the name. \
\
meandata <- dcast(melted, Activity + Subject ~ variable, mean)\
\
recast the data, taking the melted dataset, break it down by variable and take the mean for each. \
\
write.table(meandata, file="./tidyavedata.txt", row.names=FALSE)\
\
save this to a text file. \
\
}