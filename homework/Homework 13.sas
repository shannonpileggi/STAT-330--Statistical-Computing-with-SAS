/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 13
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 

We've seen basic procedures for describing data (MEANS, FREQ, UNIVARIATE)
and some brief analyses (TTEST, CORR). Statistical analyses go much
further than simple t-tests and correlations. The next two statistical 
procedures that are useful to have in your repetoire are PROC ANOVA and
PROC REG.

Recall the SAS data set cereals contains various nutritional information on
breakfast cereals in a typical grocery store. 
*****************************************************************************/

LIBNAME flash "C:\Users\spileggi\Google Drive\STAT 330\Data\" ;

PROC CONTENTS DATA = flash.cereals VARNUM ;
RUN ;

PROC PRINT DATA = flash.cereals (OBS = 10);
RUN ;

/****************************************************************************** 
The ANOVA procedure performs an Analysis of Variance. We use a CLASS statement 
to specify the grouping variable and MODEL statement to specify the ANOVA model.
In the model statement, the syntax is 

CLASS groupvariable ;
MODEL responsevariable = groupvariable ;

Suppose we want to test the hypothesis that the mean Sugar content is the same 
across the three shelves because we suspect higher sugar content cereals are lower
and closer to the eye level of young children. That is, we are testing

H0: Mu1 = Mu2 = Mu3    vs    HA: at least one population mean differs
*****************************************************************************/

PROC ANOVA DATA = flash.cereals ;
	CLASS shelf ;
	MODEL sugar = shelf ;
QUIT ;


/****************************************************************************** 
If we want to include a test of the assumption of equal variances, as well
as produce the multiple comparisons necessary to determine which population
means differ and by how much, we can do the following:
*****************************************************************************/

PROC ANOVA DATA = flash.cereals ;
	CLASS shelf ;
	MODEL sugar = shelf ;
	MEANS shelf / HOVTEST TUKEY ;
QUIT ;

/****************************************************************************** 
Take some time to observe and navigate the large amount of output.
*****************************************************************************/


/****************************************************************************** 
Suppose we want to know more about the relationship between Sugar and Calories. 
While computing a correlation or creating a scatterplot could help answer this
qusetion, we can also fit a linear regression model to these two variables 
using PROC REG.  PROC REG requires a MODEL statement, which has similar
syntax to the MODEL statement in ANOVA:

MODEL responsevariable = predictor(s) ;

*****************************************************************************/

PROC REG DATA = flash.cereals ;
	MODEL Calories = Sugar ;
QUIT ;


/****************************************************************************** 
Take some time to, again, observe and navigate the output.

One new thing to notice here - both PROC REG and PROC ANOVA are interactive
procedures, which means that you can keep adding lines of code to it 
even after a RUN; statement has been submitted!  (In these procedures, RUN; means
execute additional statements.)  The ways you can end these procedures include: 
(1) submit a DATA step
(2) submit another PROC
(3) submit a QUIT; statement
*****************************************************************************/




/****************************************************************************** 
In the space below write your own
(1) ANOVA procedure to test the content of another variable across shelves
(2) REG procedure to assess the relationship between two other variables
  of interest in the cereals data set
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;



/****************************************************************************** 
When your code looks good, run the script and verify the output.
*****************************************************************************/
