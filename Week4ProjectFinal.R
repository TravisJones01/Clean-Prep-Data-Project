#Load files (do not need the intertial signals files)
activityLabels     <- read.table("C:/Users/travis.jones01/Desktop/UCI HAR Dataset/activity_labels.txt")
dataFeaturesNames  <- read.table("C:/Users/travis.jones01/Desktop/UCI HAR Dataset/features.txt")

dataActivityTest   <- read.table("C:/Users/travis.jones01/Desktop/UCI HAR Dataset/test/Y_test.txt")
dataFeaturesTest   <- read.table("C:/Users/travis.jones01/Desktop/UCI HAR Dataset/test/X_test.txt")
dataSubjectTest    <- read.table("C:/Users/travis.jones01/Desktop/UCI HAR Dataset/test/subject_test.txt")

dataActivityTrain  <- read.table("C:/Users/travis.jones01/Desktop/UCI HAR Dataset/train/Y_train.txt")
dataFeaturesTrain  <- read.table("C:/Users/travis.jones01/Desktop/UCI HAR Dataset/train/X_train.txt")
dataSubjectTrain   <- read.table("C:/Users/travis.jones01/Desktop/UCI HAR Dataset/train/subject_train.txt")

#Union the relevant subject, activity, and features files
dataSubject  <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

#Name the columns but for dataFeatures select a subset of the columns in dataFeaturesNames
names(dataSubject)  <-c("subject")
names(dataActivity) <- c("activity")
names(dataFeatures) <- dataFeaturesNames$V2

#Assumes row numbers are equal, join the data from subject to activity to features
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#identify the types of data we are interested in (mean and std)
subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

#add subject & activity and then filter combined data to only relevant records
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity" )
Data <- subset(Data,select=selectedNames)

#change out words to something that makes sense / is clean
names(Data) <- gsub('-mean','Mean', names(Data))
names(Data) <- gsub('-std','Std', names(Data))
names(Data) <- gsub('[-()]','', names(Data))
names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))


# set column order and sort, write the new table to a txt file
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

library(knitr)
knit2html("codebook.Rmd");