
# R script called run_analysis.R that does the following
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### 1. Merge all test and training data and creates one data set all_data
# Read all test data
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Read all training data
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Combines all test and all training data 
train <- data.frame(subject_train,ytrain,xtrain)
test <- data.frame(subject_test,ytest,xtest)
all_data <- rbind(train,test)
 
### 2. Extract only mean and standard deviation measurements from full data set  
# Reads and extracts relevant features from features table
features <- read.table("./UCI HAR Dataset/features.txt")
key_features <- grep("-(mean|std)\\(\\)", features[, 2])
# Subsets relevant data and assigns features label
key_data <- all_data[,c(1,2,key_features+2)]
key_features_names <- as.character(features[key_features,2])
names(key_data) <- c("Subject","Activity",key_features_names)

### 3. Establish descriptive activity labels for data set
# Replaces y_test and y_train values with respective activities
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels <- as.character(activities[,2])
key_data$Activity <- activity_labels[key_data$Activity]

### 4. Appropriate labels for variables
# Changes abbreviated notation
key_labels <- names(key_data)
key_labels <- gsub("()","",key_labels)
key_labels <- gsub("ACC","Accelerometer",key_labels)
key_labels <- gsub("Gyro","Gyrometer",key_labels)
key_labels <- gsub("std","StandardDeviation",key_labels)
key_labels <- gsub("mean","Mean",key_labels)
key_labels <- gsub("Mag","Magnitude",key_labels)
names(key_data) <- key_labels

### 5.Creates a second, independent tidy data set with the average of each variable for 
### each activity and each subject
tidy_data <- aggregate(key_data[,3:68], by = list(Activity = key_data$Activity, Subject = key_data$Subject),FUN = mean)
write.table(x = tidy_data, file = "tidy_data.txt", row.names = FALSE)