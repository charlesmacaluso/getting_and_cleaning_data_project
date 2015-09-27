# Course Project - Getting and Cleaning Data
### A README.md file to explain the thought processes behind the code execution

Before I get into the steps of logic I took to go through the code, let me enumerate how to get the code to run and how to get the output required. Source the script into your R Studio environment with the following set of code:

         > source("run_analysis.R")
         
This will run through each of the variables required to complete the exercise. The final data set is a data frame labeled **final_data**. View that data frame in whatever way you deem fit to determine it's correctness.

--------------------------------------

Now, to start walking through how the code runs, the first thing I did was pull in the big data sets into data tables in memory, because if that's what we're going to end up binding together, I wanted to know what we were working with.

         > x_test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
         > y_test_data <- read.table("UCI HAR Dataset/test/Y_test.txt")
         > x_train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
         > y_train_data <- read.table("UCI HAR Dataset/train/Y_train.txt")

Both the data sets labeled as 'x' are observances of 561 different variables, near 3000 observances in the test data set and over 7000 observances in the train data. Both the data sets labeled as 'y' are observances of one variable, but an identical number of observances to the 'x' data sets just pulled in. Reading the README.md that goes along with the data set:

> - 'train/X_train.txt': Training set.
>
> - 'train/y_train.txt': Training labels.
>
> - 'test/X_test.txt': Test set.
>
> - 'test/y_test.txt': Test labels.

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

So, let's work on that. Much of the documentation for these data points is contained within these related files, so let's load those into memory first off:

         > activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
         > features <- read.table("UCI HAR Dataset/features.txt")
         > subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
         > subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

Let's start with the activity labels. This table ends up looking like this:

         > activity_labels
           V1                 V2
         1  1            WALKING
         2  2   WALKING_UPSTAIRS
         3  3 WALKING_DOWNSTAIRS
         4  4            SITTING
         5  5           STANDING
         6  6             LAYING

Let's make this a bit more descriptive, and put better headers on these values by renaming the columns of the table:

         > names(activity_labels) <- c("activity_id", "activity_desc")
         > activity_labels
           activity_id      activity_desc
         1           1            WALKING
         2           2   WALKING_UPSTAIRS
         3           3 WALKING_DOWNSTAIRS
         4           4            SITTING
         5           5           STANDING
         6           6             LAYING

Let's do the same thing with the other similar files we've just brought into memory, as well as the 'Y' files for the test and train data sets:

         > names(features) <- c("feature_id", "feature_desc")
         > names(subject_test) <- c("subject_id")
         > names(subject_train) <- c("subject_id")
         > names(y_test_data) <- c("activity_id")
         > names(y_train_data) <- c("activity_id")

We'll start to run into an issue here. This **feature** data frame is an 'untidy' data set, as it is amalgamating several different attributes into the **feature_desc**. As such, we need to tidy this file up. Or, at least, that was the intent before looking at the TA notes on the discussion forum (citing his reference on his advice):

https://class.coursera.org/getdata-032/forum/thread?thread_id=26

>**Should I decompose the variable names?**
>
>*No. For two reasons. One is that no-one ever does so correctly. The other is that you need to write a really excellent ReadMe and Codebook that makes it clear to your markers how what you've done is tidy, and for reasons of the first part this is a problem. This is one of those ideas that is better in theory than in practice. People (possibly inspired by the tidyr swirl tutorial) go "I can split the x,y, and z, and all the others into different columns". The trouble in practice is that you don't actually get clear one variable per column because the the entries in each column are not independent, mutually exclusive, members of the same set. It is like seeing red, dark green, light green, pink, and blue as categories and thinking it is a good idea to make it tidier by putting the light and dark in a separate column. You introduce a bunch of NA values for all the other entries, and introducing a bunch of NA values where there were not previous ones (or a functional equivalent term like "other") is a pretty clear sign the data is a best no tidier (and is probably worse).*

So, apparently, it's tidy enough for our purposes, and that's good enough for me. Or, well, almost anyways, because the question still asks for us to isolate only the measurements that consist of a mean or a standard deviation of a measurement. In order to do this, let's take a look at the **features** table:

         > head(features,5)
           feature_id      feature_desc
         1          1 tBodyAcc-mean()-X
         2          2 tBodyAcc-mean()-Y
         3          3 tBodyAcc-mean()-Z
         4          4  tBodyAcc-std()-X
         5          5  tBodyAcc-std()-Y

We're basically going to be looking for any entry in the **feature_desc** column that has either a *mean()* or *std()* within the string of the entry. To do this, we can use the **grepl** command to help find a subset within a string. As well, after we make a new data frame, we need to order it based on the activity ID. Both of those steps are listed below:

         > allowable_features <- rbind(features[grepl("mean()", 
                                           features$feature_desc, 
                                           fixed = TRUE), ], 
                                       features[grepl("std()", 
                                           features$feature_desc, 
                                           fixed = TRUE), ])
         > allowable_features <- allowable_features[order(allowable_features$feature_id),]
         > head(allowable_features, 10)
            feature_id         feature_desc
         1           1    tBodyAcc-mean()-X
         2           2    tBodyAcc-mean()-Y
         3           3    tBodyAcc-mean()-Z
         4           4     tBodyAcc-std()-X
         5           5     tBodyAcc-std()-Y
         6           6     tBodyAcc-std()-Z
         41         41 tGravityAcc-mean()-X
         42         42 tGravityAcc-mean()-Y
         43         43 tGravityAcc-mean()-Z
         44         44  tGravityAcc-std()-X

Now that we've established this **allowable_features** data frame, we can use it to initialize our sanitized data sets for the **test** and **train** data sets. Pulling only the columns from each table that are associated with the **feature_id** we pulled in the **allowable_features** data frame, we can subset the data in each table to match only *mean()* and *std()* data points.

         > test_data <- x_test_data[,allowable_features$feature_id]
         > train_data <- x_train_data[, allowable_features$feature_id]
         > dim(test_data)
         [1] 2947   66
         > dim(train_data)
         [1] 7352   66
         
This narrows the number of variables down from 561 to roughly 70 in each table. Then, it would really be better if each table had a better description as to what each column represented. To do this, we can rename the columns the same thing that is in the **allowable_features** table in the **features_description** column:

         > names(test_data) <- allowable_features$feature_desc
         > names(train_data) <- allowable_features$feature_desc
         > head(test_data[,1:4],5)
           tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X
         1         0.2571778       -0.02328523       -0.01465376       -0.9384040
         2         0.2860267       -0.01316336       -0.11908252       -0.9754147
         3         0.2754848       -0.02605042       -0.11815167       -0.9938190
         4         0.2702982       -0.03261387       -0.11752018       -0.9947428
         5         0.2748330       -0.02784779       -0.12952716       -0.9938525

Now that we have better column descriptions in the **test** and **train** data sets, it would be beneficial to get more information as to each row in the table. Each row entry has a corresponding activity and subject, which are enumerated in the **Y** and **subject** data sets.

Before we merge those into our two data frames, let's go into a bit longer discussion about the **Y** and **subject** data sets. The documentation in the README.md is a little ambiguous as to what the 'Y_test.txt' and 'Y_train.txt' actually are (confusing as to what a 'test label' and 'training label' are), so running a quick formula, we can see what values actually exist in that column:

         > table(y_test_data)
         y_test_data
           1   2   3   4   5   6 
         496 471 420 491 532 537 

Those six numbers line up really well with the 'activity_labels' table we just created. What would be optimal, in order to combine all necessary data streams together, would be to replace the 1-6 indices with the actual text from the 'activity_labels' table. The issue with doing that right off the bat is that any kind of replacement function like that (i.e. replace 1 with 'WALKING') is that R will sort that column based on the replaced value, screwing up your sorting between tables. So, let's hold off re-naming these until after we've merged **Y** data sets into the corresponding data frames.

The subject, though, is the more immediate concern. There really aren't more descriptive variables for the subjects other than their IDs, but what the **subject_test** and **subject_train** data frames hold is a matching list of IDs to each row in the **test** and **train** data frames. What the worry would be here is if each subset, **test** and **train**, had overlapping IDs for their subjects. So, for instance, if the participants in the **train** data set were labeled 1-21 and the participants in the **test** data set were labeled 1-9, we would have a problem keeping those data points in the same column of the same table. We'd need another data point to enumerate which IDs are in the **test** and which are in the **train** data sets. In order to see if this is the case, let's use the **table** command on each of the **subject** data sets:

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

Luckily, there doesn't seem to be any overlap in IDs. However, that point about enumerating which subjects are in the **test** data set and which are in the **train** data set is a good idea, if for no other reason than clarity, so we'll come back to that later.

Now that we're more comfortable with the **Y** and **subject** data frames, let's merge those two data frames into our sanitized data sets as columns at the far left of the table:

         > test_data <- cbind(y_test_data, subject_test, test_data)
         > train_data <- cbind(y_train_data, subject_train, train_data)
         > head(test_data[,1:4],5)
           activity_id subject_id tBodyAcc-mean()-X tBodyAcc-mean()-Y
         1           5          2         0.2571778       -0.02328523
         2           5          2         0.2860267       -0.01316336
         3           5          2         0.2754848       -0.02605042
         4           5          2         0.2702982       -0.03261387
         5           5          2         0.2748330       -0.02784779

That's a great start, but let's see if we can't get a bit more descriptive data into those first two columns. Like we discussed earlier, there really isn't any more description on the subject other than its ID, so we can leave that as is for now. Let's take a look at the **activity_id** column, though. In the **activity_labels** data frame we put together earlier, we have descriptions that line up with the entries in the **activity_id** column, so how do we get those character strings into our table? With the **merge** method, of course!

         > test_data <- merge(activity_labels, test_data, by.x = "activity_id", 
         +                    by.y = "activity_id", all.y = TRUE)
         > train_data <- merge(activity_labels, train_data, by.x = "activity_id", 
         +                     by.y = "activity_id", all.y = TRUE)
         > head(test_data[,1:4],5)
           activity_id activity_desc subject_id tBodyAcc-mean()-X
         1           1       WALKING         12         0.2160924
         2           1       WALKING         12         0.3434905
         3           1       WALKING         12         0.3090925
         4           1       WALKING         12         0.1918730
         5           1       WALKING         12         0.2842238

One last thing let's do before we merge together the **test** and **train** data frames: remember we talked earlier about the concept of being able to distinguish which subjects were part of the **test** series and which were part of the **train** series? Let's enumerate that a bit more specifically before we merge the data frames. In order to do this, we'll create a dummy data frame for each table, and fill up one column of that data frame with **TEST** or **TRAIN**. Then, we can *cbind()* that column of labels into each data frame to give them appropriate labeling before we merge the data frames.

         > test_df <- as.data.frame(rep(c("TEST"), nrow(test_data)))
         > names(test_df) <- c("dataset_desc")
         > test_data <- cbind(test_df, test_data)
         > train_df <- as.data.frame(rep(c("TRIAL"), nrow(train_data)))
         > names(train_df) <- c("dataset_desc")
         > train_data <- cbind(train_df, train_data)
         > head(test_data[,1:5],5)
           dataset_desc activity_id activity_desc subject_id tBodyAcc-mean()-X
         1         TEST           1       WALKING         12         0.2160924
         2         TEST           1       WALKING         12         0.3434905
         3         TEST           1       WALKING         12         0.3090925
         4         TEST           1       WALKING         12         0.1918730
         5         TEST           1       WALKING         12         0.2842238

I think we've done about everything we needed to before merging the two data sets, so let's do that now:

         > merged_data <- rbind(test_data, train_data)
         > dim(merged_data)
         [1] 10299    70

We didn't really need to use a *merge* function per se, because the columns in the two tables were identical, we were just adding rows of one identically-structured table to the other. So, we end up coming out with a data frame that has the same number of columns as each of the separate data frames did, but with over 10,000 observances.

Now, though, we have this extra **activity_id** that is kind of a repetition of the **activity_desc** data point, which is decidedly *untidy*. So, let's remedy this by removing the **activity_id** column from the merged table:

         > merged_data$activity_id <- NULL
         > head(merged_data[, 1:4], 5)
           dataset_desc activity_desc subject_id tBodyAcc-mean()-X
         1         TEST       WALKING         12         0.2160924
         2         TEST       WALKING         12         0.3434905
         3         TEST       WALKING         12         0.3090925
         4         TEST       WALKING         12         0.1918730
         5         TEST       WALKING         12         0.2842238

This basically takes us through the end of step 4 of the problem statement. We have so far done the following:

>1. Merges the training and the test sets to create one data set.
>2. Extracts only the measurements on the mean and standard deviation for each measurement. 
>3. Uses descriptive activity names to name the activities in the data set
>4. Appropriately labels the data set with descriptive variable names. 

Now, let's wrap up and push through the deliverables asked for in step 5 of the problem statement. The last problem asks for the average of each variable / subject / activity combination, which is perfectly suited for a *melt()* / *dcast()* command pairing.

First, let's melt the data to isolate each column in the data set as its own variable. We'll keep the **dataset_desc**, **activity_desc**, and **subject_id** as the IDs for the melt:

         > data_melt <- melt(merged_data,
                           id = c("dataset_desc", "activity_desc", "subject_id"), 
                           measure.vars = allowable_features$feature_desc)
         > head(data_melt,5)
           dataset_desc activity_desc subject_id          variable     value
         1         TEST       WALKING         12 tBodyAcc-mean()-X 0.2160924
         2         TEST       WALKING         12 tBodyAcc-mean()-X 0.3434905
         3         TEST       WALKING         12 tBodyAcc-mean()-X 0.3090925
         4         TEST       WALKING         12 tBodyAcc-mean()-X 0.1918730
         5         TEST       WALKING         12 tBodyAcc-mean()-X 0.2842238

Then, let's recast the melted data set into a summary table, where we enumerate the mean of each variable for each subject / activity permutation available:

         > final_data <- dcast(data_melt, subject_id + dataset_desc + activity_desc
                             ~ variable, mean)
         > head(final_data[,1:5], 10)
            subject_id dataset_desc      activity_desc tBodyAcc-mean()-X tBodyAcc-mean()-Y
         1           1        TRIAL             LAYING         0.2215982      -0.040513953
         2           1        TRIAL            SITTING         0.2612376      -0.001308288
         3           1        TRIAL           STANDING         0.2789176      -0.016137590
         4           1        TRIAL            WALKING         0.2773308      -0.017383819
         5           1        TRIAL WALKING_DOWNSTAIRS         0.2891883      -0.009918505
         6           1        TRIAL   WALKING_UPSTAIRS         0.2554617      -0.023953149
         7           2         TEST             LAYING         0.2813734      -0.018158740
         8           2         TEST            SITTING         0.2770874      -0.015687994
         9           2         TEST           STANDING         0.2779115      -0.018420827
         10          2         TEST            WALKING         0.2764266      -0.018594920
         > dim(final_data)
         [1] 180  69

This produces a tidy data frame that lays out, for each subject / activity pairing, average values for each variable. Whew.
