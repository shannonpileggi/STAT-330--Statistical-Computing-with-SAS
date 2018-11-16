/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 18 SAS Program
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
LIST AND COLUMN INPUT
-------------------------------------------------------------------------------*/

* Example 1 - list input ;
DATA cheese ;
	INFILE "&path.Data_cheese.dat" ;
	INPUT case taste acetic h2s lactic ;
RUN ;

PROC PRINT DATA = cheese ; 
RUN ;


* Example 2 - column input ;
DATA cheese2;
	INFILE "&path.Data_cheese.dat";
	INPUT case 1-2 taste 3-12 acetic 17-21 h2s 25-29 lactic 33-36;
RUN;

PROC PRINT DATA = cheese2; 
RUN;

*Example 3 - change input order;
DATA cheese3;
	INFILE "&path.Data_cheese.dat";
	INPUT lactic 33-36 case 1-2 taste 3-12 acetic 17-21 h2s 25-29 ;
RUN;

PROC PRINT DATA = cheese3; 
RUN;

*Example 4 - mix input methods;
DATA cheese4;
	INFILE "&path.Data_cheese.dat";
	INPUT case taste  acetic 17-21 h2s 25-29 lactic 33-36;
RUN;

PROC PRINT DATA = cheese4; 
RUN;


/*-------------------------------------------------------------------------------
FORMATTED INPUT
-------------------------------------------------------------------------------*/
*Example 1 - read in formatted data;
DATA test ;
INPUT name $11. money  DOLLAR10.2 ;
DATALINES ;
Constantine $15,000.35
Billy       $8,000.05
Sue         $3,000.63
Megan       $400.45
;
RUN ;

PROC PRINT DATA = test;
RUN;


*Example 2 - read in formatted data;
*Make a modification to make this work correctly.;
DATA test2;
INPUT name $11. money DOLLAR10.2 ;
DATALINES;
Constantine $15,000.35
Billy $8,000.05
Sue $3,000.63
Megan $400.45
;
RUN;

PROC PRINT DATA = test2;
RUN ;



*Example 3 - specifying column location ;
DATA homes;
	INFILE "&path.Data_homeprice.dat" ;
	INPUT price COMMA7. size 12-15 @23 age numfeat NEloc CustLab CorLoc tax ;
RUN;

PROC PRINT DATA = homes ;
RUN ;


/*-------------------------------------------------------------------------------
MORE ON MOVING THE POINTER
-------------------------------------------------------------------------------*/

*Example 1 - using a prefix pointer ;
DATA dogs;
	INFILE "&path.Data_dogs.dat" ;
	INPUT @"Name- " name $ @"Breed: " breed $ @"Bills: " spending COMMA6.2 ;
RUN;

PROC PRINT DATA = dogs ;
RUN ;

*Example 2 - line pointers ;
DATA mailing;
	INFILE "&path.mailing.dat";
	INPUT fname :$10. lname $ @"email: " email :$20. 
          / street &$30. 
	      / city &$30. state $2. zip ;
	/*this also works:
	INPUT fname :$10. lname $ @"email: " email :$20.
	#2 street &$30.
	#3 city &$30. state $2. zip ;
	*/
RUN;

PROC PRINT DATA = mailing ;
RUN ;

*Example 3 - double trailing @@;
*this data is about baggage fees for various airlines;
DATA baggage ;
	INFILE "&path.baggagefees.dat";
	INPUT rank airline &$20. revenue :COMMA. @@;
run;

PROC PRINT DATA = baggage ;
RUN ;


*Example 4 - single trailing @;
*this data is about potassium content of various foods;
*want to only retain observations with potassium (K) > 500;
DATA potassium ;
	INFILE "&path.potassium.dat" ;
	INPUT @21 K COMMA5. @ ;
	IF K < 500 THEN DELETE ;
	INPUT food $ 1-20 @28 weight measure &$10.;
RUN;

PROC PRINT DATA = potassium ;
RUN ;


/*-------------------------------------------------------------------------------
INFILE OPTIONS
-------------------------------------------------------------------------------*/

*Example 1 - using FIRSTOBS and OBS ;
DATA names ;
	INFILE "&path.names.txt" FIRSTOBS = 2 OBS = 5 ;
	INPUT fname $ lname $;
RUN;

PROC PRINT DATA = names ;
RUN ;

*Example 2 - FLOWOVER, MISSOVER, TRUNCOVER options;
%MACRO checkoptions(option);
DATA test;
	INFILE "&path.numbers.txt" &option;
	INPUT numbers 6.;
RUN;

TITLE "&option";
PROC PRINT; 
RUN;
TITLE ;
%MEND;

%checkoptions(flowover);
%checkoptions(missover);
%checkoptions(truncover);

*Example 3  - DSD, DLM options ;
DATA beer;
	INFILE "&path.beer.csv" DSD FIRSTOBS = 3 DLM = ",";
	INPUT country :$30. consumption change total;
RUN;

PROC PRINT DATA = beer ;
RUN ;
