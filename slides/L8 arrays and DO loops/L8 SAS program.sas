/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 8 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

*macro debugging options ;
OPTION MPRINT MLOGIC SYMBOLGEN ;

*macro variable for figure locations;
%LET dir = C:\Users\spileggi\Google Drive\STAT 330\Lectures\Figures\ ;

%MACRO sfig(qn);
ods pdf file="&dir.L&qn..pdf" style=HTMLBlue ;
options nodate nonumber ;
%MEND ;

%MACRO efig;
ods pdf close;
%MEND ;



/*---------------------------------------------------Implicit vs explicit OUTPUT*/

*This data step has an *implicit* OUTPUT statement right before the RUN ;
DATA example1 ;
    DO i = 1 TO 4 ;
    END ;
RUN ;

TITLE "Implicit output" ;
PROC PRINT DATA = example1 ;
RUN ;
TITLE ;

*This data step has an *explicit* OUTPUT statement right before the RUN ;
DATA example2 ;
    DO i = 1 TO 4 ;
    END ;
	OUTPUT ;
RUN ;

%sfig(8_ex2);
TITLE "Explicit OUTPUT, between END and RUN" ;
PROC PRINT DATA = example2 ;
RUN ;
TITLE ;
%efig;


/*------------------------------------------OUTPUT statement inside of DO loop*/

*The OUTPUT statement has been moved to *inside* the DO loop;
DATA example3 ;
    DO i = 1 TO 4 ;
		OUTPUT ;
    END ;
RUN ;

%sfig(8_ex3);
TITLE "Explicit OUTPUT, between DO and END" ;
PROC PRINT DATA = example3 ;
RUN ;
TITLE ;
%efig ;


/*-------------------------------------------------On your own!*/

*How could you modify the example3 code to show each iteration of 
i AND the last value of i?;
DATA example4 ;
    DO i = 1 TO 4 ;
		OUTPUT ;
    END ;
RUN ;

PROC PRINT DATA = example4 ;
RUN ;



/*----------------------------------------------Nested DO loops*/

DATA example5 ;

	*outer loop ;
	DO i = 1 TO 3;

		*inner loop ;
		DO j = "A","B" ;
			
			*increment x by 1 ;
			x + 1 ;
			
		*end inner loop ;
		END ;
        OUTPUT ;

	*end outer loop ;
	END ;

RUN ;


PROC PRINT DATA = example5 ;
RUN ;



/*--------------------------DO WHILE / DO UNTIL retirement example */
DATA retire ;

	*initialize values of savings, income, and year ;
	savings = 0 ;
	income = 60000 ;
	year = 0 ;

	DO UNTIL (savings >= 500000) ;
    /*----------------------------*/
    /*    WORKS EQUIVALENTLY      */
    /*DO WHILE (savings < 500000);*/
    /*----------------------------*/
		*increment year by 1 ;
		year = year + 1 ;
		*add 10% of income to savings ;
		savings = savings + income*.10 ;
		*increase income by 2% ;
		income = income + income*.02 ;

		OUTPUT ;
	END ;

RUN ;

PROC PRINT DATA = retire ;
RUN ;


/*------------------------------------------------On your own */
*What is the value of x at the completion of this DATA step? ;
DATA example6 ;
   x = 15;
   DO WHILE(x > 12) ;
      x + 1 ;
   END ;
RUN ;

PROC PRINT DATA = example6 ;
RUN ;


/*------------------------------------------------On your own */
*Suppose I wanted to generate the sequence of numbers 1, 4, 8, 16.  
Which line of code would achieve this?;
/*
DO UNTIL (x < 4) ;
DO WHILE (x < 4) ;
DO UNTIL (x = 5) ;
DO WHILE (x = 5) ;
*/

%MACRO try_line(line) ;
DATA example7 ;
	x = 0 ;
	    &line;
		x = x + 1 ;
		x_sq = x**2 ;
		OUTPUT ;
	END ;
RUN ;

TITLE "&line" ;
PROC PRINT DATA = example7 ; 
RUN ;
TITLE ;
%MEND ;

%try_line(DO UNTIL (x < 4) ;);
%try_line(DO WHILE (x < 4) ;);
%try_line(DO UNTIL (x = 5) ;);
%try_line(DO WHILE (x = 5) ;);
%try_line(DO i =  1 to 4 ;);


DATA check ;
		x = 0 ;
		output ;
	    DO WHILE (x < 4) ;
		x = x + 1 ;
		x_sq = x**2 ;
		OUTPUT ;
	END ;
RUN ;

proc print; run;

/*--------------------------------Grades data for ARRAYS*/

DATA grades;
   INPUT name $ exam1 exam2 exam3;
   DATALINES;
   Shannon      96    82    83
   Lex          92    81    68
   Becky        92    75    73
   Lora         94    65    70
   Susan        91    77    85
   Hunter       76    72    86
   Ulric        98    71    80
   Richann      90    60    60
   Tim          97    94   100
   Ronald        .    77    60
   ;
RUN;

PROC PRINT DATA = grades ;
RUN ;


/*--------------------------------No arrays - create letter grade*/
DATA grades2 ;
	SET grades ;

	*FOR EXAM1;
	IF exam1 = . THEN letter1 = " " ;
	ELSE IF exam1 <60 THEN letter1 = "F";
	ELSE IF 60 <= exam1 < 70 THEN letter1 = "D";
	ELSE IF 70 <= exam1 < 80 THEN letter1 = "C";
	ELSE IF 80 <= exam1 < 90 THEN letter1 = "B";
	ELSE IF 90 <= exam1 THEN letter1 = "A";

	/*Repeat code chunk for exam2*/
	IF exam2 = . THEN letter2 = " " ;
	ELSE IF exam2 <60 THEN letter2 = "F";
	ELSE IF 60 <= exam2 < 70 THEN letter2 = "D";
	ELSE IF 70 <= exam2 < 80 THEN letter2 = "C";
	ELSE IF 80 <= exam2 < 90 THEN letter2 = "B";
	ELSE IF 90 <= exam2 THEN letter2 = "A";

	/*Repeat code chunk for exam 3*/
	IF exam3 = . THEN letter3 = " " ;
	ELSE IF exam3 <60 THEN letter3 = "F";
	ELSE IF 60 <= exam3 < 70 THEN letter3 = "D";
	ELSE IF 70 <= exam3 < 80 THEN letter3 = "C";
	ELSE IF 80 <= exam3 < 90 THEN letter3 = "B";
	ELSE IF 90 <= exam3 THEN letter3 = "A";

RUN ;

PROC PRINT DATA = grades2 ;
RUN ;


/*--------------------------------With arrays - create letter grade*/
DATA grades2 ;
	SET grades ;

	*Numeric array, existing variables ;
	ARRAY scores (*) exam: ;

	*Character array, new variables ;
	ARRAY letters (3) $ ;

	DO i = 1 TO DIM(SCORES) ;
		IF scores(i) = . THEN letters(i) = " " ;
		ELSE IF scores(i) <60 THEN letters(i) = "F";
		ELSE IF 60 <= scores(i) < 70 THEN letters(i) = "D";
		ELSE IF 70 <= scores(i) < 80 THEN letters(i) = "C";
		ELSE IF 80 <= scores(i) < 90 THEN letters(i) = "B";
		ELSE IF 90 <= scores(i) THEN letters(i) = "A";
	END ;

RUN ;

PROC PRINT DATA = grades2 ;
RUN ;


/*--------------------------------A more complex array*/
DATA grades2 ;
	SET grades ;

	*Numeric array, existing variables ;
	ARRAY scores (*) exam: ;

	*Character array, new variables ;
	ARRAY letters (3) $ ;

	*this array contains constant character values ;
	ARRAY letter_values (6) $ (" " "F" "D" "C" "B" "A");

	*this array contains constant numeric values ;
	ARRAY grcuts (6) (0 60 70 80 90 100);

	DO i = 1 TO DIM(SCORES) ;
		
		DO j = 2 to 6 ;
			IF grcuts(j-1) <= scores(i) <= grcuts(j) 
			THEN letters(i) = letter_values(j) ;
		END ;
	END ;

RUN ;

*print all variables;
PROC PRINT DATA = grades2 ;
RUN ;

*print only name, exam grades, and letter grades ;
PROC PRINT DATA = grades2 ;
	VAR name exam: letters: ;
RUN ;
