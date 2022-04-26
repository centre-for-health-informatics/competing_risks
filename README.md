# competing_risks
Competing risks analysis programs

Abstract

Background: Adjusted survival curves are often presented in medical research articles. The most commonly used method for calculating such curves is the mean of covariates method, in which average values of covariates are entered into a proportional hazards regression equation. Use of this method is widespread despite published concerns regarding the validity of resulting curves.

Objective: To compare the mean of covariates method to the less widely used corrected group prognosis method in an analysis evaluating survival in patients with and without diabetes. In the latter method, a survival curve is calculated for each level of covariates, after which an average survival curve is calculated as a weighted average of the survival curves for each level of covariates.

Design, Setting, and Patients: Analysis of cohort study data from 11 468 Alberta residents undergoing cardiac catheterization between January 1, 1995, and December 31, 1996.

Main Outcome Measures: Crude and risk-adjusted survival for up to 3 years after cardiac catheterization in patients with vs without diabetes, analyzed by the mean of covariates method vs the corrected group prognosis method.

Results: According to the mean of covariates method, adjusted survival at 1044 days was 94.1% and 94.9% for patients with and without diabetes, respectively, with misleading adjusted survival curves that fell above the unadjusted curves. With the corrected group prognosis method, the corresponding survival values were 91.3% and 92.4%, with curves that fell more appropriately between the unadjusted curves.

Conclusions: Misleading adjusted survival curves resulted from using the mean of covariates method of analysis for our data. We recommend using the corrected group prognosis method for calculating risk-adjusted curves.

https://cumming.ucalgary.ca/sites/default/files/teams/30/resources/Pub-Competing%20risk-survival.pdf

Below are five computer files which can be downloaded to your PC to experiment with the use of these four statistical methods.  Please make sure you save the files as .sas (with .txt format chosen) rather than in html format.

Data set SAS program
“Sample.sas” – a SAS program which creates a SAS data file for use as an example dataset to which the following SAS programs can be applied. The dataset contains 6,456 observations.

KM SAS programs
1. “KMCensorAll.sas” – a SAS program that calculates and plots time to CABG curve by censoring for death and PCI.
2. “KMCensorDeathOnly.sas” – a SAS program that calculates and plots time to CABG curve by censoring for death and ignoring PCI.
3. “KMIgnoreAll.sas” – a SAS program that calculates and plots time to CABG curve by ignoring death and PCI.
4. “CICR.sas” – a SAS program that calculates and plots time to CABG curve by cumulative incidence competing risks method.
