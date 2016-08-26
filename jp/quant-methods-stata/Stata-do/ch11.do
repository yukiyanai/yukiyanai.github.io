/* =======================================================================
ch11.do

Stata do-file for Ch.11 of the textbook
  Stata ni yoru Keiryoseijigaku
by Masahiko Asano and Yuki Yanai

Created: Feb/05/2013 by MA and YY
=========================================================================*/

set more off

** change the working directory
** (the path must be tailored to your computer environment)
cd ~/stata/

** open a log file
log using log_ch11.log, replace



/* -----------------------------------------------------
 Analysis of the beer data
-------------------------------------------------------*/
** open the dataset
use beer2010.dta, clear

** regress beer on temp
regress beer temp

** graphical display of the 95% confidence interval
** Figure 11.2
twoway (lfitci beer temp) (scatter beer temp)



/* -----------------------------------------------------
 Analysis of the electoral data
-------------------------------------------------------*/
** open the dataset
use hr96-09.dta, clear

** focus on 2009 data
keep if year==2009
* drop if year!=2009

** focus on LDP candidates only
keep if party==800
* drop if party!=800

** generate a new variable "expm"
generate expm = exp/1000000


** regress voteshare on expm and previous
reg voteshare expm previous


** close the log file
log close
