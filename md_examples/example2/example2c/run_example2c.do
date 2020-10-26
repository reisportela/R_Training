//////////////////////////////////////////////////////////////////////////
// 2020 STATA ECONOMETRICS WINTER SCHOOL								//
// January 20-24, 2020													//
// Faculdade de Economia da Universidade do Porto, Portugal				//
//////////////////////////////////////////////////////////////////////////

clear all
set more off

*capture cd ""

capture log close
log using run_example2c.log, replace

* Create doc file
markstat using example2.stmd, strict docx bib

log close

