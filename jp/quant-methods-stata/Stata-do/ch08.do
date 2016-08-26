/* =======================================================================
ch08.do

Stata do-file for Ch.8 of the textbook
  Stata ni yoru Keiryoseijigaku
by Masahiko Asano and Yuki Yanai

Created: Feb/05/2013 by MA and YY
==========================================================================*/

set more off

** change the working directory
** (the path must be tailored to your computer environment)
cd ~/stata/

** open a log file
log using log_ch06.log, replace


/*----------------------------------------------
  Tully's vs Starbucks: unpaired t-test
-------------------------------------------------*/
** open the dataset of unpaired survey of Starbucks and Tully's
use coffee_unpaired.dta, clear

** box-and-whisker plot of scores: Tully's vs Starbucks
** (Figure 8.3)
graph box score, over(starbucks)

** Welch's t-test
ttest score, by(starbucks) welch


/*----------------------------------------------
  Tully's vs Starbucks: paired t-test
-------------------------------------------------*/
** open the dataset of paired survey of Starbucks and Tully's
use coffee_paired.dta, clear

** Paired t-test
ttest tullys==starbucks



/*----------------------------------------------
  Tully's vs Starbucks: paired t-test
  Small sample (n=5)
-------------------------------------------------*/
** open the dataset of paired survey of Starbucks and Tully's
use coffee_paired_small.dta, clear

** Paired t-test
ttest tullys==starbucks



/*----------------------------------------------
  Tully's vs Starbucks: paired t-test
  Large difference in sample means
-------------------------------------------------*/
** open the dataset of paired survey of Starbucks and Tully's
use coffee_paired_diff.dta, clear

** Paired t-test
ttest tullys==starbucks




/*----------------------------------------------
  Analysis of the electoral data
-------------------------------------------------*/
** open the dataset of the HR elections, 1996-2009
use hr96-09.dta, clear

** descriptive statistics of the variable "vote" in 2009
summarize vote if year==2009


** generate a dummy variable indicating LDP candidates
** 1=LDP, 0=DPJ, missing(.)=other parties
generate ldp=.
replace ldp=1 if party==800
replace ldp=0 if party==1001


** check the number of votes obtained by DPJ and LDP candidates in 2009
tabulate ldp if year==2009, sum(vote)


** box-and-whisker plots of vote for DPJ and LDP in 2009
** Figure 8.5
graph box vote if year==2009, over(ldp)


** Welch's t-test
ttest vote if year==2009, by(ldp) welch


** close the log file
log close
