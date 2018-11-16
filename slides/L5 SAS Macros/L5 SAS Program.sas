/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 5 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

*%LET path = C:/Users/spileggi/Google Drive/STAT 330/Lectures/Figures/;


/*-------------------------------------------------------------Baseball Data */
PROC CONTENTS DATA = sashelp.baseball VARNUM;
RUN ;

PROC PRINT DATA = sashelp.baseball (obs = 10) ;
RUN ;

PROC MEANS DATA = sashelp.baseball ;
	VAR nHome ;
RUN ;

PROC FREQ DATA = sashelp.baseball ;
	TABLES position ;
RUN ;

/*--------------------------------------------------Automatic macro variables */	

TITLE "Contents of Baseball Data on &sysdate9" ;
PROC CONTENTS DATA = sashelp.baseball VARNUM ;
RUN ;
TITLE ;

/*--------------------------------------------------Single variable insertion */

PROC PRINT DATA = sashelp.baseball (OBS = 10);
RUN ;



/*----------------------------------------------Macro variables with path names */
%LET mypath = X:/spileggi/Data Sets/ ;

LIBNAME mylib "&mypath" ;

PROC IMPORT OUT = mylib.babies
	DATAFILE = "&mypath.babies.csv"
	DBMS = CSV REPLACE;
RUN;


/*--------------------------------------------------Macro module, no parameters */

%MACRO myprint ;
TITLE "DATA = &dsn, OBS = &num" ;
PROC PRINT DATA = &dsn (OBS=&num);
RUN ;
TITLE ;
%MEND ;

%LET num = 10 ;
%LET dsn = sashelp.baseball ;
%myprint ;	




/*----------------------------------------------Macro module, POSITIONAL parameters */

*macro defintion ;
%MACRO myprint(dsn, num) ;
TITLE "DATA = &dsn, OBS = &num" ;
PROC PRINT DATA = &dsn (OBS=&num);
RUN ;
TITLE ;
%MEND ;

*macro execution ;
%myprint(sashelp.baseball,5) ;	
%myprint(sashelp.class,3) ;	

*this won't work because order of parameter values matters;
%myprint(3,sashelp.class) ;	

/*----------------------------------------------Macro module, KEYWORD parameters */

%MACRO myprint(dsn = sashelp.baseball, num = 5) ;
TITLE "DATA = &dsn, OBS = &num" ;
PROC PRINT DATA = &dsn (OBS=&num);
RUN ;
TITLE ;
%MEND ;

*These four execute equivalently ;
%myprint ;
%myprint();
%myprint(dsn = sashelp.baseball, num = 5) ;	
%myprint(num = 5, dsn = sashelp.baseball) ;	

*keep defaul data set, change number of observations printed;
%myprint(num = 3) ;	

*Changes value for data set and number of observations printed ;
%myprint(dsn = sashelp.class, num = 3) ;	

*These two do NOT work with keyword method;
%myprint(sashelp.baseball,5) ;	
%myprint(sashelp.class,3) ;	

/*----------------------------------------------View macro values in LOG */
%PUT dsn = &dsn , num = &num;
