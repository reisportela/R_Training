//////////////////////////////////////
// PANEL DATA exercise				//
// Miguel Portela -- 2021			//
// Universidade do Minho, Portugal	//
//////////////////////////////////////


// === BEGIN === //

clear all
set more off
set rmsg on

cd C:\Users\mangelo.EEG\Documents\GitHub\R_Training\paneldata\logs

capture log close
log using paneldata.txt, text replace

timer on 1

// # 1. build simulated data: 10000 observations

	set obs 5000			// 	define the number of observations
	set seed 345567789		// 	define the 'seed' in order to be able
							//	to replicate the results

	// # 1.1. define worker's id and year of observation

		gen workerid = int(_n/10.1)+1
		bysort workerid: gen year = _n

		sort workerid year
		xtset workerid year

	// # 1.2. generate individual's specific effect, ui

		bysort workerid (year): gen double ui = runiform() if _n == 1
			 bysort workerid (year): replace ui = ui[_n-1] if _n > 1

	// # 1.3. build the instrument, q1

		bysort workerid (year): gen quarter= int(4*uniform()+1) if _n == 1
			 bysort workerid (year): replace quarter = quarter[_n-1] if _n > 1

			gen q1=(quarter==1)

	// # 1.4. build education and experience; education is a function of ui,
			// the worker specific effect, as well as the instrument, q1

		bysort workerid (year): gen educ= int(16*runiform())*ui if _n == 1
			bysort workerid (year): replace educ= educ - 3*q1 if _n == 1

			bysort workerid (year): replace educ = educ[_n-1] + round(runiform()) if _n > 1
				sum educ, detail
			
			egen sd = sd(educ),by(workerid)
				sum sd, detail
				drop sd
				
				recode educ min/0 = 0 20/max = 20
					sum educ, detail

		bysort workerid (year): gen exper= int(20*uniform()) if _n == 1
			bysort workerid (year): replace exper = exper[_n-1] + 1 if _n > 1

			gen exper2 = exper^2
	
	// # 1.5. union status
	
		gen union = round(uniform(),1.0)
			
			tab union

	// # 1.6. generate the true log wage equation, where the error term is
				// defined by 'uniform()/ln(600)'; 600 is the minimum wage
	
		gen double lnwage = ln(600) + 0.06*educ + 0.007*exper - 0.00001*exper2 ///
							+ 0.02*year + ui + uniform()/ln(600)

			gen wage = exp(lnwage)
			
			egen nobs = count(workerid),by(workerid)
				tab nobs
					drop if nobs < 10
					
						drop nobs
tab year
drop if year > 10
tab year, ge(yy)

	sort workerid year
	xtset workerid year
	
	gen lag_lnwage = l.lnwage

	compress
	order workerid year ui quarter q1 wage educ exper union exper2 lnwage
	sort workerid year

				save ../data/data_simulation, replace

// # 2. DESCRIPTIVE STATISTICS

		describe
		codebook, compact
		
		sum
		inspect educ
		
		xtdes
		xtsum
		
			gen educ_int = round(educ,1.0)

	xttab educ_int
	xttab union

	xttrans educ_int
	xttrans union

			preserve
				collapse (mean) mean_educ = educ (count) educ,by(workerid)
				sum mean_educ educ if mean_educ ~= .
			restore

				tabstat educ,by(union)
				sum educ, detail
					scalar median_educ = r(p50)

	// # 2.1. export descriptive statistics & graphs

					preserve
						set dp comma
							tab year
								sum year
								
							keep if year == r(max)
							
							format %12.3f wage educ exper
							
					estpost summarize wage educ exper
					esttab using ../tex_paper/summary_statistics.tex, replace ///
						cells("count mean sd min max") nonumbers noobs label ///
						nomtitles nonotes addnotes("Source: own computations.")
						
						set dp period
					restore

					preserve
						collapse (mean) mean_educ = educ mean_wage = wage,by(year)
						gen ln_mean_wage = ln(mean_wage)
						
						label var mean_educ "Average education"
						label var ln_mean_wage "Ln Average WAGE"
						
						sum year
						local mm = r(min)
						local jj = r(max)
						twoway (line mean_educ year, yaxis(1)) || (line ln_mean_wage year, yaxis(2) title("`mm' - `jj'")), ///
							scheme(sj) title("") graphregion(color(white)) legend(region(color(white)))
							
							graph export ../tex_paper/figures/mean_education_wage_year.png, replace
							graph export ../tex_paper/figures/mean_education_wage_year.eps, replace
					restore

						sum year
						local mm = r(min)
						local jj = r(max)
					
					twoway kdensity lnwage if educ <= median_educ,legend(on label(1 "Low education")) || kdensity lnwage if educ > median_educ, /*
						*/ legend(on label(2 "High education")) title("`mm' - `jj'") scheme(s2mono) graphregion(color(white)) xtitle("Ln GDP") /*
						*/ ytitle("Density") legend(region(lcolor(white))) legend(region(color(white)))

						graph export ../tex_paper/figures/lnwage_education.png, replace					
						graph export ../tex_paper/figures/lnwage_education.eps, replace


// # 3. REGRESSIONS

	// # 3.1 OLS

		reg lnwage educ exper exper2
		reg lnwage educ exper exper2 i.year ui

		reg lnwage educ exper exper2 i.year
			est store OLS
			
	// # 3.2 PANEL

		// # 3.2.1 RANDOM EFFECTS

			xtreg lnwage educ exper exper2 i.year, re theta
					est store RE
				
		// # 3.2.2 FIXED EFFECTS

			// discuss why some time dummies are dropped

			xtreg lnwage educ exper exper2, fe			// omit the time dummies

			xtreg lnwage educ exper exper2 i.year, fe	// complete model
				est store FE
				
		// # 3.2.3 HAUSMAN test

			hausman FE RE

	// # 3.3 IV: cross-section

		preserve
			bysort workerid (year): keep if _n==1		// cross-section
			
			xi: ivreg2 lnwage (educ = q1) exper exper2 i.year, first
				est store IV
		restore

	// # 3.4 PANEL + IV

		// DISCUSS why education is dropped in the following regression

		xtivreg lnwage (educ=q1) exper exper2 i.year, fe
			est store FE_IV
			
		// COMPARE 'ivreg2' & 'xtivreg2, re' results

		xtivreg lnwage (educ=q1) exper exper2 i.year, re
			est store RE_IV

		// DISCUSS the underlying problems with this exercise


// # 4. HETEROSKEDASDICITY & SERIAL CORRELATION

	// # 4.1. test for heteroskedasticity within panel data

		// optimal solution proposed by Greene, Econometric Analysis

			xtreg lnwage educ exper exper2 i.year, fe
				xttest3

	// # 4.2. test for serial correlation within panel data

		tab year, gen(yy)
			ret li

		xtserial lnwage educ exper exper2 yy2-yy11
			
			xtreg lnwage educ exper exper2 i.year, fe cluster(workerid)

		// following this sequence of tests you can also test for cross-sectional
		// correlation in fixed effects model
		
		xtdes
		
		
		// the following solution would issue an error message in the original data as there 
		// are too many cross-section units ==> build a small ramdom sample

			preserve
				set seed 234
				sample2 1,cluster(workerid)
				xtreg lnwage educ exper exper2 i.year, fe
					xttest2
			restore

		// you can also apply specification tests for error-component models
		// this is only relevant in case the Hausman test does not reject the validity of the RE model

			xtreg lnwage educ exper exper2 year, re
				
				xttest1

		// CONCLUSION: the above results lead us to conclude that we reject the base hypothesis
		// of the FE model that we have homoskedasticy & no serial correlation in the error term

		// the cluster-robust standard errors allow for heteroscedasticity and serial correlation
		// correct solution would be


	// # 4.3. SUGGESTED MODEL

		xtreg lnwage educ exper exper2 i.year, fe cluster(workerid)
			est store FE_cluster

				test educ
				test exper exper2
				estat ic


// # 5. GOODNESS-OF-FIT measures

	egen meduc = mean(educ),by(workerid)
	gen deduc = educ - meduc
	egen mlnwage = mean(lnwage),by(workerid)
	gen dlnwage = lnwage - mlnwage

		xtreg lnwage educ, fe
		
		ereturn list
			display "RMSE:	" e(rmse)
			
		estat ic
			
		// R sq, within
			reg dlnwage deduc

		// R sq, between
			preserve
				collapse (mean) lnwage educ,by(workerid)
				reg lnwage educ
			restore

		// R sq, overall
			reg lnwage educ
				predict y_hat_ols
					correlate lnwage y_hat_ols
					ret li
					di r(rho)^2

			estimates restore FE
				predict y_hat_fe
					correlate lnwage y_hat_fe
					ret li
					di r(rho)^2


// # 6. OUTPUT EXPORT

		estimates dir
		est stats OLS RE FE IV FE_IV RE_IV FE_cluster

			estimates table OLS RE FE IV FE_IV RE_IV FE_cluster, keep(educ exper exper2) ///
				b(%7.4f) se(%7.4f) stats(N r2_a)

			estimates table OLS RE FE IV FE_IV RE_IV FE_cluster, keep(educ exper exper2) ///
				b(%7.4f) star stats(N r2_a)
			
	outreg, clear
		
		estimates restore OLS
			outreg using ../tex_paper/regression_analysis, tex frag replace ///
				rtitles("Education" \ "" \ "Exper" \ "" \ "Exper2" \ "")  ///
				keep(educ exper exper2) ///
				ctitle("","OLS") ///
				bdec(4) se starlevels(10 5 1) starloc(1) ///
				summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

		estimates restore RE
			outreg using ../tex_paper/regression_analysis, tex frag merge ///
				rtitles("Education" \ "" \ "Exper" \ "" \ "Exper2" \ "")  ///
				keep(educ exper exper2) ///
				ctitle("","RE") ///
				bdec(4) se starlevels(10 5 1) starloc(1) ///
				nodisplay summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

		estimates restore FE
			outreg using ../tex_paper/regression_analysis, tex frag merge ///
				rtitles("Education" \ "" \ "Exper" \ "" \ "Exper2" \ "")  ///
				keep(educ exper exper2) ///
				ctitle("","FE") ///
				bdec(4) se starlevels(10 5 1) starloc(1) ///
				nodisplay summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

		estimates restore IV
			outreg using ../tex_paper/regression_analysis, tex frag merge ///
				rtitles("Education" \ "" \ "Exper" \ "" \ "Exper2" \ "")  ///
				keep(educ exper exper2) ///
				ctitle("","IV") ///
				bdec(4) se starlevels(10 5 1) starloc(1) ///
				nodisplay summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

		estimates restore FE_IV
			outreg using ../tex_paper/regression_analysis, tex frag merge ///
				rtitles("Exper" \ "" \ "Exper2" \ "")  ///
				keep(exper exper2) ///
				ctitle("","FE_IV") ///
				bdec(4) se starlevels(10 5 1) starloc(1) ///
				nodisplay summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

		estimates restore RE_IV
			outreg using ../tex_paper/regression_analysis, tex frag merge ///
				rtitles("Education" \ "" \ "Exper" \ "" \ "Exper2" \ "")  ///
				keep(educ exper exper2) ///
				ctitle("","RE_IV") ///
				bdec(4) se starlevels(10 5 1) starloc(1) ///
				nodisplay summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

		estimates restore FE_cluster
			outreg using ../tex_paper/regression_analysis, tex frag merge ///
				rtitles("Education" \ "" \ "Exper" \ "" \ "Exper2" \ "")  ///
				keep(educ exper exper2) ///
				ctitle("","FE_cluster") ///
				bdec(4) se starlevels(10 5 1) starloc(1) ///
				summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")


// # 7. DYNAMIC PANEL DATA

	use ../data/data_simulation, clear

		tab year, ge(yy)

		// # 7.1. estimate OLS & FE benchmark models

				reg lnwage l.lnwage educ exper exper2 yy3-yy10, cluster(workerid)
					est store ols

				xtreg lnwage l.lnwage educ exper exper2 yy3-yy10, fe cluster(workerid)
					est store fe

		// # 7.2. GMM first-differences estimation, Arellano & Bond (1991)

				xtabond2 lnwage l.lnwage educ exper exper2 yy3-yy10, gmm(lnwage, lag(2 5)) gmm(educ, lag(2 5)) iv(i.year) ar(2) small noleveleq

				xtabond2 lnwage l.lnwage educ exper exper2 yy3-yy10, gmm(lnwage, lag(2 5)) gmm(educ, lag(2 5)) iv(yy3-yy9) ar(2) small noleveleq
					est store fd


		// # 7.3. GMM system estimation, Arellano & Bover (1995), Blundell & Bond (1998)

			// automatically insert timme dummies
				xtabond2 lnwage l.lnwage educ exper exper2 i.year, gmm(lnwage, lag(2 .))

			// manually insert timme dummies (created above with the command 'tab year, ge(yy)')
				xtabond2 lnwage l.lnwage educ exper exper2 yy2-yy10, gmm(lnwage, lag(2 5)) gmm(educ exper exper2, lag(2 5) collapse) iv(yy2-yy10, eq(level)) ar(2) twostep robust small
					est store sys

			xtabond2 lnwage l.lnwage educ exper exper2 yy2-yy10, gmm(lnwage, lag(3 5) collapse) gmm(educ exper exper2, lag(3 5) collapse) iv(yy2-yy10, eq(level)) ar(2) robust small
			xtabond2 lnwage l.lnwage educ exper exper2 yy2-yy10, gmm(lnwage, lag(3 5) collapse) gmm(educ exper exper2, lag(3 5) collapse) iv(yy2-yy10, eq(level)) ar(2) robust small twostep

			// see the comments for the FD model on the rejection of the statistics

				est table ols fe fd sys, star(.1 .05 .02) drop(yy* _cons) stats(r2 ll sargan sarganp hansen hansenp) b(%5.4f) title(Dynamic Growth regressions) /*
					*/ stfmt(%6.5f)

					outreg2 [ols fe fd sys] using dynamic_results, bdec(4) sdec(4) /*
						*/addstat(Hansen, e(hansen), Hansen p-value, e(hansenp)) word /*
						*/ replace keep(l.lnwage educ) /*
						*/ sortvar(l.lnwage education)


				sh start dynamic_results.rtf	// execute a DOS command == !start

		// 7.4. UNIT ROOT TESTS
		
			// define a balanced panel
			
				egen nobs = count(workerid),by(workerid)
					tab nobs
					
						keep if nobs == 10
							drop nobs

		// # 7.4.1. LLC test, using the AIC to choose the number of lags for regressions and using an HAC variance
		// estimator based on the Bartlett kernel and the number of lags chosen using Newey and West's method
			
			xtunitroot llc lnwage, demean lags(aic 2) kernel(bartlett nwest)

		// # 7.4.2. HT test, removing cross-sectional means from data
			
			xtunitroot ht lnwage, demean

		// # 7.4.3. Robust version of the Breitung test on a subset of OECD countries, using 3 lags for the prewhitening
		// step
			
			xtunitroot breitung lnwage, lags(3)
			
				preserve
					sample2 0.7,cluster(workerid)
					xtunitroot breitung lnwage, lags(3) robust
				restore

		// # 7.4.4. IPS test, using the AIC to choose the number of lags for regressions
			
			xtunitroot ips lnwage, lags(aic 5)

		// # 7.4.5. Fisher-type test based on ADF tests with 3 lags, allowing for a drift term in each panel
			
			xtunitroot fisher lnwage, dfuller lags(3) drift

		// # 7.4.6. Hadri LM test of stationarity, using an HAC variance estimator based on the Parzen kernel with 5 lags
			
			xtunitroot hadri lnwage, kernel(parzen 5)

	// # 7.5. DYNAMIC FORMULATION OF WAGE

		use ../data/data_simulation, clear
			tab year, ge(yy)
				set seed 234

			drop lnwage
			bysort workerid (year): gen lnwage = ln(600) + ui + uniform()/ln(600) if _n == 1
				bysort workerid (year): replace lnwage = ln(600) + 0.7*l.lnwage + ///
					0.06*educ + 0.007*exper - 0.00001*exper2 + ///
					0.02*year + ui + uniform()/ln(600) if _n > 1

				
				reg lnwage l.lnwage educ exper exper2 yy2-yy10
					est store ols_dd

				xtreg lnwage l.lnwage educ exper exper2 yy2-yy10, fe
					est store fe_dd

				xtabond2 lnwage l.lnwage educ exper exper2 yy3-yy10, ///
					gmm(lnwage, lag(2 5) collapse) gmm(educ, lag(2 5) collapse) ///
					gmm(exper exper2, lag(0 5) collapse) iv(yy3-yy10) ar(2) noleveleq
						est store fd_dd

				xtabond2 lnwage l.lnwage educ exper exper2 yy2-yy10, ///
					gmm(lnwage, lag(2 5) collapse) gmm(educ, lag(2 5) collapse) ///
					gmm(exper exper2, lag(0 5) collapse) iv(yy2-yy10, eq(level)) ar(2) robust small
						est store sys_dd

				est table ols_dd fe_dd fd_dd sys_dd, star(.1 .05 .02) drop(yy* _cons) ///
					stats(r2 ll sargan sarganp hansen hansenp) b(%5.4f) title(Dynamic Growth regressions)


		esttab ols_dd fe_dd fd_dd sys_dd using ../tex_paper/estimation_gmm_analysis.tex, replace ///
			keep(educ exper exper2) ///
			mtitle("OLS" "FE" "GMM-FD" "GMM-Sys") nonumbers ///
			coeflabel (educ Education exper "Experience" exper2 "Experience sq.") ///
			b(%5.4f) se(%5.4f) star(* 0.1 ** 0.05 *** 0.01) ///
				scalars("N Observations" "N_g Workers" ///
				"r2 \$R^{2}\$" "rmse Root MSE" ///
				"ar1 AR(1)" "ar1p p-value" "ar2 AR(2)" "ar2p p-value" ///
				"hansen Hansen" "hansen_df df" "hansenp H p-value") ///
			nonotes addnotes("Notes: standard errors in parenthesis. Significance levels: *, 10\%;" "**, 5\%; ***, 1\%. The dependent variable is ln real GDP per workers." "Source: own computations.")

// # 8. High-Dimensional Fixed-Effects

clear

// # 8.1. build simulated data

	set obs 10000			// 	define the number of observations
	set seed 345567789		// 	define the 'seed' in order to be able
							//	to replicate the results

	// # 8.1.1 define worker's id and year of observation
		
		gen workerid = int(_n/10.1)+1
		bysort workerid: gen year = _n

	// # 8.1.2 define firms's id
	
		gen firmid = int(_n/100.1)+1

		sort workerid year
		tsset workerid year

	// # 8.1.3 generate individual's specific effect, ui
		bysort workerid (year): gen double ui = runiform() if _n == 1
			 bysort workerid (year): replace ui = ui[_n-1] if _n > 1

	// # 8.1.4 generate individual's specific effect, ui
		
		// bysort firmid (year): gen double fi = runiform() if _n == 1
		// bysort firmid (year): replace fi = fi[_n-1] if _n > 1

			 egen mean_ui = mean(ui),by(firmid)

				gen fi = mean_ui + runiform()

			 bysort firmid (year): replace fi = fi[_n-1] if _n > 1

	// # 8.1.5 build education and experience; education is a function of ui,
	// the worker specific effect, as well as the instrument, q1

		bysort workerid (year): gen educ= int(16*uniform())*ui if _n == 1

			bysort workerid (year): replace educ = educ[_n-1] + round(uniform()) if _n > 1
			egen sd = sd(educ),by(workerid)
				sum sd, detail
				drop sd

		bysort workerid (year): gen exper= int(20*uniform()) if _n == 1
			bysort workerid (year): replace exper = exper[_n-1] + 1 if _n > 1

			gen exper2 = exper^2

	// # 8.1.6 generate the true log wage equation, where the error term is
	// defined by 'uniform()/ln(600)'; 600 is the minimum wage
		gen double lnwage = ln(600) + 0.06*educ + 0.007*exper - 0.00001*exper2 ///
							+ 0.02*year + ui + fi + uniform()/ln(600)

	// 8.2. ESTIMATIONS
	
	tab year
	drop if year == 11

		reg lnwage educ exper exper2 i.year
			est store ols_firm
		
		xtreg lnwage educ exper exper2 i.year,fe
			est store fe_firm

		reghdfe lnwage educ exper exper2 i.year, absorb(FE1=workerid FE2=firmid)
			est store hdfe_firm

			reg FE1 FE2
				drop FE1 FE2

			est table ols_firm fe_firm hdfe_firm, star(.1 .05 .02) keep(educ exper exper2) ///
				stats(N r2 rmse) b(%5.4f) title(High-Dimensional FE results)

		esttab ols_firm fe_firm hdfe_firm using ../tex_paper/estimation_hdfe_analysis.tex, replace ///
			keep(educ exper exper2) ///
			mtitle("OLS" "FE" "HDFE") nonumbers ///
			coeflabel (education "Education" lnk "Experience" openk "Experience sq.") ///
			b(%5.1f) se(%5.3f) star(* 0.1 ** 0.05 *** 0.01) ///
			scalars("N Observations" "ll Log likelihood" "r2 \$R^{2}\$" "F F statistic (overall)" "rmse Root MSE") ///
			aic t(3) ///
			nonotes addnotes("Notes: standard errors in parenthesis. Significance levels: *, 10\%;" "**, 5\%; ***, 1\%. The dependent variable is ln real GDP per workers." "Source: own computations.")

			
////////////////////////////////////////////////////////////////////////////////			
////////////////////////////////////////////////////////////////////////////////			
////////////////////////////////////////////////////////////////////////////////			
			

// # REPLICATE ARELLANO & BOND (1991) + Stata's 'xtabond2' command

/*
	webuse abdata, clear

		save ../data/abdata, replace

*/


// READ & DESCRIBE THE DATA
	
	use ../data/abdata, clear
		
		tsset id year, delta(1)
		
		xtsum
		
		xtsum n
		sum n
		
			preserve
				collapse (mean) mean_n = n (count) T_bar = n, by(id)
					sum mean_n T_bar
			restore
		
		egen mean_n_overall = mean(n)
		egen mean_n_id = mean(n),by(id)
		
			gen n_alt = n - mean_n_id + mean_n_overall
				
				sum n_alt
		xtsum n

// REGRESSION ANALYSIS
	
	// code in ROODMAN (2009)

		regress n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*
		xi: regress n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr* i.id
		xtreg n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*, fe

	use ../data/abdata, clear
		xtset
		
		xtdata n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*, fe
		regress n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*

// ROODMAN.3.2 Instrumenting with lags
	
	use ../data/abdata, clear
		xtset

	ivregress 2sls D.n (D.nL1= nL2) D.(nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr1979 yr1980 yr1981 yr1982 yr1983)
	
	
forvalues yr=1978/1984 {
	forvalues lag = 2 / `= `yr' - 1976' {
		quietly generate z`yr'L`lag' = L`lag'.n if year == `yr'
	}
}

quietly recode z* (. = 0)

ivregress 2sls D.n D.(L2.n w L.w k L.k L2.k ys L.ys L2.ys yr1978 yr1979 yr1980 yr1981 yr1982 yr1983) (DL.n = z*), nocons

// ROODMAN.3.3 Applying GMM

xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.n) iv(w L.w L(0/2).(k ys) yr*) h(1) nolevel small

xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.n) iv(w L.w L(0/2).(k ys) yr*) nolevel robust

xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.(n w k)) iv(L(0/2).ys yr*) nolevel robust small

// ROODMAN.3.4 Instrumenting with variables orthogonal to the fixed effects

xtabond2 n L.n L(0/1).(w k) yr*, gmmstyle(L.(n w k)) ivstyle(yr*, equation(level)) robust small



// ROODMAN.4.2 More examples

	use ../data/abdata, clear
		xtset

//		xi: xtabond2 y L.y i.t, gmmstyle(L.y) ivstyle(i.t) robust noleveleq	

//		xi: xtabond2 y L.y w1 w2 w3 i.t, gmmstyle(L.y w2 L.w3) ivstyle(i.t w1) twostep robust small orthogonal


regress n w k
abar
xtabond2 n w k, ivstyle(w k, equation(level)) small arlevels artests(1)

ivreg2 n cap (w = k ys), cluster(id)
abar, lags(2)
xtabond2 n w cap, ivstyle(cap k ys, equation(level)) small robust arlevels

ivreg2 n cap (w = k ys), cluster(id) gmm2s robust
abar
xtabond2 n w cap, ivstyle(cap k ys, equation(level)) twostep artests(1) arlevels

xtabond n, lags(1) pre(w, lagstruct(1,.)) pre(k, endog) robust
xtdpd n L.n w L.w k, dgmmiv(w k n) vce(robust)
xtabond2 n L.n w L.w k, gmmstyle(L.(w n k), eq(diff)) robust


forvalues y = 1979/1984 { /* Make variables whose differences are time dummies */
	gen yr`y'c = year>=`y'
}

gen cons = year

xtabond2 n L(0/1).(L.n w) L(0/2).(k ys) yr198?c cons, gmmstyle(L.n) ivstyle(L(0/1).w L(0/2).(k ys) yr198?c cons) noleveleq noconstant small robust

xtdpd n L.n L(0/1).(w k) yr1978-yr1984, dgmm(w k n) lgmm(w k n) liv(yr1978-yr1984) vce(robust) two hascons

xtabond2 n L.n L(0/1).(w k) yr1978-yr1984, gmmstyle(L.(w k n)) ivstyle(yr1978-yr1984, equation(level)) h(2) robust twostep small


//	Arellano & Bond (1991) Table 4
xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.n)iv(w L.w L(0/2).(k ys) yr*) nolevel robust //collumn a1

xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.n)iv(w L.w L(0/2).(k ys) yr*) nolevel twostep //collumn a2

xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.(n w k)) iv(L(0/2).ys yr*) nolevel robust small //collumn c

xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.(n w k)) iv(L(0/2).ys yr*) nolevel twostep small //collumn d

//Bludell & Bond (1998) Table 4
xtabond2 n L.n L(0/1).(w k) yr*, gmmstyle(L.(n w k)) ivstyle(yr*, equation(level)) h(1) robust small // collumn 4

drop if year==1976 | year==1977 | year==1978

xtabond2 n L.n L(0/1).(w k) yr*, gmmstyle(L.(n w k)) ivstyle(yr*, equation(level)) h(1) robust small // column 2


////////

// -> UNIT ROOT TESTS (URT)

	/*
	
	// The dataset 'pennxrate.dta' contains real exchange-rate data for a panel of countries observed over 34 years

		use https://www.stata-press.com/data/r16/pennxrate, clear
			save ../data/pennxrate, replace
	
	*/


use ../data/pennxrate, clear

// URT.1 Levin–Lin–Chu test

	xtunitroot llc lnrxrate if g7, lags(aic 10)
	xtunitroot llc lnrxrate if g7, lags(aic 10) demean
	
// URT.2 Harris–Tsavalis test

	xtunitroot ht lnrxrate, demean
	
	
// URT.3 Breitung test

	xtunitroot breitung lnrxrate if oecd, robust
	

// URT.4 Im–Pesaran–Shin test

	xtunitroot ips lnrxrate if oecd, demean
	
	xtunitroot ips lnrxrate if oecd, lags(aic 8) demean
	
// URT.5 Fisher-type tests

	xtunitroot fisher lnrxrate, dfuller drift lags(2) demean

// URT.6 Hadri LM test

	xtunitroot hadri lnrxrate if oecd, kernel(bartlett 5) demean

//////////////////////

	timer off 1
	timer list 1
		
		di _new(2) "SECONDS: " %9.1f round(r(t1),0.1)  "		MINUTES: " %9.2f round(r(t1)/60,0.01) _new(1)

		timer clear 1

log close


// === END === //
