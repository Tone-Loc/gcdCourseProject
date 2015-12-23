This README.txt documet explains how all of the documents in my repo work and how they are connected.

1) CodeBook.md
The file called CodeBook.md describes the variables, the data, and transformations that are performed to clean up the data
using the file called run_analysis.R

2) run_analysis.R
The file called run_analysis.R performs all processes necessary to generate a tidy data set and saves the tidy data set
as tidyData.txt

The processes include:
-installing R packages
-downloading raw data
-transforming raw data
-combining raw data
-writing a new text file containing the resulting tidy data set

3) tidyData.Txt
The file called tidyData.txt is the output of the run_analysis.R script.
It is an independent tidy data set in long format, containing the average of each variable for each activity and each subject.