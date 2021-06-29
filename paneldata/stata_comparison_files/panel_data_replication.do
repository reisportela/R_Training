//# Data Analysis: 2021
//# PANEL DATA MODELS WITH R | By: Miguel Portela and Anabela Carneiro

//////////////////////////////////////////////////////////////////////////////////////////////////

timer on 1

// http://scorreia.com/software/reghdfe/install.html

* Install ftools (remove program if it existed previously)
cap ado uninstall ftools
net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/") replace

* Install reghdfe 6.x
cap ado uninstall reghdfe
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/") replace

* Install parallel, if using the parallel() option; don't install from SSC
cap ado uninstall parallel
net install parallel, from(https://raw.github.com/gvegayon/parallel/stable/) replace
mata mata mlib index

// To run iv/gmm regressions with ivreghdfe, also run these lines:

cap ado uninstall ivreghdfe
cap ssc install ivreg2 // Install ivreg2, the core package
net install ivreghdfe, from(https://raw.githubusercontent.com/sergiocorreia/ivreghdfe/master/src/)



*Empirical application: National Longitudinal Survey 1968-1988*

clear all
set more off

capture cd "/Users/miguelportela/Documents/GitHub/R_Training/paneldata/"
capture cd "C:\Users\mangelo.EEG\Documents\GitHub\R_Training\paneldata"

capture log close
log using "stata_comparison_files/panel_data_results.txt", replace text

*saving output*


*opening the dataset*

use data/nlswork.dta, clear

//Final slide 11

xtset idcode year
*declare individual and time identifiers*

*variables description*

desc


*descriptive statistics*

xtdes
*describes the panel



sum
*descriptive statistics

xtsum
*between and within variation

xtline ln_wage if idcode<=5, over


*observations per year*
tabulate year

table union, by(year)


*drop missing values in the dependent variable*

drop if ln_wage==.



drop if union==.
drop if collgrad==.
drop if age==.
drop if tenure==.
drop if not_smsa==.
drop if south==.
drop if c_city==.



*Create new variables*

gen agesq=age*age

gen tensq=tenure*tenure


*Estimating a Mincerian Wage Equation*

*POLS estimator with cluster-robust standard errors*


*Q1*


reg ln_wage union collgrad age agesq tenure tensq not_smsa south c_city, robust cluster(idcode)

estimates store pols


//Final slide 20
*Q2*

*Random effects estimator (RE)*

xtreg ln_wage union collgrad age agesq tenure tensq not_smsa south c_city,re

estimates store re

preserve
	keep idcode year ln_wage union collgrad age agesq tenure tensq not_smsa south c_city
	egen nmiss = rowmiss(_all)
	keep if nmiss == 0
	drop nmiss
	egen nobs = count(idcode),by(idcode)
	sum nobs
	keep if nobs == r(max)
	drop nobs
	compress
	sort idcode year
	xtset idcode year
	//save data/nlswork_balanced, replace
	xtreg ln_wage union collgrad age agesq tenure tensq not_smsa south c_city,re
restore

xtreg ln_wage union collgrad age agesq tenure tensq not_smsa south c_city,re robust cluster (idcode)




*LM test for the presence of unobserved effects*

xttest0		




//Final slide 32

*Q3*

*Fixed effects estimator (FE)*


*Q3.1*

xtreg ln_wage union collgrad age agesq tenure tensq not_smsa south c_city,fe


estimates store fe

xtreg ln_wage union collgrad age agesq tenure tensq not_smsa south c_city,fe robust cluster(idcode)

*Q3.2*

test age agesq





*LSDV Estimator=FE estimator*
*using a smaller sample:*

reg ln_wage union age agesq tenure tensq /*
*/not_smsa south c_city b1.idcode if idcode<400

preserve
keep if idcode < 400
	keep idcode year ln_wage union collgrad age agesq tenure tensq not_smsa south c_city
	egen nmiss = rowmiss(_all)
	keep if nmiss == 0
	drop nmiss
	egen nobs = count(idcode),by(idcode)
	sum nobs
	keep if nobs == r(max)
	drop nobs
	compress
	sort idcode year
	xtset idcode year
	//save data/nlswork_balanced_small, replace
	reg ln_wage union age agesq tenure tensq /*
*/not_smsa south c_city b1.idcode
restore

*'b1.' defines the base category of id as category 1

testparm i.idcode


xtreg ln_wage union age agesq tenure tensq /*
*/not_smsa south c_city if idcode<400, fe


//Final slide 35

*Q4*
*Hausman test*

xtreg ln_wage union age agesq tenure tensq not_smsa south c_city,re

estimates store re2

xtreg ln_wage union age agesq tenure tensq not_smsa south c_city,fe

estimates store fe2


hausman fe2 re2,sigmamore


/*the sigmamore option specifies that both covariance matrices are based 
on the same estimated disturbance variance from the efficient estimator*/


//Final slide 46

*Q5*
*BE estimator
xtreg ln_wage union collgrad age agesq tenure tensq /*
*/ not_smsa south c_city ,be 

estimates store be

//Final slide 53

*Q6*
*FD estimator*

sort idcode year 

tsset idcode year


reg d.(ln_wage union age agesq tenure tensq /*
*/ not_smsa south c_city),noconst


reg d.(ln_wage union age agesq tenure tensq /*
*/ not_smsa south c_city),noconst robust cluster(idcode)

estimates store fd


*Output Table*


estimates table pols re fe be,b(%9.4f) star(.1 .05 .01) stats(N r2) title("Wage_Regressions")

					
*SPECIFICATION TESTS FOR PANEL DATA*


// # Test for heteroskedasticity within panel data

	// optimal solution proposed by Greene, Econometric Analysis

		findit xttest3
		
		xtreg ln_wage union age agesq tenure tensq not_smsa south c_city, fe
			
		xttest3

	

// # Test for serial correlation within panel data

	findit xtserial
	
	tsset idcode year
	
	xtserial ln_wage union age agesq tenure tensq not_smsa south c_city, output
		
	
	// the cluster-robust standard errors allow for heteroscedasticity and serial correlation
	
	xtreg ln_wage union age agesq tenure tensq not_smsa south c_city, fe robust cluster(idcode)


*OTHER COMMANDS"	
*Using the reghdfe command from Sergio Correia*
	findit reghdfe

reghdfe ln_wage union age agesq tenure tensq /*
*/ not_smsa south c_city,absorb(fe_worker0=idcode)	
	
reghdfe ln_wage union age agesq tenure tensq /*
*/ not_smsa south c_city,absorb(fe_worker1=idcode) vce(cluster idcode)


*including time dummies*

reghdfe ln_wage union agesq tenure tensq /*
*/ not_smsa south c_city i.year,absorb(fe_worker2=idcode) vce(cluster idcode)


reghdfe ln_wage union agesq tenure tensq /*
*/ not_smsa south c_city,absorb(idcode year)  vce(cluster idcode)



*identifying the singletons*

sort idcode year

by idcode: gen d=1

by idcode: egen count_years=sum(d)

tabulate count_years



*Using the panelstat command from Paulo Guimaraes"
// net install panelstat, from("https://github.com/pguimaraes99/panelstat/raw/master/") replace

panelstat idcode year

panelstat idcode year, gaps nosum

panelstat idcode year, demog nosum

panelstat idcode year, wiv(union, keep) nosum

panelstat idcode year, rel(ln_wage,keep) nosum

panelstat idcode year, rel(hours,keep) nosum


//save "tmp_files/nlswork.dta",replace

timer off 1
timer list 1
di _new(1) "MINUTES: " %5.1f r(t1)/60
timer clear 1

log close
clear
