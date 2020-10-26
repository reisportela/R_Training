//////////////////////////////////////////////////////////////////////////
// 2020 STATA ECONOMETRICS WINTER SCHOOL								//
// January 20-24, 2020													//
// Faculdade de Economia da Universidade do Porto, Portugal				//
//////////////////////////////////////////////////////////////////////////

clear all
set more off

*capture cd ""

capture log close
log using run_example2e.log, replace

* Create pdf file (you need to have latex installed)
markstat using example2.stmd, strict pdf bib

log close

