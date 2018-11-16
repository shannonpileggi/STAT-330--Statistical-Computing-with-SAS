/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 2
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;


/*****************************************************************************
Let's get started!  These SAS scripts will introduce you to the basics of 
programming in SAS.

Take some time to acquaint yourself with the SAS interface.  Locate the toolbar 
at the top: menus and buttons for opening, running, and saving SAS scripts among 
other things.

The left hand part of your window is used for navigating the results of your scripts 
and the folders of your computer.  The majority of your SAS window are taken up by the 
Log, Output/Results Viewer, and Editor/Code sub-windows. Though  you may not be able 
to see all of these at once.

You might notice that all of this text so far is green.  That is because it is
a comment in SAS.  Comments are pieces of a SAS script that are ignored when the script 
is run.  They can be very useful for documenting and explaining the purposes of each
portion of a SAS script.  There are two methods of commenting, show below.
*****************************************************************************/

* This is a comment;
/* This is a comment */

/*****************************************************************************
In general, any commented text will be ignored by SAS, even if it's in the 
middle of a line of code.

On to SAS... SAS programs consist of DATA steps and PROC steps.  Let's 
demonstrate PROCS with a built in SAS data set about students in a class.

Highlight the PROC PRINT command below from the capitol P to the semi-colon
after RUN.  Then click on the running man icon at the top to run this SAS script,
and observe the resulting output.
****************************************************************************/

*View the entire data set;
PROC PRINT DATA = sashelp.class; 
RUN;

/*****************************************************************************
Great!  You just printed the entire data set.  Take a moment to 
examine this output.

Now let's look at the description of the data with PROC CONTENTS.  Highlight the 
PROC CONTENTS command below from the capitol P to the semi-colon
after RUN.  Then click on the running man icon at the top to run this SAS script,
and observe the resulting output.
****************************************************************************/

*Produce a summary of the contents of the data set;
PROC CONTENTS DATA = sashelp.class; 
RUN;

/*****************************************************************************
Super!  You just produced a summary of the data set contents.  Take a moment to 
examine this output.  Now you know a little bit more about the data set.
****************************************************************************/

/*****************************************************************************
Now it's your turn.  Based the output that you have already generated,
and answer the following questions here in this SAS script.

1.  How many variables are in the data set? 

2.  How many observations are in the data set?  

3.  When was this data set created?  

Now let's generate some more output.

4.  Write code to apply the MEANS procedure to the sashelp.class data set 
	in the exact same manner that the PRINT and CONTENTS procedure was applied
    to the data set.  What was the average age of the data set?  

5.  For which variables did the MEANS procedure produce an analysis?  
    Why do you think that is?  
****************************************************************************/



/*****************************************************************************
NOTE: It's OKAY (and encouraged) to include commented code as shown below in 
case something doesn't work ... that way I can provide at least some partial 
credit!
*****************************************************************************/

/*****************************************************************************
EXAMPLE: Here's what I tried for Part A but there's an error:

proc prit data = sashelp.class;
run;
/*****************************************************************************



