library(readxl)
nlswork <- read_excel("nlswork.xlsx")

library(tidyverse)
library(stargazer)

df <- as.data.frame(nlswork)

names(df)

df2 <- df %>% 
  select(age,union)

names(df2)

df3 <- df %>% 
  filter(union==1)

count(df3)

df3 %>% count()
df %>% count()

df4 <- df3 %>% 
  mutate(exper_sq = ttl_exp^2)

names(df4)


df %>% 
  na.omit() %>% 
  count()
