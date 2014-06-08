#This R script called run_analysis.R does the following:
library(data.table)

#1. Merges the training and the test sets to create one data set.
xtrn   <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
ytrn   <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt",col.names="activity")
subtrn <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt",col.names="subject")
xtst   <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")
ytst   <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt",col.names="activity")
subtst <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt",col.names="subject")

all    <- rbind(cbind(xtrn,ytrn,subtrn),cbind(xtst,ytst,subtst))
rm(xtrn,ytrn,subtrn,xtst,ytst,subtst)

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
feat   <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt")
patt   <- grep("*(mean|std)\\(\\)*",feat$V2,value=FALSE)
all    <- all[c(patt,562,563)] #keep 562 and 563 resp. activity and subject


#3. Uses descriptive activity names to name the activities in the data set.
acti   <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt")
all    <- merge(x=all,y=acti,by.x="activity",by.y="V1")
rm(acti)

#4. Appropriately labels the data set with descriptive variable names. 
colnames(all) <- c("activity.code",as.character(feat$V2[patt]),"subject.code","activity.str")
rm(patt,feat)

#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
write.table(all,"getdata-projectfiles-UCI HAR Dataset\\tidy1.txt")

avg   <- aggregate(all[,-c(1,68,69)],by=list(activity=all$activity.code,subject=all$subject.code),FUN=mean)
write.table(avg,"getdata-projectfiles-UCI HAR Dataset\\tidy2.txt")

rm(all,avg)