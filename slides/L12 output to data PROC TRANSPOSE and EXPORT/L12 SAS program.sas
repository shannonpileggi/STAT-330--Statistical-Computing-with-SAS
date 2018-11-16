/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 12 SAS Program
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


/*-----------------------------------------------------------------------------
Import the data
-----------------------------------------------------------------------------*/
PROC IMPORT OUT= WORK.ACS 
            DATAFILE= "&path.acs.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	 GUESSINGROWS = 1000 ;
RUN;

*view first 10 obs ;
*%sfig(12_acs);
PROC PRINT DATA = work.acs (OBS = 10) ;
RUN ;
*%efig;


/*-----------------------------------------------------------------------------
PROC MEANS - storing output
-----------------------------------------------------------------------------*/
*%sfig(12_pmeans);
PROC MEANS DATA = WORK.ACS ;
    OUTPUT OUT = meansresults ;
RUN ;
*%efig;

*%sfig(12_pmeansout);
PROC PRINT DATA = meansresults ;
RUN ;
*%efig;


/*-----------------------------------------------------------------------------
PROC FEQ - storing output
-----------------------------------------------------------------------------*/
*%sfig(12_pfreq);
PROC FREQ DATA = WORK.acs ;
	TABLES sex*marstat / OUT = freqresults ;
RUN ;
*%efig;

*%sfig(12_pfreqout);
PROC PRINT DATA = freqresults ;
RUN ;
*%efig;


/*-----------------------------------------------------------------------------
PROC TTEST - storing output
-----------------------------------------------------------------------------*/
*Step 1 - trace results ;
ODS TRACE ON ;
*%sfig(12_pttest);
PROC TTEST DATA = WORK.acs H0 = 40 ;
	VAR HoursWk ;
RUN ;
*%efig;
ODS TRACE OFF ;
	

*Step 2 - examine log ;

*Step 3 - use ODS to store results ;
PROC TTEST DATA = WORK.acs H0 = 40 ;
	VAR HoursWk ;
	ODS OUTPUT ConfLimits =  CIresults ;
RUN ;

*%sfig(12_pttestout);
PROC PRINT DATA = CIresults ;
RUN ;
*%efig ;


/*-----------------------------------------------------------------------------
PROC TRANSPOSE - applied to meansresults
-----------------------------------------------------------------------------*/


PROC TRANSPOSE
   DATA = meansresults
   OUT = statstransposed
   NAME = variable ;
   ID _stat_ ;
   VAR age income hourswk;
RUN ;

*%sfig(12_meanstransposed);
PROC PRINT DATA = statstransposed ;
RUN ;
*%efig;


/*-----------------------------------------------------------------------------
PROC TRANSPOSE - on your own
-----------------------------------------------------------------------------*/
DATA datawehave ;
INPUT student $ ID Test1 Test2 ;
DATALINES ;
Andrew  6545   94     91
Beth    1252   51     65
Charlie 1167   95     97
;
RUN;


PROC TRANSPOSE DATA = datawehave OUT = datawewant NAME = ;
	ID  ;
	VAR  ;
RUN ;

PROC PRINT DATA = datawehave ; RUN ;
PROC PRINT DATA = datawewant ; RUN ;



/*-----------------------------------------------------------------------------
PROC EXPORT - applied to statstransposed
-----------------------------------------------------------------------------*/

DATA statstransposed2 ;
   SET statstransposed ;
   FORMAT mean 4.1 std 4.1 ;
RUN ;

PROC EXPORT
   DATA = statstransposed2
   OUTFILE = "&path.summarystats.csv"
   DBMS = CSV
   REPLACE ;
RUN;
