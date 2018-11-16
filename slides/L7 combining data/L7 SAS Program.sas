/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 7 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/*****************************************************************************
* Example 1: Stacking data
* Goal: combine multiple data sets that have the same variables
* How: use the SET statement to concatenate (or stack) the data sets
*****************************************************************************/

/*---------------------------------------------------Input data*/
DATA men ;
INPUT id name $ grade $ ;
DATALINES ;
1    Andrew     B+
3    Jimmy      B-
5    Ulric      A-
;
RUN ;


DATA women ;
INPUT id name $ grade $ ;
DATALINES ;
2    Soma       B
4    Karen      A
6    Beth       B+
;
RUN ;

TITLE "Men data" ;
PROC PRINT DATA = men ; 
RUN ;
TITLE ;

TITLE "Women data" ;
PROC PRINT DATA = women ; 
RUN ;
TITLE ;

/*---------------------------------------------------Stack data*/
DATA example1 ;
	SET men women ;
RUN ;

TITLE "Stacked data" ;
PROC PRINT DATA = example1; 
RUN;
TITLE ;

/*****************************************************************************
* Example 2: Interleaving data
* Goal: stack data while retaining some sort of order
* How: use the SET statement with BY (data must be pre-sorted)
*****************************************************************************/

*sort men data by id;
PROC SORT DATA = men ; 
	BY id ; 
RUN ;

*sort women data by id;
PROC SORT DATA = women ; 
	BY id ; 
RUN;

*set data by id;
DATA example2 ;
	SET men women;
	BY id ;
RUN ;

TITLE "Interleaved data";
TITLE2 "Note the order of observations compared to the stacked data";
PROC PRINT DATA = example2; 
RUN ;
TITLE ;
TITLE2 ;


/*****************************************************************************
* Example 3: stack data with same variables but different names
* How: use the rename option
*****************************************************************************/

*Note third variable is named grade;
DATA men ;
INPUT id name $ grade $ ;
DATALINES ;
1    Andrew     B+
3    Jimmy      B-
5    Ulric      A-
;
RUN ;


*Note third variable is named letter;
DATA women ;
INPUT id name $ letter $ ;
DATALINES ;
2    Soma       B
4    Karen      A
6    Beth       B+
RUN ;


TITLE "Men data" ;
PROC PRINT DATA = men ; 
RUN ;
TITLE ;

TITLE "Women data" ;
PROC PRINT DATA = women ; 
RUN ;
TITLE ;

*Stack the data without renaming;
DATA example3a ;
	SET men women ;
RUN ;

TITLE "Stacked data without renaming" ;
PROC PRINT DATA = example3a ; 
RUN ;
TITLE ;

*Stack the data with renaming;
DATA example3b ;
	SET men women (RENAME = (LETTER = GRADE)) ;
RUN ;

TITLE "Stacked data with renaming";
PROC PRINT DATA = example3b; 
RUN ;
TITLE ;


/*****************************************************************************
* Example 4: one to one merge
* How: use the MERGE statement BY identifying variables (data must be pre-sorted)
*****************************************************************************/

DATA men ;
INPUT id name $ grade $ ;
DATALINES ;
1    Andrew     B+
3    Jimmy      B-
5    Ulric      A-
;
RUN ;

DATA height_m ;
INPUT id height ;
DATALINES ;
1 68
3 69
5 72
;
RUN ;


TITLE "Men data" ;
PROC PRINT DATA = men ; 
RUN ;
TITLE ;

TITLE "Height data" ;
PROC PRINT DATA = height_m ; 
RUN ;
TITLE ;

*sort men data by id;
PROC SORT DATA = men; 
	BY id ; 
RUN ;

*sort height_m data by id;
PROC SORT DATA = height_m ; 
	BY id ; 
RUN ;

*merge by id;
DATA example4 ;
	MERGE men height_m ;
	BY id ;
RUN ;

TITLE "One to one merge" ;
PROC PRINT DATA = example4 ; 
RUN ;
TITLE ;

/*****************************************************************************
* Example 5: one to one merge when data sets have variables with the same name
* (which is not a key matching variable)
* How: delete/rename unwanted or duplicate variables
*****************************************************************************/

DATA men ;
INPUT id name $ grade $ ;
DATALINES ;
1    Andrew     B+
3    Jimmy      B-
5    Ulric      A-
;
RUN ;

DATA height_m ;
INPUT id height grade $ ;
DATALINES ;
1 68 F 
3 69 F
5 72 F
;
RUN ;


TITLE "Men data" ;
PROC PRINT DATA = men ; 
RUN ;
TITLE ;

TITLE "Height data" ;
PROC PRINT DATA = height_m ; 
RUN ;
TITLE ;

*sort men data by id;
PROC SORT DATA = men; 
	BY id; 
RUN;

*sort height_m data by id;
PROC SORT DATA = height_m ; 
	BY id ; 
RUN ;


*bad merge - grade variables will over-write;
*this may have unintended results;
DATA example5a ;
	MERGE men height_m ;
	BY id ;
RUN ;

TITLE "Bad Merge" ;
PROC PRINT DATA = example5a ; 
RUN ;
TITLE ;

*good merge - rename variables;
DATA example5b;
	MERGE men (RENAME = (grade = grade1))
          height_m (RENAME = (grade = grade2)) ;
	BY id ;
RUN ;

TITLE "Good Merge - variables re-named" ;
PROC PRINT DATA = example5b ; 
RUN ;
TITLE ;


*good merge - explicitly drop unwanted variable;
DATA example5c ;
	MERGE men
          height_m(drop=grade) ;
	BY id ;
RUN ;

TITLE "Good Merge - dropped F grades" ;
PROC PRINT DATA = example5c ; 
RUN ;
TITLE ;




/*****************************************************************************
* Example 6: merging when observations mismatch
*****************************************************************************/

*Note ID 8 does not correspond to an ID in height_m;
DATA men ;
INPUT id name $ grade $ ;
DATALINES ;
1    Andrew     B+
3    Jimmy      B-
5    Ulric      A-
8    Allan      B
;
RUN ;

*Note ID 10 does not correspond to an ID in men;
DATA height_m ;
INPUT id height ;
DATALINES ;
1  68 
3  69 
5  72 
10 70
; 
RUN ;


TITLE "Men data" ;
PROC PRINT DATA = men ; 
RUN ;
TITLE ;

TITLE "Height data" ;
PROC PRINT DATA = height_m ; 
RUN ;
TITLE ;


*sort men data by id;
PROC SORT DATA = men ; 
	BY id ; 
RUN ;

*sort height_m data by id;
PROC SORT DATA = height_m ; 
	BY id ; 
RUN ;

*merge with mismatch observations;
DATA example6 ;
	MERGE men height_m ;
	BY id ;
RUN ;

TITLE "Merge with mis-matched observtions" ;
PROC PRINT DATA = example6 ; 
RUN ;
TITLE ;

/*****************************************************************************
* Example 7: one to many merge
*****************************************************************************/

DATA prof ;
INPUT id name $ ;
DATALINES ;
1  Sklar
3  Doi 
4  Peck
;
RUN ;

DATA class ;
INPUT id class $ ;
DATALINES ;
1 Stat218
1 Stat417
3 Stat150
3 Stat330
3 Stat418
4 Stat251
4 Stat323
4 Stat423
;
RUN ;

TITLE "Prof data" ;
PROC PRINT DATA = prof ; 
RUN ;
TITLE ;

TITLE "Class data" ;
PROC PRINT DATA = class ; 
RUN ;
TITLE ;

*sort prof data by id;
PROC SORT DATA = prof ; 
	BY id ; 
RUN ;

*sort class data by id;
PROC SORT DATA = class ; 
	BY id ; 
RUN ;

*one to many merge;
DATA example7 ;
	MERGE prof class ;
	BY id ;
RUN ;

TITLE "One to many merge data" ;
PROC PRINT DATA = example7 ; 
RUN ;
TITLE ;


/*****************************************************************************
* Example 8: tracking observations
*****************************************************************************/

DATA members ;
INPUT ID state $ ;
DATALINES ;
101 NC
102 CA
103 CA
104 WI
105 NY
;
RUN ;

DATA orders ;
INPUT ID total ;
DATALINES ;
102 30.01
104 254.98
104 75.00
101 1600.56
102 385.30
;
RUN ;

TITLE "Members data" ;
PROC PRINT DATA = members ; 
RUN ;
TITLE ;

TITLE "Orders data" ;
PROC PRINT DATA = orders ; 
RUN ;
TITLE ;

PROC SORT DATA = members ; 
	BY id ; 
RUN ;

PROC SORT DATA = orders ; 
	BY id ; 
RUN ;

*all merged data;
*view tracking variables;
DATA all ;
	MERGE members (IN = a) orders (IN = b);
	BY id;
	checka = a;
	checkb = b;
RUN ;

TITLE "All data merged, with tracking variables" ;
PROC PRINT DATA = all ; 
RUN ;
TITLE ;


*track observations and only keep members that have not made an order;
DATA no_orders;
	MERGE members (IN = a) orders (IN = b);
	BY id;
	IF a AND not b;
RUN ;

TITLE "Members who have not made an order";
PROC PRINT DATA = no_orders ; 
RUN ;
TITLE ;
