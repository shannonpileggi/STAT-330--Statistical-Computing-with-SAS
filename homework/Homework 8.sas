/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 8
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/*****************************************************************************
Recall the fish data set that comes with SAS.
*****************************************************************************/

PROC PRINT DATA =  sashelp.fish (OBS = 10) ;
RUN ;

/*****************************************************************************
Notice that there are 3 measurements called length.  Suppose each measurement
was 5cm *under* measured, and so we want to add 5 to each measurement.  

One way we could achieve that would be to create new variables that represent
the correct measurements, add 5 to each of these variables in a DATA step.
*****************************************************************************/

DATA fish ;
	SET SASHELP.fish ;
	correct_length1 = length1 + 5;
	correct_length2 = length2 + 5;
	correct_length3 = length3 + 5;
RUN ;

PROC PRINT DATA =  fish (OBS = 10) ;
RUN ;

/*****************************************************************************
This really isn't efficient programming because we essentially wrote the same
line of code three times.  We can make this program more efficient, and less 
prone to manual error, if we utilize arrays.  The general syntax for 
an array is:

array <name> (n) <var-list> ;

   + <name> is the name of the array
   + n is the number of variables (ie, length of the array)
   + <var-list> is *optional* and contains the individual variable names stored 
     in the array

Let's use this to create two arrays: one for the original fish lengths
and one for the corrected lengths.
*****************************************************************************/

DATA fish ;
	SET SASHELP.fish ;
	
	*the length1, length2, and length3 variables already exist!;
	ARRAY original_length (3) length1 length2 length3 ;

	*the corrected lengths do not yet exist! ;
	ARRAY corrected_length (3) ;
	
RUN ;


PROC PRINT DATA = fish (obs = 10) ; 
RUN ;

/*****************************************************************************
So what happened in the above code?  We told SAS to put the three existing
length variables in a kind of behind-the-scene grouping called original_length.
Go back and review the PROC PRINT - no where in the output do you see
original_length.

We also told SAS to create a new array called corrected_length, and we did NOT
specify a variable list for corrected_length.  In the absence of a variable list,
SAS will automatically create variables named according to the ARRAY name.  Here,
the three variables created are corrected_length1, corrected_length2, and 
corrected_length3.  They all have missing values because we did not assign
any values to these variables yet.  Let's do that.

Variables within an array can be referenced by their position number.  For
example, correct_length(1) represents the variable corrected_length1.
*****************************************************************************/


DATA fish ;
	SET SASHELP.fish ;
	
	*the length1, length2, and length3 variables already exist!;
	ARRAY original_length (3) length1 length2 length3 ;

	*the corrected lengths do not yet exist! ;
	ARRAY corrected_length (3) ;

	*Parentheses refers to array position ;
	*Add 5 to each length value to get corrected length ;
	corrected_length(1) = original_length(1) + 5 ;
	corrected_length(2) = original_length(2) + 5 ;
	corrected_length(3) = original_length(3) + 5 ;
	
RUN ;


PROC PRINT DATA = fish (obs = 10) ; 
RUN ;


/*****************************************************************************
OK, so far our SAS program doesn't look too much tidier than the initial 
DATA step without arrays.  So what are the advantages to using arrays?

Well, one advantage is that you can easily reference an entire array in 
computations.

	+ array_name(*) signifies to perform the operations over ALL elements 
      in the array
*****************************************************************************/

DATA fish ;
	SET SASHELP.fish ;
	
	*the length1, length2, and length3 variables already exist!;
	ARRAY original_length (3) length1 length2 length3 ;

	*the corrected lengths do not yet exist! ;
	ARRAY corrected_length (3) ;

	*Parentheses refers to array position ;
	*Add 5 to each length value to get corrected length ;
	corrected_length(1) = original_length(1) + 5 ;
	corrected_length(2) = original_length(2) + 5 ;
	corrected_length(3) = original_length(3) + 5 ;

	*Reference array to compute mean length ;
	mean_corrected_length = MEAN(OF corrected_length(*)) ;
	
RUN ;


PROC PRINT DATA = fish (obs = 10) ; 
RUN ;


/*****************************************************************************
Another way we can make this code more efficient is to employ a DO loop over
the three variables in the array.  To do so, we are going to make minimal 
changes to our code:
	+  Enclose the computation in a DO/END block indexed by i.
    +  Delete two computation lines so that you only have one compuation line.
    +  Modify the array position from an exact number to the "i-th" position
*****************************************************************************/


DATA fish ;
	SET SASHELP.fish ;
	
	*the length1, length2, and length3 variables already exist!;
	ARRAY original_length (3) length1 length2 length3 ;

	*the corrected lengths do not yet exist! ;
	ARRAY corrected_length (3) ;

	DO i = 1 to 3 ;
		corrected_length(i) = original_length(i) + 5 ;
	END ;

	*Reference array to compute mean length ;
	mean_corrected_length = MEAN(OF corrected_length(*)) ;
	
RUN ;


PROC PRINT DATA = fish (obs = 10) ; 
RUN ;

/*****************************************************************************
Wow!  We just performed the same operation on three separate variables 
with one line of code.

This DO loop creates a new variable, i, and i starts at the value 1. Here is how 
the loop is working:

i = 1
	+ compute corrected_length1
	+ increment i by 1 (from 1 to 2)

i = 2
	+ compute corrected_length2
	+ increment i by 1 (from 2 to 3)

i = 3
	+ compute corrected_length3
	+ increment i by 1 (from 3 to 4)

Which explains why the last value of i that you see in the DATA step is 4.
*****************************************************************************/


/*****************************************************************************
Now it's your turn!

The Sashelp.applianc data set contains information on sales of 24 different 
appliances over time. (Units_1 represents appliance 1, Units_2 represents 
appliance 2, etc.)

   (1) Write a 2-3 procedures to get familar with the data.
   (2) Suppose the sale owner knows that any sale over 1,000 units is a
       data entry error.  Write a DATA step that creates a new variable called
	   corrected_unit1, such that until 1 values exceeding 1,000 are now
       missing in correct_unit1 (and the same otherwise).
   (3) Apply PROC MEANS to corrected_unit1 and verify that the average is
       224.03.
   (4) Copy and paste your DATA step from question (2).  Modify this data 
       step to include array(s) and a DO loop to perform the same operation 
		on all 24 appliances.  
   (5) Apply PROC MEANS to the data set to verify your result.  The original
       mean of units_24 should be 222.5 and the corrected mean for appliance
       24 should be 214.0,
*****************************************************************************/


*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

