/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 4 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

*%LET path = C:/Users/spileggi/Google Drive/STAT 330/Lectures/Figures/;


/*-------------------------------------------------------------EXAMPLE DATA */
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


/*------------------------------------------------Creating variables, part 1*/
DATA grades2 ;
	SET grades;

	*all students are assigned to section 70, as a numeric variable ;
	sec_num = 70 ;

	*all students are assigned to section 70, as a character variable ;
	sec_char = "70" ;

	*create a new variable that duplicates exam1 ;
	exam1_new = exam1;

	*create a new variable that contains all numeric missing values;
	miss_num = . ;

	*create a new variable that contains all character missing values;
	miss_char = " " ;

RUN ;

*ods pdf file="&path.L4_newvars.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC PRINT DATA = grades2 ;
RUN ;
*ods pdf close;

PROC CONTENTS DATA = grades2 VARNUM;
RUN ;


/*------------------------------------------------Creating variables, part 2*/
DATA grades2 ;
	SET grades;
	
	*compute average exam grade with mathematical expression ;
	ave_exam1 = (exam1 + exam2 + exam3)/3 ;

	*compute average exam grade with numeric function ;
	ave_exam2 =  MEAN(exam1, exam2, exam3) ;

RUN ;

*ods pdf file="&path.L4_means.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC PRINT DATA = grades2 ;
	WHERE name in ("Ronald", "Tim","Richann") ;
RUN ;
*ods pdf close;

/*---------------------------------------------------------Function example*/
DATA grades2 ;
	SET grades;
	
	first_letter = __________ ;	

RUN ;

*ods pdf file="&path.L4_firstletter.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC PRINT DATA = grades2 ;
RUN ;
*ods pdf close;


/*------------------------------------------------------------------IF/THEN*/
DATA grades2;
	SET grades;

	*create letter grade for exam 1;
	IF exam1 >=  90 THEN grade1 = "A";
    IF 80 <= exam1 < 90 THEN grade1 = "B";
    IF 70 <= exam1 < 80 THEN grade1 = "C";
    IF 60 <= exam1 < 70 THEN grade1 = "D";
    IF exam1 < 60 THEN grade1 = "F";

RUN; 

*ods pdf file="&path.L4_missingF.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC PRINT DATA = grades2;
RUN;
*ods pdf close;


/*---------------------------------------------------------------IF/THEN/ELSE*/
DATA grades2;
	SET grades;

	*create letter grade for exam 1;
	IF exam1 >=  90 THEN grade1 = "A";
    ELSE IF 80 <= exam1 < 90 THEN grade1 = "B";
    ELSE IF 70 <= exam1 < 80 THEN grade1 = "C";
    ELSE IF 60 <= exam1 < 70 THEN grade1 = "D";
    ELSE IF 0  <= exam1 < 60 THEN grade1 = "F";
	ELSE grade1 = " ";

RUN; 

PROC PRINT DATA = grades2;
RUN;


/*------------------------------------------------Multiple Condions Practice*/

DATA grades2;
	SET grades;

	IF 80 <= exam2 < 90 THEN grade1 = "B";

	IF exam1 ge 80 and exam1 lt 90 THEN grade2 = "B";
	IF exam1 in (80-90) THEN grade2 = "B";
 
RUN; 

*ods pdf file="&path.L4_multcondP.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC PRINT DATA = grades2;
RUN;
*ods pdf close;




/*---------------------------------IF/THEN/ELSE Multiple Actions and Conditions*/
DATA grades2;
	SET grades;

	*create letter grade for exam 1;
	IF exam1 >=  90 THEN grade1 = "A";
    ELSE IF 80 <= exam1 < 90 THEN grade1 = "B";
    ELSE IF 70 <= exam1 < 80 THEN grade1 = "C";
    ELSE IF 60 <= exam1 < 70 THEN grade1 = "D";
    ELSE IF 0  <= exam1 < 60 THEN grade1 = "F";
	ELSE grade1 = " ";

	*evaluate multiple conditions with AND;
	IF exam1 lt 80 and exam2 lt 80 THEN flag = "*  " ;
	ELSE flag = " " ;

	*evaluate multiple conditions with IN;
	IF grade1 in ("A", "B") THEN status = "honors" ;
	ELSE status = "other" ;

	*execute multiple actions with DO/END;
	IF exam1 = . and name = "Ronald" THEN DO ;
		exam1 = 0 ;
		flag = "***" ;
	END;

	ave_exam = MEAN(exam1, exam2, exam3) ;

RUN; 

*ods pdf file="&path.L4_ite.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC PRINT DATA = grades2;
RUN;
*ods pdf close;


/*----------------------------------------------------DROP/KEEP in DATA step*/
DATA grades2 ;
	SET grades;
	
	*compute average exam grade with numeric function ;
	ave_exam =  MEAN(exam1, exam2, exam3) ;

	DROP exam1 exam2 exam3;
RUN ;

*ods pdf file="&path.L4_drop.pdf" style=HTMLBlue;
*options nodate nonumber;
PROC PRINT DATA = grades2;
RUN;
*ods pdf close;


/*---------------------------------------------------------DROP/KEEP in PROC*/
DATA grades2 ;
   SET grades;
   ave_exam =  MEAN(exam1, exam2, exam3) ;
RUN ;

PROC PRINT DATA = grades2 (DROP = exam1 exam2 exam3) ;
RUN ;


/*---------------------------------------------------------  SUBSETTING */
DATA grades2 ;
	SET grades;
	
	*only retain observations where exam 1 grade exceeds 90;
	IF exam1 > 90 ;

   /*EQUIVALENT STATEMENTS*/
   *IF exam1 > 90 THEN OUTPUT ;
   *IF exam1 <= 90 THEN DELETE ;
   *WHERE exam1 > 90 ;
RUN ;

*ods pdf file="&path.L4_dataIF.pdf" style=HTMLBlue;
*options nodate nonumber;
TITLE "Subsetting in DATA step" ;
PROC PRINT DATA = grades2;
RUN ;
TITLE ;
*ods pdf close ;

/* OR this is equivalent to */
*ods pdf file="&path.L4_procWHERE.pdf" style=HTMLBlue;
*options nodate nonumber;
TITLE "Subsetting in PROC" ;
PROC PRINT DATA = grades;
	WHERE exam1 > 90 ;
RUN ;
TITLE ;
*ods pdf close ;

/*------------------------------------------------------  Additional WHERE examples */
DATA grades2 ;
	SET grades;
	
	*only retain observations where name has a capital S;
	WHERE name contains "S" ;
RUN ;

*ods pdf file="&path.L4_S.pdf" style=HTMLBlue;
*options nodate nonumber;
*TITLE "Subsetting in DATA step" ;
PROC PRINT DATA = grades2;
RUN ;
*TITLE ;
*ods pdf close ;

/*------------------------------------------------------  Subsetting to multiple DATA steps */
DATA gradesA gradesOther ;
	SET grades ;
	IF exam1 >= 90 THEN OUTPUT gradesA ;
	ELSE OUTPUT gradesOther ;
RUN ; 

*ods pdf file="&path.L4_gradesA.pdf" style=HTMLBlue;
*options nodate nonumber;
TITLE "PROC PRINT DATA = gradesA; RUN;" ;
PROC PRINT DATA = gradesA;
RUN ;
TITLE ;
*ods pdf close ;

*ods pdf file="&path.L4_gradesOther.pdf" style=HTMLBlue;
*options nodate nonumber;
TITLE "PROC PRINT DATA = gradesOther; RUN;" ;
PROC PRINT DATA = gradesOther;
RUN ;
TITLE ;
*ods pdf close ;
