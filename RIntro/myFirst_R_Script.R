# Miguel Portela, Cátia Cerqueira, Gabriel Andrade, Hélder Costa,  Joana Cima e Miguel Chaves
# Março 9, 2022

# 1. Install a library
# install.packages("here")
library(here)

# 2. Define working directory
here()
# setwd("/Users/miguelportela/Documents/GitHub/R_Training/RIntro")
# -- list the current directory
getwd()

# 3. Import data (from an excel file)
# 3.1. install.packages("readxl")
nlswork <- read_excel("nlswork.xlsx")

# 3.2. Define the object as a DataFrame

df <- as.data.frame(nlswork)

# 4. Data manipulation -- check the pipe operator, %>%
# install.packages("tidyverse")
library(tidyverse)

# 4.1. Select a subset of variables
nlswork_s<- nlswork %>% 
  select(idcode, ln_wage) 

# 4.2. Rename variables
nlswork_r <- nlswork %>% 
  rename(cae = ind_code)

# 4.3. Filter a subset of observations
nlswork_f<- nlswork %>% 
  filter(age > 40) 

# 4.4. Mutate: create variables
nlswork_m <- nlswork %>% 
  mutate(ln_asd=ln(age))

# 4.5. Manipulate the data in a single sequence
nlswork1<- nlswork %>% 
  rename(cae = ind_code) %>%
  select(idcode, ln_wage, age) %>% 
  filter(age > 40) %>%
  mutate(age2=age^2)

# 5. Descriptive statistics
# install.packages("stargazer")
library(stargazer)
df %>% 
  count()

summary(df)
table(df$race, df$collgrad)
str(df)

df %>%
  dplyr::select(year, age, collgrad, ttl_exp, union, hours) %>% 
  stargazer(title="Shorter statistics",
            type= "text", out = "Statistics_output.html",
            digits = 2)

# 6. Visualize missing information:
# https://cran.r-project.org/web/packages/naniar/vignettes/naniar-visualisation.htmlhttps://cran.r-project.org/web/packages/naniar/vignettes/naniar-visualisation.html
# install.packages("visdat")
library(naniar)
vis_miss(nlswork)
gg_miss_var(nlswork) + labs(y = "Total missing values for each variable")
gg_miss_upset(nlswork)

n_var_miss(nlswork)

ggplot(nlswork,aes(x=age,y=ln_wage))+
  geom_point()

ggplot(nlswork,aes(x=age,y=ln_wage))+
  geom_miss_point()

ggplot(nlswork,aes(x=age,y=ln_wage))+
  geom_miss_point() +
  facet_wrap(~race)

gg_miss_fct(x = nlswork,fct = year)

# Alternative
library(visdat)
vis_dat(nlswork)
