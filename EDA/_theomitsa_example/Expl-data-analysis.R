################# EDA WITH R #########################
#### SET THE ENV VARIABLES FOR PLOTLY.COM #########
Sys.setenv("plotly_username"="theomitsa")
Sys.setenv("plotly_api_key"="Ojps7ld5FByuyrpKV2zC")

########## READ THE INPUT FILE ##############
setwd("/Users/miguelportela/Documents/GitHub/R_Training/EDA/_theomitsa_example")
sal<-read.csv("Salaries2.csv",header=TRUE)

######################QUICK DATAFRAME CHECK####################
#####Dimensions of the dataset################
dim(sal)
#####Number and Types of Variables##########
str(sal)

##### Duplicates######################################
### How many are the unique values##############
uu<-unique(sal)
dim(uu)
dim(sal)
### Which Are the Duplicates###################
library(janitor)
dupj<-get_dupes(sal)
dupj

###########Missing Data###################

###Print the no. of complete rows and total no.of missing cases####
library(DataExplorer)
introduce(sal)
###For each column print the number of missing cases ####
apply(apply(sal,2,is.na),2,sum)
#Print the cases(rows) with the missing values######
sal[!complete.cases(sal),]

### UNIVARIATE STATISTICS###########################

summary(sal)
######### psych package ############
library(psych)
psych::describe(sal)
#### dataMaid package ##########
library(dataMaid)
summarize(sal)
makeDataReport(sal, replace=TRUE,output="gg.html")
##### Additional univariate description functions ##########
library(summarytools)
dfSummary(sal)

library(inspectdf)
inspect_num(sal)
inspect_cat(sal)

library(prettyR)
prettyR::describe(sal)

library(Hmisc)
Hmisc::describe(sal)

library(funModeling)
profiling_num(sal)

library(skimr)
skim(sal)
###Univariate Group Statistics###############
#Use tapply() to group by a factor ############
tapply(sal$salary,sal$sex,mean,na.rm=TRUE)
#Within groups, print detailed statistical information of the var under examination.
library(psych)
describeBy(sal$salary,group=sal$sex)

###Use dplyr functions #################
newgroup<-sal%>%filter(discipline=='A')%>%
  group_by(sex,rank)%>%summarise(Avgsal=mean(salary))
newgroup

###Plots of Univariate Statistics (boxplot,histogram)####
ggplot(sal,aes(sex,salary))+geom_boxplot()
ggplot(sal,aes(x=rank, fill=sex))+geom_bar()

########################BIVARIATE STATISTICS###########################
####Interactive Scatter Plot #########
library(plotly)
gg1<-ggplot(na.omit(sal), aes(salary,yrs.since.phd, col=sex))+geom_point()+geom_smooth(method=lm)
p1<-ggplotly(gg1)
api_create(p1,filename="plot of salary vs yrs.since.phd")

#### Interactive 3D plot ####################
library(plotly)
fig<-plot_ly(sal, x=~salary,y=~yrs.service,z=~yrs.since.phd,color=~sex,color_discrete_map={"female":"red"})%>% add_markers()
fig
api_create(fig,filename="3D plot")
##########################################################



###Correlations##############################################
#### Correlations displayed in a table with package stats######
sal1<-select_if(sal, is.numeric)
cor(na.omit(sal1))
library(stats)
cor.test(sal1$salary,sal1$yrs.service)

############ Correlation plots ########################
###########Corrplot package################
library(corrplot)
cc<-cor(na.omit(sal1))
corrplot(cc,method="pie")
################ PerformanceAnalytics package ################
library(PerformanceAnalytics)
chart.Correlation(sal1, histogram=TRUE, pch=19)
########## ggcorrplot package #################
library(ggcorrplot)
ggcorrplot(cor(na.omit(sal1)), p.mat = cor_pmat(na.omit(sal1)), hc.order=TRUE, type='lower')
cor_pmat(na.omit(sal1))
##ALL INCLUSIVE CORRELATION############

############### DataExplorer package ####################
library(DataExplorer)
plot_correlation(sal)

########## psych package#########
library(psych)
pairs.panels(sal,bg=c("yellow","blue")[sal$sex],pch=21, cex.cor=6, scale=TRUE)
######## GGally package ############
library(GGally)
ggpairs(sal)
##################################################################

########Test of Independence###########
table(sal$rank)
table(sal$rank,sal$sex)
library(gmodels)
t2<-CrossTable(sal$rank,sal$sex,chisq=TRUE,fisher=TRUE)
t2


#######T-test of Significant Diferences #############

filtered<-filter(sal, sex=='Male')
c1<-(filtered[6])
filtered2<-filter(sal, sex=='Female')
c2<-(filtered2[6])
t.test(c1,c2)

###########T-test with rank as the fixed effect##########
filtered<-filter(sal, sex=='Male',rank=='Prof')
c1<-(filtered[6])
filtered2<-filter(sal, sex=='Female', rank=='Prof')
c2<-(filtered2[6])
t.test(c1,c2)

#######OUTLIERS########################################
#Univariate Outlier Detection ##############
###### Interactive histogramM#################
library(plotly)
p1<-ggplot(sal,aes(sex,salary))+geom_boxplot()
p1
pp<-ggplotly(p1)
api_create(pp, filename = "boxplot-salary-sex")
##########################################

##############Package extremevalues################################
library(extremevalues)
L<-getOutliers(sal$salary)
outlierPlot(sal$salary,L)

#### Package OutlierDetection ############
library(OutlierDetection)
UnivariateOutlierDetection(sal$salary)
###########################################################
########### Multivariate Outlier Detection ################

####### Package OutlierDetection ##########
library(OutlierDetection)
sal1<-select(sal,salary,yrs.service)
saldata<-na.omit(sal1)
salr <- saldata[,c("yrs.service", "salary")]
OutlierDetection(salr)
############ Package Chemometrics###########
library(chemometrics)
gg<-Moutlier(saldata)
mahal_dist<-gg$md
names(mahal_dist) <- 1:nrow(saldata)
ff<-sort(mahal_dist, decreasing = TRUE)
ff
#############Package Mvoutlier###################
library(mvoutlier)
par("mar")
par(mar=c(1,1,1,1))
out <- chisq.plot(saldata)
out$outliers


########AUTOMATIC EDA######################

library(DataExplorer)
create_report(sal,y="salary")

library(efficient)
library(AEDA)
fastReport(data=sal)
rmarkdown::render("MainReport.rmd")

library(ExPanDaR)
ExPanD(sal)

library(RtutoR)
gg=generate_exploratory_analysis_ppt(sal,target_var="salary",
                                     output_file_name="Rtutorreport.pptx")
