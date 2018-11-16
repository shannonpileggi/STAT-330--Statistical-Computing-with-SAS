/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 14 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

OPTIONS MPRINT MLOGIC SYMBOLGEN ;

*directory for figures ;
%LET dir = C:\Users\spileggi\Google Drive\STAT 330\Lectures\Figures\ ;

*path for data ;
%LET path = C:\Users\spileggi\Google Drive\STAT 330\Data\ ;

*macro to start figure export to pdf ;
%MACRO sfig(qn);
ods pdf file="&dir.L&qn..pdf" style=HTMLBlue ;
options nodate nonumber ;
%MEND ;

*macro to end figure export to pdf ;
%MACRO efig;
ods pdf close;
%MEND ;


/*-------------------------------------------------------------------------------
Input data
-------------------------------------------------------------------------------*/

DATA kids;
INPUT famid name $ birth age wt sex $ ;
DATALINES;
1 beth 1  9  75  f
. bob  2  6  45  m
. barb 3  3  20  f
2 andy 1  8  80  m
. al   2  6  50  m
. ann  3  2  25  f
3 pete 1  6  55  m
. pam  2  4  37  f
. phil 3  2  33  m
;
RUN;
 
PROC PRINT DATA = kids;
RUN;

/*-------------------------------------------------------------------------------
Example 1 - fix family ID
-------------------------------------------------------------------------------*/

DATA kids2 ;
	SET kids ;

	*newid equals non-missing values of famid;
	IF famid NE . THEN newid = famid ;

	RETAIN newid ;
 
	*overwrite values of original famid with values from newid;
	famid = newid ;

	*remove newid variable;
	DROP newid ;
RUN ;

PROC PRINT DATA = kids2 ; 
RUN ;



/*-------------------------------------------------------------------------------
Example 2 - cumulative sums
-------------------------------------------------------------------------------*/

DATA kids3 ;
	SET kids ;

	*create a variable that represents observation number;
	obs + 1 ;

	*create cumulative total of weights;
	totwt + wt ;

	*meanwt=sumwt/obs;
RUN ;

%sfig(14_sum);
PROC PRINT DATA = kids3; 
	var name wt obs totwt ;
RUN;
%efig;



/*-------------------------------------------------------------------------------
Example 3 - equivalent sum statements
-------------------------------------------------------------------------------*/
DATA kids4 ;
	SET kids ;

	*totwt implicitly initialized to zero;
	*use SUM statement without variable assignment;
	totwt + wt ;

RUN ;

PROC PRINT DATA = kids4 ; 
RUN ;

*--------- equivalently-------------------;

DATA kids5 ;
	SET kids ;

	*explicitly initialize totwt to zero;
	RETAIN totwt 0 ;

	*use explicit variable assignment;
	totwt = totwt + wt ;
RUN ;

PROC PRINT DATA = kids5 ; 
RUN;



/*-------------------------------------------------------------------------------
Discussion - create running average 
-------------------------------------------------------------------------------*/

DATA kids3 ;
	SET kids ;

	*create a variable that represents observation number;
	obs + 1 ;

	*create cumulative total of weights;
	totwt + wt ;

	meanwt = sumwt/obs;
RUN ;

%sfig(14_sum);
PROC PRINT DATA = kids3; 
	var name wt obs totwt ;
RUN;
%efig;



/*-------------------------------------------------------------------------------
Example -  PROC SORT
-------------------------------------------------------------------------------*/
PROC SORT DATA = kids2 OUT = sortedkids ;
	BY DESCENDING famid sex ;
RUN ;

PROC PRINT DATA = sortedkids; 
RUN;


/*-------------------------------------------------------------------------------
Example 4 - create totals BY family;
-------------------------------------------------------------------------------*/

PROC SORT DATA = kids2 ; 
	BY famid ; 
RUN ;

DATA kids6 ;
	SET kids2 ;
	BY famid ;

	IF FIRST.famid THEN DO ;
		totwt = 0 ;
		num_kids = 0 ;
	END ;

	totwt + wt ;
	num_kids + 1 ;

RUN ;

%sfig(14_totalbyfam) ;
PROC PRINT DATA = kids6 ; 
	VAR famid name wt totwt num_kids ;
RUN ;
%efig ;


/*-------------------------------------------------------------------------------
Example 4 modification
	- number of m/f in each family
	- values of FIRST.famid 
-------------------------------------------------------------------------------*/
PROC SORT DATA = kids2 ; 
	BY famid ; 
RUN ;


DATA kids6 ;
	SET kids2 ;
	BY famid ;

	IF FIRST.famid THEN DO ;
		totwt = 0 ;
		num_kids = 0 ;
		num_f = 0;
		num_m = 0;
	END ;

	totwt + wt ;
	num_kids + 1 ;

	IF sex = "f" then num_f + 1 ; 
	IF sex = "m" then num_m + 1 ;

	*create a variable named check which contains values of FIRST.famid ;
	check = FIRST.famid;

RUN ;

PROC PRINT DATA = kids6; 
RUN;



/*-------------------------------------------------------------------------------
Example 5 - save family level info 
-------------------------------------------------------------------------------*/

PROC SORT DATA = kids2 ; 
	BY famid ; 
RUN ;

DATA kids7 ;
	SET kids2 ;
	BY famid ;

	IF FIRST.famid THEN DO ;
		totwt = 0 ;
		num_kids = 0 ;
	END ;

	totwt + wt ;
	num_kids + 1 ;

	IF LAST.famid THEN OUTPUT ; 

	KEEP famid totwt num_kids ;

RUN;

%sfig(14_famtotal) ;
PROC PRINT DATA = kids7; 
RUN ;
%efig ;



