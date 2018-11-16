/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 15
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
The following procedures can be used to get various summary statistics:
PROC PRINT - N, SUM
PROC MEANS - N, SUM, MEAN, STD, etc.
PROC FREQ  - N, percents

PROC TABULATE can compute all of these statistics in a SINGLE results table that 
allows the user to control additional formatting options. 

For demonstratation purposes, we are going to be working with the 
patents.sas7bdat data set.  This data reports the number of utility patent 
('patents for inventions') grants from 2011 for counties in the US, in addition
to some demographic variables about the county.
- ModIFy the libname statement to the directory of your SAS data sets.
- Submit the following data step to create some additional variables.
******************************************************************************/

LIBNAME flash "C:\Users\spileggi\Google Drive\STAT 330\Data\" ;

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

*view variables in patents data set;
PROC CONTENTS DATA = patents VARNUM; 
RUN;

*view first 10 observations;
PROC PRINT DATA = patents (OBS = 10); 
RUN;

/****************************************************************************** 
PROC TABULATE can create 1, 2, or 3 dimensional tables, and the default
summary statistic reported is N (counts).  The syntax is:

PROC TABULATE DATA = dataset ;
	CLASS catvar1 catvar2...  ;
	VAR quantvar1 quantvar2... ;
	TABLE page-var, row-var, col-var;
RUN;

Let's compare two ways to identify the number of counties with utility patent
grants.
******************************************************************************/

*First method - proc freq;
PROC FREQ DATA = patents;
	TABLES region;
RUN;

*Second method - proc tabulate;
*With ONE variable in the TABLE statement, the variable goes on the COLUMNS;
PROC TABULATE DATA = patents; 
	CLASS region;
	TABLE region; 
RUN;

*To request a statistic, do var*statistic on the TABLE statement;
*The default statistic is the count, N, so this PROC gives the same results
as the PROC above;
PROC TABULATE DATA = patents; 
	CLASS region;
	TABLE region*N; 
RUN;

/****************************************************************************** 
Let's create a two-dimensional table that shows how many counties with 
utility patent grants with regards to region and whether or not the county has 
at least 25% of the population with at least a bachelor's degree.
******************************************************************************/

*First method - proc freq;
PROC FREQ DATA = patents;
	TABLES region*edu25 / NOROW NOPERCENT NOCOL;
RUN;

*Second method - proc tabulate;
*With TWO variables in the TABLE statement, 
	-the first variable goes on the ROWS
	-the second variable goes on the columns;
PROC TABULATE DATA = patents; 
	CLASS region edu25;
	TABLE region, edu25; 
RUN;

*Again, the default statistic is the count, N, so this PROC gives the same results
as the PROC above;
PROC TABULATE DATA = patents; 
	CLASS region edu25;
	TABLE region, edu25*N; 
RUN;

/****************************************************************************** 
Note that ALL categoricical variables in the TABLE statement MUST also
go in the CLASS statement.

A limitation of PROC FREQ is that we can only request statistics for
categorical variables, like counts and percents.  In PROC TABULATE, we can
request statistics for quantitative variables, like means, standard deviations,
and sums.

When using a quantitative variable
-The quantitative variable must go in the VAR statement
-In the TABLE statement, the syntax is catvar*quantvar
-The default summary statistic is SUM

Before we obtained the *number of counties* with utility patent grants.  But each 
county has a different *number of utility patent grants*.  For example, if
you review the PROC PRINT output from above, you see that in Alabama, Baldwin
County has 8 patents and Calhoun County only has 1.  

So how many patents do these regions have?
******************************************************************************/

*One dimensional table that shows the total number of patents per region ;
*The syntax on the TABLE statement is 
TABLE catvar *  quantvar ;
PROC TABULATE DATA = patents; 
	CLASS region;
	VAR patents;
	TABLE region*patents; 
RUN;

*Because the default statistic is SUM, the above code is equivalent to this code;
*Note the syntax on the TABLE statement is
TABLE	catvar *  quantvar * statistic; 
PROC TABULATE DATA = patents; 
	CLASS region;
	VAR patents;
	TABLE region*patents*sum; 
RUN;

*To obtain both
-the number of counties per region, and
-the total number of patents per region
we need to request multiple statistics.  You can do that by placing multiple
statistic names in parentheses;
PROC TABULATE DATA = patents; 
	CLASS region;
	VAR patents;
	TABLE region*patents*(N sum); 
RUN;

*The three PROC TABULATEs that you submitted above are all still one-dimensional
tables!  You can still request statistics for two dimensional tables as well;
PROC TABULATE DATA = patents; 
	CLASS region edu25;
	VAR patents;
	TABLE region, edu25*patents*(N sum); 
RUN;


*Note that this PROC TABULATE is equivalent to the following PROC MEANS;
PROC MEANS DATA = patents N SUM;
	CLASS region edu25;
	VAR patents;
RUN;


/****************************************************************************** 
Now it is your turn to practice:

Using PROC TABULATE, create a two-dimenional table with:
   -geographical division along the rows
   -whether or not the county's unemployment rate exceeded 10% along the columns
   -the following statistics under the columns:
		~number of counties
		~total number of patents
		~average number of patents per county 

Lastly, use PROC MEANS to obtain the same results.
******************************************************************************/


*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;


