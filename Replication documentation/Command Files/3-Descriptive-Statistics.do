************************************************************************
* Project: [Descriptive statistics in Stata] 
* Data In: [kihs-poverty-analysis.dta]
* Data Out: []

/*
************************************************************************
*/
version 15
set more off
clear all
macro drop _all
global path "C:\Users\Karol Rodriguez\Downloads\Desktop\Poverty project"
**Data Analysis  folder******

global analysis "${path}\Analysis-Data"

**Codes  folder******

global dofiles "${path}\Command-Files"

**Original Data folder ******

global rawdata "${path}\Original-Data"

**Documents folder ******

global document "${path}\Documents"

capture log close
log using "${document}\descriptivestatistics.log", replace
use "${analysis}\kihs-poverty-analysis.dta", clear


***Part ONE ****
*1.a. sum, mean, mode, median, range (min,max)

describe
*short description about your dataset
sum
*short description of general characterisitcs of the dataset

su y1, d
count if y1 > 134400 
*if function is very useful 
su toty, d
su toty totx, d
* provides statistic details of a variable(s)

tab hheduc region
tab hheduc region, cell
* tabulates variables, cell gives the option that in shows you in %
*option cell gives you percentage of educ by region
tab hheduc region, col
*column total percentages in each category	
tab hheduc region, row
*row total percentages in each category
*very useful for categorical variables, can look up one variable
table hheduc, c(mean xf sd xf med xf)
*creates a table of variables for statistics of (in this case food consumption)
*you must specify which statistics
table hheduc, c(mean xf mean xh1 mean xh3)
*more ways of displaying statistics!
bysort hhhwt1: tab hheduc
*can look up values that are sorted by categorical variable

su toty, d
count if toty > 136719
*look up how many observations that are above 90% of distribution
*from the sum information table
tab region if toty > 136719 
*look up where these 10 observations are located by region type
tab hheduc if toty > 136719 
*or by education


* 1.b. variance, standard deviation, coefficient of variation, 
*		percentiles, outliers 

*What is variance?
*How do we calculate it?
*(Hint: Slide 13 in lecture)

tabstat toty, by(hheduc) ///
statistics(mean, median, sd, v, min, max, n, cv) 
/*find particular statistics in a table, can also organize 
by a categorical variable
Helpful if you want to ask questions by categorical value, 
in this case: 
What is the average income depending on the education attained?
What is a standard deviation and what does this sd tell you about
income? 
sd = Standard Deviation
v = variance
cv =  coefficient of variation
n = number of observations
*/


*Let's disect the s.d. equation & its meaning (go to slide 13/board)
* (we will do pen & paper exercises next class)

*coefficient of variation
sum totc, d
return list
di 100 * r(sd) / r(mean)
*the equation for the coefficient of variation (in percent)
*It shows the extent of variability in relation 
*to the mean of the population (it let's us compare samples)
* It is very sensitive the closer you are to the mean
* video for more details: https://www.youtube.com/watch?v=Lz9qTUzTp28

/*Qauntiles
Quartiles (quarter, by 25%)
Quintiles (twenty,  by 20%)
Deciles   (ten,     by 10%)
Ventiles  (five,    by 5%)
Percentile(one,     by 1%)
*/
_pctile toty, p(25, 50, 75)
return list
*temporarily store values of percentiles
pctile totyp = toty, n(10) genp(percent)
list totyp
*generate a new variable to store percentile permanently 
*(in this case on 10th percentile, so each observation is a Decile)

*Calculating Outliers
graph box toty
*how many outliers visually
su toty, d
return list
*stored values from the sum function, this can work with a few commands and 
*can be incredibly useful to recall temporarily stored info for example,
*we will calculate outliers:
di (r(p75)-r(p25))
*calculate IQR (Inter Quartile Range)
di 1.5*(r(p75)-r(p25))
*calculating the threshold (1.5*IQR)
di r(p75)+(1.5*(r(p75)-r(p25)))
*upper threshold (75th percentile plus 1.5*IQR)
di r(p25)-(1.5*(r(p75)-r(p25)))
*lower threshold (25th percentile minus 1.5*IQR)
tabstat toty, statistics(iqr, p25, p75)
*shortcut to find statistic numbers in another way 
*(return list doesn't work with tabstat)
*Identifying the outliers
list toty if toty > 194430
*lists total income if total income is greater than 
*(the upper threshold we calculated)
list if toty > 194430
*or even more detail by observation (too much info, probably)
* outliers are above the threshold we calculated

/*But, what is the value of the top whisker?
The value of the top whisker is: 191594 (in my case)
This is because the observation must be in your dataset
the threshold we calculated is 194430, but that doesn't 
exist in my dataset, so the top value is the closest value below the 
threshold. 
Let's look the top whisker up:
*/
sort toty
*always sorts from lowest value (starting at obs 1) to highest value
list toty in 70/75, table
*lists the top observations (observations numbered 69-75)
list toty in 1/5, table
*lists the bottom observations (observations numbered 1-5)
*I can find the whisker value by looking at the observation 
*below my outliers (varies by dataset)
	
* 1.c. covariance, correlation coefficient

*Watch: http://www.youtube.com/watch?v=eRlzmCrdTWw

*Disect cov/corr coefficient equations in class 
*(go to slide 20&21/board)

corr(toty cserv), cov
*covariance but doesn't say much since we can't compare values
corr(toty totx)
/*says way more!  can compare now: 
corr -1 variables move perfectly opposite of each other
0 means no correlation between variables
1 means the variable move perfectly in the same direction
*/

log close
