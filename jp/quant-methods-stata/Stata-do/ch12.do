/* =======================================================================
ch12.do

Stata do-file for Ch.12 of the textbook
  Stata ni yoru Keiryoseijigaku
by Masahiko Asano and Yuki Yanai

Created: Feb/05/2013 by MA and YY
=========================================================================*/

set more off

** change the working directory
** (the path must be tailored to your computer environment)
cd ~/stata/

** open a log file
log using log_ch12.log, replace


/* -------------------------------------------------------------
 Regression diagnostics for the analysis of the electoral data
---------------------------------------------------------------*/
** open the dataset
use hr96-09.dta, clear

** focus on LDP in 2009
keep if year==2009 & party==800

** generate a new variable "expm"
generate expm = exp/1000000

** regress voteshare on expm and previous
reg voteshare expm previous

** draw a residual plot: residuals vs predicted values
rvfplot, yline(0)

** save the residual in e
predict e, residual

** draw a normal Q-Q plot of e (residual)
qnorm e

** close the log file
log close
