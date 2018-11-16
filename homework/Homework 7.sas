/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 7
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
It is common for data to be stored or collected across multiple files. Yet we 
still want to work with or analyze the collection of all observations (across 
all of the data sets). We've talked extensively about how to import a raw data set 
into SAS, but now we'd like to combine data sets (stored in separate files) into 
one large data set.

Consider the following two small data sets with ID and name.  You can think of
these as students from two sections of STAT 330.  When I get my STAT 330 official 
rosters, they are separated by sections, so I have two different data files 
containing student names and IDs.  To be able to analyze their data simulataneously, 
like to caclulate grades, I need to 'stack' the data sets.
******************************************************************************/

DATA section1 ;
INPUT id name $ section ;
DATALINES ;
156 jim    1
453 janet  1
989 margot 1
;
RUN;

DATA section2 ;
INPUT id name $ section ;
DATALINES ;
297 bob    2
635 denise 2
842 warren 2
;
RUN ;

/****************************************************************************** 
We can stack these two data sets using the SET statement as follows:
******************************************************************************/

DATA allstudents ;
	SET section1 section2 ;
RUN ;

PROC PRINT DATA = allstudents ;
RUN ;

/****************************************************************************** 
Sometimes when I examine my student data, I want to know if there are trends 
with regards to performance in my class.  Is better performance related to GPA,
major, or previous coding experience?  This data doesn't come from official 
rosters, but from the questionnaire that you answered at the beginning of the 
quarter.  This data contains student id and other variables, like GPA and
whether or not you are a statistics major.  This data is typically ordered
by the time and date the student submitted their questionnaire responses.
******************************************************************************/

DATA QX ;
INPUT ID gpa statmajor $;
DATALINES ;
297 3.545 Y
635 2.897 Y
156 3.678 N
453 3.291 Y
989 2.789 N
842 3.184 N
;
RUN ;


PROC PRINT DATA = qx ; 
RUN ;


/****************************************************************************** 
To get one data set with both official roster information and my questionnaire
data, I need to `merge' the two data sets.  Note that both my qx data set and 
my allstudents data set have a common identifier - ID.  Prior to performing the
merge, both data sets should be sorted on the identifying variable.
******************************************************************************/

PROC SORT DATA = allstudents ; 
	BY id ; 
RUN ;

PROC PRINT DATA = allstudents ; 
RUN ;

PROC SORT DATA = qx ; 
	BY id ; 
RUN ;

PROC PRINT DATA = qx ; 
RUN ;

/****************************************************************************** 
Now we can combine the student data sets as follows:
--MERGE tells SAS to combine the data sets horizontally (a SET statement combines
  data sets vertically)
--BY tells SAS which variable(s) we to use to combine the data sets
******************************************************************************/

DATA students_with_qx ;
	MERGE allstudents qx ;
	BY id ;
RUN;

PROC PRINT DATA = students_with_qx; 
RUN ;


/****************************************************************************** 
Voila!  Now I have combined my official roster data with my questionnaire data.
I would need to do even more merging now to combine this data with your
PolyLearn grade records.
******************************************************************************/

/****************************************************************************** 
An example of data that might require merging is in clinical trials.  Often,
clinical trials are conducted double-blind, which means that neither the patient
nor the doctor administering treatment knows if the patients is in the 
placebo or the treatment group.  Suppose we randomly assign patients to two groups
- a group that receives a new treatment and a group that receives a placebo,
and we measure their systolic blood pressure (sbp) before and after treatment
is administered.

Consider the following three data sets:
- the placebo data set contains IDs of patients assigned to the placebo treatment
- the treatment data set contains IDs of patients assigned to the new treatment
- the results data set contains IDs of all patients and their blood pressure
  measurements before and after treatement
******************************************************************************/


DATA PLACEBO ;
INPUT id $ group $10. ;
DATALINES ;
Z45U placebo
A943 placebo
Q8W2 placebo
B902 placebo
;
RUN ;

DATA treatment ;
INPUT id $ group $10. ;
DATALINES ;
G832 treatment
U2I9 treatment
B0R3 treatment
N213 treatment
;
RUN ;

DATA results ;
INPUT id $ sbp_before sbp_after ;
DATALINES ;
Z45U 103 84 
A943 165 135
Q8W2 95  108
B902 84  78
G832 154 135
U2I9 89  65
B0R3 110 115 
N213 119 108
;
RUN ;


/****************************************************************************** 
Now it is your turn to practice:
(1) Stack the placebo and treatment data sets
(2) Sort the stacked data and the results data by ID
(3) Merge the stacked data with the results data by ID
(4) In the merged data, calculate the difference between the two SBP meaurements
 (diff = sbp_before - sbp_after)
(5) Use a PROC to calculate the average difference among the placebo and 
 treatment groups (separately).  Which medication (treatment or placebo) appears to 
 have the largest impact on change in SBP?
******************************************************************************/



*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

