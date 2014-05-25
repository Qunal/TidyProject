CodeBook
========================================================

### Human Activity Recognition Using Smartphones Dataset
Version 1.0

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit? degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

Background
------------------------------------
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

#### For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:


- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

#### Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

## Data For the exercise
{working Dir}
  - activity_labels.txt
  - features.txt
  - features_info.txt
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
       
* Train directory has files for 21 subjects .
* TrainX files has 7,352 observations of the 561 variables.
* Test directory has files for 9 subjects
* Test directory has 2,947 observations
* we have selected 86 features from 561 as relevant based on the mean or std string in its name ( mean or standard deviation)
* These have names dervied from source files and opuput in tidydf.txt

## tidydf.txt
- one row per combination of subject and activity across train and test
- there are 30 subjects and 6 activites for a potential 180 combination
- however only 40 combinations have non zero values
- the value in the columns is the across subjects mean. 
   - the source X has time averaged and smoothed and normalized measures
   - tidydf has intersubject averaged values
   
## subject
 - a number to identify the subject. derived from subject_train or test file for the row in X
 
## activity
  - one of the six as identifed in original y files .
  - the label is derived froma ctivity_labels.txt
  
## Features
 - column names for tidydf.txt are derived from features in source.
 - see features_info.txt and features.txt
 
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

- `tBodyAcc-min()-Z    	        time.body.acc.norm.min.Z`
- `tBodyAcc-sma()	            	time.body.acc.norm.sma`
- `tBodyAcc-arCoeff()-X,1   	  time.body.acc.norm.arcoeff.x.1`
- `tBodyAccJerk-mean()-X		    time.body.acc.jerk.mean.x`
- `fBodyGyro-bandsEnergy()-25,48	freq.body.gyro.bandsenergy.25.48`
- `angle(tBodyAccJerkMean),gravityMean)	angle.tbody.acc.jerk.mean.gravity.mean`

**norm** is used for default accelration reading ( no jerk). This is implicit in the names in source

_angle_ measures are troublesome from a naming perspective


## Column Names Lisiting 

_ MArkdown table generator output_
_Last moment correction Angel. Not reviewed for side effects_

| 1   | subject                                 	|   	|
|----	|-----------------------------------------	|---	|
| 2  	| activity                                	|   	|
| 3  	| time.body.acc.norm.mean.x               	|   	|
| 4  	| time.body.acc.norm.mean.y               	|   	|
| 5  	| time.body.acc.norm.mean.z               	|   	|
| 6  	| time.body.acc.norm.std.x                	|   	|
| 7  	| time.body.acc.norm.std.y                	|   	|
| 8  	| time.body.acc.norm.std.z                	|   	|
| 9  	| time.gravity.acc.norm.mean.x            	|   	|
| 10 	| time.gravity.acc.norm.mean.y            	|   	|
| 11 	| time.gravity.acc.norm.mean.z            	|   	|
| 12 	| time.gravity.acc.norm.std.x             	|   	|
| 13 	| time.gravity.acc.norm.std.y             	|   	|
| 14 	| time.gravity.acc.norm.std.z             	|   	|
| 15 	| time.body.acc.jerk.mean.x               	|   	|
| 16 	| time.body.acc.jerk.mean.y               	|   	|
| 17 	| time.body.acc.jerk.mean.z               	|   	|
| 18 	| time.body.acc.jerk.std.x                	|   	|
| 19 	| time.body.acc.jerk.std.y                	|   	|
| 20 	| time.body.acc.jerk.std.z                	|   	|
| 21 	| time.body.gyro.mean.x                   	|   	|
| 22 	| time.body.gyro.mean.y                   	|   	|
| 23 	| time.body.gyro.mean.z                   	|   	|
| 24 	| time.body.gyro.std.x                    	|   	|
| 25 	| time.body.gyro.std.y                    	|   	|
| 26 	| time.body.gyro.std.z                    	|   	|
| 27 	| time.body.gyro.jerk.mean.x              	|   	|
| 28 	| time.body.gyro.jerk.mean.y              	|   	|
| 29 	| time.body.gyro.jerk.mean.z              	|   	|
| 30 	| time.body.gyro.jerk.std.x               	|   	|
| 31 	| time.body.gyro.jerk.std.y               	|   	|
| 32 	| time.body.gyro.jerk.std.z               	|   	|
| 33 	| time.body.acc.mag.mean                  	|   	|
| 34 	| time.body.acc.mag.std                   	|   	|
| 35 	| time.gravity.acc.mag.mean               	|   	|
| 36 	| time.gravity.acc.mag.std                	|   	|
| 37 	| time.body.acc.jerk.mag.mean             	|   	|
| 38 	| time.body.acc.jerk.mag.std              	|   	|
| 39 	| time.body.gyro.mag.mean                 	|   	|
| 40 	| time.body.gyro.mag.std                  	|   	|
| 41 	| time.body.gyro.jerk.mag.mean            	|   	|
| 42 	| time.body.gyro.jerk.mag.std             	|   	|
| 43 	| freq.body.acc.norm.mean.x               	|   	|
| 44 	| freq.body.acc.norm.mean.y               	|   	|
| 45 	| freq.body.acc.norm.mean.z               	|   	|
| 46 	| freq.body.acc.norm.std.x                	|   	|
| 47 	| freq.body.acc.norm.std.y                	|   	|
| 48 	| freq.body.acc.norm.std.z                	|   	|
| 49 	| freq.body.acc.norm.meanfreq.x           	|   	|
| 50 	| freq.body.acc.norm.meanfreq.y           	|   	|
| 51 	| freq.body.acc.norm.meanfreq.z           	|   	|
| 52 	| freq.body.acc.jerk.mean.x               	|   	|
| 53 	| freq.body.acc.jerk.mean.y               	|   	|
| 54 	| freq.body.acc.jerk.mean.z               	|   	|
| 55 	| freq.body.acc.jerk.std.x                	|   	|
| 56 	| freq.body.acc.jerk.std.y                	|   	|
| 57 	| freq.body.acc.jerk.std.z                	|   	|
| 58 	| freq.body.acc.jerk.meanfreq.x           	|   	|
| 59 	| freq.body.acc.jerk.meanfreq.y           	|   	|
| 60 	| freq.body.acc.jerk.meanfreq.z           	|   	|
| 61 	| freq.body.gyro.mean.x                   	|   	|
| 62 	| freq.body.gyro.mean.y                   	|   	|
| 63 	| freq.body.gyro.mean.z                   	|   	|
| 64 	| freq.body.gyro.std.x                    	|   	|
| 65 	| freq.body.gyro.std.y                    	|   	|
| 66 	| freq.body.gyro.std.z                    	|   	|
| 67 	| freq.body.gyro.meanfreq.x               	|   	|
| 68 	| freq.body.gyro.meanfreq.y               	|   	|
| 69 	| freq.body.gyro.meanfreq.z               	|   	|
| 70 	| freq.body.acc.mag.mean                  	|   	|
| 71 	| freq.body.acc.mag.std                   	|   	|
| 72 	| freq.body.acc.mag.meanfreq              	|   	|
| 73 	| freq.body.acc.jerk.mag.mean             	|   	|
| 74 	| freq.body.acc.jerk.mag.std              	|   	|
| 75 	| freq.body.acc.jerk.mag.meanfreq         	|   	|
| 76 	| freq.body.gyro.mag.mean                 	|   	|
| 77 	| freq.body.gyro.mag.std                  	|   	|
| 78 	| freq.body.gyro.mag.meanfreq             	|   	|
| 79 	| freq.body.gyro.jerk.mag.mean            	|   	|
| 80 	| freq.body.gyro.jerk.mag.std             	|   	|
| 81 	| freq.body.gyro.jerk.mag.meanfreq        	|   	|
| 82 	| angle.tbody.acc.mean.gravity            	|   	|
| 83 	| angle.tbody.acc.jerk.mean.gravity.mean  	|   	|
| 84 	| angle.tbody.gyro.mean.gravity.mean      	|   	|
| 85 	| angle.tbody.gyro.jerk.mean.gravity.mean 	|   	|
| 86 	| angle.x.gravity.mean                    	|   	|
| 87 	| angle.y.gravity.mean                    	|   	|
| 88 	| angle.z.gravity.mean                    	|   	|

