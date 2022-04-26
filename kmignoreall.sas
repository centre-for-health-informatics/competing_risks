/* KM Ignore All Method */

libname www ‘d:\learnSAS\www’; /* PATH TOBE ENTERED BY USER */

data cicrncd;
set www.sample; /* NAME OF DATASET TO BE ENTERED BY USER */

/* SET UP DATA WITH LOSS TO FOLLOW UP CENSORED */
date=’31dec99’d;
if dateA~=. then date=dateA;
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
proc lifetest data=cicrncd method=KM noprint outsurv=cencC;
time time*cen(1);
run;
data cencC;
set cencC;
IgnoreAll=1-survival;
drop survival;
run;
proc sort data=cencC;
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

proc gplot data=cencC;
plot IgnoreAll*time / vm=0 hm=0 haxis=axis1 vaxis=axis2 legend=legend1;
title h=1.5 f=swissb “Time to Event Curves by KM Ignore All Method”;
label IgnoreAll=’Proportion’
time=’Days after Catherization’;
run;
quit;