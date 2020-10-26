//////////////////////////////////////////////////////////////////////////
// 2020 STATA ECONOMETRICS WINTER SCHOOL								//
// January 20-24, 2020													//
// Faculdade de Economia da Universidade do Porto, Portugal				//
//////////////////////////////////////////////////////////////////////////

clear all
set more off

*capture cd ""

capture log close
log using run_example2b.log, replace

* markstat reads the "markstat.css" file on the current directory
* if it doesn't it it it uses the default "markstat.css" in the markstat installation folder
markstat using example2, strict mathjax bib

log close


