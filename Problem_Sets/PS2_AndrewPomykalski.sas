*Andrew Pomykalski;
*Problem Set 2;
*Due: July 18, 2016;

*Problem Set 2;
title Problem Set 2;
filename PS2Prob1 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_2\PS2Prob1.txt';
filename PS2Prob3 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_2\PS2Prob3.csv';
filename PS2Prob4 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_2\PS2Prob4.txt';
filename PS2Prob6 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_2\PS2Prob6.txt';
filename P2Prob7A 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_2\PS2Prob7A.csv';
filename P2Prob7B 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_2\PS2Prob7B.txt';
filename P2Prob7C 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_2\PS2Prob7C.txt';
filename PS2Prob7 'C:\Users\Andrew Pomykalski\Desktop\SAS\Problem_Set_2\PS2Prob7.txt';

title1 Problem 1A;
*Problem 1: Part A;
Data expt;
keep ID Gender Pre5 Time;
length ID $ 7 Gender Pre5 $ 1;
Infile PS2Prob1;
input ID $ Gender $ Weight Age Pulse Pre1 $ Pre2 $ Pre3 $ Pre4 $ Pre5 $ 
Expt $ Time Post1 $ Post2 $ Post3 $ Post4 $Post5 $;
if _n_>235 then delete;
if Pre5="1" or Pre5="2" or Pre5 = "3" then delete;
run;

proc print;
run;

*Problem 1: Part B;
title1 Problem 1B;
Data expt;
length ID $ 7 Gender Pre5 $ 1;
Infile PS2Prob1;
input ID $ Gender $ Weight Age Pulse Pre1 $ Pre2 $ Pre3 $ Pre4 $ Pre5 $ 
Expt $ Time Post1 $ Post2 $ Post3 $ Post4 $Post5 $;
run;

proc print data=expt (obs = 90 keep = ID Gender Pre5 Time); 
where Pre5="4" or Pre5="5";
run;

*Problem 2;
title1 Problem 2;
data preds;
input x1 x2;
Y=96.0240-1.8245*x1+0.5652*x2+0.0247*x1*x2+0.0140*x1**2-0.0118*x2**2;
datalines;
5 10
5 30
5 50
20 10
20 30
20 50
40 10
40 30
40 50
;

proc print data = preds;
run;

*Problem 3;
title1 Problem 3;
Data vote;
Infile PS2Prob3 DLM =',';
input state $ party $ age;
Run;

proc print;
run;

*Problem 4: Part A;
title1 Problem 4A;
Data bank;
Infile PS2Prob4;
input name $ 1-15 acct $ 16-20 balance 21-26 rate 27-30;
interest = (balance * rate)/100;
run;

proc print;
run;

*Problem 4: Part B;
title1 Problem 4B;
Data bank;
Infile PS2Prob4;
input @1 name $14. @16 acct $5. @21 balance 6.0 @27 rate 4.2;
interest = (balance * rate)/100;
run;

proc print;
run;

*Problem 5;
title1 Problem 5;
Data expt;
Infile PS2Prob1;
input ID $ 1-7 Gender $ 9 Pre5 $ 29 Time 33-36;
if _n_>235 then delete;
if Pre5="1" or Pre5="2" or Pre5 = "3" then delete;
run;

proc print;
run;

*Problem 6;
title1 Problem 6;
Data stocks;
Infile PS2Prob6;
input @1 stock $4. @5 purdate mmddyy10. 
@15 purprice dollar6.0 @21 number 4. @25 selldate mmddyy10. @35 sellprice dollar6.0;
totalpur = number * purprice;
totalsell = number * sellprice;
profit = totalsell-totalpur;
run;

proc print data=stocks;
format purdate mmddyy10. purprice dollar6.2 selldate mmddyy10. sellprice dollar6.2;
run;

*Problem 7: Part A;
title1 Problem 7A;
Data emplA;
length ID $ 3 name $ 16;
Infile P2Prob7A DSD truncover;
input ID $ name $ dept $ datehire mmddyy10. salary dollar8.0;
run;

proc print;
run;

*Problem 7: Part B;
title1 Problem 7B;
data emplB;
length ID $ 3 name $ 16;
Infile P2Prob7B DLM='$"' truncover;
input ID $ name $ dept $ datehire : mmddyy10. salary : dollar8.0;
run;

proc print;
run;

*Problem 7: Part C;
title1 Problem 7C;
data emplC;
length ID $ 3 name $ 16;
infile P2Prob7C DLM='*' truncover;
input ID $ name $ dept $ datehire : mmddyy10. salary : dollar8.0;
run;

proc print;
run;

*Problem 7;
title1 Problem 7;
data employee;
length ID $ 3 name $ 16;
infile P2Prob7A DSD truncover;
file PS2Prob7;
input ID $ name $ dept $ datehire mmddyy10. salary dollar8.0;
put @1 ID $3. @5 name $16. @22 dept $4. @27 datehire mmddyy10. @38 salary dollar8.0;
run;

proc print;
run;

title1 Problem 7;
data employee;
length ID $ 3 name $ 16;
infile P2Prob7B DLM='$"' truncover;
file PS2Prob7;
input ID $ name $ dept $ datehire mmddyy10. salary dollar8.0;
put @1 ID $3. @5 name $16. @22 dept $4. @27 datehire mmddyy10. @38 salary dollar8.0;
run;

proc print;
run;

title1 Problem 7;
data employee;
length ID $ 3 name $ 16;
infile P2Prob7C DLM='*' truncover;
file PS2Prob7;
input ID $ name $ dept $ datehire : mmddyy10. salary : dollar8.0;
put @1 ID $3. @5 name $14. @20 dept $4. @25 datehire mmddyy10. @36 salary dollar8.0;
run;

proc print data=employee;
run;

* Another way I thought to do this was using the merge function as shown below.;
data employee;
merge P2Prob7A P2Prob7B P2Prob7C;
by ID;
run;

proc print;
run;
