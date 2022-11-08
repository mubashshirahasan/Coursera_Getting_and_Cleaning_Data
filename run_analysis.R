#download the dataset
if(!file.exists("./getcleandata")){dir.create("./projectdata")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./projectdata/projectdataset.zip")
unzip(zipfile = "./projectdata/projectdataset.zip", exdir = "./projectdata")
UCDX_train <- read.table("./projectdata/UCI HAR Dataset/train/X_train.txt")
UCDY_train <- read.table("./projectdata/UCI HAR Dataset/train/y_train.txt")
UCDSUB_train <- read.table("./projectdata/UCI HAR Dataset/train/subject_train.txt")
UCDX_test <- read.table("./projectdata/UCI HAR Dataset/test/X_test.txt")
UCDY_test <- read.table("./projectdata/UCI HAR Dataset/test/y_test.txt")
UCDSUB_test <- read.table("./projectdata/UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./projectdata/UCI HAR Dataset/features.txt")
activityLabels = read.table("./projectdata/UCI HAR Dataset/activity_labels.txt")

#1st Task
MergeUCD_DATA <- rbind(
  cbind(UCDSUB_train, UCDX_train, UCDY_train),
  cbind(UCDSUB_test,UCDX_test, UCDY_test)
)
colNames <- colnames(MergeUCD_DATA)
colnames(MergeUCD_DATA) <- c("subjectID", features[, 2], "activityID")

#2nd Task
columnsIMP <- grepl("subjectID|activityID|mean|std", colnames(MergeUCD_DATA))
MergeUCD_DATA <- MergeUCD_DATA[, columnsIMP]

#3rd Task
colnames(activityLabels) <- c("activityID", "activityType")
DescActivityNames <- merge(MergeUCD_DATA, activityLabels,
                              by = "activityID",
                              all.x = TRUE)
#4th Task
names(MergeUCD_DATA)
names(DescActivityNames)<-gsub("Acc", "Accelerometer", names(DescActivityNames))
names(DescActivityNames)<-gsub("Gyro", "Gyroscope", names(DescActivityNames))
names(DescActivityNames)<-gsub("BodyBody", "Body", names(DescActivityNames))
names(DescActivityNames)<-gsub("Mag", "Magnitude", names(DescActivityNames))
names(DescActivityNames)<-gsub("^t", "Time", names(DescActivityNames))
names(DescActivityNames)<-gsub("^f", "Frequency", names(DescActivityNames))
names(DescActivityNames)<-gsub("tBody", "TimeBody", names(DescActivityNames))
names(DescActivityNames)<-gsub("-freq()", "frequency", names(DescActivityNames), ignore.case = TRUE)
names(MergeUCD_DATA)

#5th Task
tidyDataSet <- aggregate(. ~subjectID + activityID,MergeUCD_DATA , mean)
tidyDataSet <- tidyDataSet[order(tidyDataSet$subjectID, tidyDataSet$activityID), ]
write.table(tidyDataSet, "TidyDataSet.txt", row.names = FALSE)






