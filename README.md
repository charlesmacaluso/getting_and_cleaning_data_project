# Course Project - Getting and Cleaning Data
### A repository to hold the code required for the Coursera 'Getting and Cleaning Data' project

The first thing I did was pull in the big data sets into data tables in memory, because if that's what we're going to end up binding together, I wanted to know what we were working with.

> x_test_data <- read.table("UCI HAR Dataset/test/X_test.txt")

> y_test_data <- read.table("UCI HAR Dataset/test/Y_test.txt")

> x_train_data <- read.table("UCI HAR Dataset/train/X_train.txt")

> y_train_data <- read.table("UCI HAR Dataset/train/Y_train.txt")

Both the data sets labeled as 'x' are observances of 561 different variables, near 3000 observances in the test data set and over 7000 observances in the train data. Both the data sets labeled as 'y' are observances of one variable, but an identical number of observances to the 'x' data sets just pulled in. Reading the README.md that goes along with the data set:

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

So, that makes sense the number of observances in each case should be the same. Looking at the 'head' of each table, though, there are no labels or identification on any of the data points:

> head(x_test_data[, 1:6], 5)
         V1          V2          V3         V4         V5         V6
1 0.2571778 -0.02328523 -0.01465376 -0.9384040 -0.9200908 -0.6676833
2 0.2860267 -0.01316336 -0.11908252 -0.9754147 -0.9674579 -0.9449582
3 0.2754848 -0.02605042 -0.11815167 -0.9938190 -0.9699255 -0.9627480
4 0.2702982 -0.03261387 -0.11752018 -0.9947428 -0.9732676 -0.9670907
5 0.2748330 -0.02784779 -0.12952716 -0.9938525 -0.9674455 -0.9782950

> head(y_test_data, 5)
  V1
1  5
2  5
3  5
4  5
5  5

So, let's work on that. Much of the documentation for these data points takes place in the folder above these. Let's start with the 'activity_labels.txt' file:

> activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

This ends up producing a data table that looks like this:

  V1                 V2
1  1            WALKING
2  2   WALKING_UPSTAIRS
3  3 WALKING_DOWNSTAIRS
4  4            SITTING
5  5           STANDING
6  6             LAYING

Let's make this a bit more descriptive, and put better headers on these values by renaming the columns of the table:

> names(activity_labels) <- c("activity_id", "activity_description")
> activity_labels
  activity_id activity_description
1           1              WALKING
2           2     WALKING_UPSTAIRS
3           3   WALKING_DOWNSTAIRS
4           4              SITTING
5           5             STANDING
6           6               LAYING

Let's do the same thing with the other similar file in this directory:

> features <- read.table("UCI HAR Dataset/features.txt")
> names(features) <- c("feature_id", "feature_description")
> head(features, 5)
  feature_id feature_description
1          1   tBodyAcc-mean()-X
2          2   tBodyAcc-mean()-Y
3          3   tBodyAcc-mean()-Z
4          4    tBodyAcc-std()-X
5          5    tBodyAcc-std()-Y

We'll start to run into an issue here. This feature list is an 'untidy' data set, as it is amalgamating several different attributes into the 'feature_description'. As such, we need to tidy this file up. Or, at least, that was the intent before looking at the TA notes on the discussion forum (citing his reference on his advice):

https://class.coursera.org/getdata-032/forum/thread?thread_id=26

Should I decompose the variable names
No. For two reasons. One is that no-one ever does so correctly. The other is that you need to write a really excellent ReadMe and Codebook that makes it clear to your markers how what you've done is tidy, and for reasons of the first part this is a problem. This is one of those ideas that is better in theory than in practice. People (possibly inspired by the tidyr swirl tutorial) go "I can split the x,y, and z, and all the others into different columns". The trouble in practice is that you don't actually get clear one variable per column because the the entries in each column are not independent, mutually exclusive, members of the same set. It is like seeing red, dark green, light green, pink, and blue as categories and thinking it is a good idea to make it tidier by putting the light and dark in a separate column. You introduce a bunch of NA values for all the other entries, and introducing a bunch of NA values where there were not previous ones (or a functional equivalent term like "other") is a pretty clear sign the data is a best no tidier (and is probably worse).

So, apparently, it's tidy enough for our purposes, and that's good enough for me. (Hopefully this README is at least readable, right?) This file helps establish that the columns of the data sets are equivalent to the features listed in the 'features.txt' file. So, let't assign the 'features_description' column to the columns of each of those data sets (both test and train sets of data).

> names(x_test_data) <- features$feature_description
> head(x_test_data[, 1:4], 5)
  tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X
1         0.2571778       -0.02328523       -0.01465376       -0.9384040
2         0.2860267       -0.01316336       -0.11908252       -0.9754147
3         0.2754848       -0.02605042       -0.11815167       -0.9938190
4         0.2702982       -0.03261387       -0.11752018       -0.9947428
5         0.2748330       -0.02784779       -0.12952716       -0.9938525

**The conclusion of this step goes a good portion of the way to completing Part 4 of the assignment, '4.Appropriately labels the data set with descriptive variable names.'**

Now that we've got the columns in a little better shape, let's look at the rows. First, let's look at the 'subject_test.txt' and 'subject_train.txt' files first, as we haven't covered those yet. Those two files align with the number of instances in the test and train data sets, and indicate the identification number of the person who is being monitored. Let's do the same import process that we've done with other similar files:

> subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
> subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

Doing a quick 'table' function on those two imports:

> table(subject_train)
subject_train
  1   3   5   6   7   8  11  14  15  16  17  19  21  22  23  25  26  27  28  29 
347 341 302 325 308 281 316 323 328 366 368 360 408 321 372 409 392 376 382 344 
 30 
383 
> table(subject_test)
subject_test
  2   4   9  10  12  13  18  20  24 
302 317 288 294 320 327 364 354 381 

It does not look as if there is any overlap there between identification numbers in the two sets, so luckily there's no extra column we need to put in to differentiate between 'test' and 'train' as of yet. Let's change the column name on each of these data tables and add them into the X data sets.

> names(subject_test) <- c("subject_id")
> names(subject_train) <- c("subject_id")
> test_data <- cbind(subject_test, x_test_data)
> head(test_data[, 1:4], 5)
  subject_id tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
1          2         0.2571778       -0.02328523       -0.01465376
2          2         0.2860267       -0.01316336       -0.11908252
3          2         0.2754848       -0.02605042       -0.11815167
4          2         0.2702982       -0.03261387       -0.11752018
5          2         0.2748330       -0.02784779       -0.12952716
> train_data <- cbind(subject_train, x_train_data)
> head(train_data[, 1:4], 5)
  subject_id tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
1          1         0.2885845       -0.02029417        -0.1329051
2          1         0.2784188       -0.01641057        -0.1235202
3          1         0.2796531       -0.01946716        -0.1134617
4          1         0.2791739       -0.02620065        -0.1232826
5          1         0.2766288       -0.01656965        -0.1153619

This is an important distinction here. I'm making sure to clarify that I'm establishing two new data tables here, which will henceforth be used as a repository for cleaned and sorted data: 'test_data' and 'train_data'.

The documentation in the README.md is a little ambiguous as to what the 'Y_test.txt' and 'Y_train.txt' actually are (confusing as to what a 'test label' and 'training label' are), so running a quick formula, we can see what values actually exist in that column:

> table(y_test_data)
y_test_data
  1   2   3   4   5   6 
496 471 420 491 532 537 

Those six numbers line up really well with the 'activity_labels' table we just created. What would be optimal, in order to combine all necessary data streams together, would be to replace the 1-6 indices with the actual text from the 'activity_labels' table. The issue with doing that right off the bat is that any kind of replacement function like that (i.e. replace 1 with 'WALKING') is that R will sort that column based on the replaced value, screwing up your sorting between tables. So, let's go ahead rename the columns in the Y data and cbind them to the test and train data sets:

> names(y_test_data) <- c("activity_id")
> names(y_train_data) <- c("activity_id")
> test_data <- cbind(y_test_data, test_data)
> train_data <- cbind(y_train_data, train_data)
> head(test_data[, 1:4], 5)
  activity_id subject_id tBodyAcc-mean()-X tBodyAcc-mean()-Y
1           5          2         0.2571778       -0.02328523
2           5          2         0.2860267       -0.01316336
3           5          2         0.2754848       -0.02605042
4           5          2         0.2702982       -0.03261387
5           5          2         0.2748330       -0.02784779
> head(train_data[, 1:4], 5)
  activity_id subject_id tBodyAcc-mean()-X tBodyAcc-mean()-Y
1           5          1         0.2885845       -0.02029417
2           5          1         0.2784188       -0.01641057
3           5          1         0.2796531       -0.01946716
4           5          1         0.2791739       -0.02620065
5           5          1         0.2766288       -0.01656965

With the 'activity_id' included in the destination data tables now, let's try to change that ID to something more meaningful. The merge command will add a column into the data table that will include the 'activity_description', so let's start there:

> test_data <- merge(activity_labels, test_data, by.x = "activity_id", by.y = "activity_id", all.y = TRUE, sort = FALSE)
> train_data <- merge(activity_labels, train_data, by.x = "activity_id", by.y = "activity_id", all.y = TRUE, sort = FALSE)
> head(test_data[, 1:4], 5)
  activity_id activity_description subject_id tBodyAcc-mean()-X
1           1              WALKING         12         0.2160924
2           1              WALKING         12         0.3434905
3           1              WALKING         12         0.3090925
4           1              WALKING         12         0.1918730
5           1              WALKING         12         0.2842238
> head(train_data[, 1:4], 5)
  activity_id activity_description subject_id tBodyAcc-mean()-X
1           1              WALKING          6         0.2983396
2           1              WALKING          6         0.3367657
3           1              WALKING          6         0.2180418
4           1              WALKING          6         0.2580600
5           1              WALKING          6         0.3794251

Now, though, having 'activity_id' and 'activity_description' both in this table is untidy, because it repeats information unnecessarily. As such, let's remove the 'activity_id' from both tables.

> test_data$activity_id <- NULL
> train_data$activity_id <- NULL

**The conclusion of this step completed Part 3 of the assignment, '3.Uses descriptive activity names to name the activities in the data set'**

Now we need to start thinking about combining our 'test' and 'train' data sets. They have an equal number of columns, so doing an 'rbind' should be easy enough, but let's think tidy here: the issue will be that, while we know a subject with be *either* in the test set *or* in the train set from the previous work we've done in the tables, that data won't exist in this table anywhere. So, let's add a column to identify which data set these subjects are a part of.

> test_df <- as.data.frame(rep(c("TEST"), nrow(test_data)))
> names(test_df) <- c("dataset_desc")
> test_data <- cbind(test_df, test_data)
> head(test_data[,1:5], 5)
  dataset_desc activity_description subject_id tBodyAcc-mean()-X
1         TEST              WALKING         12         0.2160924
2         TEST              WALKING         12         0.3434905
3         TEST              WALKING         12         0.3090925
4         TEST              WALKING         12         0.1918730
5         TEST              WALKING         12         0.2842238

> train_df <- as.data.frame(rep(c("TRIAL"), nrow(train_data)))
> names(train_df) <- c("dataset_desc")
> train_data <- cbind(train_df, train_data)
> head(train_data[,1:4], 5)
  dataset_desc activity_description subject_id tBodyAcc-mean()-X
1        TRIAL              WALKING          6         0.2983396
2        TRIAL              WALKING          6         0.3367657
3        TRIAL              WALKING          6         0.2180418
4        TRIAL              WALKING          6         0.2580600
5        TRIAL              WALKING          6         0.3794251

Now, let's combine the two datasets into one big table, we'll call 'merged_data':

merged_data <- rbind(test_data, train_data)

Because the columns for the two tables should be identical, there shouldn't be the need to do a merge function here, we're just adding data points from one table into an identical structure in another table.

**The conclusion of this step completed Part 1 of the assignment, '1.Merges the training and the test sets to create one data set.'**

