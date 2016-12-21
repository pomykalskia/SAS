*Andrew Pomykalski;
*Problem Set 1;
*Due: July 14, 2016

*This is the solution to Problem 1:;
Title1 ‘Problem Set 1’;
Title2 ‘Problem 1’;
Options nocenter;

Data Prob1Data;
Infile 'C:\LocalData\PS1Prob1.txt';
Input obj $ hgt wid;
Run;

Proc print;
Var obj wid hgt;
Run;

*This begins the solution to Problem 5;
Title2 'Problem 5';
Data expt;
Infile ‘Infile 'C:\LocalData\PS1Prob5.txt';
Input sample $ temp_degF press_psi;
temp_degC = (5/9) * (temp_degF – 32);
press_Pa =press_psi / 6894.757;
quadT2 = temp_degC **2;
quadP2 = press_Pa ** 2;
quadTP = temp_degC * press_Pa;

*Here begins Problem 7;
Title2 'Problem 7';
Data PS1Prob7;
Infile 'C:\LocalData\PS1Prob7.txt';
Input class $ x1 y1 y2;
Run;

Proc means data=PS1Prob7 mean median;
Var x1 y1 y2;
Run;

Proc freq data = PS1Prob7;
Tables class / nocum;
Run;

Proc univariate data = PS1Prob7;
Var x1;
Qqplot x1;
Run;

Proc corr data=PS1Prob7;
Var x1 y1;
Run;
