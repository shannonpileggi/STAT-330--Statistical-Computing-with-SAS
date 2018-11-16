%LET hr_cut = 10 ;
%LET my_pos = 1B ;


%LET dsn=sashelp.baseball ;
%LET num = 5;
PROC PRINT DATA = &dsn (OBS = &num);
RUN ;


options mprint mlogic symbolgen ;

%let x=15;
%let y=10;
%let z=&x-&y;


%put &z ;

data test;
z = &x-&y;
run; 

proc print; run;
