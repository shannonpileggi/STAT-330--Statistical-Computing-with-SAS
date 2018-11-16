/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 4
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
The sashelp.prdsal2 data set provides furniture sales data.  Let's get started 
by viewing the contents of the data set and viewing the first 10 observations.
*****************************************************************************/

PROC CONTENTS DATA = sashelp.prdsal2 VARNUM ;
RUN ;

PROC PRINT DATA = sashelp.prdsal2 (OBS = 10) ;
RUN ;

/****************************************************************************** 
Now we are going to use a DATA step to manipulate the prdsal2 data. Our 
objectives are to 
(1) create a new variable that calculates the difference between the actual and 
	predicted sales
(2) create a new variable that extracts the year from the date variable
(3) create a variable that represents whether or not the difference between the
    actual and predicted sales exceeds $1,000.
*****************************************************************************/

DATA work.furniture ;
/* Create a temporary SAS data set call furniture */

	SET sashelp.prdsal2 ;
	/* Copy the contents of sashelp.prdsal2 into work.furniture. */	

	/* Create a new variable that calculates the difference between the actual  
	and predicted sales.  The new variable name is diff1, followed by an equal sign,
	and then the algebraic expression follow. */
	diff1 = actual - predict ;
	
	/* Another way we could achieve a similar objective is by using a SAS function.
	Functions take arguments separated by commas.  	The RANGE function retuns the 
	absolute value of the differnce between the minimum and maximum values stated
	as arguments. */
	diff2 = RANGE(actual, predict);

	/* In addition to functions that can perform numeric operations, SAS also
	has functions that can perform character and date/time operations.  Here,
	we use the X function create a new variable that extracts the year from 
	the date variable. */
	my_year = YEAR(MONYR) ;


	/* Lastly, let's create a variable that represents whether or not the difference 
	between the actual and predicted sales exceeds $1,000.  We'll do this with an
	IF-THEN-ELSE statement based on the diff2 variable. 

		diff2 >= 1000 is a *condition* that we are evaluating

		diff_1000 = "Over", diff_1000 = "Under" are *actions* that we are taking 
			when the condition is satisifed

	Also, diff_1000 = "Over", diff_1000 = "Under" is creating a new
			character variable.  SAS knows it is a character variable because its
			values are in quotes. */

	IF diff2 >= 1000 THEN diff_1000 = "Over " ;
	ELSE diff_1000 = "Under" ;

RUN ;

/* View the first 10 observations to verify that it worked correctly. 
Compare diff1 and diff2, compare year to my_year, and compare
diff2 to diff__100. */	
PROC PRINT DATA = work.furniture (OBS = 10) ;
RUN ;





/****************************************************************************** 
TIP:  Write code to acheive each item one at a time, and then submit the 
PROC PRINT () to see if it worked.  Then go back and modify your data step.

Now on your own:  

In the space below,
(1) Get familiar with the sashelp.fish data set by viewing the contents
and the first 10 observations.

Write one DATA step that achieves the following:
(2) Create a temporary data set called work.fish from the permanent SAS
	data set sashelp.fish.
(3) Create a variable called average1 that computes the average of the 
    three length measurements using an algebraic expression (similar to 
    diff1 above).
(4) Create a variable called average2 that computes the average of the 
    three length measurements using SAS function (similar to diff2 above).
(5) Using either average variable, create a character variable called
	length_category that takes on values of tall for fish whose average
	length is greater than or equal to 30 and short otherwise.

After your DATA step, 
(6) Use a procedure to view the first 10 observations of your data set.  
    Verify that everything coded correctly without error.

(7) Does anything look weird about your length_category variable?  If so
	note what is weird in a comment (you don't need to fix it).  If not,
	congrats on doing a good job coding the first time around.
*****************************************************************************/






*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;
