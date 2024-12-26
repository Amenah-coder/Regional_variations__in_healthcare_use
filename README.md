# Regional_variations__in_healthcare_use
# Replication Materials for Regional Disparities in Healthcare Expenditure in Ghana

This repository contains the Stata do-file used for the analysis of regional disparities in healthcare expenditure in Ghana, as presented in Are regional variations in health care use, within a country, due to patient characteristics?.


**Description:**

This do-file performs the following steps:

1.  **Data Preparation:** Merges and cleans data from the Ghana Living Standards Survey (GLSS7) to create a dataset for analysis. This includes:
    *   Merging household and individual level data.
    *   Recoding variables such as region, gender, marital status, education level, employment status, and location.
    *   Generating variables for income in USD and health expenditure in USD using the 2017/2018 average exchange rate.
    *   Creating a flag variable to identify observations used in the regressions.
2.  **Descriptive Statistics:** Calculates descriptive statistics for both categorical and continuous variables, stratified by region (Southern and Northern Ghana).
3.  **Decomposition Analysis:** Performs an Oaxaca-Blinder decomposition to analyze the contribution of patient characteristics to regional differences in healthcare expenditure.
4.  **Regression Analysis:** Runs OLS regressions for total health expenditure and logistic regressions for healthcare utilization, stratified by region and for the full sample.

**Data Sources:**

The initial data used in this analysis is from the Ghana Living Standards Survey (GLSS7), available from the Ghana Statistical Service website: [https://microdata.statsghana.gov.gh/index.php/catalog/97]. Due to data use agreements, the initial datasets used for merging are not included in this repository. The final merged dataset used for the analysis is included as `Regional_differences.dta`.

**Software Requirements:**

*   Stata (version 14 or later is recommended)
*   `outreg2` package for Stata (install using `ssc install outreg2`)

**Running the Code:**

1.  Download the repository.
2.  Open Stata.
3.  Set the working directory to the location of the do-file.
4.  Run the do-file using the command `do your_do_file_name.do` (replace `your_do_file_name.do` with the actual name of your do-file).

**Variables:**

A detailed description of the variables used in the analysis can be found in [Table 1/Appendix Table providing variable definitions] of the associated paper. Key variables include:

*   `hh_total_health_expenditure_usd`: Household total health expenditure in USD.
*   `Region`: Binary variable indicating region (1=Southern, 0=Northern).
*   `age`: Age of the individual.
*   `gender`: Gender of the individual (1=Male, 0=Female).
*   `hhsize`: Household size.
*   `income_usd`: Household income in USD.
* `marital_status`: Marital status of the individual.
* `educational_level`: Education level of the individual.
* `employment_status`: Employment status of the individual.
* `location`: Location of the household (1=Rural, 0=Urban)
* `dem_health`: healthcare utilization


**Output Files:**

The do-file generates the following output files:

*   `oa1.doc`: Output from the Oaxaca decomposition.
*   `region.doc`: Output from the OLS regressions.



[Optional: Add a license, such as MIT or GPL. This specifies how others can use your code.]



