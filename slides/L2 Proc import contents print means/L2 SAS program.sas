/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 2 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

*%LET path = C:/Users/spileggi/Google Drive/STAT 330/Lectures/Figures/;


/*-------------------------------------------------------------PROC CONTENTS */
/* Examine contents of SAS's built in car data */
PROC CONTENTS DATA=sashelp.cars;
RUN;


/* List variables by position rather than alphabetical */
PROC CONTENTS DATA=sashelp.cars VARNUM;
RUN;


/* Add a title to the output */
title "Contents of cars data, alphabetical variables";
PROC CONTENTS DATA=sashelp.cars;
RUN;
title;




/*------------------------------------------------------------------PROC PRINT */
/* Display entire data set */
PROC PRINT DATA = sashelp.cars ;
RUN;

/* Display first 10 observations and only 4 variables */
PROC PRINT DATA = sashelp.cars (OBS=10);
	VAR make model msrp enginesize;
RUN;

/* Replace the blank with an option to display the variable label rather 
   than the variable name. */
*ods pdf file="&path.L2_procprint.pdf" ;
*options nodate nonumber;
PROC PRINT DATA = sashelp.cars (OBS=10) ______;
	VAR make model msrp enginesize;
RUN;
*ods pdf close;


/*------------------------------------------------------------------PROC MEANS */
/* Produce basic summary statistics of entire data set */
PROC MEANS DATA = sashelp.cars ;
RUN;

/* Display summary statistics for only 2 variables */
PROC MEANS DATA = sashelp.cars ;
	VAR msrp enginesize;
RUN;

/* Predict what this will do */
PROC MEANS DATA = sashelp.cars ;
	VAR make model msrp enginesize;
RUN;

/* Replace the blank with an option to display only the mean rounded to 
   two decimal places. */
*ods pdf file="&path.L2_procmeans.pdf" ;
*options nodate nonumber;
PROC MEANS DATA = sashelp.cars ______;
	VAR msrp enginesize;
RUN;
*ods pdf close;

/* Obtain summary statistics on MSRP separately for each car make,
   results condensed in one tabular output */
PROC MEANS DATA = sashelp.cars ;
	CLASS make ;
	VAR msrp ;
RUN;

/* Obtain summary statistics on MSRP separately for each car make,
   results separated with each car make per table.  Requires sorting
   by the BY variable first.  */
PROC SORT DATA =  sashelp.cars;
	BY make;
RUN;
PROC MEANS DATA = sashelp.cars ;
	BY make ;
	VAR msrp ;
RUN;



/*----------------------------------------------------------------PROC IMPORT */
/* Import a CSV data set */
PROC IMPORT 
	DATAFILE="X:/StatStudio/spileggi/Data Sets/acs.csv" 
	OUT = work.acs 
	DBMS = CSV 
	REPLACE ;
RUN;
