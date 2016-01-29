#-------------------------------------------------------------------------------
# Getting and Cleaning Data: Course Project 2. 
#-------------------------------------------------------------------------------
# The purpose of this project is to demonstrate your ability to collect, 
#  work with, and clean a data set.
# The raw data represent data collected from the accelerometers 
#  from the Samsung Galaxy S smartphone.
# A full description is available at the site where the data was obtained:
#    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#-------------------------------------------------------------------------------
# load packages
library('dplyr')
#...............................................................................
# create data directory
if(!file.exists('./data')) dir.create('./data')
# load data (all operations include conditions to save time 
#  in case of repetition)
if(!file.exists('./data/getdata_Fprojectfiles_FUCI HAR Dataset.zip')) {
    fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
    download.file(fileURL, destfile = './data/getdata_Fprojectfiles_FUCI HAR Dataset.zip')
}
# unzip data
if(!file.exists('./data/UCI HAR Dataset')) {
    unzip('./data/getdata_Fprojectfiles_FUCI HAR Dataset.zip', exdir = './data')
}
# read data
if (!exists('test')) {
     x.test <- read.table('./data/UCI HAR Dataset/test/X_test.txt')
     y.test <- read.table('./data/UCI HAR Dataset/test/y_test.txt')
     subject.test <- read.table('./data/UCI HAR Dataset/test/subject_test.txt')
     test <- cbind(subject.test, y.test, x.test)
     rm(x.test, y.test, subject.test)
}
if (!exists('train')) {
    x.train <- read.table('./data/UCI HAR Dataset/train/X_train.txt')
    y.train <- read.table('./data/UCI HAR Dataset/train/y_train.txt')
    subject.train <- read.table('./data/UCI HAR Dataset/train/subject_train.txt')
    train <- cbind(subject.train, y.train, x.train)
    rm(x.train, y.train, subject.train)
}
#...............................................................................
# * Merge the training and the test sets to create one data set.
dt.tidy <- tbl_df(rbind(train, test))
hdr <- read.table('./data/UCI HAR Dataset/features.txt', sep = '', row.names = 1,
                  as.is = T)
colnames(dt.tidy) <- c('subject.id', 'activity', make.names(unclass(hdr[, 1])))
rm(hdr, test, train)
#...............................................................................
# * Extract only the measurements on the mean and standard deviation 
#    for each measurement.
clmn.select <- c(1, 2, grep('mean|std', colnames(dt.tidy)))
dt.tidy <- dt.tidy[, clmn.select]
clmn.select <- grep('meanFreq', colnames(dt.tidy))
dt.tidy <- dt.tidy[, -clmn.select]
rm(clmn.select)
#...............................................................................
# * Use descriptive activity names to name the activities in the data set
act.lbls <- read.table('./data/UCI HAR Dataset/activity_labels.txt', sep = '', 
                       as.is = T, col.names = c('act', 'lbl'))
dt.tidy$activity <- act.lbls$lbl[dt.tidy$activity]
rm(act.lbls)
#...............................................................................
# * Appropriately label the data set with descriptive variable names. 
nms <- names(dt.tidy)
# change abbreviations to full words
nms <- sub('^t', 'time.', nms)
nms <- sub('^f', 'fft.', nms)
nms <- gsub('Body', '.body.', nms)
nms <- sub('Acc', '.accelerometer.', nms)
nms <- sub('Gyro', '.gyroscope.', nms)
nms <- sub('Freq', '.frequence.', nms)
nms <- sub('Mag', '.magnitude.', nms)
# replace series of dots with one
nms <- gsub('[.]+', '.', nms)
# remove trailing dots
nms <- gsub('[.]+$', '', nms)
# lower case
nms <- tolower(nms)
# rename columns of data table
colnames(dt.tidy) <- nms
rm(nms)
#...............................................................................
# * From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
aver.tidy <- dt.tidy %>% group_by(subject.id, 
                                  activity) %>% summarize_each(funs(mean))
#...............................................................................
# save data sets into .csv files
write.csv(dt.tidy, file = 'tidyData.csv', row.names = F)
write.csv(aver.tidy, file = 'tidyDataMeans.csv', row.names = F)
# save data sets into .txt files for submission at Coursera.org
write.table(dt.tidy, file = 'tidyData.txt', row.names = F)
write.table(aver.tidy, file = 'tidyDataMeans.txt', row.names = F)