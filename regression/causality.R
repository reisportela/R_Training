
names(world_data)
head(world_data)
# View(world_data)
str(world_data)

# dplyr::glimpse(world_data)
dplyr::glimpse(world_data$logGDPpc2000)

ExpData(world_data,type=1)
ExpData(world_data,type=2)

# STATISTICS

## EDA

# eda_report(world_data,output_dir = "EDA/",output_file = "eda_world_data.pdf")

summary(world_data[,"educ_sec"])

ExpNumStat(world_data,by="A",Outlier = TRUE,round=2,Qnt=c(0.1,0.20,0.50))

# ExpCTable(world_data)

# ExpCatViz(world_data)

ExpNumViz(world_data,Page=c(6,2))

## TRY IN A 'JUPYTER NOTEBOOK': ExpNumViz(world_data)

# ExpOutliers(world_data,varlist=c("logGDPpc2000"))

vis_dat(world_data)

# vis_miss(world_data) # ALTERNATIVE

gg_miss_upset(world_data)

## ExPanD(): import the data 'nlswork.dta' and 'ExPanD()' in the Console

summary(world_data)

stargazer(world_data,
          title = "Summary statistics",
          label = "tb:statistcis",
          table.placement = "ht",
          header=FALSE)

## or

stargazer(world_data,
          title = "Summary statistics",
          label = "tb:statistcis",
          table.placement = "ht",
          header=FALSE,type="text")

## or a subset of variables

world_data %>%
  dplyr::select(growthGDPpc,educ_sec) %>% 
  stargazer(title="Shorter statistics",
            label="tb:statistics:short",
            table.placement = "ht",
            header=FALSE,
            type="text")

attach(world_data)
plot(educ_sec,logGDPpc2000)

## FIRST CHECK OF THE RELATIONSHIP BETWEEN EDUCATION AND GDP

world_data %>%
  ggplot(aes(educ_sec,logGDPpc2000)) +
  labs(title = "GDP per capita vs. Education") +
  ylab("Log GDP pc (2000)") +
  xlab("% Population 25+ with lower sec. school") +
  geom_point()
  
  ## SAVE YOUR GRAPH

    ggsave("figures/graph1.png")

  ## FIRST REGRESSION

    reg1 <- lm(logGDPpc2000 ~ educ_sec)
      summary(reg1)

        # View(reg1)  # see what happens with this command

  ## FITTED MODEL
    
      ## SIMPLE SOLUTION
      
      plot(educ_sec,logGDPpc2000)
        abline(reg1)
      
      ## 'FANCY' SOLUTION
        
      ggplot(world_data,aes(educ_sec,logGDPpc2000))+
        labs(title = "GDP per capita vs. Education") +
        ylab("Log GDP pc (2000)") +
        xlab("% Population 25+ with lower sec. school") +
        geom_point() +
        geom_smooth(method = "lm",se = FALSE)

      ## EXPORT YOUR GRAPH
      
        ggsave("figures/graph2.png")

# <<>> --- REGRESSION ANALYSIS --- <<>> #

## Example 1
  
  ## REGRESSION
    
    M1 <- lm(data=world_data, growthGDPpc ~ logGDPpc2000 + educ_sec + invest_growth + trade2000 + gov2000,na.action = na.exclude)
      summary(M1)
  
  ## ANOVA
    
    M1.aov <- aov(data=world_data, growthGDPpc ~ logGDPpc2000 + educ_sec + invest_growth + trade2000 + gov2000,na.action = na.exclude)
      summary(M1.aov)
  
  ## VCE Estimates
    
    print(vcov(M1))
  
  ## Predicted and actual Growth log GDP pc vs. Education
    
    plot(M1)

    world_data$predicted <- predict(M1)
    world_data$residuals <- residuals(M1)
    
      world_data$residuals_sq <- residuals(M1)^2  # SQUARED RESIDUALS

    ggplot(world_data,aes(educ_sec,growthGDPpc))+
      labs(title = "Fitted vs. actual values") +
      ylab("Log GDP pc (2000)") +
      xlab("% Population 25+ with lower sec. school") +
      geom_point() +
      geom_point(aes(y=predicted),shape=1)

    ggsave("figures/graph3.png")
    
    ggplot(world_data,aes(educ_sec,growthGDPpc))+
      labs(title = "Residuals vs. actual values") +
      ylab("Log GDP pc (2000)") +
      xlab("% Population 25+ with lower sec. school") +
      geom_point() +
      geom_point(aes(y=residuals),shape=1)
    
    ggsave("figures/graph4.png")
    
    ## Output table

    
  stargazer(M1,title = "Regression analysis", model.numbers = FALSE,column.labels = c("Model 1"),label = "regressions",table.placement = "!ht",notes.append = FALSE,notes.align="l",notes="Standard errors in parentheses.",header = FALSE,no.space = TRUE,covariate.labels = c("Log GDPpc 2000","Educ Sec"),omit = c("Constant"),omit.stat = c("adj.rsq","f","ser"),digits = 2,digits.extra = 4,omit.yes.no = c("Constant",""),dep.var.caption="",dep.var.labels.include = FALSE,style = "qje",type="text")

  M2 <- lm(data=world_data, growthGDPpc ~ logGDPpc2000 + educ_sec + invest_growth + educ_sec:invest_growth + trade2000 + gov2000)
  M3 <- lm(data=world_data, growthGDPpc ~ logGDPpc2000 + educ_sec * invest_growth + trade2000 + gov2000)

  ## model without constant
  
  M0 <- lm(data=world_data, growthGDPpc ~ 0 + educ_sec)
  
  stargazer(M0,M1,M2,M3,title = "Regression analysis", 
            model.numbers = FALSE,
            column.labels = c("Model 1","Model 2","Model 3","Model 4"),
            label = "regressions",
            table.placement = "!ht",
            notes.append = FALSE,
            notes.align="l",
            notes="Standard errors in parentheses.",
            header = FALSE,
            no.space = TRUE,
            covariate.labels = c("Log GDPpc 2000","Educ Sec"),
            omit = c("Constant"),
            omit.stat = c("adj.rsq","f","ser"),
            digits = 2,
            digits.extra = 4,
            omit.yes.no = c("Constant",""),
            dep.var.caption="",
            dep.var.labels.include = FALSE,
            style = "qje",
            type="text")
  
# <<>> --- END --- <<>> #

  ## CATEGORICAL VARIABLES AND INTERACTIONS
  
  nlswork <- as.data.frame(read_dta("nlswork.dta"))
    table(nlswork$race)
  
  ## ADD A VARIALE
  nlswork$race.f <- factor(nlswork$race)
    is.factor(nlswork$race.f)
  
  str(nlswork$race)
  
  ## DEFINE THE REFERENCE CATEGORY
  
  summary(lm(ln_wage ~ relevel(factor(race),ref = 3),data=nlswork,na.action = na.exclude))
  
  mm1 <- lm(ln_wage ~ hours,data=nlswork,na.action = na.exclude)
  summary(mm1)
  
    print(mm1$coefficients)
    print(mm1$coefficients[2])
    print(vcov(mm1))
    print(vcov(mm1)[2,2])
    summary(mm1)
    print(vcov(mm1)[2,2]^.5)
  
  mm2 <- lm(ln_wage ~ factor(race),data=nlswork,na.action = na.exclude)
  summary(mm2)

  names(nlswork)
  
  mm3 <- lm(ln_wage ~ hours * factor(race),data=nlswork,na.action = na.exclude)
  summary(mm3)
  
  stargazer(mm1,mm2, mm3,title = "Regression analysis", 
            model.numbers = FALSE,
            column.labels = c("Model 1","Model 2","Model 3"),
            label = "regressions",
            table.placement = "!ht",
            notes.append = FALSE,
            notes.align="l",
            notes="Standard errors in parentheses.",
            header = FALSE,
            no.space = TRUE,
            omit.stat = c("adj.rsq","f","ser"),
            digits = 2,
            digits.extra = 4,
            omit.yes.no = c("Constant",""),
            dep.var.caption="",
            dep.var.labels.include = FALSE,
            style = "qje",
            type="text")
  
    ## AIC & BIC
    
      AIC(mm1)
      BIC(mm1)
    
    ## HYPOTHESIS TESTING    
    
      linearHypothesis(mm1,c("hours=0"))
    
    ## COLINEARITY: VIF
    
      car::vif(mm3)
    
    ## HETEROSKEDASTICITY
      
      mm4 <- lm(ln_wage ~ hours,data=nlswork,na.action = na.exclude)
      nlswork$residuals <- residuals(mm4)
        plot(nlswork$hours,nlswork$residuals)
      
        nlswork$residuals_sq <- residuals(mm4)^2
        
        bp <- summary(lm(residuals_sq ~ hours,data=nlswork,na.action = na.exclude))
        
          bp$r.squared*nrow(as.data.frame(bp$residuals))
        
        ## Breusch-Pagan test
          bptest(mm4)
        
        ## White test
          bptest(mm4,~ hours + I(hours^2),data=nlswork)
      
      ## Robust estimation
        r1mm4 <- coeftest(mm4,vcov =vcovHC(mm1,type = "HC1"))   # HC1 gives us the White standard errors
        r2mm4 <- coeftest(mm4,vcov =sandwich)
        stargazer(mm4,r1mm4,r2mm4,
                  digits = 7,
                  digits.extra = 10,
                  type="text")

# Instrumental variables
  library(ivreg)
        card <- read_dta("card.dta")
        
        ols <- lm(data=card,lwage ~ educ + exper)
        iv <- ivreg(data=card,lwage ~ educ + exper | expe + nearc4)

        stargazer(ols,iv,title = "Regression analysis", 
                  model.numbers = FALSE,
                  column.labels = c("Model 1","Model 2"),
                  label = "regressions",
                  table.placement = "!ht",
                  notes.append = FALSE,
                  notes.align="l",
                  notes="Standard errors in parentheses.",
                  header = FALSE,
                  no.space = TRUE,
                  covariate.labels = c("Education","Experience"),
                  omit = c("Constant"),
                  omit.stat = c("adj.rsq","f","ser"),
                  digits = 2,
                  digits.extra = 4,
                  omit.yes.no = c("Constant",""),
                  dep.var.caption="",
                  dep.var.labels.include = FALSE,
                  style = "qje",
                  type="text")
        
## Tests and diagnosis
        
        summary(iv,vcov=sandwich,diagnostics = TRUE)
        
        
# Diff-in-Diff
        
  hh_9198 <- read_dta("hh_9198_v2.dta")
  
  hh_9198$lnland <- log(1+hh_9198$hhland/100)
  
  attach(hh_9198)
  
  # dfmfd=treated: HH has female microcredit participant: 1=Y, 0=N
  # year=after: Year of observation: 0=1991, 1=1998
  # exptot: HH per capita total expenditure: Tk/year
  # lexptot = ln(exptot)
  
  str(hh_9198)
  ExpData(hh_9198,type=1)
  ExpData(hh_9198,type=2)
  
  ftable(hh_9198$treated,hh_9198$after)
  
  DiD1 <- lm(data=hh_9198,lexptot ~ factor(treated)*factor(after))
  
  DiD2 <- lm(data=hh_9198,lexptot ~ factor(treated)*factor(after) + 
               sexhead + agehead + educhead + lnland + vaccess + 
               pcirr + rice + wheat + milk + oil + egg)
  
  stargazer(DiD1,DiD2,title = "Regression analysis", 
            model.numbers = FALSE,
            column.labels = c("Model 1","Model 2"),
            label = "regressions",
            table.placement = "!ht",
            notes.append = FALSE,
            notes.align="l",
            notes="Standard errors in parentheses.",
            header = FALSE,
            no.space = TRUE,
            covariate.labels = c("Treated0","After"),
            omit = c("Constant"),
            omit.stat = c("adj.rsq","f","ser"),
            digits = 2,
            digits.extra = 4,
            omit.yes.no = c("Constant",""),
            dep.var.caption="",
            dep.var.labels.include = FALSE,
            style = "qje",
            type="text")
  
# sink()
