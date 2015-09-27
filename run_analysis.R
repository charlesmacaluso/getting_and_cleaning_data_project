# Need the 'reshape2' library for the melt work done later on in the code
library(reshape2)

# Imports of the pertinent data sets from the extracted .zip directory
x_test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test_data <- read.table("UCI HAR Dataset/test/Y_test.txt")
x_train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train_data <- read.table("UCI HAR Dataset/train/Y_train.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Use more descriptive names as column headers in the activity_labels,
# features, subject, and y data frames.
names(activity_labels) <- c("activity_id", "activity_description")
names(features) <- c("feature_id", "feature_description")
names(subject_test) <- c("subject_id")
names(subject_train) <- c("subject_id")
names(y_test_data) <- c("activity_id")
names(y_train_data) <- c("activity_id")

# Create a new data frame to hold only the features we're focused on for this
# assignment, and sort it based upon feature_id
allowable_features <- rbind(features[grepl("mean()", 
                                           features$feature_description, 
                                           fixed = TRUE), ], 
                            features[grepl("std()", 
                                           features$feature_description, 
                                           fixed = TRUE), ])
allowable_features <- allowable_features[order(allowable_features$feature_id),]

# Create two new data frames to hold sanitized test and train data in, and
# pull only the columns determined to be allowable by the allowable_features
# data frame
test_data <- x_test_data[,allowable_features$feature_id]
train_data <- x_train_data[, allowable_features$feature_id]

# Rename columns of the test and train data frames to match the feature
# descriptions pulled from the allowable_features data frame
names(test_data) <- allowable_features$feature_description
names(train_data) <- allowable_features$feature_description

# Add in the columns for activity and subject data into the test and train
# data frames
test_data <- cbind(y_test_data, subject_test, test_data)
train_data <- cbind(y_train_data, subject_train, train_data)

# Merge in the activity_description data into the test and train data frames
test_data <- merge(activity_labels, test_data, by.x = "activity_id", 
                   by.y = "activity_id", all.y = TRUE)
train_data <- merge(activity_labels, train_data, by.x = "activity_id", 
                    by.y = "activity_id", all.y = TRUE)

# Add a column into both the test and train data frames that identify those
# data points as being from one data set or the other. This will help
# to better identify data points once the data sets are merged.
test_df <- as.data.frame(rep(c("TEST"), nrow(test_data)))
names(test_df) <- c("dataset_desc")
test_data <- cbind(test_df, test_data)
train_df <- as.data.frame(rep(c("TRIAL"), nrow(train_data)))
names(train_df) <- c("dataset_desc")
train_data <- cbind(train_df, train_data)

# Merge the test and train data sets into one data frame
merged_data <- rbind(test_data, train_data)

# Erase the activity ID, as it is a duplicate of the activity description
merged_data$activity_id <- NULL

# Melt the data to view the column headers as variables
data_melt <- melt(merged_data, id=c("dataset_desc", "activity_description", "subject_id"), measure.vars = allowable_features$feature_description)

# Summarize the data by looking at the average of each data point by subject
# by activity
final_data <- dcast(data_melt, subject_id + dataset_desc + activity_description ~ variable, mean)