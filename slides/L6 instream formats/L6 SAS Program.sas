/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 6 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

*%LET path = C:/Users/spileggi/Google Drive/STAT 330/Lectures/Figures/;


/*---------------------------------------------Instream data, standard values*/
DATA work.class ;
	INPUT name $ GPA ;
	DATALINES;
	Bill 3.4
	Susan 2.7
	;
RUN ;

PROC PRINT DATA = work.class ;
RUN ;



/*---------------------------------------------------Instream data, practice*/
*One at a time, try making (1) Bill's GPA missing, then (2) Susan's name 
missing ;
DATA work.class ;
	INPUT name $ GPA ;
	DATALINES;
	Bill 3.4
	Susan 2.7
;
RUN ;

PROC PRINT DATA = work.class ;
RUN ;


/*--------------------------------------------Example informat, nonstandard data*/
DATA work.class ;
INPUT name $ GPA dob MMDDYY10. ;
DATALINES ;
Bill 3.4 10/13/1995
Susan 2.7 6/24/1993
;
RUN ;

PROC PRINT DATA = work.class ;
RUN ;


/*--------------------------------------------------------Identify the informat*/
DATA work.class;
INPUT name $ GPA dob MMDDYY10. salary _____;
DATALINES ;
Bill 3.4 10/13/1995 $18,000
Susan 2.7 6/24/1993 $535,000
;
RUN ;

PROC PRINT DATA = work.class ;
RUN ;




/*---------------------------------------------Instream data and data manipulation*/
/*
Where should we insert: 
	day = WEEKDAY(dob);
to create the variable that is the day of the week of birht.
*/
DATA work.class;

INPUT name $ GPA dob MMDDYY10. ;

DATALINES ;
Bill 3.4 10/13/1995
Susan 2.7 6/24/1993 
;

RUN ;


*ods pdf file="&path.L6_noformat.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC PRINT DATA = work.class ;
RUN ;
*ods pdf close ;


/*---------------------------------------Applying temporary formats*/
PROC PRINT DATA = work.class ;
	FORMAT dob DATE9. day WEEKDATE9.;
RUN ;

/*---------------------------------------Applying permanent formats*/

DATA work.class2 ;
	SET class;
	FORMAT dob DATE9. day WEEKDATE9.;
RUN ; 

PROC PRINT DATA = work.class2 ;
RUN ;


/*---------------------------------------Applying temporary labels*/
*ods pdf file="&path.L6_format.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC PRINT DATA = work.class LABEL ;
   FORMAT dob DATE9.
          day WEEKDATE9. ;
   LABEL dob = "Date of Birth" 
         gpa = "Grade Point Average" ;
RUN ;
*ods pdf close;


/*---------------------------------------Applying permanent labels*/

DATA work.class2 ;
	SET class ;
	FORMAT dob DATE9. day WEEKDATE9. ;
	 LABEL dob = "Date of Birth" 
           gpa = "Grade Point Average" ;
RUN ; 

PROC PRINT DATA = work.class2 LABEL ;
RUN ;


/*---------------------------------------PROC FORMAT*/

/* Import survey data set */
%LET data = X:\spileggi\Data Sets ;

LIBNAME x "&data" ;

PROC IMPORT
	DATAFILE = "&path.\babies.csv"
	OUT = work.babies
	DBMS = CSV
	REPLACE ;
	GUESSINGROWS = 35 ;
RUN;


/*Create formats to change value display*/
PROC FORMAT ;
	VALUE birthorder 0 = "first born"
	         		 1 = "otherwise" ;

	VALUE smokestatus 0 = "not now"
	                  1 = "yes now" ;

	VALUE birthweight low-88  = "under"
				      88<-high = "normal" ;
RUN ;


/* 2-way table of parity and smoke, not formatted */
*ods pdf file="&path.L6_2waytableNOformat.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC FREQ DATA = work.babies;
	TABLES parity*smoke / NOROW NOCOL NOPERCENT ;
RUN;
*ods pdf close ;

/* 2-way table of parity and smoke, formatted */
*ods pdf file="&path.L6_2waytableWITHformat.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC FREQ DATA = work.babies;
	TABLES parity*smoke / NOROW NOCOL NOPERCENT ;
	FORMAT parity birthorder. smoke smokestatus. ;
RUN;
*ods pdf close ;

/* table of birth weight values, not formatted */
*ods pdf file="&path.L6_1waytableNOformat.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC FREQ DATA = babies;
	TABLES bwt ;
RUN;
*ods pdf close ;

/* table of birth weight values, formatted  */
*ods pdf file="&path.L6_1waytableWITHformat.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC FREQ DATA = babies;
	TABLES bwt ;
	FORMAT bwt birthweight. ;
RUN;
*ods pdf close ;
