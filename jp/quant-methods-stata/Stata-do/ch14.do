/* =======================================================================
ch14.do

Stata do-file for Ch.14 of the textbook
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
 Analysis of the fake elecoral data
-------------------------------------------------------*/
** open the dataset
use ml_wl.dta, clear


** scatter plot: wlsmd vs previous
** Figure 14.3
scatter wlsmd previous

** scatter plot: wlsmd vs expm
** Figure 14.4
scatter wlsmd expm


** correlation between wlsmd and previous
correlate wlsmd previous

** correlation between wlsmd and expm
cor wlsmd expm


** a logistic regression
**   response = wlsmd
**   explanatory = previous and expm
logit wlsmd expm previous

** obtain the predicted values
predict Phat


** precision of the prediction
quietly logistic wlsmd previous expm
lstat


** install SPost
** delete the leading '*'s in the follwing lines to install SPost
* net from http://www.indiana.edu/~jslsoc/stata/
* net install spost9_ado


** the effect of explanatory variables on the response: SPost
quietly logit wlsmd previous expm
prchange


** generate predicted values for varying expm with previous=0
prgen expm, x(previous=0) gen(expm0)
** list the generated values
list expm0x expm0p0 expm0p1
** visually display the predicted values
twoway mspline expm0p1 expm0x, ytitle("Predicted probability of winning")


** generate predicted values for varying expm with previous=5
prgen expm, x(previous=5) gen(expm5)
** list the generated values
list expm5x expm5p0 expm5p1
** visually display the predicted values
twoway mspline expm5p1 expm5x, ytitle("Predicted probability of winning")


** combine two figures created above
twoway (mspline expm0p1 expm0x, bands(50)) ///       (mspline expm5p1 expm5x, bands(50)), ///    ytitle("Predicted probability of winning") ///    ylabel(0(.2)1, grid) xlabel(,grid) ///    legend(label(1 "no previous wins") ///           label(2 "5 previous wins") ///           rows(2) position(4) ring(0))

/* -----------------------------------------------------
 Appendix 14.1
-------------------------------------------------------*/
** generate predicted values
quietly logit wlsmd previous expmgenerate L1 = _b[_cons] + _b[previous]*0 ///    + _b[expm]*[expm]generate Phat1 = 1/(1 + exp(-L1))label variable Phat1 "P(win >=1) | previous = 0)"generate L2 = _b[_cons] + _b[previous]*5 ///    + _b[expm]*[expm]generate Phat2 = 1/(1 + exp(-L2))label variable Phat2 "P(win >=1 | previous = 5)"** conditional effect plottwoway (mspline Phat1 expm, bands(50)) ///       (mspline Phat2 expm, bands(50)), ///    ytitle("Predicted probability of winning") ///    ylabel(0(.2)1, grid) xlabel(,grid) ///    legend(label(1 "no previous wins") ///           label(2 "5 previous wins") ///           rows(2) position(4) ring(0))




/* -----------------------------------------------------
 Analysis of the real elecoral data
-------------------------------------------------------*/
use hr96-09.dta, clear

** generate a binary outcome variable of winning in an SMD
gen wlsmd=0
replace wlsmd=1 if wl==1
label var wlsmd "win or lose in SMD"
label values wlsmd wlsmdlbl
label define wlsmdlbl 0 "lose" 1 "win"

** transform exp and generate expm
gen expm = exp/1000000

** focus on LDP in 2009
keep if party==800 & year==2009


** scatter plot: wlsmd vs previous
scatter wlsmd previous

** scatter plot: wlsmd vs expm
scatter wlsmd expm


** correlation between the response and an explantory var
cor wlsmd previous
cor wlsmd expm


** a logistic regression
**   response = wlsmd
**   explanatory var = precious and expm
logit wlsmd previous expm



** precision of the logistic regression
quietly logistic wlsmd previous expm
lstat


** descriptive statistics of expm
sum expm, detail


** the effects of the explanatory var's on the response
quietly logit wlsmd previous expm
prchange



** generate predicted values for varying previous with fixing expm at the minimum value.
prgen previous, x(expm=0.010358) gen(prev0)
** list the generated values
list prev0x prev0p0 prev0p1
** visually display the predicted values
twoway mspline prev0p1 prev0x, ytitle("Predicted probability of winning")

** generate predicted values for varying previous with fixing expm at the maximum value.
prgen previous, x(expm=25.35407) gen(prev2535)
** list the generated values
list prev2535x prev2535p0 prev2535p1
** visually display the predicted values
twoway mspline prev2p1 prev2x, ytitle("Predicted probability of winning")


** combine two figures created above
twoway (mspline prev0p1 prev0x, bands(50)) ///       (mspline prev2535p1 prev2535x, bands(50)), ///    ytitle("Predicted probability of winning") ///    ylabel(0(.2)1, grid) xlabel(,grid) ///    legend(label(1 "0.010358 million yen") ///           label(2 "25.35 million yen") ///           rows(2) position(4) ring(0))
           

/* -----------------------------------------------------
 Appendix 14.3
-------------------------------------------------------*/
** generate predicted values
quietly logit wlsmd previous expmgenerate L1 = _b[_cons] + _b[expm]*0.010358 ///    + _b[previous]*[previous]generate Phat1 = 1/(1 + exp(-L1))label variable Phat1 "P(win >=1) | expm = 0.010358)"generate L2 = _b[_cons] + _b[expm]*25.35407 ///    + _b[previous]*previousgenerate Phat2 = 1/(1 + exp(-L2))label variable Phat2 "P(win >=1 | expm = 25.35407 )"

** conditional effect plottwoway (mspline Phat1 previous, bands(50)) ///       (mspline Phat2 previous, bands(50)), ///    ytitle("Predicted probability of winning") ///    ylabel(0(.2)1, grid) ///    xlabel(,grid) ///    legend(label(1 "0.010358 million yen") ///           label(2 "25.35 million yen") ///           rows(2) position(4) ring(0))



** close the log file
log close
