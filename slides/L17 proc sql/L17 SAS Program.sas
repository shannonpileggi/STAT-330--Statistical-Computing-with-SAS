/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 17 SAS Program
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
Example 1 - Getting started with PROC SQL
*****************************************************************************/

*print all variables with *;
*Note that variable labels are applied by default;
TITLE "View data from West Virginia";
PROC SQL ;
	SELECT *
	FROM patents
	WHERE state = "WEST VIRGINIA"
	;
QUIT;
TITLE;


*select a few variables to print;
%sfig(17_select);
TITLE "View 4 variables for West Virginia";
PROC SQL ;
	SELECT region, division, county, patents
	FROM patents
	WHERE state = "WEST VIRGINIA"
	;
QUIT;
TITLE;
%efig;


/****************************************************************************** 
Example 2 - calculating a new variable
*****************************************************************************/

TITLE "Create new variable for popn per 10,000";
PROC SQL ;
	SELECT region, division, county, patents, population, 
		   (population/10000) AS pop10k
	FROM patents
	WHERE state = "WEST VIRGINIA"
	;
QUIT;
TITLE;


/****************************************************************************** 
Example 3 - using WHERE with a calculated variable
*****************************************************************************/

%sfig(17_calculate);
TITLE "View data where pop10k>10";
PROC SQL ;
	SELECT  county, patents, population, 
		   (population/10000) AS pop10k
	FROM patents
	WHERE state = "WEST VIRGINIA" AND calculated pop10k > 10
	;
QUIT;
TITLE;
%efig;

/****************************************************************************** 
Example 4 - labeling and formatting
*****************************************************************************/
TITLE "Apply labels and formats";
PROC SQL ;
	SELECT region, division, county, patents LABEL = "Patents", 
           population FORMAT = COMMA15. LABEL = "Population", 
           (population/10000) AS pop10k LABEL = "Popn per 10,000" FORMAT = COMMA9.4
	FROM patents
	WHERE state = "WEST VIRGINIA"
	;
QUIT;
TITLE;


/****************************************************************************** 
Example 5 - create new variable with conditional logic
*****************************************************************************/
%sfig(17_case);
TITLE "Create size variable";
PROC SQL ;
	SELECT region, division, county, patents LABEL = "Patents", 
           population FORMAT = COMMA15. LABEL = "Population", 
		   CASE 
		   		WHEN population LE 70000 THEN "small"
				WHEN population BETWEEN 70001 AND 120000 THEN "medium"
				ELSE "large"
		   END AS size
	FROM patents
	;
QUIT;
TITLE;
%efig;


*use calculated variable with case;
TITLE "Create size variable based on calculated variable";
PROC SQL ;
	SELECT region, division, county, patents LABEL = "Patents", 
           population FORMAT = COMMA15. LABEL = "Population", 
           (population/10000) AS pop10k LABEL = "Popn per 10,000" FORMAT = COMMA15.4,
		   CASE 
		   		WHEN CALCULATED pop10k LE 7 THEN "small"
				WHEN CALCULATED pop10k GT 7 AND CALCULATED pop10k LE 12 THEN "medium"
				ELSE "large"
		   END AS size
	FROM patents
	WHERE state = "WEST VIRGINIA" and CALCULATED size = "medium"
	ORDER BY patents
	;
QUIT;
TITLE;

/****************************************************************************** 
Example 6 - Summarizing data with COUNT
*****************************************************************************/
%sfig(17_count);
TITLE "COUNT(county), group by region" ;
PROC SQL;
	SELECT region, COUNT(county) AS NumCounties
	FROM patents 
	GROUP BY region
	;
QUIT;
TITLE;
%efig;

/****************************************************************************** 
Example 7 - Counting missing/non-missing values values
*****************************************************************************/

TITLE "PROC MEANS - identify number of missing values for asian";
PROC MEANS DATA = patents N NMISS ;
	VAR asian ;
	CLASS region ;
RUN;
TITLE;

%sfig(17_count2);
TITLE "PROC SQL - identify number of missing values for asian" ;
PROC SQL ;
	SELECT region,
           COUNT(asian) AS N1, /*gives non-missing values*/
	       NMISS(asian) AS N2  /*gives missing values*/
	FROM patents
	GROUP BY region
	;
QUIT;
TITLE;
%efig;



/****************************************************************************** 
Example 8 - Summarizing data with other functions
*****************************************************************************/
%sfig(17_stats);
TITLE "Getting more summary stats";
PROC SQL ;
	SELECT region, 
		   COUNT(county) AS N,
		   SUM(patents) AS TotP,
		   MEAN(patents) AS AveP
	FROM patents
	GROUP BY region
	;
QUIT;
TITLE;
%efig;


/****************************************************************************** 
Example 9 - Multiple groupings
*****************************************************************************/
%sfig(17_multgroup);
TITLE "Multiple groupings - COUNT(county), group by region, division" ;
PROC SQL ;
	SELECT region, division, COUNT(county) AS N
	FROM patents
	GROUP BY region, division
	;
QUIT;
TITLE;
%efig;


%sfig(17_multgroup2);
TITLE "Multiple groupings - COUNT(county), group by region, edu25" ;
PROC SQL;
	SELECT region,edu25,
		   COUNT(county) AS N,
		   SUM(patents) AS TotPatents,
		   MEAN(patents) AS AvePatents
	FROM patents
	GROUP BY region, edu25
	;
QUIT;
TITLE;
%efig;

/****************************************************************************** 
Example 10 - sorting
*****************************************************************************/
%sfig(17_order);
TITLE "View 2 variables for West Virginia, sorted by patents";
PROC SQL ;
	SELECT county, patents
	FROM patents
	WHERE state = "WEST VIRGINIA"
	ORDER BY patents
	;
QUIT;
TITLE;
%efig;


/****************************************************************************** 
Example 11 - create a data set
*****************************************************************************/
TITLE  ;
PROC SQL ;
	CREATE TABLE wv AS
	SELECT region, division, county, patents
	FROM patents
	WHERE state = "WEST VIRGINIA"
	ORDER BY patents
	;
QUIT;
TITLE;

TITLE "West Virginia data set created by sql" ;
PROC PRINT DATA = wv; RUN;
TITLE;

/****************************************************************************** 
Example 12 - identify number of unique values
*****************************************************************************/
TITLE "Midwest counties, sorted";
PROC SQL ;
	SELECT region, state, county
	FROM patents
	WHERE region = "Midwest"
	ORDER BY county 
	;
QUIT;
TITLE ;

%sfig(17_distinct1);
TITLE "Identify number of unique county names within region" ;
PROC SQL ;
	SELECT region,
		   COUNT(county) AS N1,
		   COUNT(DISTINCT county) AS N2
	FROM patents
	GROUP BY region 
	;
QUIT;
TITLE;
%efig;

/****************************************************************************** 
Example 13 - identify unique values
*****************************************************************************/
%sfig(17_distinct2);
TITLE "Unique county names in Midwest";
PROC SQL ;
	SELECT DISTINCT county
	FROM patents
	WHERE region = "Midwest"
	ORDER BY county 
	;
QUIT;
TITLE ;
%efig;

TITLE "Unique county names in each region";
PROC SQL ;
	SELECT DISTINCT region, county
	FROM patents
	GROUP BY region
	ORDER BY region, county 
	;
QUIT;
TITLE ;

