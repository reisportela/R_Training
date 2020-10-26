//////////////////////////////////////////////////////////////////////////
// 2020 STATA ECONOMETRICS WINTER SCHOOL								//
// January 20-24, 2020													//
// Faculdade de Economia da Universidade do Porto, Portugal				//
//////////////////////////////////////////////////////////////////////////

clear all
set more off

*capture cd ""

capture log close
log using run_example2a.log, replace

* Create html file (the option mathjax is for the equations)
* the bib option is needed to handle citations
markstat using example2.stmd, strict mathjax bib

log close

