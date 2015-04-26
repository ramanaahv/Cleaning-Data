#The following are the transformations done:

#Libraries:
require("data.table")
require("reshape2")

#1. Read the Files and combine them
file1=read.table("UCI HAR Dataset//test//X_test.txt")
file2=read.table("UCI HAR Dataset//test//subject_test.txt")
file3=read.table("UCI HAR Dataset//test//y_test.txt")
file4=read.table("UCI HAR Dataset//train//X_train.txt")
file5=read.table("UCI HAR Dataset//train//subject_train.txt")
file6=read.table("UCI HAR Dataset//train//y_train.txt")
names_col = read.table("UCI HAR Dataset/features.txt")
clean_data1=cbind(file1,file2,file3)
clean_data2=cbind(file4,file5,file6)
combined_data=rbind(clean_data1,clean_data2)

#2. Extract the measurements containing only the mean and standard deviations
mean_cols = grep("mean",names_col$V2,ignore.case = TRUE)
std_cols = grep("std",names_col$V2,ignore.case = TRUE)
subset_clean_data=combined_data[,mean_cols]
subset_clean_data1=combined_data[,std_cols]
subset_clean_data2=combined_data[,c(562,563)]

#4.Name the columns of the combined data
names(subset_clean_data)=names_col$V2[mean_cols]
names(subset_clean_data1)=names_col$V2[std_cols]
names(subset_clean_data2)=c("Subject","activity")
combined_clean_data<-cbind(subset_clean_data,subset_clean_data1,subset_clean_data2)

#3.Give descriptive names for the activity
combined_clean_data$activity[combined_clean_data$activity==1]<-"WALKING"
combined_clean_data$activity[combined_clean_data$activity==2]<-"WALKING_UPSTAIRS"
combined_clean_data$activity[combined_clean_data$activity==3]<-"WALKING_DOWNSTAIRS"
combined_clean_data$activity[combined_clean_data$activity==4]<-"SITTING"
combined_clean_data$activity[combined_clean_data$activity==5]<-"STANDING"
combined_clean_data$activity[combined_clean_data$activity==6]<-"LAYING"
combined_clean_data$Subject=as.factor(combined_clean_data$Subject)
combined_clean_data$activity=as.factor(combined_clean_data$activity)
combined_clean_data$Subject=as.factor(combined_clean_data$Subject)
combined_clean_data$activity=as.factor(combined_clean_data$activity)

#5. Create independent tidy data set with the average of each variable for each activity and each subject.
melted_data=melt(combined_clean_data,id=c("Subject","activity"),measure.vars = c(1:86))
View(melted_data)
tidy_data=dcast(melted_data,Subject+activity~ variable,mean)
tidy_data<-tidy_data[order(tidy_data$Subject,tidy_data$activity),]
write.table(tidy_data, file = "Tidy.txt", row.names = FALSE)
