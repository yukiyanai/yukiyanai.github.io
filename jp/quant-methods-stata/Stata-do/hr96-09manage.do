/* =======================================================================
hr96-09manage.do

Stata do-file for labeling the variables in hr96-09 data

Ch.5 in 
  Stata ni yoru Keiryoseijigaku
     by Masahiko Asano and Yuki Yanai

Created: Jan/06/2013 by MA and YY
==========================================================================*/

** label the variable "wl"
label variable wl "electoral results"
label values wl wllbl
label define wllbl 0 "lose" 1 "win" 2 "zombie"

** label the variable "status"
label variable status "candidate status"
label values status statuslbl
label define statuslbl 1 "challenger" 2 "incumbent" 3 "moto"

** label the variable "party"
label variable party "party name"
label values party partylbl 
label define partylbl 1 "msz" 305 "JCP" 800 "LDP" 850 "CGP" ///
    877 "oki" 886 "tai" 928 "saki" 1000 "NFP" 1001 "DPJ" 1002 "SDP" ///
    1003 "LF" 1004 "NJSP" 1005 "DRF" 1010 "kobe" 1011 "nii" 1012 "sei" ///
    1013 "JNFP" 1014 "bunka" 1015 "green" 1020 "LP" 1021 "RC" 1022 "muk" ///
    1023 "CP" 1030 "NCP" 1031 "ND" 1032 "son" 1033 "sek" 1038 "NP" ///
    1040 "NNP" 1041 "NPJ" 1042 "NPD" 1111 "minna" 1112 "R" 1115 "H" 9998 "sho"


** label the variable "year"
label var year "election year"

** label the variable "ku"
label var ku "prefecture"

** label the variable "kun"
label var kun "district number"

** label the variable "name"
label var name "candidate name (LAST, FIRST)"

** label the variable "age"
label var age "candidate age"

** label the variable "nocand"
label var nocand "number of candidate in each district"

** label the variable "rank"
label var rank "rank"

** label the variable "previous"
label var previous "number of winning"

** label the variable "vote"
label var vote "number of votes"

** label the variable "voteshare"
label var voteshare "vote share (%)"

** label the variable "eligible"
label var eligible "number of eligible voters"

** label the variable "turnout"
label var turnout "turnout in each district(%)"

** label the variable "exp"
label var exp "campaign spending (yen)"

