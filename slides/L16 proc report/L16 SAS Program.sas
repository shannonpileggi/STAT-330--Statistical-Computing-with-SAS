/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 16 SAS Program
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
	IF state in ("ALASKA" "CALIFORNIA" "HAWAII" "OREGON" "WASHINGTON") THEN division="Pacific";

	IF division in ("New England" "Middle Atlantic") THEN region="Northeast";
	IF division in ("East North Central" "West North Central") THEN region="Midwest";
	IF division in ("South Atlantic" "East South Central" "West South Central") THEN region="South";
	IF division in ("Mountain" "Pacific") THEN region="West";

	*This indicates IF the percent of the county with at least a bachelors degree exceeds 25 or not;
	IF education gt 25 THEN edu25 = 1;
	ELSE edu25 = 0;

	*This indicates IF the percent of the county that is unemployed exceeds 10 or not;
	IF unemployed gt 10 THEN unemp10 = 1;
	ELSE unemp10 = 0;
RUN;



/****************************************************************************** 
Example 1 - Getting started with DETAIL reports
*****************************************************************************/

TITLE "REPORT with no COLUMN/DEFINE statements";
PROC REPORT DATA = patents ;
RUN ;
TITLE ;

TITLE "REPORT specifying variables in COLUMN";
PROC REPORT DATA = patents ;
   COLUMN state county patents ;
RUN ;
TITLE ;

%sfig(16_basic_detail);
TITLE "REPORT specifying variables in COLUMN, applies default usages" ;
PROC REPORT DATA = patents ;
   COLUMN state county patents ;
   DEFINE state / DISPLAY ;
   DEFINE county / DISPLAY ;
   DEFINE patents / ANALYSIS ;
RUN ;
TITLE ;
%efig;



/****************************************************************************** 
Example 2 - ORDER usage
*****************************************************************************/
%sfig(16_detail_order);
TITLE "ORDER usage for state and county, and SPANROWS" ;
PROC REPORT DATA = patents SPANROWS ;
	COLUMN state county patents ;
	DEFINE state / ORDER ;
	DEFINE county / ORDER ;
	DEFINE patents / ANALYSIS ;
RUN ;
TITLE ;
%efig;


/****************************************************************************** 
Example 2a - identify usage
*****************************************************************************/
%sfig(16_discussion1);
TITLE "Discussion question" ;
PROC REPORT DATA = patents  ;
	WHERE state = "WEST VIRGINIA" ;
	COLUMN county patents population;
	DEFINE county / DISPLAY ;
	DEFINE patents / ANALYSIS ;
	DEFINE population / ORDER ;
RUN ;
TITLE ;
%efig;

/****************************************************************************** 
Example 2a - identufy blank values
*****************************************************************************/
%sfig(16_discussion2);
TITLE "Discussion question" ;
PROC REPORT DATA = patents  ;
	WHERE state = "ALABAMA" ;
	COLUMN county patents population;
	DEFINE county / DISPLAY ;
	DEFINE patents / ORDER ;
	DEFINE population / ANALYSIS ;
RUN ;
TITLE ;
%efig;




/****************************************************************************** 
Example 3 - Spanning column headings
*****************************************************************************/
%sfig(16_spancolhead);
TITLE "Column header spanned";
PROC REPORT DATA = patents SPANROWS;
	COLUMN ("Location" state county) patents ("Demographics" population age education income);
	DEFINE state / order;
	DEFINE county / order;
RUN;
TITLE ;
%efig;

TITLE "Nested column headers";
PROC REPORT DATA = patents SPANROWS;
	COLUMN ("Patents Data" ("Location" state county) patents ("Demographics" population age education income));
	DEFINE state / ORDER;
	DEFINE county / ORDER;
RUN;
TITLE ;

/****************************************************************************** 
Example 4 - Applying labels and formats
*****************************************************************************/
%sfig(16_format_label);
TITLE "Applying labels and formats";
PROC REPORT data=patents spanrows;
	COLUMN state county patents population age education income;
	DEFINE state / ORDER;
	DEFINE county / ORDER;
	DEFINE patents /  "Patents" F=COMMA15. ;
	DEFINE population / "Population" F=COMMA15. ;
	DEFINE education /  "% >= Bachelor" ;
	DEFINE income / F=DOLLAR15. ; 
RUN;
TITLE ;
%efig;


/****************************************************************************** 
Example 5 - Summary Report with GROUP usage
*****************************************************************************/
%sfig(16_group);
TITLE "GROUP usage for region and division";
PROC REPORT DATA = patents SPANROWS ;
	COLUMN region division patents  ;
	DEFINE region / GROUP;
	DEFINE division / GROUP;
RUN;
TITLE ;
%efig;


/****************************************************************************** 
Example 6 - Specifying Statistics
*****************************************************************************/
%sfig(16_stats);
TITLE "Compute N, PCTN, sum and mean patents, mean income";
PROC REPORT DATA = patents SPANROWS;
	COLUMN region division N PCTN patents,(SUM MEAN) income ;
	DEFINE region / GROUP;
	DEFINE division / GROUP;
	DEFINE patents / ANALYSIS "Patents" ;
	DEFINE income / ANALYSIS MEAN "Ave Income" F=DOLLAR10. ;
	DEFINE PCTN / "Percent" F=PERCENT8.1;
	DEFINE MEAN / "Mean" F=COMMA10.1;
	DEFINE SUM / "Sum" F=COMMA10.;
RUN;
TITLE ;
%efig;

/****************************************************************************** 
Example 7 - Summary Report with ACROSS usage
*****************************************************************************/
%sfig(16_across);
TITLE "ACROSS usage for EDU25";
PROC REPORT DATA = patents SPANROWS;
	COLUMN region division N edu25 patents  ;
	DEFINE region / GROUP;
	DEFINE division / GROUP;
	DEFINE edu25 / ACROSS;
	DEFINE patents / "Patents" F=COMMA15.;
RUN;
TITLE ;
%efig;

/****************************************************************************** 
Example 8 - Single ANALYSIS variable nested with ACROSS variable
*****************************************************************************/
%sfig(16_across_nest1);
TITLE "ACROSS=edu25, statistics within groups";
TITLE2 "edu25,patents";
PROC REPORT DATA = patents SPANROWS;
	COLUMN region division N edu25,patents  ;
	DEFINE region / GROUP;
	DEFINE division / GROUP;
	DEFINE edu25 / ACROSS;
	DEFINE patents /  F=COMMA15.;
RUN;
TITLE2 ;
TITLE ;
%efig;

%sfig(16_across_nest2);
TITLE "ACROSS=edu25, statistics within groups";
TITLE2 "patents,edu25 ";
PROC REPORT DATA = patents SPANROWS;
	COLUMN region division N patents,edu25  ;
	DEFINE region / GROUP;
	DEFINE division / GROUP;
	DEFINE edu25 / ACROSS;
	DEFINE patents / " " F=COMMA15.;
RUN;
TITLE2;
TITLE ;
%efig;

/****************************************************************************** 
Example 9 - Multiple ANALYSIS variables nested with ACROSS variable
*****************************************************************************/
%sfig(16_across_multnest);
TITLE "ACROSS=edu25, single statistics for patents and income";
PROC REPORT DATA = patents SPANROWS;
	COLUMN region division N edu25,(patents income)  ;
	DEFINE region / GROUP;
	DEFINE division / GROUP;
	DEFINE edu25 / ACROSS;
	DEFINE patents / "Patents" SUM  F=COMMA15.;
	DEFINE income /  "Income" MEAN F=DOLLAR15.;
RUN;
TITLE ;
%efig;


/****************************************************************************** 
Example 10 - ACROSS variable with ANALYSIS variable, multiple statistics
*****************************************************************************/
TITLE "ACROSS=edu25, mutliple statistics for patents";
PROC REPORT DATA = patents SPANROWS;
	COLUMN region division N edu25,patents,(SUM MEAN)  ;
	DEFINE region / GROUP;
	DEFINE division / GROUP;
	DEFINE edu25 / ACROSS;
	DEFINE patents / "Patents"  F=COMMA15.;
RUN;
TITLE ;


TITLE "ACROSS=edu25, mutliple statistics for patents and income";
PROC REPORT DATA = patents SPANROWS;
	COLUMN region division N edu25,(patents income),(SUM MEAN)  ;
	DEFINE region / GROUP;
	DEFINE division / GROUP;
	DEFINE edu25 / ACROSS;
	DEFINE patents / "Patents"  F=COMMA15.;
RUN;
TITLE ;


/****************************************************************************** 
Example 11 - Breaks
*****************************************************************************/
%sfig(16_breaks);
TITLE "Creates summary lines, overall and by region";
PROC REPORT DATA = patents SPANROWS;
	COLUMN region division N patents income ;
	DEFINE region / GROUP;
	DEFINE division / GROUP;
	DEFINE patents / ANALYSIS "Patents" F=COMMA10. ;
	DEFINE income / ANALYSIS MEAN "Ave Income" F=DOLLAR10.;
	BREAK AFTER region / SUMMARIZE;
	RBREAK AFTER / SUMMARIZE;
RUN;
TITLE ;
%efig;


/****************************************************************************** 
Example 12 - More
*****************************************************************************/
*create format for edu25 variable;
PROC FORMAT ;
	VALUE yn 1="Yes" 0="No" ;
RUN;

%sfig(16_more);
TITLE "Number of Patents";
PROC REPORT DATA = patents NOWD; *NOWD option allows me to print to pdf;
	COLUMN region  patents, edu25, (N SUM MEAN) sumdiff ;
	DEFINE region / "Region" GROUP ;
	DEFINE edu25 / ACROSS ">=25% with Bachelor's degree" F=yn. ORDER=data;
	DEFINE patents / " " ANALYSIS;
	DEFINE SUM / "Sum" F=COMMA12.;
	DEFINE MEAN / "Mean" F=COMMA6.1;
	*calculate difference in sums;
	DEFINE sumdiff / COMPUTED F=COMMA12. "Difference in Sums" STYLE(column)={backgroundcolor=PaleGreen};
	COMPUTE sumdiff;
		sumdiff=_C3_ - _C6_;
	ENDCOMP;
	*include row for overall total;
	*DOL stands for Double Over Line;
	RBREAK AFTER / SUMMARIZE DOL style(summary)={backgroundcolor=LightSkyBlue};
	COMPUTE AFTER ;
		region="All";
	ENDCOMP;
RUN;
TITLE;
%efig;



