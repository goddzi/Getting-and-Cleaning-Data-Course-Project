# Peer Graded Assignment: Getting and Cleaning Data Course Project
# library reshape2 is required

library(reshape2)

#read files into dataframe
test_x<-read.table(file.path(targetPath, "test", "X_test.txt"))
test_sub<-read.table(file.path(targetPath, "test", "subject_test.txt"))
test_y<-read.table(file.path(targetPath, "test", "y_test.txt"))
train_x<-read.table(file.path(targetPath, "train", "X_train.txt"))
train_sub<-read.table(file.path(targetPath, "train", "subject_train.txt"))
train_y<-read.table(file.path(targetPath, "train", "y_train.txt"))
act_lb<-read.table(file.path(targetPath,  "activity_labels.txt"))
feat<-read.table(file.path(targetPath,  "features.txt"), as.is = TRUE)

#conbine dataset into one dataframe
train_ds<-cbind(train_sub,train_x,train_y)
test_ds<-cbind(test_sub,test_x,test_y)
ds_all<-rbind(train_ds,test_ds)
colnames(ds_all)<-c("subject", feat[,2] , "activity")

#Extract mean and standard deviation and set variable name
colNum <- grepl("subject|activity|mean|std", colnames(ds_all))
tblAll<-ds_all[,colNum]
tblAll$activity <- factor(tblAll$activity, levels = act_lb[,1], labels = act_lb[,2])
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#average of each variable for each activity and each subject, and create second dataset
tblAllMlt <- melt(tblAll, id = c("subject", "activity"))
secondDataset <- dcast(tblAllMlt, subject + activity ~ variable, mean)
