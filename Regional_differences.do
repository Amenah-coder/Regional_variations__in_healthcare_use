

****** Generating Patient characterisitcs 


clear
use "C:\Users\Michel  Amenah\OneDrive - Lancaster University\Catastrophic Health Expenditure\GLSS7\g7aggregates\15_GHA_2017_E_final.dta"

des

ren loc2 urbrur
recode region (1 2 3 4 5 6=1 "Southern regions") (7 8 9 10=2 "Northern regions"), gen(Region)
xtile quintile = pc_hh, n(5)
ren TOTHLTH hh_total_health_expenditure
ren padq_hh income

keep hid hh_total_health_expenditure Region WTA_S quintile hhsize income 

merge 1:m hid using "C:\Users\Michel  Amenah\OneDrive\Catastrophic Health Expenditure\GLSS7\g7aggregates\16_GHA_2017_I.dta" 


recode SEX (1=1 "Male") (0=2 "Female"), gen(gender)

// Recode MARSTAT into broader categories
recode MARSTAT (1 = 1 "Never Married") ///
               (2/4 = 2 "Married/Living Together") ///
               (5/6 = 3 "Separated/Divorced/Widowed") ///
               (. = 4 "Others"), generate(marital_status)
			   
// Recode EDLEVEL_AR into broader categories
recode EDLEVEL_AR (0 = 1 "No Education") ///
                  (2/3 = 2 "Primary") ///
                  (4/5 = 3 "Secondary") ///
                  (6/7 = 4 "Post-Secondary") ///
                  (. 9= 5 "Others"), generate(educational_level)
				  
ren AGEY age 

drop _merge

merge m:m hid using "C:\Users\Michel  Amenah\OneDrive\Catastrophic Health Expenditure\GLSS7\g7PartA\g7sec4-reviewed.dta"
 

recode work (1 2 3 4=1 "Employed") (6=0 "Unempolyed"), gen(employment_status)

drop _merge

merge m:m hid using "C:\Users\Michel  Amenah\OneDrive\Enerrgy poverty and health outcomes\GLSS7\g7PartA\g7sec1_5.dta"


recode loc2(1=0 urban)(2=1 rural), gen(location)

recode s3aq5 (2=0 "No") (1=1 "Yes"), gen(dem_health)


keep hid hh_total_health_expenditure dem_health Region age gender location employment_status educational_level marital_status WTA_S quintile hhsize income 

bys hid: keep if _n==1

* Define the average exchange rate for 2017/2018
local exchange_rate = 4.69  

* Create a new variable for household expenditure in USD
generate income_usd = income / 4.69



* Step 3: Create a new variable for household health expenditure in USD
generate hh_total_health_expenditure_usd = hh_total_health_expenditure/ 4.69

* Verify the transformation
summarize income_usd hh_total_health_expenditure_usd


save "C:\Users\Michel  Amenah\OneDrive - Lancaster University\PhD Health Economcis and Policy\Regional_differences.dta", replace 

use "C:\Users\Michel  Amenah\OneDrive - Lancaster University\PhD Health Economcis and Policy\Regional_differences.dta"

/// Analysis ////


*-------------------------------------------------------------
* Descriptive Statistics for Categorical Variables
*-------------------------------------------------------------

* 1. Gender
tab gender Region, row

* 2. Employment Status 
tab employment_status Region, row

* 3. Educational Status
tab educational_level Region, row

* 4. Marital Status
tab marital_status Region, row

* 5. Region (Southern vs Northern)
tab Region

*-------------------------------------------------------------
* Step 3: Descriptive Statistics for Continuous Variables
*-------------------------------------------------------------

* 1. Descriptive Statistics for Age
summarize age if Region == 1  // Southern
summarize age if Region == 2 // Northern
summarize age // Total

* Create table for minimum, maximum, and mean for Age
tabstat age, statistics(min max mean) by(Region)
tabstat age, statistics(min max mean)

* 2. Descriptive Statistics for Household Size
summarize hhsize if Region == 1 // Southern
summarize hhsize if Region == 2 // Northern
summarize hhsize // Total

* Create table for minimum, maximum, and mean for Household Size
tabstat hhsize, statistics(min max mean) by(Region)
tabstat hhsize, statistics(min max mean)

* 3. Descriptive Statistics for Income
summarize income if Region == 1 // Southern
summarize income if Region == 2 // Northern
summarize income // Total

* Create table for minimum, maximum, and mean for Income
tabstat income_usd, statistics(min max mean) by(Region)
tabstat income_usd, statistics(min max mean)


* Create table for minimum, maximum, and mean for Household Expenditure
tabstat hh_total_expenditure_usd, statistics(min max mean) by(Region), if hh_total_expenditure_usd > 0
tabstat hh_total_expenditure_usd, statistics(min max mean), if hh_total_expenditure_usd > 0


gen used_in_regression = !missing(dem_health age i.gender hhsize income i.marital_status i.educational_level i.employment_status)


////// Decompositon Analysis /////

oaxaca hh_total_heal~d hhsize age gender marital_status educational_level employment_status location income_usd [aw=WTA_S], by(Region) detail

outreg2 using oa1.doc


///// Additional Analysis /////////

* OLS regression for total health expenditure (weighted) for Southern region

regress hh_total_heal~d age i.gender hhsize i.marital_status i.educational_level  i.location i.employment_status income_usd [pw=WTA_S] if Region == 1
outreg2 using region.doc 

regress hh_total_expenditure_usd age i.gender hhsize income i.marital_status i.educational_level i.location i.employment_status income_usd [pw=WTA_S] if Region == 2
outreg2 using region.doc 

regress hh_total_expenditure_usd age i.gender hhsize income i.marital_status i.educational_level i.location i.employment_status income_usd i.Region [pw=WTA_S] 
outreg2 using region.doc 




* Logistic regression for healthcare utilization (binary outcome)
logit dem_health age i.gender hhsize income i.marital_status i.educational_level i.employment_status, or, [pw=WTA_S] if Region ==1 
outreg2 using region2.doc 

logit dem_health age i.gender hhsize income i.marital_status i.educational_level i.employment_status, or, [pw=WTA_S] if Region == 2
outreg2 using region2.doc 

logit dem_health age i.gender hhsize income i.marital_status i.educational_level i.employment_status, or, [pw=WTA_S]
outreg2 using region2.doc 














