/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 9 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

*macro variable for figure locations;
%LET dir = C:\Users\spileggi\Google Drive\STAT 330\Lectures\Figures\ ;

*macro debugging options;


*macro to start figure export to pdf ;
%MACRO sfig(qn);
ods pdf file="&dir.L&qn..pdf" style=HTMLBlue ;
options nodate nonumber ;
%MEND ;

*macro to end figure export to pdf ;
%MACRO efig;
ods pdf close;
%MEND ;




*Import the survey data set ;
PROC IMPORT
	DATAFILE = "C:\Users\spileggi\Google Drive\STAT 330\Data\Stat217Survey.csv"
	OUT = work.survey
	DBMS = CSV
	REPLACE ;
	GUESSINGROWS = 35 ;
RUN;

*Examine contents of the data set ;
PROC CONTENTS DATA = work.survey VARNUM;
RUN ;

*View data set ;
PROC PRINT DATA = work.survey (firstobs=5 obs=10) ;
RUN ;


/*****************************************************************************
CATEGORICAL TO CATEGORCAL
-----------------------------------------------------------------------------
Create a new variable called \texttt{class} that classifies students as ``lower''
class (first years and second years) and ``upper'' class (third years, fourth years, etc.).
******************************************************************************/

/*---------------------------------------------------------------------------
STEP 1: Get to know your data
---------------------------------------------------------------------------*/
*view values of year at Cal Poly;
%sfig(9_ccstep1) ;
PROC FREQ DATA = work.survey ;
	TABLES Q02 ; 
RUN;
%efig ;

/*---------------------------------------------------------------------------
STEP 2: Create clean new variables with desired result.
---------------------------------------------------------------------------*/
DATA work.survey2 ;
	SET work.survey ;
	
	*create class variable;
	IF Q02 IN ("First year","Second year") THEN class  = "lower" ;
	ELSE class = "upper" ;

RUN ;


/*---------------------------------------------------------------------------
STEP 3: Verify that coding was done correctly.
---------------------------------------------------------------------------*/
%sfig(9_ccstep3a) ;
PROC FREQ DATA = survey2 ;
	TABLES class * Q02 ;
RUN ;
%efig ;

%sfig(9_ccstep3b) ;
PROC FREQ DATA = survey2 ;
	TABLES class * Q02 / LIST MISSING;
RUN ;
%efig ;




/*****************************************************************************
QUANTITATIVE TO QUANTITATIVE
-----------------------------------------------------------------------------
Create a new variable called class that classifies students as ``lower''
class (first years and second years) and ``upper'' class (third years, fourth 
years, etc.).
*****************************************************************************/

/*---------------------------------------------------------------------------
STEP 1: Get to know your data
---------------------------------------------------------------------------*/
*view quick summary of GPA;
PROC MEANS DATA = work.survey ;
	VAR  Q04; 
RUN;

*5 lowest and 5 highest obs of GPA;
PROC UNIVARIATE DATA = work.survey ;
	VAR Q04; 
RUN;

*all values of GPA;
PROC FREQ DATA = work.survey ;
	TABLES Q04; 
RUN;

*identify which observations had unusual values;
PROC PRINT DATA = work.survey ;
	WHERE Q04 > 4 ;
RUN ;


/*---------------------------------------------------------------------------
STEP 2: Create clean new variables with desired result.
---------------------------------------------------------------------------*/
DATA work.survey3 ;
	SET work.survey2 ;

	*clean GPA variable;
	GPA_clean = Q04 ;
	IF GPA_clean > 4 THEN GPA_clean = . ;
RUN ;


/*---------------------------------------------------------------------------
STEP 3: Verify that coding was done correctly.
---------------------------------------------------------------------------*/
%sfig(9_qqstep3a) ;
PROC MEANS DATA = survey3 ;
	VAR Q04 GPA_clean ;
RUN ;
%efig ;

%sfig(9_qqstep3b) ;
PROC FREQ DATA = survey3 ;
	TABLES Q04 * GPA_clean / LIST MISSING;
RUN ;
%efig ;



/*****************************************************************************
QUANTITATIVE TO CATEGORICAL
-------------------------------------------------------------------------
Use the GPA_clean variable to create a new variable called honors that 
classifies students according to their current GPA; students who do not yet 
achieve honors should be classified as ``none''.
*****************************************************************************/

/*---------------------------------------------------------------------------
STEP 1: Get to know your data
---------------------------------------------------------------------------*/
*view quick summary of GPA;
PROC MEANS DATA = work.survey3 ;
	VAR  GPA_clean ; 
RUN;

*5 lowest and 5 highest obs of GPA;
PROC UNIVARIATE DATA = work.survey3 ;
	VAR GPA_clean ; 
RUN;

*all values of GPA;
PROC FREQ DATA = work.survey3 ;
	TABLES GPA_clean ; 
RUN;

*identify which observations had missing values;
PROC PRINT DATA = work.survey3 ;
	WHERE GPA_clean = . ;
RUN ;


/*---------------------------------------------------------------------------
STEP 2: Create clean new variables with desired result.
---------------------------------------------------------------------------*/
DATA work.survey4 ;
	SET work.survey3 ;

	*create honors variable ;
	LENGTH honors $ 20 ;
	IF GPA_clean = . THEN honors = "" ;
	ELSE IF GPA_clean >= 3.85 THEN honors = "Summa cum laude" ;
	ELSE IF 3.70 <= GPA_clean < 3.85 THEN honors = "Magna cum laude" ;
	ELSE IF 3.50 <= GPA_clean < 3.70 THEN honors = "Cum laude" ;
	ELSE honors = "none" ;
RUN ;


/*---------------------------------------------------------------------------
STEP 3: Verify that coding was done correctly.
---------------------------------------------------------------------------*/
%sfig(9_qcstep3a) ;
PROC MEANS DATA = survey4 ;
	VAR GPA_clean ;
	CLASS honors ;
RUN ;
%efig ;

%sfig(9_qcstep3b) ;
PROC FREQ DATA = survey4 ;
	TABLES honors * GPA_clean / LIST MISSING;
RUN ;
%efig ;

