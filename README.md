# DataCleaningProject


This repo contains files relevant to the Getting and Cleaning Data peer graded project.  The files in this directory include the following:

## 1:  run_analysis.r
  This is a script which does the following:
  * Loads the relevant training and testing data, the relevant users and the type of activity for each observation from both the training and testing data sets.
  * Merges these data frames into one combined data set.
  * Takes the numerical labels originally used to label the activity types, relabels them based on the activity type (from "activity_labels.txt") and then combines them row-wise with the combined data frame.
  * Labels each observation with the relevant user from the "subject_test.txt" and "subject_train.txt" files.
  * Extracts the columns which are relevant to measurements of the mean.
  * Renames the variable names in the new combined data frame to remove messy character types like "-" and "()".
  * Takes the combined data and then uses it to create a new data frame sorted based on the subject, the activity type, and the mean of the variable for each of these subject and activity type combinations.
  * Outputs the new tidy data to a csv file called "tidied_data.csv".

A final note:  When running run_analysis.r, the files features.txt is assumed to be in the same directory that R is running from.  If this condition fails then the rest of the script won't execute correctly.  This also follows with the test and train folders.
  
## 2: tidied_data.csv
  This is the tidy output data mentioned in the last bullet point for the run_analysis.r section.
  
## 3: Codebook.md
  A codebook giving the new variable names as well as how the activity types were labeled in the tidied data set mentioned above.
  


