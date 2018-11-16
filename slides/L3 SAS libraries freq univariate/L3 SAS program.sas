/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 3 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

*%LET path = C:/Users/spileggi/Google Drive/STAT 330/Lectures/Figures/;


/*-------------------------------------------------------------SAS LIBRARIES */
/* Examine contents of SAS's *permanent* built in baseball data 
		LIBRARY REFERENCE = sashelp
		DATA SET NAME     = baseball        
*/
PROC CONTENTS DATA = sashelp.baseball ;
RUN;


/* These two procedures will equivalently produce a temporary SAS data set 
   called babies
		LIBRARY REFERENCE = work
		DATA SET NAME     = babies        
*/
PROC IMPORT OUT = WORK.babies
	DATAFILE = "X:/spileggi/Data Sets/babies.csv"
	DBMS = CSV REPLACE;
RUN;

PROC IMPORT OUT = babies
	DATAFILE = "X:/spileggi/Data Sets/babies.csv"
	DBMS = CSV REPLACE;
RUN;


/*--------------------------------------------- CREATE YOUR OWN SAS LIBRARY */
/* Replace Location with the location of the adni data set on your flash
drive or desk top */
LIBNAME flash "C:\Users\spileggi\Google Drive\STAT 330\Data" ;


/* Examine contents of adni data set
		LIBRARY REFERENCE = flash
		DATA SET NAME     = adni        
*/
PROC CONTENTS DATA = flash.adni ;
RUN;


/*------------------------------------------------------ Your first DATA step */
*Create a temporary version of the adni data set in the work library;
DATA work.adni_temp ;
RUN;

*Examine the contents of work.adni_temp;
PROC CONTENTS DATA = work.adni_temp ;
RUN;


/*----------------------------------------- Create a temporary data set of adni */
/* Here, we are creating a brand new, temporary data set called adni_temp in the 
work library.  This data set contains a copy of the permanent adni data set located 
in the flash library. */
DATA work.adni_temp ;
    SET flash.adni;
RUN;

PROC CONTENTS DATA = work.adni_temp ;
RUN;



/*----------------------------------------- Create a permanent data set of adni */
/* Here, we are creating a brand new, permanent SAS data set called adni2 in the 
flash library.  This data set contains a copy of the permanent adni data set located 
in the flash library. */
DATA flash.adni2 ;
    SET flash.adni;
RUN;

PROC CONTENTS DATA = flash.adni2 ;
RUN;



/*------------------------------------------------------------------- PROC FREQ */
*all variables in data set;
PROC FREQ DATA = flash.adni; 
RUN;

*one-way and two-way contingency table;
PROC FREQ DATA = flash.adni;
    TABLES dx dx*gender ;
RUN;

*two-way contingency table converted to list style;
PROC FREQ DATA = flash.adni;
    TABLES dx*gender / LIST MISSING NOPERCENT;
RUN;

/* YOUR TURN:
Replace the blank with options would you use to obtain the percent of males 
that have a normal diagnosis */

PROC FREQ DATA = flash.adni;
    TABLES dx*gender / _________;
RUN;

/* Chi-squared test with PROC FREQ */
*ods pdf file="&path.L3_chisq.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC FREQ DATA = flash.adni;
    TABLES dx*gender / CHISQ ;
RUN;
*ods pdf close;



/*-------------------------------------------------------------- PROC UNIVARIATE */
*all numeric variables in data set;
PROC UNIVARIATE DATA = flash.adni; 
RUN;


*one sample t-test on age;
*ods pdf file="&path.L3_onesamplet.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC UNIVARIATE DATA = flash.adni CIBASIC LOCATION = 70 ;
	VAR age ; 
RUN;
*ods pdf close;


*produce summary statistics and histograms of MMSE separated by diagnosis with normal 
curve overlayed; 
*ods html gpath = "&path";
*ods graphics on / imagename="L3_hist" reset=index;
PROC UNIVARIATE DATA = flash.adni ;
	CLASS dx;
	VAR MMSE;
	HISTOGRAM MMSE / NORMAL;
RUN;
*ods graphics off;


