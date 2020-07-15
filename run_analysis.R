library(dplyr)
fname <- "final_proj.zip"
if(!file.exists(fname))
{
  f_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(f_URL,destfile = fname, method = "curl")
}
unzip(fname)
features <- read.table("./UCI HAR Dataset/features.txt",col.names = c("n","functions"))
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged_data <- cbind(subject,x,y)
mean_std <- select(merged_data,subject,code,contains("mean"),contains("std"))
mean_std$code <- activity_labels[mean_std$code,2]

names(mean_std)[2] <- "activity"
names(mean_std) <- gsub("Acc","Accelerometer",names(mean_std))
names(mean_std) <- gsub("Gyro","Gyroscope",names(mean_std))
names(mean_std) <- gsub("BodyBody","Body",names(mean_std))
names(mean_std) <- gsub("Mag","Magnitude",names(mean_std))
names(mean_std) <- gsub("^t","Time",names(mean_std))
names(mean_std) <- gsub("^f","Frequency",names(mean_std))
names(mean_std) <- gsub("tBody","TimeBody",names(mean_std))
names(mean_std)<-gsub("-mean()", "Mean", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub("-std()", "STD", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub("angle", "Angle", names(mean_std))
names(mean_std)<-gsub("gravity", "Gravity", names(mean_std))
names(mean_std)<-gsub("-freq()", "Frequency", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub("\\.*$", "", names(mean_std))
names(mean_std)<-gsub("mean", "Mean", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub(".mean", "Mean", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub(".std", "STD", names(mean_std), ignore.case = TRUE)

final_data <- mean_std %>% group_by(subject,activity) %>% summarise_all(mean)
write.table(final_data,"final_data.txt")
