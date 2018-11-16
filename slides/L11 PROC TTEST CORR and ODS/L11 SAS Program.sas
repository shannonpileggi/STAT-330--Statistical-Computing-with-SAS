/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 11 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

OPTIONS MPRINT MLOGIC SYMBOLGEN ;

%LET dir = C:\Users\spileggi\Google Drive\STAT 330\Lectures\Figures\ ;

*macro to start figure export to pdf ;
%MACRO sfig(qn);
ods pdf file="&dir.L&qn..pdf" style=HTMLBlue ;
options nodate nonumber ;
%MEND ;

*macro to end figure export to pdf ;
%MACRO efig;
ods pdf close;
%MEND ;



/*****************************************************************************
* Get to know the data
*****************************************************************************/

LIBNAME flash "C:\Users\spileggi\Google Drive\STAT 330\Data" ;

PROC CONTENTS DATA = flash.BtheB VARNUM ; 
RUN ;


PROC PRINT DATA = flash.BtheB (OBS = 10) ; 
RUN ;


/*****************************************************************************
* One sample t-test
*****************************************************************************/
%sfig(11_onesamplet);
PROC TTEST DATA = flash.BtheB H0 = 20 ALPHA = 0.05 SIDES = 2;
	VAR bdi_pre ;
RUN ;
%efig ;


/*****************************************************************************
* Two sample t-test
*****************************************************************************/
%sfig(11_twosamplet);
PROC TTEST DATA = flash.BtheB ALPHA = 0.05 SIDES = 2 ;
	VAR bdi_pre ;
    CLASS drug ;
RUN ;
%efig ;

/*****************************************************************************
* Paired t-test
*****************************************************************************/
%sfig(11_pairedt);
PROC TTEST DATA = flash.BtheB H0 = 0 ALPHA = 0.05 SIDES = 2 ;
	PAIRED bdi_pre*bdi_2m ;
RUN ;
%efig ;



/*****************************************************************************
* Correlation
*****************************************************************************/
*everything on VAR produces redundant information ;
PROC CORR DATA = flash.BtheB ;
	VAR bdi_pre bdi_2m bdi_4m bdi_6m bdi_8m ;
RUN ;

*Simplify your output with a WITH statement;
%sfig(11_corr);
PROC CORR DATA = flash.BtheB ;
	VAR bdi_pre ;
	WITH bdi_2m bdi_4m bdi_6m bdi_8m ;
RUN ;
%efig ;



/*****************************************************************************
* OUTPUT DELIVERY SYSTEM EXAMPLES
*****************************************************************************/

*list all possible styles ;
PROC TEMPLATE;
   LIST styles;
RUN;

*Change destination of images ;
ODS HTML GPATH = "&dir";
ODS GRAPHICS ON / IMAGENAME = "L11_scatter" RESET = INDEX ;
PROC CORR DATA = flash.BtheB PLOTS = matrix ;
	VAR bdi_pre ;
	WITH bdi_2m bdi_4m bdi_6m bdi_8m ;
RUN ;

*Example of exporting a pdf ;
ODS PDF FILE = "&dir.L11_correlation.pdf" STYLE = HTMLBlue ;
OPTIONS NODATE NONUMBER ;
PROC CORR DATA = flash.BtheB PLOTS = matrix ;
	VAR bdi_pre ;
	WITH bdi_2m bdi_4m bdi_6m bdi_8m ;
RUN ;
ODS PDF CLOSE ;
