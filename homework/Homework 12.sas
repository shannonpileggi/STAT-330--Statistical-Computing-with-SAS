/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 12
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
In the data set below, the observations correspond to two people.  The variables
represent savings for three different years.  
*****************************************************************************/

DATA demo ;
INPUT name $ year1 year2 year3 ;
DATALINES ;
Harry 100 200 300 
Sally 500 600 800 
;
RUN ;

PROC PRINT DATA = demo ;
RUN ;


/****************************************************************************** 
This data set may be a common format for storing data, but for standard 
statistical analysis we would actually need our data to be in "long" (or "tidy") 
format such that we only have one variable called savings and another variable 
called year.

PROC TRANSPOSE allows you to re-arrange your data.  This means that you can 
turn variables into observations, or observations into variables.

	OUT = name of new transponsed data set
	NAME = names a variable in TransposedData that contains VAR variables
	BY  = transposes groups (may require PROC SORT first)
	VAR  = lists variables to transpose 
	
*****************************************************************************/

PROC TRANSPOSE DATA = demo OUT = demo_tidy NAME = year;
    BY name ;
	VAR year1 year2 year3 ;
RUN ;

PROC PRINT DATA = demo_tidy;
RUN ;


/****************************************************************************** 
We can use the same procedure to turn our data back around into a "wide" 
format.  The only new option used here is 

ID = a variable in original data that names multiple variables in TransposedData
	
*****************************************************************************/

PROC TRANSPOSE DATA = demo_tidy OUT = original ;
	BY name ;
	VAR COL1 ;
	ID year ;
RUN ;

PROC PRINT DATA = original ;
RUN ;


/****************************************************************************** 
The sashelp.citiyr data set contains five types of population estimates of a 
city for the years 1980 - 1989.

(1) Write a one to three SAS procedures to familiarize yourself with the data.

(2) Convert the data from a "wide" to a "long" format.  That is, your new
    data set should have 50 obsevations (rows), such that there is a single
    column with the various population estimates.  Below is a comment
    with what my data looks like in case you want to confirm that you are on 
    right track.

(3) Print your "long" data.

*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;













/****************************************************************************** 

The "long" data results: 

         Obs    DATE    population                    _LABEL_                      COL1

           1    1980      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     227757
           2    1980      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    172456
           3    1980      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    138358
           4    1980      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    116869
           5    1980      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    110888
           6    1981      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     230138
           7    1981      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    175017
           8    1981      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    140618
           9    1981      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    118074
          10    1981      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    112064
          11    1982      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     232520
          12    1982      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    177346
          13    1982      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    142740
          14    1982      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    119275
          15    1982      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    113245
          16    1983      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     234799
          17    1983      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    179480
          18    1983      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    144591
          19    1983      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    120414
          20    1983      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    114385
          21    1984      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     237001
          22    1984      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    181514
          23    1984      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    146257
          24    1984      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    121507
          25    1984      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    115494
          26    1985      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     239279
          27    1985      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    183583
          28    1985      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    147759
          29    1985      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    122631
          30    1985      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    116648
          31    1986      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     241625
          32    1986      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    185766
          33    1986      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    149149
          34    1986      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    123795
          35    1986      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    117830
          36    1987      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     243942
          37    1987      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    187988
          38    1987      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    150542
          39    1987      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    124945
          40    1987      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    118997
          41    1988      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     246307
          42    1988      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    189867
          43    1988      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    152113
          44    1988      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    126118
          45    1988      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    120189
          46    1989      PAN         POPULATION EST.: ALL AGES, INC.ARMED F.     248762
          47    1989      PAN17       POPULATION EST.: 16 YRS AND OVER,INC ARM    191570
          48    1989      PAN18       POPULATION EST.: 18-64 YRS,INC.ARMED F.O    153695
          49    1989      PANF        POPULATION EST.: FEMALES,ALL AGES,INC.AR    127317
          50    1989      PANM        POPULATION EST.: MALES, ALL AGES, INC.AR    121445

*****************************************************************************/
