/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 14
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
Recall that SAS data steps execute line by line and observation by observation.
In doing so, SAS makes use of the Program Data Vector (PDV), which erases all 
entries of the PDV as it cycles through the observations.  

Sometimes, it would be helpful to force SAS to keep the value of a variable 
from a previous observation (and not erase all PDV entries). We can do this with 
the RETAIN statement.
*****************************************************************************/


/****************************************************************************** 
Researchers collect blood pressure measurements on patients before and after six 
months of a new therapy. The variables included in the data are: ID number, 
systolic blood pressure, diastolic blood pressure and whether the measurement 
was taken before/after therapy.

Notice that the 2nd line corresponds to the first patient and should have an
ID of 1, but the ID is missing.  
*****************************************************************************/

DATA trial;

INPUT ID SBP DBP trt $;

DATALINES;
1 130 75 before
. 125 65 after
2 145 73 before
. 120 60 after
3 155 90 before
. 130 78 after
4 148 80 before
. 149 79 after
5 153 67 before
. 134 62 after
;
RUN;


PROC PRINT DATA = trial; 
RUN;

/****************************************************************************** 
It may seem trival here because we could
easily manually edit the data, but let's use the RETAIN statement to create 
the five missing ID values.

Here is the game plan:
(1) Create a variable called newid which contains the non-missing values of id
(2) Use the RETAIN statement to fill in the missing values of newid 
*****************************************************************************/


DATA trial2;
	SET trial ;

	IF id NE . THEN newid = id;
	RETAIN newid;

RUN;

PROC PRINT DATA = trial2; 
RUN;



/****************************************************************************** 
Now it's your turn.

Suppose we have information from vet bills organized by dog breed, but the
vet didn't re-enter the breed for each dog.  Modify the data step below:
(1) Write the input statement
(2) Create a new breed variable for which the first three observarions show
"Shepherd" and the last three show "Boxer".  (Don't modify the raw data!)
(3) Once you are done print the data to make sure it executed correctly.
*****************************************************************************/


*<--- TYPE CODE WITHIN THESE BOUNDS  ----TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;


DATA dogs;
INPUT ;
DATALINES;
Shepherd Kia    325
.        Cali   45
.        Chewy  72
Boxer    Sydney 56
.        Sam    34
.        Maggie 100 
;
RUN;




