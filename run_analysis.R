# We'll assume that the original data files are in the working directory
# or appropriate subdirectories.  We set the working directory first.

setwd("C:\\Users\\Chris\\Desktop\\Coursera Getting Data\\Project\\UCI HAR Dataset")

# Pull in the labels for the features, i.e. measured variables,
# and the activity code..verbose pair labels.  Using strsplit
# for the activity code labels
# in this way gives us a decent dictionary for looking up the
# verbose activity label name in terms of its numeric code, 
# i.e. "1"corresponds to "WALKING".
# There is significant cleaning to be done on the feature labels.
# The function nameclean cleans each label individually.  The new
# label contains three to four pieces of information, separated by underscores
# in the case that the label corresponds to a variable to be retained.  If
# the label corresponds to data that is to be discarded, the new label is
# simply "Remove".  The elements of the new label are as follows:
#
# 1. TimeDomain or FrequencyDomain, describing whether the data is derived
# from time or frequency data.
#
# 2. String descriptor of measurement, corresponding to description
# present in original label.
#
# 3. (when applicable) X, Y, or Z denoting the axis along which the data
# was collected.
#
# 4. Mean or Standard Deviation
#
# First import the labels for the measured features and clean them.
featureLabels <- readLines("features.txt")
nameclean <- function(z) {
  y <- strsplit(z," ")[[1]][2]
  if (substr(y,1,1)=="t") topaste2 <- "TimeDomain_"
  else topaste2 <- "FrequencyDomain_"
  if (!(grepl("-mean\\(\\)",y) | grepl("-std\\(\\)",y) | grepl("-meanFreq\\(\\)",y))) {
    y <- "Remove"
  }
  if (grepl("-mean\\(\\)",y) | grepl("-meanFreq\\(\\)",y)) topaste3 <- "Mean_"
  if (grepl("-std\\(\\)",y)) topaste3 <- "StandardDeviation_"
  if (grepl("-[XYZ]",y)) {
    if (grepl("-X",y)) topaste4 <- "X"
    if (grepl("-Y",y)) topaste4 <- "Y"
    if (grepl("-Z",y)) topaste4 <- "Z"
  }
  else topaste4 <- "N"
  if (grepl("[[:alnum:]]+-mean",y) | grepl("[[:alnum:]]+-std",y)) {
    cutpoint <- regexpr("-(mean|std)",y)[1]-1
    topaste1 <- paste(substring(y,2,cutpoint),"_",sep="")
  }
  if (y=="Remove") return(y)
  else return(paste(topaste1,topaste2,topaste3,topaste4,sep=""))
}
featureLabels <- as.vector(sapply(featureLabels,function(z) if (grepl(" ",z)) nameclean(z)))

# Next import the label/number pairs for the activities and
# create a dictionary-like object.
alabels <- readLines("activity_labels.txt")
alabels <- strsplit(alabels,"[[:space:]]+")

# Read in the data from the test set.  There is some cleaning to be done
# on the X data set.
data1 <- readLines("test\\subject_test.txt")
predata2 <- readLines("test\\X_test.txt")
library(gdata)
predata2 <- trim(predata2)
predata2 <- strsplit(predata2,"[[:space:]]+")
predata2 <- sapply(predata2,as.numeric)
# At this point we have created numeric data.  Create a data frame
# and give column names.  We have many extraneous columns, each of
# which will now have the name "Remove" (see earlier comments when
# creating the new feature labels).
dftest <- data.frame(t(predata2))
names(dftest) <- featureLabels
# We now read the activity labels.  Because these were originally recorded
# as integer codes and we would like to have them as words, we
# create two variables for our data frame, numeric activity levels
# and activity labels as words.
labels1 <- readLines("test\\y_test.txt")
dftest$NumericActivityLabels <- labels1
dftest$ActivityLabels <- sapply(labels1,
                                 function(z) {alabels[[as.numeric(z)]][2]})
dftest$TestSubjectID <- as.factor(data1)

# We now repeat the same procedure of importing and labeling for
# the training set.
data1 <- readLines("train\\subject_train.txt")
predata2 <- readLines("train\\X_train.txt")
library(gdata)
predata2 <- trim(predata2)
predata2 <- strsplit(predata2,"[[:space:]]+")
predata2 <- sapply(predata2,as.numeric)

labels1 <- readLines("train\\y_train.txt")
dftrain <- data.frame(t(predata2))
names(dftrain) <- featureLabels
dftrain$NumericActivityLabels <- labels1
dftrain$ActivityLabels <- sapply(labels1,
                                function(z) {alabels[[as.numeric(z)]][2]})
dftrain$TestSubjectID <- as.factor(data1)

# We now include all records from the training and test data sets
# in one data frame.
df <- rbind(dftest,dftrain)

# We remove all columns we marked as such.
dftidy <- df[,which(names(df) != "Remove")]

#We are now ready to compute appropriate averages.  We only want to do this
# for the numeric columns.
dftidy$Source <- rep("Original",times = nrow(dftidy))
ndftidy <- dftidy[,sapply(dftidy,is.numeric)]
mutidy <- apply(ndftidy,2,mean)
ID <- as.numeric(levels(dftidy$TestSubjectID))
AL <- levels(as.factor(dftidy$ActivityLabels))
for (id in ID) {
  for (al in AL) {
    bb<-data.frame(ndftidy[which(dftidy$TestSubjectID == id 
                             & dftidy$ActivityLabels == al),])
    names(bb) <- names(ndftidy)
    bb <- apply(bb,2,mean)
    bb$Source <- c("Mean")
    bb$ActivityLabels <- al
    bb$TestSubjectID <- id
    bb$NumericActivityLabels <- dftidy$NumericActivityLabels[which(dftidy$ActivityLabels==al)][1]
    dftidy <- rbind(dftidy,bb)
  }
}
# At this point we should be able to write a tidy data set
# using write.table().
write.table(dftidy,file = "tidierdata.txt",row.names=FALSE)

# We include code to import the tidy data set again.  This assumes
# that tidierdata.txt is in the current working directory for R.
# We form factors for the TestSubjectID and NumericActivityLabels,
# which read.csv() read in as numeric data.
df <- read.csv("tidierdata.txt",sep=" ")
df$NumericActivityLabels <- as.factor(df$NumericActivityLabels)
df$TestSubjectID <- as.factor(df$TestSubjectID)
# We also provide a function for extracting the mean data for
# a specified ID and activity label
extractMeans <- function(id,al,data=df) {
  data[which(data$TestSubjectID == id & data$ActivityLabels == al) & data$Source == "Mean",]
}
#Last we provide a function that removes the summarized data
# and returns a the remaining data in a data frame
removeSummaries <- function(data=df) {
  y <- data[which(data$Source=="Original"),]
  y <- y[,which(names(y)!= "Means")]
  y
}
