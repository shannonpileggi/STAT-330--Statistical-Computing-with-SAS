/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 16
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
You've already learned about the power of PROC TABULATE to produce a table
of summary statistics.  In this lesson we'll learn yet another alternative, 
PROC REPORT.

PROC REPORT behaves like PROC PRINT, in that it can be used to display 
rows of a data set.

PROC REPORT also behaves like PROC MEANS, PROC FREQ, and PROC TABULATE in that
it can be used to obtain summary statistics.

With PROC REPORT, the user can also control additional formatting/display 
options like with PROC TABULATE. 

For demonstratation purposes, we are again going to be working with the 
patents.sas7bdat data set.  This data reports the number of utility patent 
('patents for inventions') grants from 2011 for counties in the US, in addition
to some demographic variables about the county.
- Modify the libname statement to the directory of your SAS data sets.
- Submit the following data step to create some additional variables.
******************************************************************************/

LIBNAME flash "C:\Users\spileggi\Google Drive\STAT 330\Data";

*create a temporarary data set called patents - work with this data set 
for the remainder of the exercsies;
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

*view variables in patents data set;
PROC CONTENTS DATA = patents VARNUM; 
RUN;

*view first 10 observations;
PROC PRINT DATA = patents (OBS = 10); 
RUN;

/****************************************************************************** 
The syntax for PROC REPORT is:

PROC REPORT DATA = dataset ;
	COLUMN var1 var2...  ;
	DEFINE var1 / options ;
	DEFINE var2 / options ;
RUN;

Let's compare some ways to view the patents data for counties in Arizona (just
to keep the output short).
******************************************************************************/

*First method - proc print;
PROC PRINT DATA = patents;
	WHERE state = "ARIZONA";
RUN;

*Second method - proc report;
PROC REPORT DATA = patents;
	WHERE state = "ARIZONA";
RUN;

/****************************************************************************** 
Compare the two pieces of output.  

With PROC PRINT
  - rows are labeled with observation number
  - variable names are used as column headers

With PROC REPORT
  - no row labels
  - variable labels are used as column headers
  - you might also see some text wrapping in cells

By default, if no COLUMN statement is specfied, then PROC REPORT prints all
variables in the data set.  To specify the variables to be printed, use
the COLUMN statement.
******************************************************************************/

*First method - specify variables using VAR in proc print;
PROC PRINT DATA = patents;
	WHERE state = "ARIZONA";
	VAR county state patents population;
RUN;

*Second method - specify variables using COLUMN in proc report;
PROC REPORT DATA = patents;
	WHERE state = "ARIZONA";
	COLUMN county state patents population;
RUN;


/****************************************************************************** 
Now let's summarize the data instead of viewing observations.  How many 
patent-holding counties are there in each region?  The first two methods
(PROC FREQ and PROC TABULATE) you already saw in HW15.  

A third method is to use PROC REPORT with a DEFINE statement.  DEFINE 
  - tells SAS how to treat the variable
  - requires an option: ACROSS, ANALYSIS, COMPUTED, DISPLAY, GROUP, ORDER

This objective can be achieved by using ACROSS, which places values in columns.
******************************************************************************/
TITLE "One-way table - proc freq";
PROC FREQ DATA = patents;
	TABLES region;
RUN;
TITLE ;

TITLE "One-way table - proc tabulate";
PROC TABULATE DATA = patents; 
	CLASS region;
	TABLE region; 
RUN;
TITLE ;

TITLE "One-way table - proc report";
PROC REPORT DATA = patents; 
	COLUMNS region  ;
	DEFINE region / ACROSS  ; 
RUN;
TITLE ;

/****************************************************************************** 
Let's create a two-dimensional table that shows the number counties with 
patents with regards to region and edu25.  The first two methods
you saw already in HW15.  

To create a two-way table in PROC REPORT that mimics the PROC FREQ and PROC
TABULATE output, we want
 - values of edu25 in the columns (use ACROSS option in DEFINE)
 - values of region along the rows (use GROUP option in DEFINE)
******************************************************************************/

TITLE "Two-way table  - proc freq";
PROC FREQ DATA = patents;
	TABLES region*edu25 / NOROW NOPERCENT NOCOL;
RUN;
TITLE ;

TITLE "Two-way table  - proc tabulate";
PROC TABULATE DATA = patents; 
	CLASS region edu25;
	TABLE region, edu25; 
RUN;
TITLE ;

TITLE "Two-way table  - proc report";
PROC REPORT DATA = patents; 
	COLUMNS region edu25 ;
	DEFINE region / GROUP;  *group for rows;
	DEFINE edu25  / ACROSS; *across for columns; 
RUN;
TITLE ;

/****************************************************************************** 
Note that you can have an unlimited number of DEFINE statements.

Before we obtained the *number of counties* with utility patent grants.  But 
each county has a different *number of patents*.  So how many patents do these 
regions have?

Below, are two methods we already learned (PROC MEANS and PROC TABULATE).
******************************************************************************/

TITLE "Total # patents by region/edu25 - proc means";
PROC MEANS DATA = patents N SUM;
	CLASS region edu25;
	VAR patents;
RUN;
TITLE ;

TITLE "Total # patents by region/edu25 - proc tabulate";
PROC TABULATE DATA = patents; 
	CLASS region edu25;
	VAR patents;
	TABLE region, edu25*patents*(N sum); 
RUN;
TITLE ;

/****************************************************************************** 
Now let's achieve the same objective with PROC REPORT.
 - Patents is a numeric variable in the data set and is defined as an ANALYSIS variable 
   for PROC TABULATE (which means we want to calculate statistics for this variable).
   The default summary statistic produced is SUM.
 - To also produce the sample size for each combination of region/edu25, we 
   need to place N on the COLUMNS statement
 - Since edu25 utlizes the GROUP option (goes along rows), this produces a vertical
   orientation of the table similar to PROC MEANS.
******************************************************************************/
TITLE "Total # patents by region/edu25 - proc report";
TITLE2 "edu25 in GROUP";
PROC REPORT DATA = patents; 
	COLUMNS region edu25 N patents ;
	DEFINE region / GROUP; *group for rows;
	DEFINE edu25  / GROUP; *group for rows;
	DEFINE patents / ANALYSIS; *analysis to get a statistic from a numeric variable;
	*define patents / analysis SUM; *the demonstrates how to explicitly request a statistic; 
RUN;
TITLE ;
TITLE2 ;


/****************************************************************************** 
The default summary statistic produced for an analysis variable is SUM.
To explicitly specify this statistic, or a different statistic, we could use 
	DEFINE patents / analysis SUM;
******************************************************************************/


/****************************************************************************** 
Now it is your turn to practice:

Using PROC REPORT, create table with:
   -geographical region along the rows
   -geographical division along the rows (should appear nested within region)
   -the following statistics under the columns:
		~number of counties
		~total number of patents
		~total population size
		~average age (This will display as Median Age in your table because
         the variable age represents the median age of the county - you want to
		 calculate the average of the median ages.) 

Your PROC REPORT table should looks something like this:
                                                               
                                                            Number of Population     Median
      region     division                                N    patents   estimate        Age

      Midwest    East North Central                    138      13126   37969602  38.406522
                 West North Central                     55       5630   12446268  35.394545
      Northeast  Middle Atlantic                       100      13841   39009873     40.312
                 New England                            37       8656   13369711  40.943243
      South      East South Central                     64       1601   11272651    37.4375
                 South Atlantic                        192      11427   50738460  38.633854
                 West South Central                     92       8050   29389346         35
      West       Mountain                               52       6876   18725147  35.319231
                 Pacific                                78      34771   48290623  37.591026

******************************************************************************/


*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;






/****************************************************************************** 
Compare your PROC REPORT output to the 'equivalent' PROC MEANS  and PROC
TABULATE output.  What do you see as pros and cons of the different methods?  
******************************************************************************/





