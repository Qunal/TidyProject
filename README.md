Readme
========================================================

## Steps for running the exercise
Note the sequence is not same as per instructions

### Directory 
run_analysis.R resides in working directory
Assume that the working directory has subdirectory train and test which have the data
{working Dir}
  - {test}
       - subject_test.txt
       - X_test.txt
       - y_test.txt
       - {Inertial Signals}
  - {train}
      - subject_train.txt
      -  X_train.txt
      -  y_train.txt
      -  {Inertial Signals}
       
  The program outputs the final data as tidydf.txt with no rownames in the working directory
  
  `
write.table(tidydf,file="tidydf.txt",row.names=FALSE)`

To read back into R lease use header=TRUE

`
tidydf2=read.table("tidydf.txt",stringsAsFactor=FALSE,header=TRUE)`

## Assumption
There are a number of ambiguous areas and also some degree of confusion on the MOOC discussion forums on the data and formats. Here we document our assumptions.
* The Inertial Signals are the raw data and not relevant for this exercise
* The X files contain time averaged and processed data for activity in y. 
    See features_info.txt
* The rows in X are observations
* The rows of X are for one subject refrenced in subject file
* 30  sujects are split among  train(21 subjects) and test(9 subjects)
* The test data has 2,947 observations and train has 7,352 for a total of 10,299
* y has a classification of the activity being done for the same row in X
* y activity code relates to activity_labels.txt
* We have used the feature names in features.txt . We assume the columns in X are in same order as features in features.txt. Thus the column names are in ordere of features
* 

### Tidy Naming approach
One of the big issues is naming the features contained in X files. The features_info.txt provides information.
* We analyzed the feature names and have noted following pattern
    - segment1_segment2()_segment3(Optional)
    
segment 1 is a combination of several parts
1 part is f for freq or t for time
2 part if body or gravity part of motion
3 part is acc for acceleration or gyro for Gyrometer
4 part is skipped for normal and jerk for Jerky motion. 
5 part is mag for maginitude (optional)

Not all segments and parts occur.  
Not all combinations of options within each part are there in data
so gravity does not have gyro or jerk combinations

segments are seperated by - or ()-
parts are delimted by Capital as first character or by ,
Most troublesome featurenames are angles. 
Adopted naming convention is
catagory.measure.qualifier
eache segment may have optional parts again seperated by . see below


* Feature names are broken into three sections each consisting of multiple parts
*The first section is the catagory which informs us of the 
    - Type (time or frequency{freq})
    - Origin ( body or gravity)
    - Nature( Acceleration{acc} or Gyroscope{gyro})
    - Motion type ( Normal {norm} or Jerk). _norm is implied_.
    - Measure type ( Magnitude{mag} or default time averaged)
* Second section defines the measured variable
    - simple like Energy, Entropy 
    - derived like minimum{min}, mean , inter quartile range etc
* Third part is a qualifier
    - none for some measures like sma
    - X,Y,Z for acceleration etc
    - pairlike X,Y for correlation, X,1 for ar coeff, freq range for bandsEnergy
    
The naming convention in the source file has several problems
  - double words like BodyBody
  - troublesome characters like () 
  
We have processed these to a Tidy Name format which conforms to the principles outlined in this course
Some examples of the names are below

- `tBodyAcc-min()-Z  		        time.body.acc.norm.min.Z`
- `tBodyAcc-sma()	            	time.body.acc.norm.sma`
- `tBodyAcc-arCoeff()-X,1   	  time.body.acc.norm.arcoeff.x.1`
- `tBodyAccJerk-mean()-X		    time.body.acc.jerk.mean.x`
- `fBodyGyro-bandsEnergy()-25,48	freq.body.gyro.bandsenergy.25.48`
- `angle(tBodyAccJerkMean),gravityMean)	angle.tbody.acc.jerk.mean.gravity.mean`

**norm** is used for default accelration reading ( no jerk). This is implicit in the names in source

_angle_ measures are troublesome from a naming perspective

#### Activity 
  The y files have a identifier on the activity. The activity labels are descriptive enough. These are used as Tidy names with lowercase conversion
  
  
### Checks
The code has number of checks and diagnostic output. Some have been commented out. Here are some observations
* 561 features or columns of X
* 86 qualify as means or standard deviation (std). Some are questionable. A mere string match has been used
* The source of data (train, test) has been added to the X files for tracing
* Subject has been linked in to X . For a total of 88 columns
* combined X files has 10,299 rows 2,947  from test and 7,352 from training
* These lead to 88,5714 rows in melted file means.melt in step 5( 10,299*86)
*Not all subjects do alla ctivities. The tabel statement in line 139
  `table(meansdf$subject,meansdf$activity)`
  
 ** 40 non zero combination of subject, activity so will have 40 rows finally**
  _ Check no missing combination 30 subjects* 6 activity =180 _
`length(table(meansdf$subject,meansdf$activity))`


  
    
  

