/*****************************************************************************
* Name:        Shannon Pileggi
* Assignment:  Lecture 13 SAS Program
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
Get familiar with the data
-------------------------------------------------------------------------------*/

LIBNAME flash "&path";

PROC CONTENTS DATA = flash.cars VARNUM ; 
RUN;

*summary of quantitative variables ;
PROC MEANS DATA = flash.cars ;
	VAR price mileage liter ;
RUN ;

*summary of categorical variables ;
PROC FREQ DATA = flash.cars ;
	TABLES make type cylinder doors cruise sound leather ;
RUN ;



/*-------------------------------------------------------------------------------
ANOVA: y = price, x = cylinder
-------------------------------------------------------------------------------*/
*without MEANS statement;
PROC ANOVA DATA = flash.cars ;
   CLASS cylinder ;
   MODEL price=cylinder ;
QUIT ;


*with means statement ;
%sfig(13_anova);
PROC ANOVA DATA = flash.cars ;
   CLASS cylinder ;
   MODEL price = cylinder ;
   MEANS cylinder ;
QUIT ;
%efig;

/*-------------------------------------------------------------------------------
ANOVA: y = price, x = cylinder, multiple comparisons
-------------------------------------------------------------------------------*/
%sfig(13_anova_mc);
PROC ANOVA DATA = flash.cars ;
   CLASS cylinder ;
   MODEL price = cylinder ;
   MEANS cylinder / TUKEY HOVTEST ;
QUIT ;
%efig;


/*-------------------------------------------------------------------------------
ANOVA: y = price, x = cylinder, using PROC GLM
-------------------------------------------------------------------------------*/
PROC GLM DATA = flash.cars ;
   CLASS cylinder ;
   MODEL price = cylinder ;
QUIT ;


/*-------------------------------------------------------------------------------
Linear regression: y = price, x = mileage, using PROC REG
-------------------------------------------------------------------------------*/
%sfig(13_reg);
PROC REG DATA = flash.cars ;
   MODEL price = mileage ;
QUIT ;
%efig;

/*-------------------------------------------------------------------------------
Linear regression: y = price, x = mileage, using PROC GLM
-------------------------------------------------------------------------------*/
PROC GLM DATA = flash.cars ;
  MODEL price = mileage ;
QUIT ;


/*-------------------------------------------------------------------------------
Linear regression: y = price, x = mileage, using PROC REG
Other features of PROC REG
-------------------------------------------------------------------------------*/
*multiple model statements;
PROC REG DATA = flash.cars ;
   MODEL price = mileage ;
   MODEL price = liter ;
QUIT ;

*output residuals/predicted values to a data set ;
PROC REG DATA = flash.cars ;
   MODEL price = mileage ;
   OUTPUT OUT = reg_results PREDICTED = yhat RESIDUAL = resid ;
QUIT ;

%sfig(13_resid);
PROC PRINT DATA = reg_results (obs = 5) ; 
	VAR price mileage yhat resid ;
RUN ;
%efig;


/*-------------------------------------------------------------------------------
Linear regression: y = price, x1 = mileage, x2 = sound (0/1), using PROC REG
-------------------------------------------------------------------------------*/
%sfig(13_sound);
PROC REG DATA = flash.cars ;
   MODEL price = mileage sound ;
QUIT ;
%efig;


/*-------------------------------------------------------------------------------
Linear regression: y = price, x1 = mileage, x2 = sound (0/1), using PROC GLM
-------------------------------------------------------------------------------*/
PROC GLM DATA = flash.cars ;
  MODEL price = mileage sound ;
QUIT ;



/*-------------------------------------------------------------------------------
Linear regression: y = price, x1 = mileage, x2 = cruise (Y/N), using PROC GLM
-------------------------------------------------------------------------------*/
%sfig(13_cruise);
PROC GLM DATA = flash.cars ;
  CLASS cruise ;
  MODEL price = mileage cruise / SOLUTION ;
QUIT ;
%efig;


/*-------------------------------------------------------------------------------
Linear regression: y = price, x1 = mileage, x2 = mileage^2, using PROC GLM
-------------------------------------------------------------------------------*/
PROC GLM DATA = flash.cars ;
  MODEL price = mileage mileage*mileage ;
QUIT ;


/*-------------------------------------------------------------------------------
MODEL SELECTION in PROC REG
Linear regression: y = price, x's = {mileage liter sound leather} 
-------------------------------------------------------------------------------*/
PROC REG DATA = flash.cars ;
  MODEL price = mileage liter sound leather / SELECTION = RSQUARE ;
QUIT ;
