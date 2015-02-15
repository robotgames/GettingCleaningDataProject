# Coursera *Getting and Cleaning Data* Project 1 #

----------

## Introduction ##
In Project 1, we are given a set of readings from instrumentation sensing motion and acceleration.  The readings are broken into a number of files, the names of the variables are (likely) determined by the machine(s) creating the readings and are not very descriptive, and an important factor is coded by integer rather than string.

Our goal is to create a tidy data set containing

* the data associated with means and standard deviations of the sensor readings, and
* means for each test subject performing each task for each sensor reading.

## Overview of the data cleaning process ##
1. Import the data, both numeric and variable names (in separate files).  Numeric data is located in test and training data sets.
2. Clean the variable names.  Variables have been renamed per the scheme described in the next subsection.
3. Select the desired data (only the variables measuring means or standard deviations).
4. Merge the test and training data sets.
5. **Create a new variable translating the integer activity codes 1-6 into strings descriptors**.
6. Compute the desired means.
7. Store the means as new records (rows) in the tidy data frame, and **create a new factor variable with two levels**, coding each record as one of the summarizing means ("Mean") or one of the original data records ("Original").

We create two new factor variables (in **bold**).  One is simply a translation of the integer codes for the activity level.  The second helps us distinguish later between the data originally present in the data sets and the summarizing data we computed and stored later.

As a result of the data cleaning, we provide

* a tidy data set, tidierdata.txt ,
* a code snippet importing the tidy data set as a data frame,
* a function for extracting the mean data for a given test subject and given activity label, and
* a function removing the computed data from the data frame.

## Variable Name Cleaning ##
Each of the variables kept for the tidy data set has a name containing 4-5 of the following 5 components:

* An integer code numbering off the variables.  This code was discarded.
* A character tag "t" (denoting "time domain") or "f" (denoting "frequency domain")
* A function name "mean()" (denoting mean) or "std()" (denoting standard deviation)
* A character descriptor of the measurement, e.g. "BodyAcc"
* (optional) the spatial axis along which the measurement was taken, **X**, **Y**, or **Z**

When cleaning the variable names each new variable name for the original variables includes each of these four components, separated by underscores.  In the case that no spatial axis is provided, that component is coded as **N**.

Additionally, "t" was recoded as **TimeDomain** and "f" as **FrequencyDomain**, and "mean()" as **Mean** and "std()" as **StandardDeviation**.

For example, "1 tBodyAcc-mean()-X" was recoded as
	
	BodyAcc_TimeDomain_Mean_X.

This system makes it easier to select variables by name using **grep**.

## Selecting Data on Means and Standard Deviations ##
The original data sets contained a number of variables with a name indicating that a function "mean()" or "std()" had been applied (in one case, "meanFreq()").  These variables were retained for the tidy data set.

While other variable names in the original data set contained the word "Mean", they were described as means of windowed samples from the data.  However, the windows were not provided nor were the samples, and so we do not have some important information on these variables.  Thus these variables were not retained for the tidy data set.

## Computed Mean Data ##

The tidy data set should include the **average of each variable for each activity and each subject**.  For example, test subject "3" has 52 measurements of the

	"BodyAcc_TimeDomain_Mean_X"

variable which are labeled "SITTING".  We provide a single average of those 52 measurements.  Thus each computed mean will correspond to

* a unique test subject ID, from 1 to 30
* a unique activity label, one of "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
* a unique variable

Once the means have been computed, we include them in the tidy data set.  We code all data in the tidy data set with a factor variable **Source** indicating that the record is "Original" data or a computed "Mean".

## Examples ##
The following R code snippet imports the data and sets the appropriate variables to factors.  This assumes that the file "tidierdata.txt" is in the working directory.

    df <- read.csv("tidierdata.txt",sep=" ")
	df$NumericActivityLabels <- as.factor(df$NumericActivityLabels)
	df$TestSubjectID <- as.factor(df$TestSubjectID)

We can extract the mean data for a specified test subject with a specified activity code:

	extractMeans("3","SITTING")

will extract the data for test subject with code "3" and activity label "SITTING".