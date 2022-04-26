/* KM Censor All Method */

libname www ‘D:\learnSAS\www’; /* PATH TO BE ENTERED BY USER */

data cicrca;
set www.sample; /* NAME OF DATASET TO BE ENTERED BY USER */

 

/* SET UP DATA WITH DEATH, PCI and LOSS TO FOLLOW UP CENSORED */
date=’31DEC99’d;
if dateA~=. then date=dateA;
if dateB~=. and (dateB<date) then date=dateB;
if dateC~=. and (dateC<date) then date=dateC;
time=date-date0;
event1=0;
if date=dateA then event1=1;
/* CUT OFF AT 1 YEAR */
oneyr=0;
if time>365 then oneyr=1;
if oneyr then time=365;
cen=1-event1;
if event1 & oneyr then cen=1;
run;

/* USE KAPLAN-MEIER METHOD */
proc lifetest data=cicrca method=KM noprint outsurv=cencA;
time time*cen(1);
run;
data cencA;
set cencA;
CensorAll=1-survival;
drop survival;
run;
proc sort data=cencA;
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

proc gplot data=cencA;
plot CensorAll*time / vm=0 hm=0 haxis=axis1 vaxis=axis2 legend=legend1;
title h=1.5 f=swissb “Time to Event Curves by KM Censor All Method”;
label CensorAll=’Proportion’
time=’Days after Catherization’;
run;
quit;