# Getting and Cleaning Data Code Book
### A source to highlight and explain data frames within the code.

**activity_labels**

> *Import of the activity_labels.txt file into a dataframe*
>
> A data frame of activity descriptions

**allowable_features**

> A data frame based off of the **features** data frame, meant to only hold features required for this exercise

**data_melt**

> A data frame which takes the **merged_data** data frame and unpivots the variables into their own column

**features**

> Import of the features.txt file into a dataframe
>
> A data frame of features descriptions

**final_data**

> A data frame which takes the unpivotted data in the **melt_data** data frame and summarizes it into the averages of data points by subject by activity

**merged_data**

> A data frame which takes the combination of rows from the **test_data** and **train_data** data frames, once data has been sanitized in each of those data sets

**subject_test**

> Import of the subject_test.txt file into a dataframe
>
> A data frame which holds the matching subject ID to each observation within the **x_test_data** data frame

**subject_train**

> Import of the subject_train.txt file into a dataframe
>
> A data frame which holds the matching subject ID to each observation within the **x_train_data** data frame

**test_data**

> A data frame which begins by combine data from the **x_test_data**, **y_test_data**, and **subject_test** data frames, then further sanitizes the data frame

**test_df**

> A data frame created to hold a vector of **"TEST"** character strings to apply to the **test_data** data frame

**train_data**

> A data frame which begins by combine data from the **x_train_data**, **y_train_data**, and **subject_train** data frames, then further sanitizes the data frame

**train_df**

> A data frame created to hold a vector of **"TRAIN"** character strings to apply to the **train_data** data frame

**x_test_data**

> Import of the X_test.txt file into a dataframe
>
> A data frame that houses all of the raw data collected from the **test** exercises

**x_train_data**

> Import of the X_train.txt file into a dataframe
>
> A data frame that houses all of the raw data collected from the **train** exercises

**y_test_data**

> Import of the Y_test.txt file into a dataframe
>
> A data frame that contains the activity identification marker for each observation in the **x_test_data** data frame

**y_train_data**

> Import of the Y_train.txt file into a dataframe
>
> A data frame that contains the activity identification marker for each observation in the **x_train_data** data frame
