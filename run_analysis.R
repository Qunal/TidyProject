
#Order of code is not in order of sequence of exercise
#step 3 create tidy names first
#      create index of feature names with mean and std for step 2
#For test and train data set
# step 4 label activities (features) in x and y and then
# step 2 select only means and std features
# x dataset has two additional columns source (train or test) and subject 
#step 1 merge training and testlast 
# Step 5 use melt and dcast and save result


# Step 3 part 1 for x  Formulate tidy names for features
#Apply gsub in sequence to mutate fature names to tidy names



feature<-read.table("features.txt")
tok <- feature$V2
tok <- gsub(pattern="\\(\\)$", x=tok, replacement="")# handels ending braces only
tok <- gsub(pattern="\\(\\)", x=tok, replacement=".")# Remaining ending () 
tok <- gsub(pattern="\\)$", x=tok, replacement="")# Angel ending) 
tok <- gsub(pattern="\\(|\\)", x=tok, replacement=".")# Remaining ending ( or ) Angel 
tok <- gsub(pattern="Mean$", x=tok, replacement=".mean")# Angel Mean
tok <- gsub(pattern="Acc-", x=tok, replacement="acc.norm.")# Acc
tok <- gsub(pattern="-", x=tok, replacement=".")# handels  
tok <- gsub(pattern="\\,", x=tok, replacement=".")# handels , 
tok <- gsub(pattern="^f", x=tok, replacement="freq.")# Firstf
tok <- gsub(pattern="^t", x=tok, replacement="time.")# Firstt
tok <- gsub(pattern="Body|BodyBody", x=tok, replacement="body.")# Firstf
tok <- gsub(pattern="Gyro", x=tok, replacement="gyro.")# Gyro
tok <- gsub(pattern="Jerk", x=tok, replacement="jerk.")# Jerk
tok <- gsub(pattern="Mag", x=tok, replacement="mag.")# Mag
tok <- gsub(pattern="Gravity", x=tok, replacement="gravity.")# Gravity
tok <- gsub(pattern="Acc", x=tok, replacement="acc.")# remainin acc Resarch excliding 
tok <- gsub(pattern="-", x=tok, replacement=".")# - with .
tok <- gsub(pattern="..", x=tok, replacement=".",fixed=TRUE)# .. with .
tok <- tolower(tok)
feature$tidy.feature.names<-tok


# Step 3 part 2 for y get activity label for fixing y
activity.label <- read.table('activity_labels.txt',stringsAsFactor=FALSE)# 6 rows
names(activity.label) <- c("activity","label")
activity.label$label <- tolower(activity.label$label)


# Step 2 part 1 find features with mean and standard deviation (std) in the name

indx <- grep("mean|std",tok,value=FALSE)


# Process Test 
# X firstdata X and add source and subject as well mutate to tidy names

x.test <- read.table('test/X_test.txt',stringsAsFactor=FALSE)# 2947 rows
subject.test<-read.table('test/subject_test.txt',stringsAsFactor=FALSE)
names(x.test) <- feature$tidy.feature.names

# Subset intresting features mean and std only
x.test <- x.test[,indx]# 86 columns
#colnames(x.test)
x.test$source<-"test"
x.test$subject<-subject.test$V1
#which( colnames(x.test)=="source" )# 87
#which( colnames(x.test)=="subject" )# 88
#table(x.test$source)
#table(x.test$subject) # Subject 2,4,9,10,12,13,18,20,24

# Read Y and mutate activity id to label
y.test<-read.table('test/y_test.txt',stringsAsFactor=FALSE)#2947
names(y.test) <- c("activity")
# Left join y and labels
y.label <- merge(x = y.test, y = activity.label,  all.x=TRUE)
y.test$activity<-y.label$label
# check subject and activity
#table(y.test$activity)# all 6 activities are there


# Read Training data
x.train <- read.table('train/X_train.txt',stringsAsFactor=FALSE)# 7352 rows
subject.train<-read.table('train/subject_train.txt',stringsAsFactor=FALSE)
names(x.train) <- feature$tidy.feature.names
# Subset intresting features mean and std only
x.train <- x.train[,indx]# 86 columns
x.train$source<-"train"
x.train$subject<-subject.train$V1
#table(x.train$source) #7352
table(x.train$subject) # Subject 1,3,5,6-8,11,14-17,19,21-23,25-30

# Read Y and mutate activity id to label
y.train<-read.table('train/y_train.txt',stringsAsFactor=FALSE)#7352 rows
names(y.train) <- c("activity")
# Left join y and labels
y.label <- merge(x = y.train, y = activity.label,  all.x=TRUE)
y.train$activity<-y.label$label
# check subject and activity
#table(y.test$activity)# all 6 activities are there

# step 1 merge train and test
x <- rbind(x.test,x.train)# 10299 rows
# table(x$subject) # Check got all subjects
y <- rbind(y.test,y.train)# 1029 rows
#table(y$activity)# check got all activity

#Step 5 summarize by subject and activity 
# Drop source in preparation for melt
library("reshape2")
which( colnames(x)=="source" )# 87
x <- x[,c(1:86,88)]
which( colnames(x)=="subject" )# 87 is correct
meansdf <- cbind(y,x)# 10299 rows
# Every subject does not every activity 
table(meansdf$subject,meansdf$activity)
# 40 non zero combination of subject, activity so will have 40 rows finally
# Check no missing combination 30 subjects* 6 activity =180 
length(table(meansdf$subject,meansdf$activity))
means.melt <- melt(meansdf,id=c("subject","activity"))#885714 rows 86*10299
# Now compute mean of the feature value this is across subject mean
tidydf <- dcast(means.melt,subject+activity ~ variable,mean)
#check only 40 rows. 
tidydf[1,1:3] # avg for time.body.acc.norm.mean.X is 0.2656969
# save for loading to github, no row names
write.table(tidydf,file="tidydf.txt",row.names=FALSE)
# Check
tidydf2=read.table("tidydf.txt",stringsAsFactor=FALSE,header=TRUE)




