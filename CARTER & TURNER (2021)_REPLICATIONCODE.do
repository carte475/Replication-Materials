*====================================* 
* CARTER & TURNER (2021)		     *
* EXAMINING THE IMMEDIATE EFFECTS... *
* LAST UPDATED: 04/09/2021			 *	
*====================================* 

*=====================================* 
* SET MACROS FOR EZ NAV 			  *
* TO FOLDERS W/JURSIDCITIONAL DATASET *
*=====================================* 

	global MASTER "C:\Users\travi\OneDrive - Michigan State University\COVID-19 Grant Project\Data"
	global Lansing "C:\Users\travi\OneDrive - Michigan State University\COVID-19 Grant Project\Data\Lansing"
	global Detroit "C:\Users\travi\OneDrive - Michigan State University\COVID-19 Grant Project\Data\Detroit"
	global Kalamazoo "C:\Users\travi\OneDrive - Michigan State University\COVID-19 Grant Project\Data\Kalamazoo"
	global GrandRapids "C:\Users\travi\OneDrive - Michigan State University\COVID-19 Grant Project\Data\Grand Rapids"

*===============================================================================*	
	
*===============================*
**# PREPARE EACH DATASET		*
* FOR MERGE INTO MASTER DATASET *
*===============================*

*=========*
* DETROIT *
*=========*
	{
* IMPORT DATA FROM MASTER FILE
	import excel "$Detroit\Excel files\Detroit_NEWMASTER_2018-2020.xlsx", ///
	sheet("Sheet1") firstrow clear

* GENERATE DUMMY COUNTS FOR RESIDENTIAL AND COMMERCIAL BURGLARY
	gen DET_RES = 1 if LocationCode == "20"
	gen DET_COM = 1 if LocationCode == "03" | ///
				LocationCode == "05" | ///
				LocationCode == "06" | ///
				LocationCode == "07" | ///
				LocationCode == "08" | ///
				LocationCode == "09" | ///
				LocationCode == "12" | ///
				LocationCode == "14" | ///
				LocationCode == "17" | ///
				LocationCode == "18" | ///
				LocationCode == "21" | ///
				LocationCode == "23" | ///
				LocationCode == "24" | ///
				LocationCode == "36" | ///
				LocationCode == "39" | ///
				LocationCode == "41" | ///
				LocationCode == "48" | ///
				LocationCode == "55"
	gen DET_NONRES = 1 if DET_RES == .
	
* GENERATE DATE VARIABLE
	gen DATE = DATE_OCC 
	recast double DATE
	format DATE %td
	
* COLLAPSE TO DAYS									
	collapse (sum) *RES *COM, by (DATE)
	
* SAVE AS MASTER TIME-SERIES DATASET
	save "$Detroit\DET_TS.dta", replace
}
*=========*
* LANSING *
*=========*
	{
* IMPORT DATA FROM MASTER FILE
	import excel "$Lansing\Excel files\Part 1 Burglary 2018-2020 MASTER FILE.xlsx", ///
	sheet("Sheet1") firstrow clear

* GENERATE DUMMY COUNTS FOR RESIDENTIAL AND COMMERCIAL BURGLARY
	gen LAN_RES = 1 if Location_Type == "20 - Residence/Home"
	gen LAN_COM = 1 if Location_Type == "03 - Bar/Nightclub" | ///
				Location_Type == "05 - Commercial/Office Building" | ///
				Location_Type == "06 - Construction Site" | ///
				Location_Type == "07 - Convenience Store" | ///
				Location_Type == "08 - Department/Discount Store" | ///
				Location_Type == "09 - Drug Store/Doctor's Office/Hospital" | ///
				Location_Type == "12 - Grocery/Supermarket" | ///
				Location_Type == "14 - Hotel/Motel/Etc." | ///
				Location_Type == "17 - Liquor Store" | ///
				Location_Type == "18 - Parking Lot/Garage" | ///
				Location_Type == "21 - Restaurant" | ///
				Location_Type == "23 - Service/Gas Station" | ///
				Location_Type == "24 - Specialty Store (TV, Fur, Etc.)" | ///
				Location_Type == "36 - Gambling Facility/Casino/Race Track" | ///
				Location_Type == "39 - Arena/Stadium/Fairgrounds/Coliseum" | ///
				Location_Type == "41 - Auto Dealership New/Used" | ///
				Location_Type == "48 - Industrial Site" 
	gen LAN_NONRES = 1 if LAN_RES == .
		
* GENERATE DATE VARIABLE
	clonevar DATE = Date_Occurred 
	
* COLLAPSE TO DAYS									
	collapse (sum) *RES *COM, by (DATE)
	
* MERGE W/MASTER TIME-SERIES DATASET
	merge 1:1 DATE using "$Detroit\DET_TS.dta"
	save "$Lansing\LAN_TS.dta", replace
	}
*===========*
* KALAMAZOO *
*===========*
	{
* IMPORT DATA FROM MASTER FILE
	import excel "$Kalamazoo\Excel Files\Kalamazoo_NEWMASTER 2018-2020.xlsx", ///
	sheet("Sheet1") firstrow clear

* GENERATE DUMMY COUNTS FOR RESIDENTIAL AND COMMERCIAL BURGLARY
	gen KAL_RES = 1 if Premise_Code == 20
	gen KAL_COM = 1 if Premise_Code == 3 | ///
				Premise_Code == 5 | ///
				Premise_Code == 6 | ///
				Premise_Code == 7 | ///
				Premise_Code == 8 | ///
				Premise_Code == 9 | ///
				Premise_Code == 12 | ///
				Premise_Code == 14 | ///
				Premise_Code == 17 | ///
				Premise_Code == 18 | ///
				Premise_Code == 21 | ///
				Premise_Code == 23 | ///
				Premise_Code == 24 | ///
				Premise_Code == 36 | ///
				Premise_Code == 39 | ///
				Premise_Code == 41 | ///
				Premise_Code == 48 | ///
				Premise_Code == 55
	gen KAL_NONRES = 1 if KAL_RES == .
						
* GENERATE DATE VARIABLE
	clonevar DATE = reported_date 
	
* COLLAPSE TO DAYS									
	collapse (sum) *RES *COM, by (DATE)
	
* MERGE W/MASTER TIME-SERIES DATASET
	merge 1:1 DATE using "$Lansing\LAN_TS.dta", gen(_merge2)
	save "$Kalamazoo\KAL_TS.dta", replace
	}
*==============*
* GRAND RAPIDS *
*==============*
	{
* IMPORT DATA FROM MASTER FILE
	import excel "$GrandRapids\Excel Files\Grand Rapids NEWMASTER 2018-2020.xlsx", ///
	sheet("Sheet1") firstrow clear
	
* GENERATE DUMMY COUNTS FOR RESIDENTIAL AND COMMERCIAL BURGLARY
	gen GR_RES = 1 if PREMISECODE == "20"
	gen GR_COM = 1 if PREMISECODE == "3" | ///
				PREMISECODE == "5" | ///
				PREMISECODE == "6" | ///
				PREMISECODE == "7" | ///
				PREMISECODE == "8" | ///
				PREMISECODE == "9" | ///
				PREMISECODE == "12" | ///
				PREMISECODE == "14" | ///
				PREMISECODE == "17" | ///
				PREMISECODE == "18" | ///
				PREMISECODE == "21" | ///
				PREMISECODE == "23" | ///
				PREMISECODE == "24" | ///
				PREMISECODE == "36" | ///
				PREMISECODE == "39" | ///
				PREMISECODE == "41" | ///
				PREMISECODE == "48" | ///
				PREMISECODE == "55"
	gen GR_NONRES = 1 if GR_RES == .
				
* GENERATE DATE VARIABLE
	clonevar DATE = DATEOFOFFENSE
	recast double DATE
	
* COLLAPSE TO DAYS									
	collapse (sum) *RES *COM, by (DATE)
	
* MERGE W/MASTER TIME-SERIES DATASET
	merge 1:1 DATE using "$Kalamazoo\KAL_TS.dta", gen (_merge3)
	save "$GrandRapids\GR_TS.dta", replace
	}
*===============================================================================*	
	
*=====================*
**# DATA CLEANING &	  *
* VARAIBLE GENERATION *
*=====================*
	{
* GENERATE A TS VARIABLE, "WEEK_NUM", # OF 7-DAY PERIODS SINCE 01/01/2018
	gen DAY = doy(DATE)
	gen WEEK = week(DATE)
	gen MONTH = month(DATE)
	gen YEAR = year(DATE)
	gen INT_WEEK_NUM = floor((DATE - td(1jan2018))/7) + 1
	sort DATE
	
* WEEK 157 STARTS ON 12/28/2020, WHICH HAS ONLY 4 DAYS. DROP THIS PARTIAL WEEK	
	di date("12-28-2020", "MDY")
	drop if DATE >= 22277
	
* COLLAPSE TO WEEK_NUM FOR TS MODELS
	collapse (sum) *RES *COM, by (INT_WEEK_NUM)
	
* GENERATE MI LOCKDOWN INDICATOR
	gen MI_LOCKDOWN = 0
	replace MI_LOCKDOWN = 1 if INT_WEEK_NUM >=117 & INT_WEEK_NUM <= 126
	
* GENERATE FLOYD INTERVENTION 	+++ MAY HE REST IN PEACE +++
	gen FLOYD = 0
	replace FLOYD = 1 if INT_WEEK_NUM >= 122 & INT_WEEK_NUM <= 122	
	
* GENERATE ANNUAL INDICATORS
	gen YEAR_2018 = 0
	replace YEAR_2018 = 1 if INT_WEEK_NUM <= 52
	gen YEAR_2019 = 0
	replace YEAR_2019 = 1 if INT_WEEK_NUM > 52 & INT_WEEK_NUM <= 104
	gen YEAR_2020 = 0
	replace YEAR_2020 = 1 if INT_WEEK_NUM > 104 
	gen YEAR = 1 if YEAR_2018 == 1
	replace YEAR = 2 if YEAR_2019 == 1
	replace YEAR = 3 if YEAR_2020 == 1
	label variable YEAR "YEAR"
	label define YY 1  "2018" 2 "2019" 3 "2020" 
	label value YEAR YY
	
* GENERATE MONTHLY INDICATORS
	gen JAN = 0
	replace JAN = 1 if INT_WEEK_NUM <= 5 | ///
				INT_WEEK_NUM >= 53 & INT_WEEK_NUM <= 57 | ///
				INT_WEEK_NUM >= 105 & INT_WEEK_NUM <= 109
	gen FEB = 0
	replace FEB = 1 if INT_WEEK_NUM >= 6 & INT_WEEK_NUM <= 9 | ///
				INT_WEEK_NUM >= 58 & INT_WEEK_NUM <= 61 | ///
				INT_WEEK_NUM >= 110 & INT_WEEK_NUM <= 113
	gen MAR = 0
	replace MAR = 1 if INT_WEEK_NUM >= 10 & INT_WEEK_NUM <= 13 | ///
				INT_WEEK_NUM >= 62 & INT_WEEK_NUM <= 65 | ///
				INT_WEEK_NUM >= 114 & INT_WEEK_NUM <= 117
	gen APR = 0
	replace APR = 1 if INT_WEEK_NUM >= 14 & INT_WEEK_NUM <= 17 | ///
				INT_WEEK_NUM >= 66 & INT_WEEK_NUM <= 69 | ///
				INT_WEEK_NUM >= 118 & INT_WEEK_NUM <= 122
	gen MAY = 0
	replace MAY = 1 if INT_WEEK_NUM >= 18 & INT_WEEK_NUM <= 22 | ///
				INT_WEEK_NUM >= 70 & INT_WEEK_NUM <= 74 | ///
				INT_WEEK_NUM >= 123 & INT_WEEK_NUM <= 126
	gen JUN = 0
	replace JUN = 1 if INT_WEEK_NUM >= 23 & INT_WEEK_NUM <= 26 | ///
				INT_WEEK_NUM >= 75 & INT_WEEK_NUM <= 78 | ///
				INT_WEEK_NUM >= 127 & INT_WEEK_NUM <= 130
	gen JUL = 0
	replace JUL = 1 if INT_WEEK_NUM >= 27 & INT_WEEK_NUM <= 30 | ///
				INT_WEEK_NUM >= 79 & INT_WEEK_NUM <= 83 | ///
				INT_WEEK_NUM >= 131 & INT_WEEK_NUM <= 135
	gen AUG = 0
	replace AUG = 1 if INT_WEEK_NUM >= 31 & INT_WEEK_NUM <= 35 | ///
				INT_WEEK_NUM >= 84 & INT_WEEK_NUM <= 87 | ///
				INT_WEEK_NUM >= 136 & INT_WEEK_NUM <= 139
	gen SEP = 0
	replace SEP = 1 if INT_WEEK_NUM >= 36 & INT_WEEK_NUM <= 39 | ///
				INT_WEEK_NUM >= 88 & INT_WEEK_NUM <= 91 | ///
				INT_WEEK_NUM >= 140 & INT_WEEK_NUM <= 144
	gen OCT = 0
	replace OCT = 1 if INT_WEEK_NUM >= 40 & INT_WEEK_NUM <= 44 | ///
				INT_WEEK_NUM >= 92 & INT_WEEK_NUM <= 96 | ///
				INT_WEEK_NUM >= 145 & INT_WEEK_NUM <= 148	
	gen NOV = 0
	replace NOV = 1 if INT_WEEK_NUM >= 45 & INT_WEEK_NUM <= 48 | ///
				INT_WEEK_NUM >= 97 & INT_WEEK_NUM <= 100 | ///
				INT_WEEK_NUM >= 149 & INT_WEEK_NUM <= 152
	gen DEC = 0
	replace DEC = 1 if INT_WEEK_NUM >= 49 & INT_WEEK_NUM <= 52 | ///
				INT_WEEK_NUM >= 101 & INT_WEEK_NUM <= 104 | ///
				INT_WEEK_NUM >= 153 & INT_WEEK_NUM <= 156

* SET INT_WEEK_NUM TO TIME SERIES
	tsset INT_WEEK_NUM, weekly

*===============================================================================*	
}

*====================*
**#MODEL SPEC CHECKS *
*====================*
	{
*===================* 
* STATIONARITY TEST *
*===================*
* SEE "STATIONARITY TEST FILE"
 save "$MASTER\CV19_PPR_TS.dta", replace

* UPDATES: ALL SERIES ARE STAIONARY AROUND A TREND AND MEAN!

*=====================*
* OVERDISPERSION TEST *
*=====================*

	* LANSING 
	nbreg LAN_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
		AUG SEP OCT NOV
					* NO OVERDISPERSION
	nbreg LAN_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
		AUG SEP OCT NOV
					* OVERDISPERSION
	* DETROIT 
	nbreg DET_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
		AUG SEP OCT NOV
					* OVERDISPERSION
	nbreg DET_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
		AUG SEP OCT NOV
					* OVERDISPERSION
	* KALAMAZOO 
	nbreg KAL_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
		AUG SEP OCT NOV
					* NO OVERDISPERSION
	nbreg KAL_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
		AUG SEP OCT NOV
					* NO OVERDISPERSION
	* GRAND RAPIDS 
	nbreg GR_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
		AUG SEP OCT NOV
					* OVERDISPERSION
	nbreg GR_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
		AUG SEP OCT NOV
					* OVERDISPERSION

*========================*
* MULTICOLLINEARITY TEST *
*========================*

	regress LAN_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
		AUG SEP OCT NOV
	estat vif
}

*=================*
**# AR ESTIMATION *
*=================*
	{
	* LANSING RESDIENTIAL
	regress LAN_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, r
	predict LAN_RES_RESIDUALS, resid
	wntestq LAN_RES_RESIDUALS
	ac LAN_RES_RESIDUALS
	pac LAN_RES_RESIDUALS
	wntestb LAN_RES_RESIDUALS
	
	arima LAN_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, arima(1,0,0) vce(robust)
	predict LAN_RES_RESIDUALS_AR1, resid
	wntestq LAN_RES_RESIDUALS_AR1
	ac LAN_RES_RESIDUALS_AR1
	pac LAN_RES_RESIDUALS_AR1
	wntestb LAN_RES_RESIDUALS_AR1

	* LANSING COMMERCIAL	
	regress LAN_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, r
	predict LAN_COM_RESIDUALS, resid
	wntestq LAN_COM_RESIDUALS
	ac LAN_COM_RESIDUALS
	pac LAN_COM_RESIDUALS
	wntestb LAN_COM_RESIDUALS
	
	* KALAMAZOO RESIDENTIAL
	regress KAL_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, r
	predict KAL_RES_RESIDUALS, resid
	wntestq KAL_RES_RESIDUALS
	ac KAL_RES_RESIDUALS
	pac KAL_RES_RESIDUALS
	wntestb KAL_RES_RESIDUALS
	
	* KALAMAZOO COMMERCIAL
	regress KAL_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, r
	predict KAL_COM_RESIDUALS, resid
	wntestq KAL_COM_RESIDUALS
	ac KAL_COM_RESIDUALS
	pac KAL_COM_RESIDUALS
	wntestb KAL_COM_RESIDUALS
	
	* GRAND RAPIDS RESIDENTIAL
	regress GR_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, r
	predict GR_RES_RESIDUALS, resid
	wntestq GR_RES_RESIDUALS
	ac GR_RES_RESIDUALS
	pac GR_RES_RESIDUALS
	wntestb GR_RES_RESIDUALS
	
	arima GR_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, arima(1,0,0) vce(robust)
	predict GR_RES_RESIDUALS_AR1, resid
	wntestq GR_RES_RESIDUALS_AR1
	ac GR_RES_RESIDUALS_AR1
	pac GR_RES_RESIDUALS_AR1
	wntestb GR_RES_RESIDUALS_AR1

	* GRAND RAPIDS COMMERCIAL
	regress GR_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, r
	predict GR_COM_RESIDUALS, resid
	wntestq GR_COM_RESIDUALS
	ac GR_COM_RESIDUALS
	pac GR_COM_RESIDUALS
	wntestb GR_COM_RESIDUALS, table

	arima GR_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, arima(5,0,0) vce(robust)
	predict GR_COM_RESIDUALS_AR5, resid
	wntestq GR_COM_RESIDUALS_AR5
	ac GR_COM_RESIDUALS_AR5
	pac GR_COM_RESIDUALS_AR5
	wntestb GR_COM_RESIDUALS_AR5
	
	* DETROIT RESIDENTIAL
	regress DET_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, r
	predict DET_RES_RESIDUALS, resid
	wntestq DET_RES_RESIDUALS
	ac DET_RES_RESIDUALS
	pac DET_RES_RESIDUALS
	wntestb DET_RES_RESIDUALS

	arima DET_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, arima(4,0,0) vce(robust)
	predict DET_RES_RESIDUALS_AR4, resid 
	wntestq DET_RES_RESIDUALS_AR4
	ac DET_RES_RESIDUALS_AR4
	pac DET_RES_RESIDUALS_AR4
	wntestb DET_RES_RESIDUALS_AR4

	* DETROIT COMMERCIAL
	regress DET_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, r
	predict DET_COM_RESIDUALS, resid
	wntestq DET_COM_RESIDUALS
	ac DET_COM_RESIDUALS
	pac DET_COM_RESIDUALS
	wntestb DET_COM_RESIDUALS
	
	arima DET_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, arima(1,0,0) vce(robust)
	predict DET_COM_RESIDUALS_MA1, resid
	wntestq DET_COM_RESIDUALS_MA1
	ac DET_COM_RESIDUALS_MA1
	pac DET_COM_RESIDUALS_MA1
	wntestb DET_COM_RESIDUALS_MA1
	}
*===============*
**#FLOYD MODELS *
*===============*
	{
* TABLE ? RESIDENTIAL 
	eststo clear
	* DETROIT
	eststo: arpois DET_RES MI_LOCKDOWN FLOYD YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(4) delete
			predict resid_DETRES_FLOYD, residuals
			wntestq resid_DETRES_FLOYD
	* GRAND RAPIDS
	eststo: arpois GR_RES MI_LOCKDOWN FLOYD YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(1) delete
			predict resid_GRRES_FLOYD, residuals
			wntestq resid_GRRES_FLOYD
	* KALAMAZOO
	eststo: arpois KAL_RES MI_LOCKDOWN FLOYD YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(0) delete
			predict resid_KALRES_FLOYD, residuals
			wntestq resid_KALRES_FLOYD
	* LANSING	
	eststo: arpois LAN_RES MI_LOCKDOWN FLOYD YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, ar(1) delete
			predict resid_LANRES_FLOYD, residuals
			wntestq resid_LANRES_FLOYD
	
	* OUTPUT TABLE		
	esttab using results_FLOYD_RES.csv, b(3) se(2) ///
			scalars(F df_m df_r r2_a) ///
			nonumbers mtitles("DETROIT" "GRAND RAPIDS" "KALAMAZOO" "LANSING") ///
			title("RESDIENTIAL BURGLARY W/FLOYD") replace

* TABLE ? COMMERCIAL 
	eststo clear
	* DETROIT
	eststo: arpois DET_COM MI_LOCKDOWN FLOYD YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(1) delete
			predict resid_DETCOM_FLOYD, residuals
			wntestq resid_DETCOM_FLOYD	
	* GRAND RAPIDS
	eststo: arpois GR_COM MI_LOCKDOWN FLOYD YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(5) delete
			predict resid_GRCOM_FLOYD, residuals
			wntestq resid_GRCOM_FLOYD	
	* KALAMAZOO
	eststo: arpois KAL_COM MI_LOCKDOWN FLOYD YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(0) delete
			predict resid_KALCOM_FLOYD, residuals
			wntestq resid_KALCOM_FLOYD	
	* LANSING	
	eststo: arpois LAN_COM MI_LOCKDOWN FLOYD YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(0) delete
			predict resid_LANCOM_FLOYD, residuals
			wntestq resid_LANCOM_FLOYD
			
	* OUTPUT TABLE		
	esttab using results_FLOYD_COMM.csv, b(3) se(2) ///
			scalars(F df_m df_r r2_a) ///
			nonumbers mtitles("DETROIT" "GRAND RAPIDS" "KALAMAZOO" "LANSING") ///
			title("COMMERCIAL BURGLARY W/FLOYD") replace
	}
*===============================================================================*	

*================*
**# FINAL MODELS *
*================*
	{
* TABLE 1 ANNUAL FREQUENCIES
	total DET_RES DET_COM GR_RES GR_COM KAL_RES KAL_COM LAN_RES LAN_COM, over(YEAR) 
	
	* CHECK TO SEE IF NONRES AND COMM LOOK SIMILAR
	total DET_COM DET_NONRES GR_COM GR_NONRES KAL_COM KAL_NONRES LAN_COM LAN_NONRES, over(YEAR) 
	corr DET_COM DET_NONRES GR_COM GR_NONRES KAL_COM KAL_NONRES LAN_COM LAN_NONRES
	
* TABLE 2 SUMMARY STATISTICS
	summarize DET_RES DET_COM GR_RES GR_COM KAL_RES KAL_COM LAN_RES LAN_COM

* TABLE 3 RESIDENTIAL 
	eststo clear
	* DETROIT
	eststo: arpois DET_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(4) delete
			predict resid_DETRES, residuals
			wntestq resid_DETRES
	* GRAND RAPIDS
	eststo: arpois GR_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(1) delete
			predict resid_GRRES, residuals
			wntestq resid_GRRES			
	* KALAMAZOO
	eststo: arpois KAL_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(0) delete
			predict resid_KALRES, residuals
			wntestq resid_KALRES	
	* LANSING	
	eststo: arpois LAN_RES MI_LOCKDOWN YEAR_2018 YEAR_2020 JAN FEB MAR APR MAY JUN JUL ///
			AUG SEP OCT NOV, ar(1) delete
			predict resid_LANRES, residuals
			wntestq resid_LANRES
	* OUTPUT TABLE		
	esttab using results_ppr1.csv, b(3) se(2) ///
			scalars(F df_m df_r r2_a) ///
			nonumbers mtitles("DETROIT" "GRAND RAPIDS" "KALAMAZOO" "LANSING") ///
			title("RESDIENTIAL BURGLARY") wide replace

* TABLE 4 COMMERCIAL 
	eststo clear
	* DETROIT
	eststo: arpois DET_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(1) delete
			predict resid_DETCOM, residuals
			wntestq resid_DETCOM			
	* GRAND RAPIDS
	eststo: arpois GR_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(5) delete
			predict resid_GRCOM, residuals
			wntestq resid_GRCOM			
	* KALAMAZOO
	eststo: arpois KAL_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(0) delete
			predict resid_KALCOM, residuals
			wntestq resid_KALCOM			

	* LANSING	
	eststo: arpois LAN_COM MI_LOCKDOWN YEAR_2018 YEAR_2020 ///
			JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV, ar(0) delete
			predict resid_LANCOM, residuals
			wntestq resid_LANCOM			
	* OUTPUT TABLE		
	esttab using results2_ppr1.csv, b(3) se(2) ///
			scalars(F df_m df_r r2_a) ///
			nonumbers mtitles("DETROIT" "GRAND RAPIDS" "KALAMAZOO" "LANSING") ///
			title("COMMERCIAL BURGLARY") wide replace
	}
*===============================================================================*	
*==================================*
**# POST_INT_MEAN REVERSION MODELS *
*==================================*
{
	* STEP 1) CREATE SUBSET OF BURGLARY SERIES (WEEKS 117-156)
	
	* RESIDENTIAL
		* DETROIT
	clonevar SUBSET_DET_RES = DET_RES
	replace SUBSET_DET_RES = . if INT_WEEK_NUM < 117
		* GRAND RAPIDS
	clonevar SUBSET_GR_RES = GR_RES
	replace SUBSET_GR_RES = . if INT_WEEK_NUM < 117
		* KALAMAZOO
	clonevar SUBSET_KAL_RES = KAL_RES
	replace SUBSET_KAL_RES = . if INT_WEEK_NUM < 117
		* LANSING
	clonevar SUBSET_LAN_RES = LAN_RES
	replace SUBSET_LAN_RES = . if INT_WEEK_NUM < 117
	
	* COMMERCIAL
		* DETROIT
	clonevar SUBSET_DET_COM = DET_COM
	replace SUBSET_DET_COM = . if INT_WEEK_NUM < 117
		* GRAND RAPIDS
	clonevar SUBSET_GR_COM = GR_COM
	replace SUBSET_GR_COM = . if INT_WEEK_NUM < 117
		* KALAMAZOO
	clonevar SUBSET_KAL_COM = KAL_COM
	replace SUBSET_KAL_COM = . if INT_WEEK_NUM < 117
		* LANSING
	clonevar SUBSET_LAN_COM = LAN_COM
	replace SUBSET_LAN_COM = . if INT_WEEK_NUM < 117

	* STEP 2) CREATE A DUMMY INDICATOR FOR WHEN THE LOCKDOWN ORDER WAS LIFTED
	gen LIFT_LOCKDOWN = 0
	replace LIFT_LOCKDOWN = 1 if INT_WEEK_NUM >=127 
	
	* STEP 3) CHECK FOR WHITE NOISE & STATIONARY PROCESS IN DATA SERIES
	* RESIDENTIAL
	foreach x of varlist  SUBSET_DET_RES SUBSET_GR_RES ///
							SUBSET_KAL_RES SUBSET_LAN_RES {
	wntestq `x'
			}
			
	foreach x of varlist  SUBSET_DET_RES SUBSET_GR_RES ///
							SUBSET_KAL_RES SUBSET_LAN_RES {
	dfuller `x'
			}

			
	* COMMERCIAL
	foreach x of varlist  SUBSET_DET_COM SUBSET_GR_COM ///
							SUBSET_KAL_COM SUBSET_LAN_COM {
	wntestq `x'
			}
			
	foreach x of varlist  SUBSET_DET_COM SUBSET_GR_COM ///
							SUBSET_KAL_COM SUBSET_LAN_COM {
	dfuller `x'
			}
			
	* STEP 4) RUN PAR(q) MODELS WITH A LINEAR TREND TERM AND THE LOCKDOWN ORDER
	cd  "C:\Users\travi\OneDrive - Michigan State University\COVID-19 Grant Project\Data\Do Files\PPR1"
	eststo clear
	* RESIDENTIAL
		* DETROIT
	eststo: arpois SUBSET_DET_RES LIFT_LOCKDOWN INT_WEEK_NUM, ar(0) delete
			predict resid_DETRES_SA, residuals
			wntestq resid_DETRES_SA 
			estadd scalar pQ = r(stat)
			estadd scalar pQp = r(p)
			* NO MEAN REVERSION
			
		* GRAND RAPIDS
	eststo: arpois SUBSET_GR_RES LIFT_LOCKDOWN INT_WEEK_NUM, ar(1) delete
			predict resid_GRRES_SA, residuals
			wntestq resid_GRRES_SA 
			estadd scalar pQ = r(stat)
			estadd scalar pQp = r(p)
			* MEAN REVERSION @ 95% CONF LVL
			
		* KALAMAZOO
	eststo: arpois SUBSET_KAL_RES LIFT_LOCKDOWN INT_WEEK_NUM, ar(0) delete
			predict resid_KALRES_SA, residuals
			wntestq resid_KALRES_SA 
			estadd scalar pQp = r(p)
			estadd scalar pQ = r(stat)
			* NO MEAN REVERSION
			
		* LANSING
	eststo: arpois SUBSET_LAN_RES LIFT_LOCKDOWN INT_WEEK_NUM, ar(0) delete
			predict resid_LANRES_SA, residuals
			wntestq resid_LANRES_SA 
			estadd scalar pQp = r(p)
			estadd scalar pQ = r(stat)
			* NO MEAN REVERSION		
	
		* CREATE TABLE
		esttab using results_LOCKDOWNREMOVAL_RES.csv, b(2) se(2) ///
			scalars(F df_m df_r r2_a pQ p) ///
			nonumbers mtitles("DETROIT" "GRAND RAPIDS" "KALAMAZOO" "LANSING") ///
			title("RESDIENTIAL BURGLARY LOCKDOWN REMOVAL") replace

	cd  "C:\Users\travi\OneDrive - Michigan State University\COVID-19 Grant Project\Data\Do Files\PPR1"
	eststo clear

	* COMMERCIAL
		* DETROIT
	eststo: arpois SUBSET_DET_COM LIFT_LOCKDOWN INT_WEEK_NUM, ar(0) delete
			predict resid_DETCOM_SA, residuals
			wntestq resid_DETCOM_SA
			estadd scalar pQ = r(stat)
			estadd scalar pQp = r(p)
			* MEAN REVERSION @ 95% CONF LVL

		* GRAND RAPIDS
	eststo: arpois SUBSET_GR_COM LIFT_LOCKDOWN INT_WEEK_NUM, ar(0) delete
			predict resid_GRCOM_SA, residuals
			wntestq resid_GRCOM_SA
			estadd scalar pQ = r(stat)
			estadd scalar pQp = r(p)
			* NO MEAN REVERSION
			
		* KALAMAZOO
	eststo: arpois SUBSET_KAL_COM LIFT_LOCKDOWN INT_WEEK_NUM, ar(0) delete
			predict resid_KALCOM_SA, residuals
			wntestq resid_KALCOM_SA 
			estadd scalar pQ = r(stat)
			estadd scalar pQp = r(p)
			* NO MEAN REVERSION
			
		* LANSING
	eststo: arpois SUBSET_LAN_COM LIFT_LOCKDOWN INT_WEEK_NUM, ar(0) delete
			predict resid_LANCOM_SA, residuals
			wntestq resid_LANCOM_SA 
			estadd scalar pQ = r(stat)
			estadd scalar pQp = r(p)
			* NO MEAN REVERSION

		* CREATE TABLE
		esttab using results_LOCKDOWNREMOVAL_COM.csv, b(2) se(2) ///
			scalars(F df_m df_r r2_a pQ pQp) ///
			nonumbers mtitles("DETROIT" "GRAND RAPIDS" "KALAMAZOO" "LANSING") ///
			title("COMMERCIAL BURGLARY LOCKDOWN REMOVAL") replace
			
}			

