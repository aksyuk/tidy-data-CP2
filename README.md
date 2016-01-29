# tidy-data-CP2
'Getting and Cleaning Data' course, week 4. Course Project 2.  
Student: Svetlana Aksyuk  
*Version 1.0, 29/01/2016.*

# Repository content
This repository contains data files along with code book explaining them. The key concept represented by data files is **'tidy data'**. As described in ['Tidy Data' article by Hadley Wickham (2014)](http://www.jstatsoft.org/article/view/v059i10/v59i10.pdf), in tidy data:  
1. Each variable forms a column.  
2. Each observation forms a row.  
3. Each type of observational unit forms a table.  
  
List of files of this repository:  
  
1. **`run_analysis.R`** -- R code which loads raw data and produces tidy data 
files. Script file includes seven parts which are supposed to run consequentially:  
   * load packages;  
   * create subdirectory `'data'` in working directory, download archive with data, unzip it and create two data tables: *`train`* and *`test`* with training and test samples, respectively;  
   * merge *`train`* and *`test`* into one dataset;  
   * extract only the measurements on the mean and standard deviation;
   * replace activity labels with descriptive activity namesin the dataset;  
   * make column names of the dataset descriptive and human readable;  
   * creates an independent tidy dataset with the average of each variable for each activity and each subject.  
   * saves data to **`tidyData.csv`** and **`tidyDataMeans.csv`** files.  
  
2. **`tidyData.csv`** - tidy dataset, created from raw data collected from the accelerometers from the Samsung Galaxy S smartphone.  
  
3. **`tidyDataMeans.csv`** - second dataset created in this assignment. Contains values of variables from **`tidyData.csv`**, averaged by subject and activity.  

4. **`CodeBook.md`** -- Code book with descriptions of data sets and explanation of data transformations which made them tidy.