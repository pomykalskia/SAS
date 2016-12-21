*Problem Set 3;
*Andrew Pomykalski;
*ajp5sb;
*Due: July 21, 2016;

filename P3Prob1A 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3\PS3Prob1A.txt';
filename PS3Prob2 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3\PS3Prob2.txt';
filename PS3Prob3 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3\PS3Prob3.txt';
filename PS3Prob4 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3\PS3Prob4.sas7bdat';

*Problem 1A;
title1 Problem 1A;
Data survey;
infile P3Prob1A;
input @1 subjID $7. 
	  @9 gender $1. 
	  @11 dob mmddyy10. 
	  @22 qA1 1. 
	  @23 qA2 1. 
	  @24 qA3 1. 
	  @25 qA4 1. 
	  @27 qB1 dollar6.0 
	  @34 qB2 dollar6.0 
	  @41 qB3 dollar6.0
	  @48 qC1 1.
	  @49 qC2 1.
	  @50 qC3 1.
	  @51 qC4 1.
	  @52 qC5 1.
	  ;
totB = qB1 + qB2 + qB3;
pctC = (qC1 + qC2 + qC3 + qC4 + qC5)/5;
adultyrs = (18498-dob)/365.25;
run;

proc print data=survey (keep = subjID gender adultyrs totB pctC) label;
label gender ='Sex'
	  adultyrs='Years since 2010'
	  totB='Sum of dollars'
	  pctC='Percent Yes'
	  ;
format adultyrs 2. totB dollar7.2 pctC percent10.;
id subjID;
var gender adultyrs totB pctC;
Run;

*Problem 1B;
title1 Problem 1B;
Data survey;
infile P3Prob1A;
file 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3\PS3Prob1Bout.txt';
input @1 subjID $7. 
	  @9 gender $1. 
	  @11 dob mmddyy10. 
	  @22 qA1 1. 
	  @23 qA2 1. 
	  @24 qA3 1. 
	  @25 qA4 1. 
	  @27 qB1 dollar6.0 
	  @34 qB2 dollar6.0 
	  @41 qB3 dollar6.0
	  @48 qC1 1.
	  @49 qC2 1.
	  @50 qC3 1.
	  @51 qC4 1.
	  @52 qC5 1.
	  ;
totB = qB1 + qB2 + qB3;
pctC = (qC1 + qC2 + qC3 + qC4 + qC5)/5;
adultyrs = (18498-dob)/365.25;
put @1 subjID $7. @9 gender $1 @11 adultyrs 2. @14 totB dollar7.2 @22 pctC percent6.;
run;

*Problem 1C;
title1 Problem 1C;

libname voting 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3';

Data PS3Prob1C;
set voting.PS3Prob1C;
file 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3\PS3Prob1Cout.txt';
totB = qB1 + qB2 + qB3;
pctC = (qC1 + qC2 + qC3 + qC4 + qC5)/5;
adultyrs = (18498-dob)/365.25;
put @1 subjID $7. @9 gender $1 @11 adultyrs 2. @14 totB dollar7.2 @22 pctC percent6.;
run;

proc print;
run;

*Problem 2;

title1 Problem 2;
data PS3Prob2;
length ID $3 gender $1;
infile PS3Prob2;
input ID $ gender $ dob : mmddyy10. height weight;
run;

proc print;
run;

proc print data=PS3Prob2;
format dob date9.;
run;

proc contents data = PS3Prob2;
run;

data PS3Prob2;
length ID $3 gender $1;
infile PS3Prob2;
input ID $ gender $ dob : mmddyy10. height weight;
format dob date9.;
run;

proc contents data=PS3Prob2;
run;

*The last proc contents step adds a column labeled "Format" that displays the format of dob that we changed to DATE9.;
*Everything else stays the same;

*Problem 3;
title1 Problem 3;
libname Problem3 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3';

data Problem3.PS3Prob3;
infile PS3Prob3;
input @1 age 
	  @4 gender $
	  @6 Resp1 1.
	  @7 Resp2 1.
	  @8 Resp3 1.
	  @9 Resp4 1.
	  @10 Resp5 1.
	  ;
run;

proc print;
Run;

proc means data=Problem3.PS3Prob3 mean;
var age;
run;

proc freq data=Problem3.PS3Prob3;
tables Resp1 Resp2 Resp3 Resp4 Resp5 / nocum nopercent;
run;


data Problem3.Femalessubset;
set Problem3.PS3Prob3;
if gender = 'M' or Resp5 NE '3' then delete;
file print;
put age= gender= 'Responses =' Resp1 Resp2 Resp3 Resp4 Resp5;
run;

*Problem 4A;
title1 Problem 4A;
libname Survey 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3';
data PS3Prob4;
set Survey.PS3Prob4;
run;

proc format;
value age
	low-30 = '0 to under 30'
	30<-<50 = '30 to under 50'
	50<-<70 = '50 to under 70'
	70<-high = '70 or older'
	other = 'Missing';
value $party
	'L' = 'Left'
	'R' = 'Right'
	'C' = 'Center'
	'I' = 'Independent'
	'X' = 'Other';
value likert
  1 = 'Strongly disagree'
  2 = 'Disagree'
  3 = 'No opinion'
  4 = 'Agree'
  5 = 'Strongly agree';
run;

proc print data=PS3Prob4 label;
label q1 = 'Congressperson X is doing a good job';
label q2 = 'Institution Y is doing a good job';
label q3 = 'Plan Z is the correct solution for Issue A';
label q4 = 'The country is on track regarding Issue B';
format age age. party $party. q1 q2 q3 q4 likert.;
var age party q1 q2 q3 q4;
run; 

*Problem 4B;

proc format;
value $crudeparty
	'L' = 'Left'
	'R' = 'Right'
	'C','I','X' = 'Other'
	;
value crudelikert
  1,2 = 'General Disagreement'
  3 = 'No opinion'
  4,5 = 'General Agreement';
run;

proc freq data=PS3Prob4;
format q1 q2 q3 q4 crudelikert. party $crudeparty.;
tables party q1 q2 q3 q4 / nocum;
run;

*Problem 5A;
title Problem 5A;
libname info 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3';
data Bicycles;
set info.Bicycles;
run;

data Mountain_USA Road_France;
set info.bicycles;
if country = 'USA' and Model = 'Mountain Bike' then output Mountain_USA;
if country = 'France' and Model = 'Road Bike' then output Road_France;
run;

proc print data = Mountain_USA;
run;

proc print data=Road_France;
run;

*Problem 5B;
title1 Problem 5B;
data markup;
input manuf : $10. Markup;
datalines;
Cannondale 1.05
Trek 1.07
;
run;

data markup_prices;
merge info.bicycles markup;
by Manuf;
newtotal=totalsales * markup;
run;

proc print;
run;

*Problem 6A;
title1 Problem 6A;
libname storage 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3';
libname new 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3';
libname cost 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3';

data updated;
set storage.inventory new.newproducts;
by model;
run;

proc print;
run;

*Problem 6B;
title1 Problem 6B;

data pur_price unpurchased (drop=quantity totcost custnumber);
merge storage.inventory(in=in1) cost.purchase(in=in2);
by model;
totcost=quantity * price;
if in1 and in2 then output pur_price;
else output unpurchased;
run;

proc print data= pur_price;
run;

proc print data=unpurchased;
run;

*Problem 6C;
title1 Problem 6C;

data changes;
input Model : $8. price;
datalines;
M567 25.95
X999 35.99
;
run;

proc sort data = changes;
by Model;
run;

proc sort data = storage.inventory;
by Model;
run;

data newprices;
update storage.inventory changes;
by Model;
run;

*Problem 7;
title1 Problem 7;
libname firm 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_3';

data newsales;
set firm.monthsales;
retain sum 0;
if not missing(sales) then sum = sum + sales;
run;
