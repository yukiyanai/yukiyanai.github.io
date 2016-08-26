/* =======================================================================
ch13.do

Stata do-file for Ch.13 of the textbook
  Stata ni yoru Keiryoseijigaku
by Masahiko Asano and Yuki Yanai

Created: Feb/05/2013 by MA and YY
=========================================================================*/

set more off

** change the working directory
** (the path must be tailored to your computer environment)
cd ~/stata/

** open a log file
log using log_ch13.log, replace


/* -----------------------------------------------------
 Analysis of the elecoral data
-------------------------------------------------------*/
** open the dataset
use hr96-09.dta, clear

** generate dummy variables
generate new=0
replace new=1 if status==1
gen old=0
replace old=1 if status==3

** list the generated dummy variables and their parent "status"
list new old status


** generate multiple dummy variables from a categorical variable at once
tabulate party, generate(ptyd)


/* -----------------------------------------------------
 Regression analyses with dummy variables
-------------------------------------------------------*/
** focus on 2009 data
keep if year==2009
* drop if year!=2009

** generate a new variable "expm"
generate expm = exp/1000000


** generate a dummy variable for DPJ
generate dpj=0
replace dpj=1 if party==1001

** a multiple regression with a dummy variable
**   response var = voteshare
**   explanatory var1 = expm
**   explanatory var2 = dpj
regress voteshare expm dpj

** create the predicted values for non-dpj and dpj, respectively
predict yhat0 if dpj==0
predict yhat1 if dpj==1

** scatter plot with regression lines
** Figure 13.1
twoway (scatter voteshare expm if dpj==0) ///       (mspline yhat0 expm) ///       (scatter voteshare expm if dpj==1, msymbol(Dh)) ///       (mspline yhat1 expm, lwidth(thick)), ///    ytitle(voteshare) ///    legend(label(1 non-DPJ) label(2 Fit for non-DPJ) ///           label(3 DPJ) label(4 Fit for DPJ))



** a multiple regression with dummy variables generated
**   from a category variable
**     response var = voteshare
**     explanatory var1 = expm
**     explanatory var2-- = dummies created from party
xi: regress voteshare expm i.party

 
** a multiple regression with dummy variables generated
**   from a category variable.
** reference party = LDP (800)
**     response var = voteshare
**     explanatory var1 = expm
**     explanatory var2-- = dummies created from party
char party[omit]800
xi: reg voteshare expm i.party
char party[omit]



** a multiple regression with an interaction term
reg voteshare c.expm##i.dpj

** create predicted values for non-dpj and dpj, respectively
predict yhat2 if dpj==0
predict yhat3 if dpj==1


** scatter plot with regression lines
** Figure 13.2
twoway (scatter voteshare expm if dpj==0) ///       (mspline yhat2 expm) ///       (scatter voteshare expm if dpj==1, msymbol(Dh)) ///       (mspline yhat3 expm, lwidth(thick)), ///    ytitle(voteshare) ///    legend(label(1 non-DPJ) label(2 Fit for non-DPJ) ///           label(3 DPJ) label(4 Fit for DPJ))



/* --------------------------
 Variable transformations 
 ----------------------------*/
** open the dataset
use height.dta, clear


** regress ht on father and female
regress ht father female

** regress ht on metfather and female
reg ht metfather female

** regress ht on infather and female
reg ht infather female


** center the variable "father" and create "cfather"
quietly summarize father
generate cfather = father - r(mean)
label var cfather "centered father's ht (cm)"

** center the variable "female" and create "cfemale"
quietly sum female
gen cfemale = female - r(mean)
label var cfemale "centered female dummy"


** check statistics of the centered variables
sum cfather cfemale

** regress ht on the centered variables
reg ht cfather cfemale

** close the log file
log close
