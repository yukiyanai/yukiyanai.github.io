/* =======================================================================
ch05.do

Stata do-file for Ch.5 of the textbook
  Stata ni yoru Keiryoseijigaku
by Masahiko Asano and Yuki Yanai

Created: Jan/06/2013 by MA and YY
==========================================================================*/

set more off

** change the working directory
** (the path must be tailored to your computer environment)
cd ~/stata/

** open a log file
log using log_ch05.log, replace

** open a csv dataset
insheet using hr96-09.csv, clear


** get basic statistics of the variables in the dataset
summarize

** tabulate the variable wl and status
tabulate wl
tab status
	

** do (or run) the do-file to label variables
do hr96-09manage.do
** run hr96-09manage.do


** check the labels
tab wl
tab status
tab party


** show the frequency distribution table of party in the 2009 HR election
tab party if year==2009


** the number of SMD winners by party in the 2009 HR election
tab party if year==2009 & wl==1


** show the prfile of two SMD winners belonging to Your Party
list ku kun name age nocand rank vote ///
    if year==2009 & party==1111 & wl==1, noobs

** show the electoral results of Kenji EDA
list year party age nocand rank status wl previous vote ///    if name=="EDA, KENJI", noobs


** save the modified dataset in Stata format
save hr96-09.dta, replace




** stem-and-leaf plot of SDP candidates' ages (1)?** Figure 5.2 (will be displayed in Results window)
stem age if party==1002 & year==2009, lines(1)

** stem-and-leaf plot of SDP candidates' ages (2)
** Figure 5.3 (will be displayed in Results window)
stem age if party==1002 & year==2009



** histogram of age of SDP candidattes in 2009,
**   vertical axis repsents frequency
** Figure 5.4 and Figure 5.6
histogram age if party==1002 & year==2009, ///    width(10) start(30) frequency

** histogram of age of SDP candidattes in 2009,
**   vertical axis represents probability density
** Figure 5.5hist age if party==1002 & year==2009, ///    width(10) start(30) 

** histogram of age of SDP candidattes in 2009,
**   vertical axis repsents frequency, the number of bins is 7
** Figure 5.7
histogram age if party==1002 & year==2009, freq bin(7)


** box-and-whisker plot of age of SDP candidattes in 2009
** Figure 5.9
graph box age if year==2009 & party==1002

** box-and-whisker plot of SMD winners' ages by party in 2009
** Figure 5.10
graph box age if year==2009 & wl==1, over(party)


** see the distribution of the ages of the SMD winners 
**   belonging to LDP in 2009
tabstat age if year==2009 & party==800 & wl==1, ///    stat(min p25 median p75 max mean sd)

** see the distribution of the ages of the SMD winners 
**   belonging to DPJ in 2009
tabstat age if year==2009 & party==1001 & wl==1, ///    stat(min p25 median p75 max mean sd)

** see the distribution of the ages of the SMD winners 
**   belonging to SDP in 2009)
tabstat age if year==2009 & party==1002 & wl==1, ///    stat(min p25 median p75 max mean sd)


** show the profile of SDP's SMD winners in 2009
list name ku kun party age ///    if year==2009 & wl==1 & party==1002, noobs


** close the log file
log close






