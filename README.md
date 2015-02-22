There are five functions in run_analysis.R.  The run_analysis() function is the
main function that calls the other functions and creates the summary. The 
read_files() function reads the files into R and combines them into a big dataset.
The fix_data_labels, filter_mean_and_std, and add_activity_labels add descriptive 
column names that describe each variable, filter out the columns that correspond 
to the mean and std of each main variable, and add a label column that correspond
to each Activity_Number respectively. Details of overall function of each is below.
 

#read_files()

	Reads in the X_train, subject_train, and y_train and combines them. Then
reads in the X_test, subject_test, and y_test and combines them. The train and test
datasets are then combined into a Total dataset.  The X files contain a list of 
numbers that correspond to each Activity category in activity_labels.txt, the 
subject files contain the number of the subject that the observation is about, and 
the y files contain summaries of all the observations of the variables.  


#fix_data_labels(file)

	This adds column names to the Total dataset made above by reading the 
features.text file and adds that list to the colnames of the Total dataset.  
"Subject_Number" and "Activity_Number" are also added to the first two columns, 
respectively.
 
#filter_mean_and_std(file)

	This filers the columns of the Total labeled data made by the 
fix_data_labels above.  First it retrieves all the columns with mean() and std(). 
Then takes out the columns with Freq so that meanFreq() columns would not be 
included. The average of the means and standard deviations are being requested 
and meanFreq() are Weighted average of the frequency components to obtain a mean
frequency and not a regular mean of a variable so are not included.
    
#add_activity_labels(file)

	This reads in the activity_labels.txt file and then adds the activity 
description as a factor that correspond to the Activity_Number. 

#run_analysis()

	This first calls the other functions to get the dataset ready.  After these
function calls the dataset has its columns and Activities labeled and only the mean
and std columns remain.  Then it is grouped by Activity and Subject_Number and 
summarized by taking the mean of each of the other columns.  The summarized data
is then written to the Average Data Summary.txt file.
