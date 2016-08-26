/* =======================================================================
ch09.do

Stata do-file for Ch.9 of the textbook
  Stata ni yoru Keiryoseijigaku
by Masahiko Asano and Yuki Yanai

Created: Feb/05/2013 by MA and YY
=========================================================================*/

set more off

** change the working directory
** (the path must be tailored to your computer environment)
cd ~/stata/

** open a log file
log using log_ch09.log, replace




/* -----------------------------------------------------
 Contingency table of the electoral data
-------------------------------------------------------*/
** open the electoral dataset
use hr96-09.dta, clear

** cross-tabulate the variables status and wl in the 2009 HR election
** Table 9.2
tabulate status wl if status<3 & wl<2 & year==2009


** row percentagea
** Table 9.3
tab status wl if status<3 & wl<2 & year==2009, row


** column percentge
** Table 9.4
tab status wl if status<3 & wl<2 & year==2009, column


** cell percentage
** Table 9.5
tab status wl if status<3 & wl<2 & year==2009, cell




/* -----------------------------------------------------
 Chi-square test of cabinet support by gender
-------------------------------------------------------*/
** open the dataset
use ch9_cabinet_support.dta, clear

** conduct a chi-square test
tabulate male support, chi2


** open the dataset
use ch9_fisher.dta, clear

** conduct a Fisher's exact test
tab male support, exact




/* -----------------------------------------------------
 Analysis of correlations in the electoral data
-------------------------------------------------------*/
** open the electoral dataset
use hr96-09.dta, clear


** scatter plot: vote vs exp in 2009
** Figure 9.6
scatter vote exp if year==2009

** statistical test of correlation between vote and exp in 2009
pwcorr vote exp if year==2009, sig


** sctter plot: vote vs exp, Your Party (Minna-no-to) in 2009
** Figure 9.7
scatter vote exp if year==2009 & party==1111

** statistical test of correlation between vote and exp
**  for Your Party (Minna-no-to) in 2009
pwcorr vote exp if year==2009 & party==1111, sig


** close the log file
log close
