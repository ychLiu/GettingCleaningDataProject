# Getting and Cleaning Data course project 

The course project is to create one R script called run_analysis.R that 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The five steps were implemented as the following
<ol> 
  <li> the training and the test sets were merged by </li>
  <ol>
    <li> loading data files (X_test.txt for test set; X_train.txt for training set) </li>
    <li> the training and test data were merged with rbind. The merged data, mergedSet, will be referred to as 'main dataframe'. </li>
  </ol>

  <li> extracting only the measurements on the mean and standard deviation by </li>
  <ol>
    <li> loading "features.txt" </li>
    <li> from measurements listed in "features.txt", selecting those containing "mean()" and "std()". </li>
    <li> subsetting the main dataframe based on the seletced measurements </li>
  </ol>

<li> the activities in the data set were given descriptive names by </li>
  <ol>
    <li> loading "activity_labels.txt", which links the class labels with their activity name </li>
    <li> loading test labels (y_test.txt) and training labels (y_train.txt). These files contain class labels for each and every record. </li>
    <li> adding the test and training labels to the main dataframe with variable name "activity" </li>
    <li> creating a new variable, named "actname", from "activity" by mapping class labels to their activity name  </li>
  </ol>

<li> the data set were labeled with descriptive variable names by </li>
  <ol>
  <li> in the selected features, replace "-mean()" and "-std()" with "Mean" and "Std" respectively. Also replace "-x", "-y" and "-z" with "X", "Y" and "Z" respectively. 
  <li> use the updated selected features as the variable names </li>
  </ol>

<li> for createing a second, independent tidy data set with the average over the same activity for each activity in each subject </li>
<ol>
  <li> loading the files containing subject ID (subject_test.txt for test set; subject_train.txt for training set) </li>
  <li> adding the subject IDs to the main dataframe. </li>
  <li> generating summary statistics (which is mean in this case) within subject and activity </li>
  <li> writing the desired summary statistics to a plain text file named tidyData.txt. </li>
</ol>

</ol>
