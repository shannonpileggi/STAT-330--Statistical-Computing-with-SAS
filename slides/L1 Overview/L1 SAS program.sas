/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 1 SAS Program
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

*%LET path = C:/Users/spileggi/Google Drive/STAT 330/Lectures F17/Figures/;

/*------------------------------------------------------------------ PART 1 */
/* Input data */
DATA grades;
   INPUT name $ exam1 exam2 exam3;
   DATALINES;
   Shannon      96    82    83
   Lex          92    81    68
   Becky        92    75    73
   ;
RUN;


ods html close; ods html;


/* Print data */
*ods pdf file="&path.L1_procprint.png" ;
*options nodate nonumber;
PROC PRINT DATA = grades;
RUN;
*ods pdf close;

  
/*------------------------------------------------------------------ PART 2 */
*Identify three errors in the code below;
DAT grades;
   INPUT name $ exam1 exam2 exam3;
   DATALINES;
   Shannon      96    82    83
   Lex          92    81    68
   Becky        92    75    73
   ;
RUN

PROC PRINT DATA = grade;
RUN;
