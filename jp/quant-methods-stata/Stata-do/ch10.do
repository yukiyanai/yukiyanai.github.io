/* =======================================================================
ch10.do

Stata do-file for Ch.10 of the textbook
  Stata ni yoru Keiryoseijigaku
by Masahiko Asano and Yuki Yanai

Created: Feb/05/2013 by MA and YY
=========================================================================*/

set more off

** change the working directory
** (the path must be tailored to your computer environment)
cd ~/stata/

** open a log file
log using log_ch10.log, replace



/* -----------------------------------------------------
 Analysis of the beer data
-------------------------------------------------------*/
** open the dataset
use beer2010.dta, clear


** scatter plot: beer vs temp
** Figure 10.1
scatter beer temp

** correlation between beer and temp
correlate beer temp


** scatter plot with a regression line: beer vs temp
** Figure 10.2
twoway (scatter beer temp) (lfit beer temp)


** a simple regression
**   response variable = beer
**   explanatory variable = temp
regress beer temp



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


** a multiple regression
**  response variable = voteshare
**  explanatory variable 1 = exp
**  explanatory variable 2 = previous
reg voteshare exp previous


** generate a new variable "expm"
generate expm = exp/1000000

** a multiple regression
**  response variable = voteshare
**  explanatory variable 1 = expm
**  explanatory variable 2 = previous
reg voteshare expm previous




/* -----------------------------------------------------
 Obtain the results of a multiple regression
   by a series of simple regressions
-------------------------------------------------------*/

** regress voteshare on expm
reg voteshare expm


** regress voteshare on previous
reg voteshare previous
** save the residuals in e1
gen e1 = voteshare - (35.400008 + 1.417635*previous)
* predict e1, residual


** regress expm on previous
reg expm previous
** save the residual in e2
gen e2 = expm - (9.99618 + 0.378646*previous)
* predict e2, res


** regress e1 on e2
reg e1 e2



** close the log file
log close
