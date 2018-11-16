/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 10 SAS Program
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
*   PROGRAM DATA VECTOR
*****************************************************************************/


/*************************************************      Input data*/

DATA class;
  INPUT name $ GPA dob MMDDYY10. salary COMMA8.;
  DATALINES;
  Bill  3.4 10/13/1995 $18,000
  Susan 2.7 06/24/1993 $535,000
  ;
RUN;

PROC PRINT DATA = class;
RUN;


/*************************************************  Example of error */

DATA class;
  INPUT name $ GPA dob MMDDYY10. salary COMMA8.;
  DATALINES;
  Bill  3.4 10/13/1995  $18,000
  Susan 2.7 06/24/199  $535,000
  ;
RUN;

*CHECK LOG ;



/*************************************************  Using the PDV */
DATA one;
  OUTPUT;
  DO i = 1 to 4;
	 x = i**3;
	 OUTPUT;
  END;
  OUTPUT;
RUN;

PROC PRINT DATA = one;
RUN;




/*****************************************************************************
*  PROC SGPLOT
*****************************************************************************/



LIBNAME flash "C:\Users\spileggi\Google Drive\STAT 330\Data";

PROC CONTENTS DATA = flash.o2012 VARNUM ;
RUN ;

PROC FREQ DATA = flash.o2012 ;
	TABLES country ;
	WHERE sport = "Swimming";
RUN ;


/*****************************************          PROC FREQ BAR PLOT */

*%sfig(10_procfreqbarplot) ;
TITLE "Number of Swimming Participants by Country";
PROC FREQ DATA = flash.o2012; 
	TABLES country / PLOTS = freqplot; 
	WHERE sport = "Swimming"; 
RUN;
TITLE ;
*%efig() ;


/*****************************************          PROC SGPLOT BAR PLOT */

*%sfig(10_procsgplotbarplot) ;
TITLE "Number of Swimming Participants by Country";
PROC SGPLOT DATA = flash.o2012;
	WHERE sport = "Swimming";
	VBAR country ;
RUN;
TITLE ;
*%efig() ;


/*****************************************   PROC SGPLOT BAR PLOT, WEIGHTED COUNT */

*%sfig(10_procsgplotbarplotresponse) ;
TITLE "Number of Swimming Medals by Country";
PROC SGPLOT DATA = flash.o2012 ;
	where sport = "Swimming";
	VBAR country / RESPONSE = total ;
RUN ;
TITLE ;
*%efig() ;

/************************************   PROC SGPLOT BAR PLOT, STACKED, WEIGHTED COUNT */

*%sfig(10_procsgplotbarplotresponsestacked) ;
TITLE "Total medals won in swimming or rowing by country";
PROC SGPLOT DATA = flash.o2012;
	WHERE sport="Swimming" or sport="Rowing";
	VBAR country /GROUP = sport RESPONSE = total ;
RUN;
TITLE ;
*%efig() ;


/************************************   PROC SGPLOT BAR PLOT, with lines */

*%sfig(10_procsgplotbarplotresponselines) ;
TITLE "Total medals won in swimming, with lines for medal type";
PROC SGPLOT DATA = flash.o2012;
	WHERE sport="Swimming" ;
	VBAR country / RESPONSE = total ;
	VLINE country / RESPONSE = gold ;
	VLINE country / RESPONSE = silver ;
	VLINE country / RESPONSE = bronze ;
RUN ;
TITLE ;
*%efig() ;


/************************************   PROC SGPLOT HISTOGRAM, with normal curve */
*%sfig(10_histnormal) ;
TITLE "Distribution of Height of Medal-Winning Swimmers";
PROC SGPLOT DATA = flash.o2012;
	WHERE sport = "Swimming";
	HISTOGRAM height;
	DENSITY height; 
RUN;
TITLE ;
*%efig() ;

/************************************   PROC SGPLOT HISTOGRAM, density separated */
*%sfig(10_histnormaloverlay) ;
TITLE "Distribution of Height of Medal-Winning Swimmers and Gymnasts";
PROC SGPLOT DATA = flash.o2012;
	WHERE sport="Swimming" OR sport="Gymnastics - Artistic";
	HISTOGRAM height/  GROUP = sport TRANSPARENCY = 0.5;
RUN ;
TITLE ;
*%efig() ;


/************************************   PROC SGPLOT HISTOGRAM of TWO variables*/
TITLE "Height and weight on same histogram";
PROC SGPLOT DATA = flash.o2012;
	WHERE sport="Swimming" ;
	HISTOGRAM height /   TRANSPARENCY = 0.5;
	HISTOGRAM weight /   TRANSPARENCY = 0.5;
RUN ;
TITLE ;

/************************************   PROC SGPLOT HISTOGRAM separated by values of a variable*/
TITLE "Height separated by gender";
PROC SGPLOT DATA = flash.o2012;
	WHERE sport="Swimming" ;
	HISTOGRAM height /  GROUP = gender TRANSPARENCY = 0.5;
RUN ;
TITLE ;



/************************************   PROC SGPLOT HISTOGRAM separated by values of a variable*/
TITLE "Height separated by gender";
PROC SGPLOT DATA = flash.o2012;
	WHERE sport="Swimming" ;
	HISTOGRAM height /  GROUP = gender TRANSPARENCY = 0.5;
RUN ;
TITLE ;


/************************************   PROC SGPLOT HISTOGRAM separated by values of a variable*/
*%sfig(10_sideboxcategory) ;
TITLE "Distribution of Height among Medal Winners";
PROC SGPLOT DATA = flash.o2012;
	HBOX height / CATEGORY = sport ;
RUN ;
TITLE ;
*%efig ;

*%sfig(10_sideboxgroup) ;
TITLE "Distribution of Height among Medal Winners";
PROC SGPLOT DATA = flash.o2012;
	HBOX height / GROUP = sport ;
RUN ;
TITLE ;
*%efig ;

/************************************   PROC SGPLOT SCATTERPLOT */
*%sfig(10_scatter1) ;
TITLE "Relationship between height and weight among medal winners";
PROC SGPLOT DATA = flash.o2012 ;
	SCATTER Y = weight X = height ;
	XAXIS LABEL = "Height" ;
	YAXIS LABEL = "Weight" ;
	*fitted line with confidence limits;
	REG Y = weight X = height / CLM CLI ;
RUN ;
*%efig ;


/***********************   PROC SGPLOT SCATTERPLOT, color by categorical variable */
*%sfig(10_scatter2) ;
TITLE "Relationship between height and weight among Rowing and Swimming medal winners";
PROC SGPLOT DATA = flash.o2012 ;
	WHERE sport = "Swimming" or sport = "Rowing" ;
	SCATTER Y = weight X = height / 
		GROUP = sport 
		MARKERATTRS = (symbol = CircleFilled) ;
RUN ;
*%efig;


/***********************   PROC SGPLOT SCATTERPLOT, color by quantitative variable */
*%sfig(10_scatter3) ;
TITLE "Relationship between height and weight, colored by age";
PROC SGPLOT DATA = flash.o2012 ;
SCATTER Y = weight X = height / 
	COLORRESPONSE = age
	MARKERATTRS = (symbol=CircleFilled size=10)  
	COLORMODEL = TwoColorRamp; 
RUN ;
*%efig;

