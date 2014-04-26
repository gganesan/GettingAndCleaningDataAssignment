## The dataset for assignment is extracted to a folder. There will be folder 
## named "UCI HAR Dataset"
## pre-condition : 
## The run_analysis.R is placed in the dataset folder "UCI HAR Dataset"

library(data.table)


tidy_featureNames <-function(a){
  
  ## Remove "-"
  sub_dash <- function(x){gsub("-", "",x)}
  a = sapply(a,sub_dash)
  
  ## change case to lower
  sub_lowcase <- function(x){tolower(x)}
  a[,1] <- sapply(a[,1],sub_lowcase)
  
  ## remove close paranthesis
  sub_cparan <- function(x) {gsub(")", "", x)}
  a[,1] = sapply(a[,1],sub_cparan)
  
  ## remove open paranthesis
  sub_oparan <- function(x) {gsub("(", "", x, fixed = T)}
  a[,1] = sapply(a[,1],sub_oparan)
  
  ## remove comma
  sub_comma <- function(x) {gsub(",", "", x)}
  a[,1] = sapply(a[,1],sub_comma)
  
  return(a[,1])
}


tidy_activityNames <-function(a){
  
  ## Remove "_"
  sub_dash <- function(x){gsub("_", "",x)}
  a = sapply(a,sub_dash)
  
  ## change case to lower
  sub_lowcase <- function(x){tolower(x)}
  a[,1] <- sapply(a[,1],sub_lowcase)
  
  return(a[,1])
}

activityid2name <- function(a){
  
  #substitute activity id to name
  sub_act_id2name <- function(x){gsub(activity$id[x],activity$name[x],x)}
  a = sapply(a[,1],sub_act_id2name)
  
  return(a)
}

extract_featureName <- function(a, keywd){
  
  #get the matching entry list
  name_match_list <- function(x){grep(keywd,x)}
  a = sapply(a,name_match_list)
  
  a = names(unlist(a))
  
  return(a)
}

find_col_avg <- function(a, colnames){
  
  retval = NULL
  for(i in 1:length(colnames)){
    n = colnames[i]
    retval[i] = cbind(sum(a[n]) / ncol(a[n]))
  }
  return(retval)
}

nrow = -1

## Read the features.txt and tidy the values
features <- fread("./features.txt")
setnames(features, c("id", "name"))
features$name = tidy_featureNames(features[,2,with = F])

## Read the subject_test and X_test files
test <- read.table("./test/X_test.txt", nrows = nrow, col.names = features$name, row.names = NULL)
subject_test = read.table("./test/subject_test.txt", nrows = nrow, row.names = NULL)
setnames(subject_test,"subjectid")

train <- read.table("./train/X_train.txt", nrows = nrow, col.names = features$name, row.names = NULL)
subject_train = read.table("./train/subject_train.txt", nrows = nrow, row.names = NULL)
setnames(subject_train,"subjectid")

## cbind the subject id
test = cbind(test,subject_test)
train = cbind(train,subject_train)



## Read the y_test for activity
## Appropriately labels the data set with descriptive activity names
y_test <- read.table("./test/y_test.txt", nrows = nrow, col.names = "activity", row.names = NULL)
y_train <- read.table("./train/y_train.txt", nrows = nrow, col.names = "activity", row.names = NULL)

## Read adn tidy activity labels
activity <- fread("./activity_labels.txt")
setnames(activity, c("id", "name"))
activity$name = tidy_activityNames(activity[,2,with = F])

## Uses descriptive activity names to name the activities in the data set
## convert activity id to activity name
y_test$activity = activityid2name(y_test)
y_train$activity = activityid2name(y_train)

## cbind the subject id
test = cbind(test,y_test)
train = cbind(train,y_train)

## merge the test and train data
dt = merge(test,train, all = T)

## Extract the feature names for mean and std
## regex results in 53 mean and 33 std matches
fnames_mean = extract_featureName(features$name, "mean")
fnames_std = extract_featureName(features$name, "std")

## Extracts only the measurements on the mean and standard deviation 
## for each measurement.
dt_mean_std = dt[,c(fnames_mean,fnames_std)]

write.table(dt_mean_std,"mean_std.txt")

## addding factor variables to subjectid and activity
# dt$subjectidfac <- factor(dt$subjectid)
# dt$activityfac <- factor(dt$activity)


## Creates a second, independent tidy data set with the average of 
## each variable for each activity and each subject
col_len = length(features$name)
df_out_indx = 1


subidlist = as.numeric(levels(factor(dt$subjectid)))
actlist = as.character(levels(factor(dt$activity)))


for(subid in subidlist){
  for(act in actlist){
    ## subset rows per subjectid and activity
    df_sub_act = dt[(dt$subjectid == subid & dt$activity == act),]
    num_row  = nrow(df_sub_act)
    
    ## get the average of every col
    if(df_out_indx == 1){
      tidy_dat = data.frame(cbind(rbind(colSums(df_sub_act[,c(1:col_len)])/num_row),subjectid = subid, activity = act))
    }else{
      tidy_dat = rbind(tidy_dat, data.frame(cbind(rbind(colSums(df_sub_act[,c(1:col_len)])/num_row),subjectid = subid, activity = act)))
    }
    
    df_out_indx = df_out_indx + 1
    
  }

#  Write the tidy data
write.table(tidy_dat,"tidy_data.txt")

}
  

