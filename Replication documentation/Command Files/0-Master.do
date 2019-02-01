************************************************************************
* Project: [Master do files, run ALL the do files at once]
* Data In: [kihs-poverty.csv]
* Data Out: [kihs-poverty.dta]
* Purpose of do-file: Master do files
************************************************************************
version 15
set more off
clear all
macro drop _all

**********************************************************************


* Contents: 1. Explain project
*               1.1 Overview
*               1.2 Do files
*           2. Define globals
*           3. Run do files
*               3.1 import
*               3.2 cleaning
*               3.3 descriptive statistics
*               3.4 inferential statistics

**********************************************************************

* 1. Explain project

*[produce key stat kyrghistan]

*1.1 Overview

*[Description of what the overall purpose of the do files is and how the files are organized]

* 1.2 Do files

*[each dofiles clean or analyze]

**********************************************************************

*2. Globals

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

log using "${document}\finalreport.log", replace

**********************************************************************

* 3. Run .do files

*[Call the .do files you will be using in your analysis.  In this example, it might look something like this]

     * Step 1: import raw data
	 

do "${dofiles}\1-import.do"

     * Step 2: data cleaning

do "${dofiles}\2-cleaning.do"

     * Step 3: Basic summary analysis & data checking

do "${dofiles}\3-Descriptive-Statistics.do"

     * Step 4: Inferential statistics

do "${dofiles}\4-Inferentialstatistics.do"



