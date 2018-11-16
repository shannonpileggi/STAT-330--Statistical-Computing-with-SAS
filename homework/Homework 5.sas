/*****************************************************************************
* Name:        YOUR NAME HERE
* Assignment:  Homework 5
*****************************************************************************/

*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/*****************************************************************************
So far we have been using variables that exist in data sets.  However, once 
the RUN statement at the end of the DATA step is executed SAS completes that 
DATA step and stores that data set. The variables and data in that data set are 
ONLY accessible by referencing that data set. This is why when we run a PROC PRINT,
for example, we must tell SAS which data set we want to print.

There is a way to create variables that can be referenced by a DATA or PROC step 
at any time, that aren't necessarily part of a particular data set. One way to 
achieve this is using the macro facility within SAS by creating what's called a 
macro variable. Macro variables are global, which means they can be used
anywhere in your SAS program.  Here's a simple example.

Recall the sashelp.class data set which contains information on the 19 students.
Suppose we want to do operations with the same variable repeatedly.  So
for example, we want to apply PROC MEANS to a variable and PRINT the first
10 observations of the variable.

First, it's often useful to think about a SAS program without macros first,
and then 'macro-fy' it.
*****************************************************************************/

TITLE "No macros yet" ;
PROC MEANS DATA = sashelp.class ;
	VAR age ;
RUN ;

PROC PRINT DATA = sashelp.class (OBS = 5);
	VAR age ;
RUN ;
TITLE ;

/*****************************************************************************
Note here that I wanted to do multiple operations with the variable age.  
Instead of repeatedly writing age, I could substitute in a macro variable
everywhere I see age.

First, we create a global macro variable with 
*****************************************************************************/

%LET my_variable = age ;

/*****************************************************************************
  +  % initiates a macro function, statement, or call
  +  LET is a a SAS statement for macros that defines a global macro variable
  +  myvariable is the global macro variable
  +  = age defines the current value of the global macro variable as age

Then we substitute in our global macro variable everywhere we had age.  This
global macro variable is referenced as &myvariable.  Let's see how this works.

  +  & initiates a macro reference
*****************************************************************************/

TITLE "With a macro variable" ;
PROC MEANS DATA = sashelp.class ;
	VAR &my_variable ;
RUN ;

PROC PRINT DATA = sashelp.class (OBS = 5);
	VAR &my_variable ;
RUN ;
TITLE ;


/*****************************************************************************
All right, we got the exact same output as before!  That is exactly what 
should happen.  So why should we do this?  Well, now your task is to perform
the same operations, but for the height variable.  All you need to do is
substitute in a different value for your global macro variable.  
*****************************************************************************/

%LET my_variable = height ;

TITLE "With a macro variable" ;
PROC MEANS DATA = sashelp.class ;
	VAR &my_variable ;
RUN ;

PROC PRINT DATA = sashelp.class (OBS = 5);
	VAR &my_variable ;
RUN ;
TITLE ;

/*****************************************************************************
Hopefully you can see the simplicity of it.  We didn't have to change
our two VAR statements; we only had to change our one %LET statement.

However, we did have to copy and paste some code.  We further simplify the 
process by creating a macro module, which can consist of multiple chunks of 
code.  To create a macro module, you need to book end your previous
chunk of code with

%MACRO my_module(my_variable) ;
	enter code here...
%MEND ;

+  %MACRO is a macro statement that creates a new macro module
+  my_module is the name of the macro module
+  (my_variable) is a parameter that gets passed through the macro module
+  %MEND is a macro statement that closes the macro module

Note here that I simply copied and pasted my previous code into the macro 
module.  No modifications were made to the inner code chunks, except for 
the TITLE statement.  Now submit the macro module below.
*****************************************************************************/

%MACRO my_module(my_variable) ;
	TITLE "With a macro module" ;
	PROC MEANS DATA = sashelp.class ;
		VAR &my_variable ;
	RUN ;

	PROC PRINT DATA = sashelp.class (OBS = 5);
		VAR &my_variable ;
	RUN ;
	TITLE ;
%MEND ;

/*****************************************************************************
Super!  Oh wait, you probabably didn't get any output, right?  That is 
because the chunk of code above only defined the macro module, it didn't 
execute it.  In order to execute it, you need to call the macro module.
*****************************************************************************/

%my_module(age);

/*****************************************************************************
The macro module execution works by calling the macro name with a % sign
and then stating the parameter value in parentheses. Now we can execute
this macro as many times as we want.  Try it.
*****************************************************************************/

%my_module(height);
%my_module(weight);

/*****************************************************************************
One more note about what happened above:

When we executed 

	%LET my_variable = height ;

we created a *global* macro variable called my_variable that can be accessed
*anywhere* in your SAS program.

When we executed 

	%MACRO my_module(my_variable) ;
		code...
	%MEND ;

my_variable now represents a *local* macro variable that exists *only* inside
of this macro module.
*****************************************************************************/


*<--- TYPE CODE WITHIN THESE BOUNDS  ----  TYPE CODE WITHIN THESE BOUNDS --->;
*1234567890123456789012345678901234567890123456789012345678901234567890123456;

/*****************************************************************************
Now it's your turn.  Recall the SAS help baseball data set.  Suppose we
want to look at statistics summarized according to different categories
(position, division, etc.)  Let's write a macro to achieve this.

1)  View the contents and print the first 10 observations of sashelp.baseball
	so that you can get familiar with it.
*****************************************************************************/


/*****************************************************************************
2) Write a procedure that will allow you to view the 5 basic summary
   statistics (N, mean, sd, min, max) of Times at Bat in 1986 separated by
   team.
*****************************************************************************/



/*****************************************************************************
3) Copy and paste your procedure from (2) below.  Now define a global macro
   variable called class_var which takes a value of team.  Substitute in your
   global macro variable in your procedure.  Submit your code to verify 
   that it works correctly.
*****************************************************************************/



/*****************************************************************************
4) Copy and paste your procedure from (3) below.  Turn this procedure into
   a macro module named at_bats that takes a parameter of class_var.  Submit 
   your macro module.  (Remember, nothing will happen when you submit the 
   module).
*****************************************************************************/



/*****************************************************************************
5) Execute the at_bats macro module 4 separate times with substitutions of team, 
   league, division, and position for the class_var paramter.
*****************************************************************************/

