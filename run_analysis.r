
rm(list=ls())
library(plyr)
library(dplyr)

library(reshape2)
# [1]  Load the data into R from the directories.  For simplicity I extracted the directories to the directory where R is initialized. 

trainname <-"train/X_train.txt"
testname <-"test/X_test.txt"
training <- read.table(trainname,sep = "")
test<- read.table(testname,sep = "")



# [2]  Merge the training and test data into one data set.
# combined consists of the two row merged test and training data frames.
combined <- rbind(test,training)

# Each of the 561 columns represents some measurement related to an activity performed by the participant.  The names of each of the 561 measurements
# is provided in the file  "features.txt".  These will be read into the program to provide the column names for each activity.
filename <- "features.txt"    
colnames <-as.vector(read.table(file = filename , sep=""))
colnames <- as.vector(colnames[2])

# Produce more amenable variable names for the data frame.
names(combined) <- t(colnames)
names(combined) <- gsub(x=names(combined),"-mean","mean")
names(combined) <- gsub(x=names(combined),"-std","std")
names(combined) <- gsub(x=names(combined),"[()-]","")

# [2]  Extract only the measurements considering the mean or the standard deviation.
# Perusing the column names it is easy to see that the mean tends to be marked with "mean" while the standard deviation was "std".

mean.names <- grep(names(combined),pattern = "mean")
std.names <- grep(names(combined),pattern = "std")
combined.mean <- combined[mean.names]
combined.std<- combined[std.names]
combined.summary<-cbind(combined.mean,combined.std)


# [3]  Uses descriptive activity names to name the activities in the data set.
# To do this, I have to use the numerical coding which was provided with the assignment in "activity_labels.txt":

# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING


# Now, draw the information from:
# "y_test.txt"
# "y_train.txt
# and code this into descriptive names for the rows using the mavalues function.  Afterwards, rbind
# the activity labels to the selected rows from [2].

train.rows <- as.vector(read.table("train/y_train.txt",sep = ""))
test.rows <- read.table("test/y_test.txt",sep = "")

number.labels <-rbind(test.rows,train.rows)
number.labels<-as.factor(as.vector(number.labels[,1]))
activity.labels <-mapvalues(number.labels,c(1,2,3,4,5,6),
                            c( "WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
activity.labels<-as.data.frame(activity.labels)
combined_w_activities <- cbind(activity.labels,combined.summary)


# [4] I am assuming that the fourth step of this project corresponds to loading in who the participants were
# for this study.  I proceed in the same manner at [3] in terms of load and adding the participants.

train.partic <- as.vector(read.table("train/subject_train.txt",sep = ""))
test.partic <- read.table("test/subject_test.txt",sep = "")
subjects <-rbind(test.partic,train.partic)
final.frame <- cbind(subjects,combined_w_activities)
# Give more suitable names to the first few rows:
names(final.frame)[1:2]<-c("Subject","Activity")

# [5]  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# What I want to do is create a new data frame which includes information for each of the participants broken into each type of activity they pursued. 
#  This means that subject 1 will have six different activities and for each of these an average will be displayed.  This means I will be using
# the dplyr library to rearrange and manipulate this data.

#     i.    In order to get the specified values, I have to change the layout of the data so that it is stratified based on user, then activity
#           and there is one measurement for each type of activity. As a result, we get a data frame which is 813,621 by 4.

tidy.melted <- melt(final.frame,id.vars = c("Subject","Activity"))

# Now I want to use the mean() function on each of the 561 data types based on the user and the activity type.  This values below are arranged first
# on subject (based on number) and then on the activity.  Afterwards the mean is displayed for each type of variable.
tidy.data1<- dcast(tidy.melted,Subject+Activity~variable,mean)

# Write the data to a csv file.  Opening the file below in Excel show that the data meets the requirements of tidy data which are:
write.table(x = tidy.data1,file = "tidied_data.csv",row.names = FALSE,sep=",")
