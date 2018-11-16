/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 15 SAS Program
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

LIBNAME flash "C:\Users\spileggi\Google Drive\STAT 330\Data";


*create new variables in data set;
DATA patents;
	SET flash.patents;
	LENGTH division $30. ;

	*The US census divides states into Regions and Divisions.  Each for the 4 census regions is divided into 2 or more divisions.;
	IF state in ("CONNECTICUT" "MAINE" "MASSACHUSETTS" "NEW HAMPSHIRE" "RHODE ISLAND" "VERMONT") THEN division="New England";
	IF state in ("NEW JERSEY" "NEW YORK" "PENNSYLVANIA") THEN division="Middle Atlantic";
	IF state in ("ILLINOIS" "INDIANA" "MICHIGAN" "OHIO" "WISCONSIN") THEN division="East North Central";
	IF state in ("IOWA" "KANSAS" "MINNESOTA" "MISSOURI" "NEBRASKA" "NORTH DAKOTA" "SOUTH DAKOTA") THEN division="West North Central";
	IF state in ("DELAWARE" "DISTRICT OF COLUMBIA" "FLORIDA" "GEORGIA" "MARYLAND" "NORTH CAROLINA" "SOUTH CAROLINA" "VIRGINIA" "WEST VIRGINIA") THEN division="South Atlantic";
	IF state in ("ALABAMA" "KENTUCKY" "MISSISSIPPI" "TENNESSEE") THEN division="East South Central";
	IF state in ("ARKANSAS" "LOUISIANA" "OKLAHOMA" "TEXAS") THEN division="West South Central";
	IF state in ("ARIZONA" "COLORADO" "IDAHO" "MONTANA" "NEVADA" "NEW MEXICO" "UTAH" "WYOMING") THEN division="Mountain";
	IF state in ("ALASKA" "CALIFORNIA" "HAWAII" "OREGON" "WASHINGTON") THEN division="PacIFic";

	IF division in ("New England" "Middle Atlantic") THEN region="Northeast";
	IF division in ("East North Central" "West North Central") THEN region="Midwest";
	IF division in ("South Atlantic" "East South Central" "West South Central") THEN region="South";
	IF division in ("Mountain" "PacIFic") THEN region="West";

	*This indicates IF the percent of the county with at least a bachelors degree exceeds 25 or not;
	IF education gt 25 THEN edu25 = 1;
	ELSE edu25 = 0;

	*This indicates IF the percent of the county that is unemployed exceeds 10 or not;
	IF unemployed gt 10 THEN unemp10 = 1;
	ELSE unemp10 = 0;
RUN;



/*-------------------------------------------------------------------------------
Example 1 - changing table dimensions. Note the default statistic produced is 
the number of observations (N) in each category.
-------------------------------------------------------------------------------*/


*one dimensional table: columns=edu25;
%sfig(15_1dtable);
TITLE "One-dimensional table" ;
PROC TABULATE DATA = patents ;
	CLASS edu25 ;
	TABLE edu25 ;
RUN ;
TITLE ;
%efig;

*two dimensional table: columns=edu25, rows=region;
%sfig(15_2dtable);
TITLE "Two-dimensional table" ;
PROC TABULATE DATA = patents ;
	CLASS edu25 region ;
	TABLE region, edu25 ;
RUN ;
TITLE ;
%efig ;

*three dimensional table: pages=unemp10, columns=edu25, rows=region;
%sfig(15_3dtable);
TITLE "Three-dimensional table" ;
PROC TABULATE DATA = patents ;
	CLASS unemp10 edu25 region ;
	TABLE unemp10, region, edu25 ;
RUN ;
TITLE ;
%efig;


/****************************************************************************** 
Example 2 - concatenate vs cross. Note the default statistic produced is 
the number of observations (N) in each category.
*****************************************************************************/

*two dimensional table: concatenated columns=edu25 and unemp10, rows=region;
%sfig(15_concatenate);
TITLE "Two-dimensional, concatenated table";
PROC TABULATE DATA = patents ;
	CLASS edu25 region unemp10 ;
	TABLE region, edu25 unemp10 ;
RUN ;
TITLE ;
%efig;

*two dimensional table: crossed columns=edu25 and unemp10, rows=region;
%sfig(15_cross);
TITLE "Two-dimensional, crossed table";
PROC TABULATE DATA = patents ;
	CLASS edu25 region unemp10 ;
	TABLE region, edu25*unemp10 ;
RUN ;
TITLE ;
%efig;

/****************************************************************************** 
Example 3 - using ALL to create totals
*****************************************************************************/

*two dimensional table: columns=edu25 and unemp10, rows=region;
TITLE "table region ALL, edu25 ALL;" ;
PROC TABULATE DATA = patents ;
	CLASS edu25 region ;
	TABLE region ALL, edu25 ALL ;
RUN ;
TITLE ;

*two dimensional table: concatenated columns=edu25 and unemp10, rows=region;
TITLE "table region, edu25 ALL unemp10 ALL;";
PROC TABULATE DATA = patents ;
	CLASS edu25 region unemp10 ;
	TABLE region, edu25 ALL unemp10 ALL ;
RUN ;
TITLE ;

*two dimensional table: crossed columns=edu25 and unemp10, rows=region;
TITLE "table region, edu25*unemp10 ALL";
PROC TABULATE DATA = patents ;
	CLASS edu25 region unemp10 ;
	TABLE region, edu25*unemp10 ALL ;
RUN ;
TITLE ;

*two dimensional table: crossed columns=edu25 and unemp10, rows=region;
%sfig(15_ALLexample);
TITLE "table region, edu25*(unemp10 ALL) ALL;";
PROC TABULATE DATA = patents;
	CLASS edu25 region unemp10;
	TABLE region, edu25*(unemp10 ALL) ALL;
RUN;
TITLE ;
%efig ;


/****************************************************************************** 
Example 4 - producing default statistics for categorical variables
*****************************************************************************/

*class variable - default is N;
%sfig(15_catstats);
TITLE "N = number of counties";
PROC TABULATE DATA = patents ;
	CLASS edu25 region ;
	TABLE region, edu25 ;
RUN ;
TITLE ;
%efig ;

*class variable - default is N;
TITLE "N = number of counties";
PROC TABULATE DATA = patents ;
	CLASS edu25 region ;
	TABLE region, edu25*N ;
RUN ;
TITLE ;



/****************************************************************************** 
Example 5 - producing default statistics for quantitative variables
*****************************************************************************/

*var variable (aka, analysis variable) - default is sum;
%sfig(15_quantstats);
TITLE "Sum = number of patents";
PROC TABULATE DATA = patents ;
	CLASS region ;
	VAR patents ;
	TABLE region, patents ;
RUN;
TITLE ;
%efig;

*var variable (aka, analysis variable) - default is sum;
TITLE "Sum = number of patents";
PROC TABULATE DATA = patents ;
	CLASS region ;
	VAR patents ;
	TABLE region, patents*SUM ;
RUN ;
TITLE ;


/****************************************************************************** 
Example 6 - multiple statistics
*****************************************************************************/
*getting multiple statistics - N, sum, and mean;
%sfig(15_nestedstats);
TITLE "N, sum, and mean with PROC TABULATE" ;
PROC TABULATE data = patents ;
	CLASS edu25 region ;
	VAR patents ;
	TABLE region, edu25*patents*(N SUM MEAN) ;
RUN ;
TITLE ;
%efig;

TITLE "N, sum, and mean with PROC MEANS" ;
PROC MEANS DATA = patents N SUM MEAN ;
	CLASS edu25 region ;
	VAR patents ;
RUN ;
TITLE ;



/****************************************************************************** 
Example 7 - statistics with ALL
*****************************************************************************/
%sfig(15_ALLstats);
TITLE "Statistics with ALL" ;
PROC TABULATE DATA = patents ;
	CLASS edu25 region ;
	VAR patents ;
	TABLE region ALL, 
          edu25*patents*(N SUM MEAN ROWPCTSUM) ALL*patents*(N SUM MEAN ROWPCTSUM) ;
RUN ;
TITLE ;
%efig;


/****************************************************************************** 
Example 8 - formatting
*****************************************************************************/
*create format for 0/1 variables to display as no/yes;
*create format that displays percentages with percent signs in the cell;
PROC FORMAT ;
	VALUE yn 1 = "Yes" 0 = "No" ;
	PICTURE pct(ROUND) low-high = '009.9%';
RUN;

*Apply formats two ways
-to a variable using FORMAT statement
-to a statistic using *f= ;
%sfig(15_formatvariable);
TITLE "Apply formatting to variable values";
PROC TABULATE DATA = patents ;
	CLASS edu25 region;
	VAR patents;
	TABLE region ALL, 
          edu25*patents*(N SUM MEAN ROWPCTSUM) 
            ALL*patents*(N SUM MEAN ROWPCTSUM);
	FORMAT edu25 yn. ;
RUN;
TITLE ;
%efig;

%sfig(15_formatstats);
TITLE "Apply formatting to statistics";
PROC TABULATE DATA = patents ;
	CLASS edu25 region;
	VAR patents;
	TABLE region ALL, 
          edu25*patents*(N SUM*F=COMMA7. MEAN*F=COMMA5.1 ROWPCTSUM*F=PCT.) 
            ALL*patents*(N SUM*F=COMMA7. MEAN*F=COMMA5.1 ROWPCTSUM*F=PCT.);
	FORMAT edu25 yn. ;
RUN;
TITLE ;
%efig;

/****************************************************************************** 
Example 9 - Basic Labels
*****************************************************************************/
*Apply variable labels two ways
-to a variable using LABEL statement
-to a variable using ="ABC" ;
*a blank label removes the cell from the table;
%sfig(15_labels);
TITLE "Apply basic labels";
PROC TABULATE DATA = patents;
	CLASS edu25 region ;
	VAR patents;
	TABLE region=" "  ALL,
         edu25*patents=" "*(N sum mean ROWPCTSUM) 
         ALL*patents=" "*(N sum mean ROWPCTSUM) ;
	LABEL edu25="At least 25% of county has a Bachelor's";
RUN;
TITLE ;
%efig;

/****************************************************************************** 
Example 10 - keylabel and box
*****************************************************************************/
*BOX= is an option in the TABLE statement that changes text in upper left box;
*KEYLABEL is a statement that applies a label to a keyword
everywhere that keyword appears;
%sfig(15_keybox);
TITLE "Keylabel and box";
PROC TABULATE DATA = patents;
	CLASS edu25 region ;
	VAR patents;
	TABLE region=" "  ALL,
         edu25*patents=" "*(N SUM MEAN ROWPCTSUM) 
         ALL*patents=" "*(N SUM MEAN ROWPCTSUM) /
		 BOX = "Geographic Region";
	LABEL edu25="At least 25% of county has a Bachelor's";
	KEYLABEL ALL="Total" ROWPCTSUM="Row Sum" ;
RUN;
TITLE;
%efig;

/****************************************************************************** 
Example 11 - change cell background colors
*****************************************************************************/
*create format;
PROC FORMAT ;
	VALUE hlpct 95-high="Chartreuse" ;
RUN;

*apply PapayaWhip background color to all cells; 
*highlight cells in Chartreuse with row percent sum greater than 95%;
%sfig(15_highlight);
TITLE "With cell colors";
PROC TABULATE DATA=patents;
	CLASS region;
	CLASS edu25 / DESCENDING;
	VAR patents;
	TABLE region=" "  ALL,
          edu25*patents=" "*(N SUM*F=COMMA7. MEAN*F=COMMA5.1 ROWPCTSUM*F=PCT.*{STYLE={BACKGROUND=HLPCT.}}) 
          ALL*patents=" "*(N SUM*F=COMMA7. MEAN*F=COMMA5.1 ROWPCTSUM*F=PCT.) /
		  BOX="Geographic Region";
	LABEL edu25="At least 25% of county has a Bachelor's";
	KEYLABEL ALL="Total" ROWPCTSUM="Row Sum" ;
	FORMAT edu25 yn.;
RUN;
TITLE ;
%efig;
