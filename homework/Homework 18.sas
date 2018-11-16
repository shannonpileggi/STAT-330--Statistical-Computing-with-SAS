/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 18
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
Data can come in all shapes, sizes, and types of files. Thus far we've
imported raw data into SAS manually via the DATALINES statement,  or with PROC 
IMPORT. We've also worked with permanent SAS data sets.

In this lesson we'll use DATALINES once again, but the new data importing
concepts extend to importing external raw data files into 
SAS (.dat, .txt, .csv, etc.). We'll see their use throughout 
lessons in the near future.

Observe the following small data set about ice cream, which contains the variables:
name, portion size, calories, fat, description, 5 taste tester ratings, and price.
*****************************************************************************/


/****************************************************************************** 
CherryGarcia    106  240  13.0  CherryIceCream                  8 9 8 9 6  $4.99
ChubbyHubby     111  340  20.0  VanillaMaltIceCream             6 8 8 7 7  $5.99
PhishFood       107  280  13.0  ChocolateIceCream               5 4 6 9 8  $6.99
HalfBaked       106  270  13.0  Vanilla&ChocolateIceCreams      2 3 8 4 9  $5.99
BerriedTreasure  98  110   0.0  BlueberryandBlackberry   	    7 3 8 2 10 $4.99
*****************************************************************************/


/******************************************************************************
The following DATA step reads in name, description, and price as character 
variables, and the remaining variables as numeric.
*****************************************************************************/


DATA icecream ;
INPUT name $ size cals fat desc $ test1-test5 price $ ;
DATALINES;
CherryGarcia    106 240 13.0 CherryIceCream             8 9 8 9 6 $4.99
ChubbyHubby     111 340 20.0 VanillaMaltIceCream        6 8 8 7 7 $5.99
PhishFood       107 280 13.0 ChocolateIceCream          5 4 6 9 8 $6.99
HalfBaked       106 270 13.0 Vanilla&ChocolateIceCreams 2 3 8 4 9 $5.99
BerriedTreasure 98  110 0.0  BlueberryandBlackberry     7 3 8 2 10 $4.99
;
RUN;

TITLE "Ice Cream 1" ;
PROC PRINT DATA = icecream ;
RUN ;

PROC CONTENTS DATA = icecream VARNUM ; 
RUN ;

/******************************************************************************
Notice that the output does not look exactly like the data we typed in
above. In particular, the name and description variable values are cut off 
because SAS character variables default to a length of 8 characters. Additionally, 
it would be more useful if the prices were numeric so that we could perform
mathematical operations on them, like find the average price.

We can address these issues when reading the data into SAS using INFORMATS.
For example, we can tell SAS in the input statement how long the variable 
name and description should be.
*****************************************************************************/

DATA icecream2 ;
INPUT name $16. size cals fat desc $ test1-test5 price $ ;
DATALINES;
CherryGarcia    106 240 13.0 CherryIceCream             8 9 8 9 6 $4.99
ChubbyHubby     111 340 20.0 VanillaMaltIceCream        6 8 8 7 7 $5.99
PhishFood       107 280 13.0 ChocolateIceCream          5 4 6 9 8 $6.99
HalfBaked       106 270 13.0 Vanilla&ChocolateIceCreams 2 3 8 4 9 $5.99
BerriedTreasure 98  110 0.0  BlueberryandBlackberry     7 3 8 2 10 $4.99
;
RUN ;

TITLE "Ice Cream 2" ;
PROC PRINT DATA = icecream2 ;
RUN ;
TITLE ;

PROC CONTENTS DATA = icecream2 VARNUM ; 
RUN ;

/******************************************************************************
The convention for the character format is $w. where 'w' specifies the desired 
width of the character variable. There are many SAS informats. A list can be found
at the following page:

http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a001239776.htm

or a subset of them can be found on page 44 of The Little SAS Book Fifth Edition.

Look over the available informats to get a sense of what specially formatted
data (non-standard data) SAS can handle.
*****************************************************************************/


/******************************************************************************
In the space below write a third DATA step to read in the ice cream data. 
	- Change the informat on the description (desc) variable so that it is no 
      longer cut off. 
	- Change the informat for the price variable so that you can read it in as a 
	  numeric value.  
	- Print you data.
	- Use SAS to find the average ice cream price.
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;



DATA icecream3 ;
INPUT name $16. size cals fat desc test1-test5 price ;
DATALINES ;
CherryGarcia    106 240 13.0 CherryIceCream             8 9 8 9 6 $4.99
ChubbyHubby     111 340 20.0 VanillaMaltIceCream        6 8 8 7 7 $5.99
PhishFood       107 280 13.0 ChocolateIceCream          5 4 6 9 8 $6.99
HalfBaked       106 270 13.0 Vanilla&ChocolateIceCreams 2 3 8 4 9 $5.99
BerriedTreasure 98  110 0.0  BlueberryandBlackberry     7 3 8 2 10 $4.99
 ;
RUN ;

