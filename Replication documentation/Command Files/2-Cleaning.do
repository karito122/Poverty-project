************************************************************************
* Project: [cleaning the raw data in Stata] 
* Data In: [kihs-poverty.dta]
* Data Out: [kihs-poverty-analysis.dta]

/*
	Outline
	Part 1:********
	Part 2:********* 
	Part 3:********** 

*************************************************************************************************
*/
version
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
log using "${document}\cleaningreport.log", replace

use "${rawdata}\kihs-poverty.dta", clear

*********************************************PART ONE**************************************************************************
*********************************************************************************************************************************
run "${dofiles}\kihs-labels"
codebook, compact
browse 
*find observation that is the problem
*How do we change the variable from string to numeric?
/*change the string to read numeric, but ignore comma because that is where
the error is coming from
or*/
destring xf, replace 
*This is from the email lutz gave you, which identifies the decimal place you should have.

/* BUT usually, we don't know the correct value, what do we do?
1. "Impute" the average of the variable and replace the observation with the mean
2.  Find if there are any other variables that can help you recreate the variable
3. Last resort, replace te observation as "." to denote a missing value

In our case:
1. look at your other variables and see if there are any relationship between 
this variable and the problem variable (HINT: this is in the label)
2. We see that xf is equal to the sum of xf1 - xf15, so we can generate the 
value of the problem observation by summing the variables
*/
egen sumxf = rowtotal(xf1-xf15)
drop xf
rename sumxf xf
label var xf "Food consumption excl. eating out, SUM(xf1 to xf15)"
* OR use the value of the problem observation you got from sumxf 
* and replace in with the error observation in xf
*then you must run the command destring xf, replace 

/*NOTE: In real life, other options that you can if you cannot find the real value, 
then you can either replace the value as missing 
or impute the value as the average of that variable
*/

*********************************************PART TWO**************************************************************************
*********************************************************************************************************************************

***Graphing qualitative data***
use "${rawdata}\kihs-poverty.dta", clear
run "${dofiles}\kihs-labels"
* HINT: graphing or browsing data are some ways to find a bias in your data
codebook hhhsex
*learn more details about a particular variable

*Pie graph* 
graph pie, over(hhhempl) title("Distribution of HHH by Employment Status")
*do a pie graph for a categorical variable (must use comma ONLY for categorical)

*Bar graph*
graph bar, over(hhhwt1) xsize(15) 
*graph a qualitative value and change the xaxis size
*Please update your Stata with the command
update all
* if stata is not updated, the graph may not work (should have already done this before class)

/*NOTE: How to label categorical variables (ie gender)
This is already done in your data set and what was done in the do file
Lutz gave you, but if you have to define other categories, here is the code:
label define hhhsex1 1 "Male" 2 "Female"
label values hhhsex hhhsex1
*/

***Graphing Quantitative data***

*Quantitative bar graph*
graph bar xf, over(hhhwt1) xsize(15) ///
title("Total consumption by household respondent type") ///
saving("${document}\graphprincipalworkarea.gph", replace)
*NOTE: Look up questions about data in manual of KIHS Survey

*Quantitative pie graph*
graph pie (xf1-xf15), title("Consumption of food excl. eating out of Kyrgyz")

**Scatter plot**
*toty = total income
*totx = total annual expenses
*Scatter plot with fitted line

tw(scatter totx toty) (lfit totx toty), ///
title("Relationship between total income and expenditure") ///
ytitle("Total Expenditure") xtitle("Total Income") ///
legend(label(1 "Expenditure and Income Earned") label(2 "fitted line")) xsize(7)
*What do you see?

**box plot** 
*Graph of the variation of the data
graph box xf, over(hhhempl) nofill ///
title("Variation of wages by employment level") 
*The thin line, 'whiskers', represents the upper and lower fence/boundaries
*the line within the box represents the median
*the box shows the 75 percentile (upper) to 25 percentile (lower)

save "${analysis}\kihs-poverty-analysis.dta", replace

log close
