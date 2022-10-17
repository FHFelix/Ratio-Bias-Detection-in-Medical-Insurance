
clear
log using "/Users/felixhuang/Desktop/490log.log",replace

use "/Users/felixhuang/Desktop/addwave4.dta"

keep H4HS1 H4IR4 H4LM25 H4LM4 H4OD1Y H4TO3

*create age variable
gen age=2008-H4OD1Y

*create y insurance variable where insuarance=1 as insurance with work, and insurance=0 as no insurance
gen insurance=1 if H4HS1==2 | H4HS1==3
replace insurance=0 if H4HS1==1
drop if insurance==.

*create race dummy variable where race=1 white, race=0 black; forcus on white and black
gen race=1 if H4IR4==1
replace race=0 if H4IR4==2

*rename H4LM4 as fireNumber
rename H4LM4 fireNumber
drop if fireNumber>=97

*create dummy variable: Supervised=1 as supervised others; Supervised=0 as not supervise others
gen Supervised=1 if H4LM25==1 | H4LM25==2
replace Supervised=0 if H4LM25==3
drop if Supervised==.

*create dummy variable: smoke=1 and smoke=0
gen smoke=1 if H4TO3==1
replace smoke=0 if H4TO3==0 | H4TO3==7
drop if smoke==.

*summary statistic
sum insurance race Supervised fireNumber age smoke
sum insurance Supervised fireNumber if race==0
sum insurance Supervised fireNumber if race==1

*regression model
*OLS regression
reg insurance race Supervised fireNumber age smoke
outreg2 using regressionResult, replace ctitle(OLS Regression)
vif
hettest
predict residuals,residual
kdensity residuals,normal

*Probit regression
probit insurance race Supervised fireNumber age smoke
outreg2 using regressionResult, append ctitle(Probit Regression)

log close
