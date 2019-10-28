---
title: "Explanation of R code for programming assignment"
output: html_document
---
This code reads the files with data and the labels into data frames
```{r}
xtest<-read.table("./test/x_test.txt")
ytest<-read.table("./test/y_test.txt")
subjecttest<-read.table("./test/subject_test.txt")
xtrain<-read.table("./train/x_train.txt")
ytrain<-read.table("./train/y_train.txt")
subjecttrain<-read.table("./train/subject_train.txt")
features<-read.table("./features.txt")
activities<-read.table("./activity_labels.txt")
```

For Step1, merge the training and the test sets to create one data set.
  
  + Merge xtest and xtrain data frames into one, with 10299 obs of 561 variables
  + Merge activity codes, ytest and ytrain, data sets into one
  + Merge subjectest and subjecttrain data sets into one

```{r}
dataset<-rbind(xtest, xtrain)
datalabels<-rbind(ytest,ytrain)
datasubjects<-rbind(subjecttest,subjecttrain)
names(datalabels)<-"subject"
```


Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
  
  + First, add labels to the data frame, dataset, with observations
  + Select columns that compute mean and standard deviation only, 10299 obs of 79 variables

```{r}
names(dataset)<-features[[2]]
columns<-grep("mean\\(\\)|std\\(\\)",names(dataset))
dataset1<-dataset[,columns]
```

Step 3: Uses descriptive activity names to name the activities in the data set

  + First, we need to match activity labels, in activities data frame, to activity codes in datalabels
  + Merge subjects and activity labels with mean and standard deviation measurements into new dataset1
  
```{r}
activity<-sapply(datalabels[[1]], function(x) {activities[[2]][x]})
dataset1<-cbind(datasubjects, activity, dataset1)
```

Step 4: Appropriately labels the data set with descriptive variable names.

  + Change column names to lower case
  + Remove "-" from the column names
  + Remove duplicate text "bodybody"
  + Replace "t" in the beginning of the labels with "time"
  + Replace "f" in the beginning of the labels with "freq"
  + Remove "\\(\\)" after "mean" and "Std"
  
```{r}
names(dataset1)<-tolower(names(dataset1))
names(dataset1)<-gsub("-", "", names(dataset1))
names(dataset1)<-sub("bodybody","body", names(dataset1))
names(dataset1)<-sub("^t","time", names(dataset1))
names(dataset1)<-sub("^f","freq", names(dataset1))
names(dataset1)<-sub("\\(\\)","", names(dataset1))
```
  
Step 5:From the data set in step 4, create a second, independent tidy data set 
with the average of each variable for each activity and each subject.

  + Use group_by to group the dataset1 by subect and activity, then use summarize_at to apply "mean" to the remaining columns in dataset1 within each subject-activity group

```{r}
tidyset<-summarise_at(group_by(dataset1,subject,activity), 
        .vars= names(dataset1)[3:length(names(dataset1))], .funs = mean, na.rm=TRUE)
```
  
The run_analysis.R file can be read from parent directory using:

```{r}
tidyset<-read.table("tidyset.txt")
```

