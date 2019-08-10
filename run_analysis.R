##You should create one R script called run_analysis.R that does the following.
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# 1. Merges the training and the test sets to create one data set by the following steps
#    a) loading libraries
#    b) loading data files (X_test.txt for test set; X_train.txt for training set)
#    c) merging train and test data using rbind. 
#       The merged data, mergedSet, will be referred to as 'main dataframe'.

library(dplyr)

testValue <- read.table("UCIHARDataset/test/X_test.txt")
trainValue <- read.table("UCIHARDataset/train/X_train.txt")
mergedSet <- rbind(testValue, trainValue)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement by
#    a) loading the features.txt file
#    b) selecting measurements (listed in features.txt) on mean and std (those contains "mean()" and "std()").
#    c) subsetting the main dataframe based on the seletced measurements

featureCode <- read.table("UCIHARDataset/features.txt", stringsAsFactors = FALSE)
featureCode <- rename(featureCode, feature=V2)
featureCode$feature <- tolower(featureCode$feature)

selectedFeaturesLogic <- grepl("mean\\(\\)|std\\(\\)", featureCode$feature)
selectedFeatures <- featureCode$feature[selectedFeaturesLogic]
mergedSet <- mergedSet[ ,selectedFeaturesLogic]


# 3. Uses descriptive activity names to name the activities in the data set
#    a) load activity_labels.txt
#    b) load test labels (y_test.txt) and training labels (y_train.txt).
#    c) add the labels (variable "activity") to the main dataframe
#    d) create a new variable (variable name "activityname") from variable "activity" for descriptive activity names

activityLabel <- read.table("UCIHARDataset/activity_labels.txt", stringsAsFactors = FALSE)
activityLabel <- rename(activityLabel, label=V2)
activityLabel$label <- tolower(activityLabel$label)
activityLabel$label <- gsub("_", "", activityLabel$label)

testActCategory <- read.table("UCIHARDataset/test/y_test.txt")
testActCategory <- rename(testActCategory, activity=V1)
trainActCategory <- read.table("UCIHARDataset/train/y_train.txt")
trainActCategory <- rename(trainActCategory, activity=V1)

mergedActCategory <- rbind(testActCategory, trainActCategory)

mergedSet <- cbind(mergedSet, mergedActCategory)
mergedSet <- mutate(mergedSet, actname = factor(activity, labels=activityLabel$label))


# 4. Appropriately labels the data set with descriptive variable names.
#    a) in the selected features 
#       i) replace "-mean()" and "-std()" with "Mean" and "Std" respectively.
#       ii) replace "-x", "-y" and "-z" with "X", "Y" and "Z" respectively. 
#    b) use the updated selected features as the variable names

selectedFeatures <- gsub("-mean\\(\\)", "Mean", selectedFeatures)
selectedFeatures <- gsub("-std\\(\\)", "Std", selectedFeatures)
selectedFeatures <- gsub("-x", "X", selectedFeatures)
selectedFeatures <- gsub("-y", "Y", selectedFeatures)
selectedFeatures <- gsub("-z", "Z", selectedFeatures)

colnames(mergedSet) <- c(selectedFeatures, "activity", "actname")


# 5. average over the same activity for each activity in each subject
#    a) load the files containing subject ID (subject_test.txt for test set; subject_train.txt for training set)
#    b) add the subject IDs to the main dataframe. 
#    c) generate summary statistics (which is mean in this case) within subject and activity
#    d) write the desired summary statistics to a plain text file.

testSubject <- read.table("UCIHARDataset/test/subject_test.txt")
testSubject <- rename(testSubject, subject=V1)
trainSubject <- read.table("UCIHARDataset/train/subject_train.txt")
trainSubject <- rename(trainSubject, subject=V1)
mergedSubject <- rbind(testSubject, trainSubject)

mergedSet <- cbind(mergedSet, mergedSubject)

tidyData <- mergedSet %>% group_by(subject, actname) %>% summarise_if(is.numeric, mean)
write.table(tidyData, "./tidyData.txt", quote=FALSE, row.names = FALSE)
