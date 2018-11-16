/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 17
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
PROC SQL is a powerful procedure that can singlehandly perform tasks that 
previously required the use of multiple data steps and/or procs.  

The general syntax for PROC SQL is:


PROC SQL;
	SELECT column(s)
	FROM table(s) | view(s)
	WHERE expression
	GROUP BY column(s)
	HAVING expression
	ORDER BY column(s)
	;
QUIT;

Only the SELECT and FROM clauses are required; all other are optional.

Terminology between standard SAS and SQL differs a bit:
------------------------
SAS				SQL
------------------------
Data Set		Table
Observation 	Row
Variable		Column
------------------------

To get started, let's work with a small data set called grades.
******************************************************************************/

DATA grades;
INPUT name $ section test1 test2 test3;
DATALINES;
Sue   1  79 82 85
Mary  1  92 77 89 
Colt  1  64 85 92 
Bob   2  95 89 93 
Beth  2  87 92 97 
Jim   2  75 93 79
RUN;

*View entire data set;
TITLE "Proc Print";
PROC PRINT DATA = grades;
RUN;
TITLE;

*Equivalent sql code to view entire data set;
TITLE "Proc SQL";
PROC SQL;
	SELECT *
	FROM grades
	;
QUIT;
TITLE;

/****************************************************************************** 
The asterisk (*) on the SELECT statement is used to select ALL variables. 
On the FROM line we state the data set name (aka, table).

To view certain columns, specify the variable names, separated by a comma, in 
the select statement.
******************************************************************************/

*View name and test1 for all rows;
TITLE "Proc Print";
PROC PRINT DATA = grades;
	VAR name test1;
RUN;
TITLE;

*Equivalent sql code to view name and test1 for all rows;
TITLE "Proc SQL";
PROC SQL;
	SELECT name, test1
	FROM grades
	;
QUIT;
TITLE;

/****************************************************************************** 
Now let's do something more complex:
	1. calculate the average test score;
	2. order the observations by their average test score
	3. display the data set for section 1 only

Here is how we can do this with standard SAS:
******************************************************************************/

DATA grades2;
	SET grades;
	ave_test = MEAN(OF test1 test2 test3);
RUN;

PROC SORT DATA = grades2 OUT = grades_sorted;
	BY ave_test;
RUN;

TITLE "data step, then sort, then print";
PROC PRINT DATA = grades_sorted; 
	WHERE section = 1;
RUN;
TITLE;

/****************************************************************************** 
In standard SAS, this took three steps!  One data step and two procs.

Let's duplicate these efforts using PROC SQL.  Here,
--On the SELECT clause, we use a comma to separate ALL existing variables (*)
  and a new variable that we caculate.  The syntax here is
		  (expression) AS newvariable
--On the FROM clause, we specify the data set we are using
--On the WHERE clause, we specify the desired subset of observations
--Lastly, we use ORDER BY to display the observations sorted by the average 
  test score
******************************************************************************/

TITLE "Proc SQL";
PROC SQL;
	SELECT *, ((test1+test2+test3)/3) AS ave_test
	FROM grades
	WHERE section = 1
	ORDER BY ave_test 
	;
QUIT;
TITLE;


/****************************************************************************** 
Now it's your turn to practice.  Use PROC SQL to
--The instructor wants to curve the three test grades by 3, 5, and 7 points,
  respectively.  Create three new variables for the three updated test scores.
--Display the test scores sorted by the updated test 3 grade.

Your output should look something like this:


         name       section     test1     test2     test3  test1new  test2new  test3new
         ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
         Jim              2        75        93        79        78        98        86
         Sue              1        79        82        85        82        87        92
         Mary             1        92        77        89        95        82        96
         Colt             1        64        85        92        67        90        99
         Bob              2        95        89        93        98        94       100
         Beth             2        87        92        97        90        97       104


******************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;
