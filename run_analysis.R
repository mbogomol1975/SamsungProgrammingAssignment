## Read the files with data and the labels into data frames
xtest<-read.table("./test/x_test.txt")
ytest<-read.table("./test/y_test.txt")
subjecttest<-read.table("./test/subject_test.txt")
xtrain<-read.table("./train/x_train.txt")
ytrain<-read.table("./train/y_train.txt")
subjecttrain<-read.table("./train/subject_train.txt")
features<-read.table("./features.txt")
activities<-read.table("./activity_labels.txt")

##  Step1: Merges the training and the test sets to create one data set.
  
## Merge 2 data frames into one, with 10299 obs of 561 variables
dataset<-rbind(xtest, xtrain)

## Merge activity codes data sets into one
datalabels<-rbind(ytest,ytrain)

## Merge subjecs data sets into one
datasubjects<-rbind(subjecttest,subjecttrain)
names(datasubjects)<-"subject"

## Add labels to the data frame
names(dataset)<-features[[2]]

##  Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

## Select columns that compute mean and standard diviation, 10299 obs of 79 variables
columns<-grep("mean\\(\\)|std\\(\\)",names(dataset))
dataset1<-dataset[,columns]

## Step 3: Uses descriptive activity names to name the activities in the data set

## Match activity labels to activity codes
activity<-sapply(datalabels[[1]], function(x) {activities[[2]][x]})

## Merge subjects and activity labels  with mean and standard deviation measurements 
dataset1<-cbind(datasubjects, activity, dataset1)

## Step 4: Appropriately labels the data set with descriptive variable names.
## Changes column names to lower case
names(dataset1)<-tolower(names(dataset1))

## Removes "-" from the column names
names(dataset1)<-gsub("-", "", names(dataset1))

## Remove duplicate text "bodybody"
names(dataset1)<-sub("bodybody","body", names(dataset1))

names(dataset1)<-sub("^t","time", names(dataset1))
names(dataset1)<-sub("^f","freq", names(dataset1))
names(dataset1)<-sub("\\(\\)","", names(dataset1))


##  Step 5:From the data set in step 4, create a second, independent tidy data set 
##  with the average of each variable for each activity and each subject.
tidyset<-summarise_at(group_by(dataset1,subject,activity), 
        .vars= names(dataset1)[3:length(names(dataset1))], .funs = mean, na.rm=TRUE)
