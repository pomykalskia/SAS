* STAT6430;
* SAS Group Project;
* Due: 7/25/2016;
* Andrew Pomykalski, Jordan Baker, Colin Cassady;
* ajp5sb, jmb4ax, cvc2cq;

title 'SAS Group Project';

* Initialize the library we will be using for this project, named project.;
libname project 'C:\Users\Andrew Pomykalski\Desktop\SAS\Final Project\Project_AJP5SB_JMB4AX_CVC2CQ';


* Sort all 5 data files by a number of variables (if they apply to the data set).;
proc sort data=project.Master;
by projnum date assign;
run;

proc sort data=project.Newforms;
by projnum date;
run;

proc sort data=project.Assign;
by projnum assign;
run;

proc sort data=project.Type;
by projnum;
run;

proc sort data=project.Correct;
by projnum date;
run;



* Merge the newforms data set with the assign data set by their common variable - projnum.;
* The goal of this is to combine the post September 1 data with the assignment data for each consultant.;
data project.temp_master;
merge project.Newforms project.Assign;
by projnum;
run;

proc sort data=project.temp_master;
by projnum date assign;
run;



* Merge the current temp_master data set with the master data set, by their common variables - projnum, date, and assign.;
* The goal of this is to combine data from pre September 1 (master) and data from post September 1 (temp_master).;
data project.temp_master;
merge project.temp_master (in=in1) project.master (in=in2);
by projnum date assign;
run;



* Merge the current temp_master data set with the type data set, by their common variable - projnum.;
* The goal of this is to add in the additional column of Project Type to each observation.;
data project.temp_master;
merge project.temp_master project.type;
by projnum;
run;



title2 'Part A';
title3 'New Master List';
* Use the update function to pull in information from the correcttions data file into the temp_master data file.;
* Update by projnum and date.;
* The goal of this is to add in the corrections to the temp_master file.;
* Additionally, we added in the Corrected column here, which indicates 1 if an observation was corrected and 0 if not.;
proc sort data=project.temp_master;
by projnum date;
run;

proc sort data=project.correct;
by projnum date;
run;

data project.newmaster;
update project.temp_master(in=in1) project.correct(in=in2);
by projnum date;
if in1 and in2 then Corrected = 1;
else Corrected = 0;
label Corrected = 'Data Corrected?';
run;

proc print data=project.newmaster label;
run;


title2 'Part B';
title3 'Task i';
title4 'List of Ongoing Projects';
* Part B;
* Task i;
* Create two data subsets that contain data on projects that are closed and projects that are not closed.;
* Sorted by projnum and then merged the two files to compile a list of closed projects.;
data project.notclosed;
set project.newmaster;
if closed = 0 then output;
keep projnum;
run;

data project.closed;
set project.newmaster;
if closed = 1 then output;
keep projnum;
run;

proc sort data=project.notclosed;
by projnum;
run;

proc sort data=project.closed;
by projnum;
run;

data project.ongoing;
merge project.notclosed(in=in1) project.closed(in=in2);
by projnum;
keep projnum;
if (in1 and NOT in2) and (first.projnum)then output;
run;

proc print data=project.ongoing label;
run;

title3 'Task ii';
title4 'Consultant Activity Report';
* Part B;
* Task ii;
* The first data set created stores start and finish dates for each project.;
* The second and  third data sets replace all missing hour values with 0 and;
* then create a total hours variable that stores the amount of time spent on;
* each project.;
* The newmaster2 data set combines these total hours and date data sets to give;
* us our most updated data set so far.;
* The final data set creates an activity subset for each consultant and adds;
* a ongoing variable to indicate if the project is still ongoing.;
data project.dates;
set project.newmaster;
by projnum;
if first.projnum then stdate = date;
if last.projnum then fndate = date;
run;

data project.truehours;
set project.newmaster;
array array1{1} hours;
do i = 1;
	if array1{i} = . then array1{i} = 0;
end;
drop i;
run;

data project.totalhours;
set project.truehours;
by projnum;
if first.projnum then tothours = 0;
tothours + hours;
if last.projnum;
run;

data project.newmaster2;
update project.totalhours project.dates;
by projnum;
run;

data project.brown project.jones project.smith;
set project.newmaster2;
if closed = 0 then ongoing = 1;
else Ongoing = 0;
if assign = 'Ms. Brown' then output project.brown;
if assign = 'Mr. Jones' then output project.jones;
if assign = 'Ms. Smith' then output project.smith;
format stdate DATE9. fndate DATE9.;
label tothours = "Total Hours"
      ongoing = "Ongoing?"
	  stdate = "Start Date"
	  fndate = "Finish Date"
	  ;
run;

title5 'Summary Consulting Activity for Ms. Brown';
proc print data=project.brown (keep = projnum type tothours stdate fndate ongoing) label;
id projnum;
run;

title5 'Summary Consulting Activity for Mr. Jones';
proc print data=project.jones (keep = projnum type tothours stdate fndate ongoing) label;
id projnum;
run;

title5 'Summary Consulting Activity for Ms. Smith';
proc print data=project.smith (keep = projnum type tothours stdate fndate ongoing) label;
id projnum;
run;



title3 'Task iii';
title4 'Overall Activity Report';
* Part B;
* Task iii;
* This final task creates the overall data set which allows us to create the overall;
* activity report for the group of consultants.;
* The report uses a number of new variables that are initialized in this step to calculate;
* total projects, average hours per project (for completed projects), the max and min;
* hours for all projects.;
data project.overall;
set project.brown project.jones project.smith;
by assign;
retain totproj maxhours finhours avghours totcompl totcomplhrs 0 minhours 100;
if first.assign then do;
	totproj = 0; maxhours = 0; finhours = 0; avghours = 0; totcompl = 0; totcomplhrs = 0; minhours = 100;
	end;
totproj = totproj + 1;
finhours = finhours + tothours;
if max(tothours) > maxhours then maxhours = max(tothours);
if ((min(tothours) < minhours) and minhours NOT EQ 0) then minhours = min(tothours);
if ongoing = 0 then do;
	totcompl = totcompl + 1;
	totcomplhrs = totcomplhrs + tothours;
	end;
avghours = totcomplhrs/totcompl;
if last.assign then output;
label avghours = "Average Hours"
      minhours = "Minimum Hours"
	  maxhours = "Maximum Hours"
	  totproj = "Total Projects"
	  finhours = "Total Project Hours"
;
run;

proc print data=project.overall (keep = assign totproj finhours avghours minhours maxhours) label;
var assign totproj finhours avghours minhours maxhours;
run;
