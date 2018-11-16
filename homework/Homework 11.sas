/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 11
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
Let's learn about how to use the statistical procedures PROC TTEST and PROC CORR.

The SAS data set cereals contains various nutritional information on
breakfast cereals in a typical grocery store. 

Modify the path macro variable below to the location of your SAS data sets.
*****************************************************************************/
%LET path = C:\Users\spileggi\Google Drive\STAT 330\Data;

LIBNAME flash "&path";

PROC CONTENTS DATA = flash.cereals VARNUM;
RUN ;

/****************************************************************************** 
Suppose we wanted to test the hypothesis that the average amount of Calories 
per serving for cereals at this store is greater than 100 at the 5% 
significance level.

H0: Mu=100 vs HA: Mu>100

PROC TTEST can be used for one-sample, two-sample, and paired t-tests. 
Specifying one variable tells SAS to do a one-sample test.  We can also 
specify the null and alternative hypotheses to test with PROC TTEST.
*****************************************************************************/

PROC TTEST DATA = flash.cereals H0 = 100 sides = U ALPHA = .05 ;
	VAR calories ;
RUN ;

/****************************************************************************** 
Review the syntax and optional statements for PROC TTEST here:

http://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_ttest_sect001.htm

Below are templates for how to execute the paired t-test and the two-sample
t-test.  Note that the template code below won't work because
we haven't inserted data set names and variables.
*****************************************************************************/

* For a paired t-test follow this template;
PROC TTEST DATA = <data-set name> ALPHA = .05; 
	PAIRED <var1>*<var2>;
RUN;

* For the two sample t-test follow this template;
PROC TTEST DATA = <data-set name> ALPHA = .05; 
	VAR <var1>;
	CLASS <categorical variable that defines groups>;
RUN;

/****************************************************************************** 
Suppose we wanted to investigate the relationship between the amount Sugar
per serving and the amount of Calories per serving in these cereals (both 
quantitative variables). We've already seen how we could create a scatterplot
to visualize this, and we can use the correlation to measure the strength of the 
linear association. We can compute use PROC CORR to compute the correlation.
*****************************************************************************/

PROC CORR DATA = flash.cereals;
	VAR Sugar Calories;
RUN;


/****************************************************************************** 
By default, PROC CORR generates some summary statistics as well as a
correlation matrix with correlations between all pairs of variables 
specified in the VAR statement.

If we want to restrict our output to only correlations between specific
pairs of variables we can use the WITH statement. This will produce 
correlations between all of the variables in the VAR statement and all of 
the variables in the WITH statement.
*****************************************************************************/

PROC CORR DATA = flash.cereals;
	VAR Sugar TotalFat;
	WITH Calories Carbs; 
RUN;

/****************************************************************************** 
Notice that the output also includes a p-value for the hypothesis test that the 
population correlation (rho) is equal to 0.

H0: rho = 0 vs HA: rho =/= 0
*****************************************************************************/


/****************************************************************************** 
In the space below write your own PROC TTEST and PROC CORR steps to:

(1) Test if the mean amount of Sugar per serving is different from 10g
at the 1% significance level

		H0: Mu=10 vs HA: Mu=/=10

(2)  Test if the mean amount of TotalFat is different among
cereals that have trans-fat and cereals that do not (TRANS)

	    H0: Mu_yes=Mu_no vs HA: Mu_yes=/=Mu_no

(3)  Compute the correlation between protein and fiber SEPARATELY for the
TRANS classification of cereals (YES/NO).  (Hint: use a WHERE statement.)
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;


