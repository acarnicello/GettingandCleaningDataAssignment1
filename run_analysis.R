#read and combine observation files
read_files <- function()
{
    #read train files
    xTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", colClasses = "numeric")
    
    sTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", colClasses = "numeric")
    
    yTrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", colClasses = "numeric")
    
    #Combine train files
    train <- cbind(sTrain,yTrain,xTrain)
    
    #read test files
    xTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", colClasses = "numeric")
    
    sTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", colClasses = "numeric")
    
    yTest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", colClasses = "numeric")
    
    #combine test files
    test <- cbind(sTest,yTest,xTest)
    
    #combine train and test observations
    Total <- rbind(train,test)
    
    #return final combined file
    Total
}

#add column names and add character descriptions to Activites
fix_data_labels <- function(file)
{
    #read files containing column names (features.txt) 
    feat <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt",colClasses=c("numeric","character"))
    
    
    
    #add column names 
    colnames(file)<- c("Subject_Number","Activity_Number",feat[,2])
    
    file
    
}
 
filter_mean_and_std <- function(file)
{

    #get columns with mean() or std() and assign to mstdTotal
    mstdTotal <- file[,c(1,2,grep("mean()",colnames(file)),grep("std()",colnames(file)))]
    
    #get columns that do not have Freq so that meanFreq() would not be included and assign to mstdTotal
    mstdTotal <- mstdTotal[,-grep("Freq",colnames(mstdTotal))]
    
    #return mstdTotal
    mstdTotal
}     
    
#add activity labels that correspond to the number in the activity_number column  
add_activity_labels <- function(file)    
{  
    #read files containing string labels for the activity category (activity_labes.txt)
    activityLabels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
   
    
    
    #add column that contains the label
    file <- mutate(Activity = factor( mstdTotal$Activity_Number, labels=activityLabels[,2]),mstdTotal)
    
    #return file
    file
}

#make summary of the averages of each activity and each subject
run_analysis <- function()
{
    #Make sure needed packages are loaded
    
    library("data.table", lib.loc="~/R/win-library/3.1")
    library("dplyr", lib.loc="~/R/win-library/3.1")
    
    #read files with the data observations
    Total <- read_files()
    
    #fix column names and set descriptive names for Activites
    Total <- fix_data_labels(Total)
    
    #return only mean and std columns for analysis
    mstdTotal <- filter_mean_and_std(Total)     
    
    #add Activity labels
    mstdTotal <- add_activity_labels(mstdTotal)
    
    #make summary of mean of each category seperated by Activity and Subject_Number
    summaryTotal <- mstdTotal %>% group_by(Activity, Subject_Number ) %>% summarise_each(funs(mean),3:ncol(mstdTotal)-1)
    
    #write file
    write.table(summaryTotal, "Average Data Summary.txt",row.name=FALSE)
}