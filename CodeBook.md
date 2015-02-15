# Code Book #
----------
This data set has gone through a cleaning process, updated February 15, 2015.    Each subsection of the code book indicates in its title whether it corresponds to the original data set or the cleaned data set.  **Please see updates to the code book, listed in their own subsections, below**.  The original data set can be found at the URL

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

## Feature Selection (Original Data Set) ##
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

## Feature vector records (Original Data Set) ##
These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

## Estimated variables (Original Data Set) ##
The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'.

## Update February 15, 2015: Discarding variables ##
In creating the tidy data set, we were asked to retain only information on means and standard deviations.  All variables with "mean()", "std()", or "meanFreq()" were retained, as well as test subject ID and activity type labels; all other variables were discarded.

## Update February 15, 2015: Additional Factor Variables ##
In creating the tidy data set we coded four new factor variables.  These are:

1. **NumericActivityLabels** == the numeric codes used to identify the type of activity.  (This variable was present in the original data set but had a different name.)  The correspondence is:

	"1" == "WALKING"
	
	"2" == "WALKING_UPSTAIRS"
	
	"3" == "WALKING_DOWNSTAIRS"
	
	"4" == "SITTING"
	
	"5" == "STANDING"
	
	"6" == "LAYING"

2. **ActivityLabels** == the descriptive string codes used to identify the type of activity.  See 1. for correspondences.
3. **TestSubjectID** == the numeric identification code for the test subject, values 1 through 30.  (This variable was present in the original data set but had a different name.)
4. **Source** == factor indicating whether the record (row) was drawn from the original data set, coded "Original", or was computed as a summarizing mean, coded as "Mean".  See the *ReadMe.md* file for details on computing these means.