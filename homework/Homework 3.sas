/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 5-3
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
In the last lesson we learned about how basic procedures applied to the built
in SAS data set called class. When we did this, we called the SAS data set as

				sashelp.class

This is standard SAS notation for dataset contain within libraries, as in
	
				library.dataset

In this case, the class data set was located in the sashelp library.
*****************************************************************************/

/****************************************************************************** 
Now let's learn a few more PROCS.  Last lesson we learned about PROC MEANS
to quickly produce descriptive statistics of numeric variables in a data set.
Another procedure used to obtain statistics of numeric variables is PROC 
UNIVARIATE, which is much more comprehensive than PROC MEANS.
*****************************************************************************/

PROC UNIVARIATE DATA = sashelp.class;
RUN;

/****************************************************************************** 
What about summarizing categorical data?  PROC FREQ can be used to compute 
frequencies and percentages.  The default is to do so for all variables
in the data set, even numeric ones. 
*****************************************************************************/

PROC FREQ DATA = sashelp.class;
RUN;


/****************************************************************************** 
Now on your own:  

(1) Apply the CONTENTS procedure to the data set called baseball located
in the sashelp library.  How many observations and variables does this 
data set contain.

(2)  Still utilizing the baseball data set, apply both the MEANS and UNIVARIATE 
procedure to the ONLY the variable that represents the number of homeruns in 1986.
Describe two pieces of information that are provided in the UNIVARIATE output but 
not in PROC MEANS.

(3) Still utilizing the baseball data set, apply the FREQ procedure ONLY to
the variable that represents the league at the end of 1986.  Note that while
both MEANS and UNIVARIATE use a VAR statement to specify variables, FREQ uses 
TABLES statement.  What percent of teams were in the American league?

*****************************************************************************/


*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;
