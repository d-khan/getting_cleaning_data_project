install.packages('reshape2')
library(reshape2)

###### Notes for Reviewer ########
## tidy_dataset object contain tidy set with the average of each variable for each activity and each subject ##

#############Points 1 & 3#####################

# Load test data and feature in R
test = read.table('./test/X_test.txt',sep='')
feature = read.table('./features.txt',sep='')
colnames(test) = feature$V2

# Read test activity
test_activity = read.table('./test/y_test.txt')

# Bind Activity and entire measurements of test set in one data frame and change column name
test = cbind.data.frame(test_activity,test)
colnames(test)[1] = 'Activity'

#Change activity number to activity name
test[test$Activity==1,1] = 'Walking';test[test$Activity==2,1] = 'Walking_Upstairs';test[test$Activity==3,1] = 'Walking_Downstairs';test[test$Activity==4,1] = 'Sitting';test[test$Activity==5,1] = 'Standing';test[test$Activity==6,1] = 'Laying'

#Read test subject ID, bind 'Subject' with existing 'test' data frame and change column name
subject_test = read.table('./test/subject_test.txt',sep='')
test = cbind.data.frame(subject_test,test)
colnames(test)[1] = 'Subject'

# Load train data in R
train = read.table('./train/X_train.txt',sep='')
colnames(train) = feature$V2

# Read train activity in R, bind with 'train' data frame and change column name
train_activity = read.table('./train/y_train.txt')
train = cbind.data.frame(train_activity,train)
colnames(train)[1] = 'Activity'

# Change activity number to activity name
train[train$Activity==1,1] = 'Walking';train[train$Activity==2,1] = 'Walking_Upstairs';train[train$Activity==3,1] = 'Walking_Downstairs';train[train$Activity==4,1] = 'Sitting';train[train$Activity==5,1] = 'Standing';train[train$Activity==6,1] = 'Laying'

# Read train subject ID, bind 'Subject' with existing 'train' data frame and change column name
subject_train = read.table('./train/subject_train.txt',sep='')
train = cbind.data.frame(subject_train,train)
colnames(train)[1] = 'Subject'

# Merge train and test data set into one set 
train_test = rbind(train,test)

#############Point 2#####################

# Using regular expression to extract mean() and std() column names 
m = grep(c('mean()'),colnames(train_test),fixed=TRUE)
s = grep(c('std()'),colnames(train_test),fixed=TRUE)
train_test_extract = train_test[,c(1,2,m,s)]

#############Point 4#####################

# Using regular expression to change variable names with descriptive variable names
names(train_test_extract) = gsub('mean\\(\\)','mean',names(train_test_extract))
names(train_test_extract) = gsub('std\\(\\)','sd',names(train_test_extract))
names(train_test_extract) = gsub('BodyBody','Body',names(train_test_extract))
names(train_test_extract) = gsub('-','_',names(train_test_extract))


#############Point 5#####################

# Create a second independent tidy data set with the average of each variable for each activity and each subject
temp = melt(train_test_extract,id=c('Subject','Activity'))
tidy_dataset = dcast(temp,Subject+Activity ~ variable, mean)

# Write second tidy set into text file
write.table(tidy_dataset,file='tidy_dataset.txt',row.name=FALSE,col.name=TRUE)