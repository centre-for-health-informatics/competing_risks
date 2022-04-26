/* CICR code – created by TAI BEE CHOO published in Statist. Med. 2001; 20: 661-684*/

libname www ‘d:\learnSAS\www’; /* PATH TO BE ENTERED BY USER */
data cicr;
set www.sample; /* NAME OF DATASET TO BE ENTERED BY USER */

/* SET UP DATA WITH STATUS VARIABLE AS 0=no event, 1=PCI, 2=CABG or 3=death */
date=’31dec99’d;
if dateB~=. then date=dateB;
if dateA~=. and (dateA<date) then date=dateA;
if dateC~=. and (dateC<date) then date=dateC;
status=0;
if date=dateB then status=1;
if date=dateA then status=2;
if date=dateC then status=3;
if date=dateA & dateA=dateB then status=1;
time=date-date0;
oneyr=0;
if time>365 then oneyr=1;
if oneyr=1 then time=365;
if oneyr=1 then status=0;
run;

****************************************************************************
* *
* SAS MACRO FOR CUMULATIVE INCIDENCE CURVES *
* *
* PROGRAM : CICR.SAS *
* CREATED ON : 29 JULY 1998 *
* BY : TAI BEE CHOO *
* *
* INPUT VARIABLES OF MACRO PROGRAM *
* ================================ *
* *
* &dsn = NAME OF SAS DATA SET *
* &time = TIME TO OCCURRENCE OF COMPETING EVENTS *
* &status = CENSORING STATUS, WHERE CODE 0 DENOTES CENSORING *
* &num = NUMBER OF COMPETING EVENTS *
* &hmax = HIGHEST VALUE TO BE DISPLAYED ON THE HORIZONTAL AXIS OF PLOT *
* &hstep = INTERVAL INCREMENT ALONG THE HORIZONTAL AXIS *
* &vmax = HIGHEST VALUE TO BE DISPLAYED ON THE VERTICAL AXIS OF PLOT *
* &vstep = INTERVAL INCREMENT ALONG THE VERTICAL AXIS *
* *
****************************************************************************;

%macro event(dsn,time,status,num,hmax,hstep,vmax,vstep);

 

options nodate center nonumber ls=100;

 

********************************************************************
* ESTIMATE EVENT-FREE SURVIVAL USING KAPLAN-MEIER METHOD *
********************************************************************;

data trt;
set &dsn;
proc lifetest data=trt outsurv=surv notable noprint;
time &time*&status(0);
title “EVENT-FREE SURVIVAL ESTIMATES”;
run;

 

*********************************************************************
* REPLACE CURRENT SURVIVAL ESTIMATE WITH ITS PRECEDING VALUE *
* TO BE USED IN THE COMPUTATION OF CRUDE CUMULATIVE INCIDENCE *
*********************************************************************;

data surv (keep = &time survival _censor_ newsurv);
set surv;
if _censor_ ne 1;
newsurv=lag1(survival);
if &time=0 then newsurv=1;
run;

%do j = 1 %to &num;

data event&j;
set trt;
if &status=&j then censor=0;
else censor=1;
run;

 

***********************************************************************
* ESTIMATE CAUSE-SPECIFIC HAZARD RATE USING KAPLAN-MEIER METHOD *
***********************************************************************;

proc lifetest data=event&j outsurv=hazard&j notable noprint;
time &time*censor(1);
title “CAUSE-SPECIFC SURVIVAL ESTIMATES, EVENT &j”;
run;

data censor&j;
set hazard&j end=eof;
if eof and _censor_=1;
keep &time;
run;

data hazard&j (keep = &time survival _censor_ haz);
set hazard&j;
if _censor_ ne 1;
survlag = lag1(survival);
if &time = 0 then survlag = 1;
haz = 1 – survival/survlag;
run;

 

**********************************************************************
* MERGE OUTPUT FROM EVENT-FREE SURVIVAL WITH CAUSE-SPECIFIC SURVIVAL *
**********************************************************************;

data merge&j (drop = _censor_ survival);
merge surv (in=a) hazard&j (in=b) end=ended;
by &time;
if a=b;
run;

**********************************************************************
* COMPUTE CRUDE CUMULATIVE INCIDENCE : I(t) = I(t-1) + S(t-1)*h(t) *
**********************************************************************;

data merge&j;
set merge&j;
CICR + (newsurv*haz);

proc print data=merge&j split=’*’;;
label &time=”Time to*occurrence*of event &j”
haz=’Estimated*failure rate*h(t)’
newsurv=’Estimated*overall survival*S(t-1)’
CICR=’Crude*cumulative incidence*I(t)’;

run;

proc append base=merge&j data=censor&j;
proc sort data=merge&j out=merge&j;
by &time;
run;

data http://www.merge2&j (keep = CICR surv &time);
set merge&j end=eof;
newccum=lag1(CICR);
if (eof and CICR=.) then do;
CICR=newccum;
end;

%end;

 

%mend event;

%event(cicr,time,status,3,365,91.25,0.6,0.2); /* INPUT VARIABLES TO BE ENTERED BY USER */

************************************************************************
* PLOTS OF CRUDE CUMULATIVE INCIDENCE AND CRUDE SURVIVAL FOR CABG *
************************************************************************;
symbol1 i=stepl2 c=black l=1;
symbol2 i=stepl2 c=black l=3;
legend1 label= none;
axis1 label = (h=1 f=swiss)
order = 0 to 365 by 91.25;
axis2 label = (h=1 f=swiss a=90 r=0)
order = 0 to 0.6 by 0.2;
proc gplot data=www.merge22;
plot CICR*time / vm=0 hm=0 haxis=axis1 vaxis=axis2 legend=legend1;
title h=1.5 f=swissb “Crude cumulative incidence, Event CABG”;
label CICR = ‘Probability’
time = ‘Time to occurrence of event (weeks)’; /* UNIT OF TIME TO BE ENTERED BY USER */
run;
quit;
/* MERGE22 FILE IS CABG EVENT ONLY */
/* MERGE21 FILE IS PCI EVENT ONLY */
/* MERGE23 FILE IS DEATH EVENT ONLY */