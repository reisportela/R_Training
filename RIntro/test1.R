#Miguel Portela, Cátia Cerqueira,  Gabriel Andrade, Hélder Costa,  Joana Cima e Miguel Chaves
# install.packages("here")
library(here)

#2.Define work directory
here()
setwd("/Users/miguelportela/Documents/GitHub/R_Training/RIntro")


#3.Import
# install.packages("haven")
library(haven)
nlswork <- as.data.frame(read_dta("data/nlswork.dta"))

#4.Data manipulation
install.packages("tidyverse")
library(tidyverse)

#4.1.Select
nlswork_s<- nlswork %>% 
  select(idcode, ln_wage, age, tenure, collgrad, ttl_exp, grade, ind_code, union, hours) 

#4.2.Rename
nlswork_r <- nlswork %>% 
  rename(cae = ind_code)

#4.3.Filter
nlswork_f<- nlswork %>% 
  filter(age > 40) 

#4.4.Mutate
nlswork_m<- nlswork %>% 
  mutate(age2=age^2)

#4.5.Final

nlswork1<- nlswork %>% 
  rename(cae = ind_code) %>%
  select(idcode, ln_wage, age, tenure, collgrad, ttl_exp, grade, cae, union, hours) %>% 
  filter(age > 40) %>%
  mutate(age2=age^2)

View(nlswork1)


#3. Descriptive statistics
install.packages("stargazer")
summary(nlswork)
table(nlswork$race, nlswork$collgrad)
str(nlswork)

library(stargazer)
nlswork %>%
  dplyr::select(year, age, collgrad, ttl_exp, union, hours) %>% 
  stargazer(title="Shorter statistics",
            type= "text", out = "Statistics_output.html",
            digits = 2)

#Missings
install.packages("visdat")
library(visdat)
vis_dat(nlswork)
