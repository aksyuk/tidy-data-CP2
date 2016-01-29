# Code book for data files
  
## **`tidyData.csv`**  
The dataset contains 10299 observations and 68 variables and is named  `'dt.tidy'` in the R script. Each observation contains one measurement of a subject performing one of a 6 activities. Totally 30 subjects participated in the survey. Variables correspond to characteristics calculated based on signals from accelerometer and gyroscope embedded in a subject's smartphone. A number of transformations have been done to raw data in order to obtain certain variables and make the dataset tidy.  
  
The sequence of steps were taken:  
  
 1. Files **`subject_test.txt`**, **`y_test.txt`**, **`X_test.txt`** from subdirectory `'test'` of the data archive were imported into objects `subject.test`, `y.test`, `x.test`, respectively. Raw data files have no missing values and also no headers. Then this objects were combined using `cbind()` function:  
```
test <- cbind(subject.test, y.test, x.test)
```
  
 2. The same operations were performed to create `'train'` dataset.  
  
 3. Then datasets `'test'` and `'train'` were merged into `'dt.tidy'` object using `rbind()` function. The object was converted into data table with `tbl_df(){dplyr}`:  
```
dt.tidy <- tbl_df(rbind(train, test))
```
  
 4. Column names were imported from file **`features.txt`** and added to the `'dt.tidy'` dataset. First two columns, which are not represented in **`features.txt`**, were named `'subject.id'` and `'activity'`.  
  
 5. Only measurements of mean and standard deviation were extracted for each observation. This task was done using `grep()` function. First, all column names with keywords `'mean'` and `'std'` were selected. Then column headers containing `'meanFreq'` were dropped since this variables are not the result of summarizing functions.  
  
 6. Next, column names of the remaining columns were made reading friendly: all abbreviations were replaced with full words (according to the code book from file **`features_info.txt`**). All words in column headers are separated with dots, series of dots and trailing dots are removed. This task was done using `sub()` and `gsub()` functions. For example:  
```
nms <- names(dt.tidy)
# change abbreviations to full words
nms <- sub('^t', 'time.', nms)
# ...more text pattern replacements...
# remove trailing dots
nms <- gsub('[.]+$', '', nms)
# lower case
nms <- tolower(nms)
# rename columns of data table
colnames(dt.tidy) <- nms
```
  
As a result, dataset [10299 obs. of 68 variables] contains groups of columns:  
  
  * `"subject.id"` and `"activity"` as codes of the observations;
  * `"time.body.accelerometer.mean.x"`, ..., `"time.body.gyroscope.jerk.magnitude.std"` (40 columns) - means and standard deviations of various time domain signals from accelerometer and gyroscope;  
  * `"fft.body.accelerometer.mean.x"`, ..., `"fft.body.body.gyroscope.jerk.magnitude.std"` (26 columns) - means and standard deviations of Fast Fourier Transform (FFT) applied to some of these signals.  
  
## **`tidyDataMeans.csv`**  
This dataset was summarized based on the first dataset and contains 180 observations of 68 variables. During R session it was created as object `'aver.tidy'`. Dataset contains average of each variable for each activity and each subject from `'dt.tidy'` table:  
```
aver.tidy <- dt.tidy %>% group_by(subject.id, 
                                  activity) %>% summarize_each(funs(mean))
```