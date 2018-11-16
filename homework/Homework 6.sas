/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 6
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/*****************************************************************************
So far we have been mainly accessed SAS data set in two ways:
	(1) use PROC IMPORT with an external file, like .csv
	(2) use a LIBNAME statement for SAS data sets

This utilizes a SAS DATA step with INPUT and DATALINES statements.
Let's look at a small example by referring to an abbreviated version
from a previous lecture.
*****************************************************************************/

DATA work.grades;
INPUT name $ exam1 exam2 exam3;
DATALINES;
Shannon 96 82 83
Lex     92 81 68
Ronald   . 77 60
;
RUN;

PROC PRINT DATA = work.grades ;
RUN ;

/*****************************************************************************

DATA work.grades;
	 + Creates a new, temporary data set called grades

INPUT name $ exam1 exam2 exam3; 
	 + specifies the names of the variables that we are inputting
	 + note that three variables (exam1, exam2, and exam3) are numeric
       and have no special formatting
	 + name is character and REQUIRE a dollar sign ($) after the 
	   variable name in order to notify SAS that it is a character variable	

DATALINES;
 	+ initiates data input
	+ after data input is complete, end with semi-colon	


Now let's add another variable called PolyCard, which represents the amount
of money left on the students' PolyCard at the end of the quarter.  

Note that the field we are inputting includes a dollar sign, which is a
*non-standard* value because it contains special characters (the dollar sign).
When we have non-standard values, we need to tell SAS how to read them.  

The Dollar6.2 is an *informat* that tells SAS how to read the non-standard 
value.  The 6 indicates that the entire field is 6 characters long, including the 
dollar sign and the decimal.  The 2 indicates the number of decimals to read.
*****************************************************************************/


DATA work.grades;
INPUT name $ exam1 exam2 exam3 PolyCard Dollar6.2;
DATALINES;
Shannon 96 82 83 $50.40
Lex     92 81 68 $85.91
Ronald   . 77 60 $90.03
;
RUN;

TITLE "First print" ;
PROC PRINT DATA = work.grades ;
RUN ;
TITLE ;

/*****************************************************************************
Now when you printed the data you probably noticed that the PolyCard variable
no longer has dollar signs beside it.  That is because it is just printing
the numeric value.  

If you want dollar signs to display in your output, then you want to give your 
output a special *format*.  You can acheive this with FORMAT statements
either in a DATA step or a PROC.  

Generally, *formats* and *informats* have the similar syntax.  So to print the 
PolyCard values with a dollar sign to two decimal places, you can apply the 
Dollar6.2 format.
*****************************************************************************/
TITLE "Second print, with FORMAT statement" ;
PROC PRINT DATA = work.grades ;
FORMAT polycard Dollar6.2 ;
RUN ;
TITLE ;


/*****************************************************************************
Now it's your turn.  

We've changed the data set to include a date of birth (dob) for the student.
Note that this is a *non-standard* value because it mixes characters and 
numbers.  

(1) Fill in the blank with the appropriate *informat* to correctly input
the dob variable. Hints:
	+ Check out section 2.8 of your textbook for a short list of informats -
      it is in there.
	+ Count the number of characters in the dob field - be sure to include 
      that in your informat.
*****************************************************************************/

DATA work.grades;
INPUT name $ exam1 exam2 exam3 dob __________;
DATALINES;
Shannon 96 82 83 13JAN2001
Lex     92 81 68 25MAR2000
Ronald   . 77 60 17MAY2002
;
RUN;


/*****************************************************************************
(2) Now print the grades data set.  What does Shannon's dob show?  What 
does that value mean?  Hint:  
	+ this corresponds to the reading in you text book in section 3.8
*****************************************************************************/



/*****************************************************************************
(3) Copy and paste your procedure from above, and include a FORMAT
statement to change how the dob value is displayed.  Try the MMDDYY10. format.
*****************************************************************************/

