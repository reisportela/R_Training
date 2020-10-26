//////////////////////////////////////////////////////////////////////////
// 2020 STATA ECONOMETRICS WINTER SCHOOL								//
// January 20-24, 2020													//
// Faculdade de Economia da Universidade do Porto, Portugal				//
//////////////////////////////////////////////////////////////////////////

clear all
set more off

capture log close
log using run_example5.log, replace

* markstat reads the "markstat.css" file on the current directory
* if it doesn't it it it uses the default "markstat.css" in the markstat installation folder
	markstat using example5, strict mathjax bib

capture log close
