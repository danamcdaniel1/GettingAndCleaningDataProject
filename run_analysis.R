# STEP 0 -- Setup
setwd("C:\\Users\\Dianshi\\Desktop\\Laptop Stuff\\Getting and Cleaning Data\\UCI HAR Dataset")

#initialize data frames
activityLabels <- read.table("./activity_labels.txt",     header = FALSE)
features       <- read.table("./features.txt",            header = FALSE)
xTrain         <- read.table("./train/x_train.txt",       header = FALSE)
xTest          <- read.table("./test/x_test.txt",         header = FALSE) 
yTrain         <- read.table("./train/y_train.txt",       header = FALSE)
yTest          <- read.table("./test/y_test.txt",         header = FALSE) 
subjectTest    <- read.table("./test/subject_test.txt",   header = FALSE) 
subjectTrain   <- read.table("./train/subject_train.txt", header = FALSE)

# Assign column names to data frames
colnames(activityLabels)  <- c("activityid", "description")
colnames(subjectTest)  <-  "subjectid"
colnames(subjectTrain) <-  "subjectid"
colnames(xTest)        <-  features[,2]
colnames(xTrain)       <-  features[,2]
colnames(yTest)        <-  "activityid"
colnames(yTrain)       <-  "activityid"

# STEP 1.  Merges the training and the test sets to create one data set.
testData   <- cbind(subjectTest, xTest, yTest)
trainData  <- cbind(subjectTrain, xTrain, yTrain)
finalData  <- rbind(trainData, testData)

# STEP 2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
finalData  <- finalData[, grepl("activity|subject|mean|std", colnames(finalData))]

# STEP 3.  Uses descriptive activity names to name the activities in the data set
finalData  <- merge(finalData, activityLabels, by="activityid")

# STEP 4.  Appropriately label the data set with descriptive activity names. 
#          Please see STEP 0 and STEP 3, above.  Activity names and labels were 
#          preserved from original datasets.

# STEP 5.  Create a second, independent tidy data set with the average of each 
#          variable for each activity and each subject. 

preTinyData  <- finalData[, !grepl("activityLabel|description", names(preTinyData))]
tidyData     <- aggregate(preTinyData, 
                          by = list(activityid = preTinyData$activityid,
                                    subjectid  = preTinyData$subjectid),
                          mean)[,-c(1,2)]
tidyData     <- merge(tidyData, activityLabels, by = "activityid", all.x = TRUE)

# Export the tidyData set 
setwd("..")
write.table(tidyData, "./tidyData.txt", row.names = F, sep='\t')
