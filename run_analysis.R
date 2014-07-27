# Download data
      fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl, destfile = "./data/data.zip")
      
# Loading data frrom each txt files to R
      subjectTrain <- read.table("./subject_train.txt")
      xTrain <- read.table("./X_train.txt")
      yTrain <- read.table("./y_train.txt")
      
      subjectTest <- read.table("./subject_test.txt")
      xTest <- read.table("./X_test.txt")
      yTest <- read.table("./y_test.txt")
      
      features <- read.table("./features.txt")
      activityLabels <- read.table("./activity_labels.txt")
      
      # Add names to the activityLabel columns
      names(activityLabels) <- c("ActivityId", "Activity")
      names(xTrain) <- features[,2]      
      names(xTest) <- features[,2]
      
# Step 1. Merges the training and the test sets to create one data set.
            trainTable <- cbind(subjectTrain, yTrain, xTrain); names(trainTable)[1:2] <- c("subject", "ActivityId") 
            testTable <- cbind(subjectTest, yTest, xTest); names(testTable[1:2]) <- c("subject", "ActivityId")
            
      # Creating a unic big table with train and test data
            unicTable <- rbind(testTable, trainTable)
            
      # Add the activity names in the data set to be used (unicTable)
            unicTable <- merge(activityLabels, unicTable, by = "ActivityId")
      
      
# Step 2 & 3. 
            No_meanFreq_header <- unique (grep("meanFreq",features$V2, value=TRUE,invert=TRUE))
            mean_std <- c(".*mean().*", ".*std().*")
            columsToUsed <- unique(grep(paste(mean_std, collapse = "|"), No_meanFreq_header, value = T))
      
      # Subsetting the unicTable 
            tidyTable1 <- unicTable[c("subject", "Activity", columsToUsed)]
            tidyTable1 <- arrange(tidyTable1, subject, decreasing = FALSE)
      
# Step 4. Appropriately labels the data set with descriptive variable names.
      # Take the current column names of the dataframe
      column_Names <- names(tidyTable1)
      
      # Replace the column names to give a more descriptive name
      column_Names <- gsub("tBodyAcc", "time_Body_Acceleration", column_Names)
      column_Names <- gsub("tGravityAcc", "time_Gravity_Acceleration", column_Names)
      column_Names <- gsub("tBodyGyro", "time_Body_Gyroscope", column_Names)
      column_Names <- gsub("fBodyAcc", "frequency_Body_Acceleration", column_Names)
      column_Names <- gsub("fBodyGyro", "frequency_Body_Gyroscope", column_Names)
      column_Names <- gsub("fBodyBodyAccJerkMag", "frequency_Body_AccelerationJerkMag", column_Names)
      column_Names <- gsub("fBodyBodyGyroMag", "frequency_Body_GyroscopeMag", column_Names)
      column_Names <- gsub("fBodyBodyGyroJerkMag", "frequency_Body_GyroscopeJerkMag", column_Names)
      
      # Sets the new colums names to the dataframe
      names(tidyTable1) <- column_Names
      
      
# Step 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject. 
      tidyTable2 <- ddply(tidyTable1, .(subject, Activity), numcolwise(mean))
      
      
      
      

      