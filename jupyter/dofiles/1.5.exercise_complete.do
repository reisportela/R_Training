//////////////////////////////////////////////////////////////////////////
// 2020 STATA ECONOMETRICS WINTER SCHOOL								//
// January 20-24, 2020													//
// Faculdade de Economia da Universidade do Porto, Portugal				//
// Anabela Carneiro, João Cerejeira, Miguel Portela	& Paulo Guimarães	//
//////////////////////////////////////////////////////////////////////////

// -- Organizing and handling data
// -- Data analysis
// -- Producing analysis output: graphs and tables

// tree -P *.do

version
	clear all												// CLEAR STATA'S MEMORY; START A NEW SESSION
	set more off											// ALLOW SCREENS TO PASS BY
	set rmsg on												// CONTROL THE TIME NEEDED TO RUN EACH COMMAND

	timer on 1

		capture cd "D:\miguel\Dropbox\uminhoexecss2020\day1\5.exercise_complete\logs"
		capture cd "/Users/miguelportela/Dropbox/1.miguel/1.formacao/jupyter/stata_full_exercise/logs/"

// DAY 1: Complete exercise

// start a command log to register everything you type interactively
capture cmdlog close
capture cmdlog using commands.txt, replace

// start a log file for the output

capture log close
log using exercise_complete_output.txt, text replace

// # 1. Build the data

	// We will use the 3 datasets discussed under section "handling data", namely income, education and capital data at the country level

// # 1.1 explore the three data files

	// # 1.1.a INCOME

	use ../data/income, clear
		describe
		codebook, compact
		inspect openk
		sum
		sum rgdpwok, detail

			lookfor GDP

		order isocode,before(year)
		des
		list country isocode year in 1/10
		assert (year >= 1950 & year <= 2010)
		// assert pop >0 & pop ~= .
		// ssc install unique
		unique year
		unique country

	// # 1.1.b EDUCATION

	use ../data/education, clear
		describe
		codebook, compact
		inspect education
		sum education, detail

		unique year
		unique country

		// IDENTIFY DUPLICATES

			duplicates tag country,gen(dup)
				tab dup
				list if dup == 0
					drop dup

		tabstat education,by(country) stat(mean sd min p10 p50 p90 p99)

		logout, save(tabstat_education_country) excel word replace: tabstat education,by(country) stat(mean sd min p10 p50 p90 p99)

		// the command logout closes the log, so one has to open it with the option append
			log using exercise_complete_output.txt, text append

	// # 1.1.c CAPITAL

	use ../data/capital, clear
		describe

		// browse the data using the command 'browse' to explore its features
		// key conclusion: one needs to reshape the data

		reshape long k,i(country) j(year)
		describe

		// as k, for capital, is a string, one needs to make it a number

		destring k, replace force		// type 'help destring' to understand the option force

		rename k capital

		label var capital "Total capital per country"

		codebook, compact
		inspect capital
		sum capital, detail
		unique year
		unique country

		sort country year

			preserve
				drop if capital == .		// drop observations that satisfy the condition
				list in 1/10
				tab country
			restore

		save ../data/data_capital_long, replace

// # 1.2 combine the three data sets and save the data for the following analysis

	use ../data/income
	merge 1:1 country year using ../data/education
		drop _merge

		merge 1:1 country year using ../data/data_capital_long
		drop _merge

		egen rmiss = rowmiss(rgdpwok education)
		tab rmiss
		keep if rmiss == 0
			drop rmiss

	save ../data/data_full, replace

	// if your co-author uses Stata version 13 you need to save the data file in the old format

		saveold ../data/data_full_stata_version13, replace version(13)

// # 2. explore the data

// # 2.1 Exploratory Data Analysis

	use ../data/data_full, clear
		describe
		codebook, compact
		inspect rgdpwok education capital
		tab country year if year >= 1990 & year <= 2000
		tab country year if year >= 1990 & year <= 2000,sum(education)

// # 2.2 generate variables, label values, etc.

		generate lngdp = ln(rgdpwok)
		ge lnk = ln(capital)

		label var rgdpwok "Real GDP per worker"
		label var education "Education (in years)"
		label var capital "Capital"
		label var open "Degree of openness"

		sum open, detail
		return list

			format %5.2f open
			l open in 1/10

			format %5.3f open
				sum open
				sum open, format

		gen high_open = (open > r(p50) & open ~= .)
		label define lbl_openh 0 "Low openness"  1 "High openness"
		label values high_open lbl_openh
		tab high_open

		// one could replace the values under 'high_open' with 10 & 20

			clonevar high_open_tmp = high_open
				recode high_open_tmp 0 = 10 1 = 20
				tab high_open_tmp
					drop high_open_tmp

		encode country, gen(country_n)
			tab country_n if high_open == 1
			tab country_n if high_open == 1, nolabel

		label dir
		label list country_n

		bysort country: gen nobs_1 = _N
		egen nobs_2 = count(year),by(country)

			compare nobs_1 nobs_2
			drop nobs*

		foreach nn of numlist 1985(5)2000 {

			display _new _new "YEAR: 	`nn'" _new
			preserve
				keep if year == `nn'
				tabstat education,by(high_open) stat(mean sd p10 p50 p90 p99)
			restore

		}

		// within variable transformation/correction
		replace country = proper(country)	// replace within variable 'country' all country names with caps in the first letter

			preserve

				contract country
					drop _freq
					list in 1/10

			restore

		// explore Stata's functions, type help functions
		// play with string functions, substr, word, regexr

		replace country = regexr(country,"Spain","Espanha")

		local cc = "Portugal Espanha"

		foreach asd of local cc {

			di _new _new "COUNTRY:	`asd'" _new

			preserve
				keep if country == "`asd'"
				sum education if year >= 1990, detail
			restore

		}

		preserve

			// use just one data point per country

			collapse (mean) lngdp education,by(country)
			count
			codebook, compact

			scatter lngdp education || lfit lngdp education, scheme(economist)
				graph export ../text/gdp_education.png, replace

		restore

		// sort the data

		gsort -country +year
			list country year in 1/20

		sort country year
			list country year if _n <15

		// create a variable that tracks changes in gdp over time within

		bysort country (year): gen delta_gdp = lngdp - lngdp[_n - 1]
			list country year lngdp delta_gdp in 1/15

			// this is not the efficient/correct way to do it; latter we will use 'tsset'

// # 2.3 export the descriptive statistics

	// # 2.3.a logout

		//ssc install outreg2
	
	replace capital = capital/1000000
	
			preserve
				keep rgdpwok education capital open
				order rgdpwok education capital open
				outreg2 using ../text/summary_statistics_table.doc, auto(4) sum(detail) word tex eqkeep(N mean p99 sd min max) dec(3) replace label
			restore

	// # 2.3.b logout

			logout, save(tabstat_education_country) tex replace: tabstat education,by(country) stat(mean sd min p5 p50 p90 p99)

			// the command logout closes the log, so one has to open it with the option append
			log using exercise_complete_output.txt, text append

	// # 2.3.c estout
	label var year "Year"
		tabout year using ../text/summary_statistics_2.tex, ///
			cells(N pop mean pop mean openk mean rgdpwok mean education mean lngdp median lnk median delta_gdp) ///
			sum style(tex) replace ptotal(single) oneway f(0c 1c 1c 1c 1c 1p 1c 2p)	///
			h1(nil) h2( & & \multicolumn{5}{c}{Means} & \multicolumn{2}{|c}{Medians} \\ \hline) ///
			h3(& Obs. & Pop. & OpenK & GDP & Education & ln GDP & ln Capital & $\Delta_{GDP}$ \\) botf() botstr("Source: own computations.")


// # 2.4 export key graphs

	// # 2.4.a densities

		twoway (kdensity lngdp if year == 1970) || (kdensity lngdp if year == 1990, lpattern(dash_dot_dot)), ///
			legend(label(1 "Year: 1960") label(2 "Year: 2000") region(lwidth(none))) title(Income: 1960 vs. 2000) ///
			xtitle("Log (Income)") ytitle("Density") scheme(sj) graphregion(color(white)) bgcolor(white)

			graph export ../text/income_density.png, replace
				
				
	// # 2.4.b 'dots'
		
			sum education if year == 2000,detail
				
			global a = r(p50)
			global b = r(p10)
			local c = r(p90)

		graph dot (mean) education if (country == "Denmark" | country == "Portugal" | country == "United States" | country == "Italy" | country == "Spain"),over(country, sort((max) lngdp)) ///
				title("Maximum level of education between 1960 and 2000", span) ///
				note("Notes: Countries are ordered by maximum GDP." "Values in the axis are percentiles 10, 50 and 90 of education, respectively, in 2000.") ///
				ytitle("Education") yline($a $b `c') ylabel($a $b `c',format(%3.1g)) ///
				graphregion(color(white)) bgcolor(white) scheme(s2color)

				
				graph export ../text/example1.eps, replace



// # 3. regression analysis

// # 3.1 Regressions
encode country,ge(cty_id)

xtset cty_id year

	reg lngdp education
		estimates store r1

	reg lngdp education lnk
		est store r2

	reg lngdp education lnk openk i.year	// use the operator i. to produce time dummies
		est store r3

	xtreg lngdp education lnk openk i.year, fe
		est store fe

	xtreg lngdp education lnk openk i.year, be
		est store be

	xtreg lngdp education lnk openk i.year,re
		est store re


		
// # 3.2 export the regression output

	// # 3.2.a export the output to word with 'outreg'

	outreg, clear
		estimates restore r1
			outreg using ../text/growth_analysis, replace rtitles("Education" \ "" \ "Capital" \ "" \ "Openness degree" \ "")  /*
					*/ drop(_cons) /*
					*/ ctitle("","Simple model") /*
					*/ nodisplay varlabels bdec(3) se starlevels(10 5 1) starloc(1) summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

		estimates restore r2
			outreg using ../text/growth_analysis, merge rtitles("Education" \ "" \ "Capital" \ "" \ "Openness degree" \ "")  /*
					*/ drop(_cons) /*
					*/ ctitle("","Include capital") /*
					*/ nodisplay varlabels bdec(4) se starlevels(10 5 1) starloc(1) summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

		estimates restore r3
			outreg using ../text/growth_analysis, merge rtitles("Education" \ "" \ "Capital" \ "" \ "Openness degree" \ "")  /*
					*/ drop(_cons 1975.year 1980.year 1985.year 1990.year) /*
					*/ ctitle("","Full model") /*
					*/ varlabels bdec(4) se starlevels(10 5 1) starloc(1) summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")
	
	// # 3.2.b export the output to word using 'esttab'

	// ssc install estout

		esttab r1 r2 r3 fe re using ../text/growth_analysis_esttab.doc, replace ///
				keep(education lnk openk) ///
				mtitle("Model # 1" "Model (2)" "Model (3)") nonumbers ///
				coeflabel (education "Average education" lnk "Log capital" openk "Openness") ///
				b(%5.3f) se(%5.3f) sfmt(%5.2f) star(* 0.1 ** 0.05 *** 0.01) ///
				scalars("N Observations" "r2 R$^2$" "rmse RMSE") ///
				nonotes addnotes("Notes: standard errors in parenthesis. Significance levels: *, 10\%;" "**, 5\%; ***, 1\%. The dependent variable is ln real GDP per workers." "Source: own computations.")


// # 3.3 export to LATEX, 3 options

	// # 3.3.a export the output to latex using 'esttab'

		esttab r1 r2 r3 fe be re using ../text/growth_analysis_esttab.tex, replace ///
				keep(education lnk openk) ///
				mtitle("OLS (1)" "OLS (2)" "OLS (3)" "FE" "BE" "RE") nonumbers ///
				coeflabel (education "Average education" lnk "Log capital" openk "Openness") ///
				b(%5.3f) se(%5.3f) sfmt(%7.2f) star(* 0.1 ** 0.05 *** 0.01) ///
				scalars("N Observations" "r2 R$^2$" "rmse RMSE") ///
				nonotes addnotes("Notes: standard errors in parenthesis. Significance levels: *, 10\%; **, 5\%; ***, 1\%." "The dependent variable is ln real GDP per worker. All models include a constant." "Models OLS (3) till RE include time dummies." "Source: own computations.")

	// # 3.3.b export the output to latex FRAGMENT: use \input{growth_analysis_frag} to include it in your tex file

		outreg, clear
			estimates restore r1
				outreg using ../text/growth_analysis_frag, tex fragment replace rtitles("Education" \ "" \ "Capital" \ "" \ "Openness degree" \ "")  /*
						*/ drop(_cons) /*
						*/ ctitle("","Simple model") /*
						*/ nodisplay varlabels bdec(4) se starlevels(10 5 1) starloc(1) summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

			estimates restore r2
				outreg using ../text/growth_analysis_frag, tex fragment merge rtitles("Education" \ "" \ "Capital" \ "" \ "Openness degree" \ "")  /*
						*/ drop(_cons) /*
						*/ ctitle("","Include capital") /*
						*/ nodisplay varlabels bdec(3) se starlevels(10 5 1) starloc(1) summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

			estimates restore r3
				outreg using ../text/growth_analysis_frag, tex fragment merge rtitles("Education" \ "" \ "Capital" \ "" \ "Openness degree" \ "")  /*
						*/ drop(_cons 1975.year 1980.year 1985.year 1990.year) /*
						*/ ctitle("","Full model") /*
						*/ nodisplay varlabels bdec(1) se starlevels(10 5 1) starloc(1) summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

	// # 3.3.c export the output to latex FULL DOC

		outreg, clear
			estimates restore r1
				outreg using ../text/growth_analysis, tex replace rtitles("Education" \ "" \ "Capital" \ "" \ "Openness degree" \ "")  /*
						*/ drop(_cons) /*
						*/ ctitle("","Simple model") /*
						*/ nodisplay varlabels bdec(4) se starlevels(10 5 1) starloc(1) summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

			estimates restore r2
				outreg using ../text/growth_analysis, tex merge rtitles("Education" \ "" \ "Capital" \ "" \ "Openness degree" \ "")  /*
						*/ drop(_cons) /*
						*/ ctitle("","Include capital") /*
						*/ nodisplay varlabels bdec(4) se starlevels(10 5 1) starloc(1) summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

			estimates restore r3
				outreg using ../text/growth_analysis, tex merge rtitles("Education" \ "" \ "Capital" \ "" \ "Openness degree" \ "")  /*
						*/ drop(_cons 1975.year 1980.year 1985.year 1990.year) /*
						*/ ctitle("","Full model") /*
						*/ nodisplay varlabels bdec(4) se starlevels(10 5 1) starloc(1) summstat(r2\rmse \ N) summtitle("R2"\"RMSE" \ "N")

timer off 1
timer list 1

log close
