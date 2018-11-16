/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 10
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/****************************************************************************** 
SAS procedures are a great way to get to know a data set. We can 
print the data out in very customizable ways, as well as ask SAS for many
descriptive statistics about the data using just some basic procedures like

- PROC PRINT
- PROC FORMAT
- PROC MEANS
- PROC FREQ
- PROC UNIVARIATE

Graphics are also just as important in any exploratory data. In this
lesson we're going to get a taste of graphics in SAS using a procedure called
PROC SGPLOT.

PROC SGPLOT is very flexible and robust, and it is capable of handily producing 
many different kinds of plots. Let's see this in action with the Big Company
data. Remember to establish the appropriate library for referencing this data set.
*****************************************************************************/

LIBNAME mylib "C:\Users\spileggi\Google Drive\STAT 330\Data";

*View first 10 obs;
PROC PRINT DATA = mylib.bigcomp (OBS = 10) ;
RUN ;

*Now, let's contruct a boxplot for the Profits variable.;
PROC SGPLOT DATA = mylib.bigcomp ;
	VBOX Profits ;
RUN;

/****************************************************************************** 
VBOX is used to construct a Vertical Boxplot. This plot looks nice, but
it might be more informative to see this broken down by country. 
*****************************************************************************/

PROC SGPLOT DATA = mylib.bigcomp ;
	VBOX Profits / CATEGORY = Country ;
RUN ;

/****************************************************************************** 
Notice that the option is specified after being separated by a "/";

Suppose we wanted to overlay a boxplot of Profits with a boxplot of Sales.
We can do this by specifying them in the same procedure step. This particular
graph may not be the most informative, but notice how nice and easy it is to
combine graphics. Because they might be overlapping, I've increased the 
transparency value so they're easier to see and distinguish. Feel free to play
around with these values.
*****************************************************************************/

PROC SGPLOT DATA = mylib.bigcomp ;
	VBOX Profits / TRANSPARENCY = .5 ;
	VBOX Sales / TRANSPARENCY = .5 ;
RUN ;


/****************************************************************************** 
Just like many other SAS procedures, PROC SGPLOT has a multitude of options
that can be used to customize its output. A good description of these can be 
found here:

https://support.sas.com/documentation/cdl/en/grstatproc/62603/HTML/default/viewer.htm#sgplot-chap.htm

In the space below write a few of your own SGPLOT procedures to do the 
following for the Big Company data:

- Create a histogram for at least one variable
- Create a scatterplot of Profits vs. Sales
- Use the WHERE statement within PROC SGPLOT to create overlaid histograms
of Sales and Assets for only the United States (you may want to 
play around with the transparency)
*****************************************************************************/


*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;




/****************************************************************************** 
Once your code looks good, run the script and verify the output.;
*****************************************************************************/
