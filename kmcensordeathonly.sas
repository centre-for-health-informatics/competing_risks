/* KM Censor Death Only method */

libname www ‘d:\learnSAS\www’; /* PATH TO BE ENTERED BY USER */

data cicrnc;
set www.sample; /* NAME OF DATASET TO BE ENTERED BY USER */

/* SET UP DATA WITH DEATH and LOSS TO FOLLOW UP CENSORED */
date=’31dec99’d;
if dateA~=. then date=dateA;
if dateC~=. & dateC<date then date=dateC;
/* CUT OFF AT 1 YEAR */
time=date-date0;
event1=0;
if date=dateA then event1=1;
oneyr=0;
if time>365 then oneyr=1;
if oneyr then time=365;
cen=1-event1;
if event1 & oneyr then cen=1;
run;

/* USE KAPLAN-MEIER METHOD */
proc lifetest data=cicrnc method=KM noprint outsurv=cencB;
time time*cen(1);
run;
data cencB;
set cencB;
IgnorePCI=1-survival;
drop survival;
run;
proc sort data=cencB;
by time;
run;

************************************************************************
* PLOT OF CRUDE CUMULATIVE INCIDENCE AND CRUDE SURVIVAL FOR CABG *
************************************************************************;
legend1 label= none;
axis1 label = (h=1 f=swiss)
order = 0 to 365 by 91.25;
axis2 label = (h=1 f=swiss a=90 r=0)
order = 0 to 0.6 by 0.2;

proc gplot data=cencB;
plot IgnorePCI*time / vm=0 hm=0 haxis=axis1 vaxis=axis2 legend=legend1;
title h=1.5 f=swissb “Time to Event Curves by KM Ignore PCI Method”;
label IgnorePCI=’Proportion’
time=’Days after Catherization’;
run;
quit;