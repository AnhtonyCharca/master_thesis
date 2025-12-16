************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – Full 2018–2022 y paneles puros
* - Logit FE y RE
* - Modelo dinámico (GEE con L.pob_monetaria)
* - Efectos marginales FE
* - Poder de predicción (CCR, SEN, SPE, AUC)
* - Tabla comparativa de dy/dx (FE) con collect
************************************************************

clear all
set more off

************************************************************
* 0. CARGA DE BASE Y CONFIGURACIÓN GENERAL
************************************************************

use "$dclea/pobreza_panel_18-22_full.dta", clear
* DATA POBREZA - ENAHO Panel 2018–2022 (long)

* Variable dependiente
capture confirm variable pob_monetaria
if _rc {
    capture rename pobre2_ pob_monetaria
}

label define lbl_pobmon 0 "No pobre" 1 "Pobre", replace
label values pob_monetaria lbl_pobmon

* Identificar variable de departamento
capture confirm variable dpto_
if _rc == 0 {
    global DEPVAR dpto_
}
else {
    capture confirm variable depto
    if _rc == 0 global DEPVAR depto
}

* Declarar panel
xtset idhogar year

* Especificación final de regresores (sin analfa_)
* lwage_    = log(ingreso laboral u hogar
* totmieho_ = tamaño del hogar
* internet_ = dummy acceso a internet
global X_panel lwage_ totmieho_ internet_


************************************************************
* 1. MODELOS POR ÁMBITO Y PANEL
*    (FE, RE y dinámico GEE)
************************************************************

**********************
* 1.1 PERÚ – FULL 18–22
**********************
di as text "================ PERU_FULL 2018–2022 ================"

xtset idhogar year

*------------------*
* FE – PERU_FULL   *
*------------------*
xtlogit pob_monetaria $X_panel, fe
estimates store FE_PERU_FULL

margins, dydx($X_panel)
estimates store MFE_PERU_FULL

* Predicciones y poder de clasificación FE
capture drop phat_fe_PERU_FULL yhat_fe_PERU_FULL
predict double phat_fe_PERU_FULL, pu0

gen byte yhat_fe_PERU_FULL = (phat_fe_PERU_FULL >= 0.5) if e(sample)

tempname M_fe_PERU_FULL
tab pob_monetaria yhat_fe_PERU_FULL if e(sample), matcell(`M_fe_PERU_FULL')

scalar TN_fe_PERU_FULL = `M_fe_PERU_FULL'[1,1]
scalar FP_fe_PERU_FULL = `M_fe_PERU_FULL'[1,2]
scalar FN_fe_PERU_FULL = `M_fe_PERU_FULL'[2,1]
scalar TP_fe_PERU_FULL = `M_fe_PERU_FULL'[2,2]

scalar CCR_fe_PERU_FULL = (TP_fe_PERU_FULL + TN_fe_PERU_FULL) / ///
                          (TP_fe_PERU_FULL + TN_fe_PERU_FULL + FP_fe_PERU_FULL + FN_fe_PERU_FULL)
scalar SEN_fe_PERU_FULL = TP_fe_PERU_FULL / (TP_fe_PERU_FULL + FN_fe_PERU_FULL)
scalar SPE_fe_PERU_FULL = TN_fe_PERU_FULL / (TN_fe_PERU_FULL + FP_fe_PERU_FULL)

roctab pob_monetaria phat_fe_PERU_FULL if e(sample), nograph
scalar AUC_fe_PERU_FULL = r(area)

*------------------*
* RE – PERU_FULL   *
*------------------*
 xtlogit pob_monetaria $X_panel, re vce(cluster idhogar) nolog
estimates store RE_PERU_FULL

capture drop phat_re_PERU_FULL yhat_re_PERU_FULL
predict double phat_re_PERU_FULL

gen byte yhat_re_PERU_FULL = (phat_re_PERU_FULL >= 0.5) if e(sample)

tempname M_re_PERU_FULL
tab pob_monetaria yhat_re_PERU_FULL if e(sample), matcell(`M_re_PERU_FULL')

scalar TN_re_PERU_FULL = `M_re_PERU_FULL'[1,1]
scalar FP_re_PERU_FULL = `M_re_PERU_FULL'[1,2]
scalar FN_re_PERU_FULL = `M_re_PERU_FULL'[2,1]
scalar TP_re_PERU_FULL = `M_re_PERU_FULL'[2,2]

scalar CCR_re_PERU_FULL = (TP_re_PERU_FULL + TN_re_PERU_FULL) / ///
                          (TP_re_PERU_FULL + TN_re_PERU_FULL + FP_re_PERU_FULL + FN_re_PERU_FULL)
scalar SEN_re_PERU_FULL = TP_re_PERU_FULL / (TP_re_PERU_FULL + FN_re_PERU_FULL)
scalar SPE_re_PERU_FULL = TN_re_PERU_FULL / (TN_re_PERU_FULL + FP_re_PERU_FULL)

roctab pob_monetaria phat_re_PERU_FULL if e(sample), nograph
scalar AUC_re_PERU_FULL = r(area)

*------------------------*
* Dinámico GEE – PERU_FULL
*------------------------*
xtgee pob_monetaria L.pob_monetaria $X_panel, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)
estimates store DYN_PERU_FULL

capture drop phat_dyn_PERU_FULL yhat_dyn_PERU_FULL
predict double phat_dyn_PERU_FULL, mu

gen byte yhat_dyn_PERU_FULL = (phat_dyn_PERU_FULL >= 0.5) if e(sample)

tempname M_dyn_PERU_FULL
tab pob_monetaria yhat_dyn_PERU_FULL if e(sample), matcell(`M_dyn_PERU_FULL')

scalar TN_dyn_PERU_FULL = `M_dyn_PERU_FULL'[1,1]
scalar FP_dyn_PERU_FULL = `M_dyn_PERU_FULL'[1,2]
scalar FN_dyn_PERU_FULL = `M_dyn_PERU_FULL'[2,1]
scalar TP_dyn_PERU_FULL = `M_dyn_PERU_FULL'[2,2]

scalar CCR_dyn_PERU_FULL = (TP_dyn_PERU_FULL + TN_dyn_PERU_FULL) / ///
                           (TP_dyn_PERU_FULL + TN_dyn_PERU_FULL + FP_dyn_PERU_FULL + FN_dyn_PERU_FULL)
scalar SEN_dyn_PERU_FULL = TP_dyn_PERU_FULL / (TP_dyn_PERU_FULL + FN_dyn_PERU_FULL)
scalar SPE_dyn_PERU_FULL = TN_dyn_PERU_FULL / (TN_dyn_PERU_FULL + FP_dyn_PERU_FULL)

roctab pob_monetaria phat_dyn_PERU_FULL if e(sample), nograph
scalar AUC_dyn_PERU_FULL = r(area)


**********************
* 1.2 PUNO – FULL 18–22
**********************
di as text "================ PUNO_FULL 2018–2022 ================"

preserve
keep if $DEPVAR == 21
xtset idhogar year

* FE – PUNO_FULL
 xtlogit pob_monetaria $X_panel, fe
estimates store FE_PUNO_FULL

margins, dydx($X_panel)
estimates store MFE_PUNO_FULL

capture drop phat_fe_PUNO_FULL yhat_fe_PUNO_FULL
 predict double phat_fe_PUNO_FULL, pu0

gen byte yhat_fe_PUNO_FULL = (phat_fe_PUNO_FULL >= 0.5) if e(sample)

tempname M_fe_PUNO_FULL
tab pob_monetaria yhat_fe_PUNO_FULL if e(sample), matcell(`M_fe_PUNO_FULL')

scalar TN_fe_PUNO_FULL = `M_fe_PUNO_FULL'[1,1]
scalar FP_fe_PUNO_FULL = `M_fe_PUNO_FULL'[1,2]
scalar FN_fe_PUNO_FULL = `M_fe_PUNO_FULL'[2,1]
scalar TP_fe_PUNO_FULL = `M_fe_PUNO_FULL'[2,2]

scalar CCR_fe_PUNO_FULL = (TP_fe_PUNO_FULL + TN_fe_PUNO_FULL) / ///
                          (TP_fe_PUNO_FULL + TN_fe_PUNO_FULL + FP_fe_PUNO_FULL + FN_fe_PUNO_FULL)
scalar SEN_fe_PUNO_FULL = TP_fe_PUNO_FULL / (TP_fe_PUNO_FULL + FN_fe_PUNO_FULL)
scalar SPE_fe_PUNO_FULL = TN_fe_PUNO_FULL / (TN_fe_PUNO_FULL + FP_fe_PUNO_FULL)

roctab pob_monetaria phat_fe_PUNO_FULL if e(sample), nograph
scalar AUC_fe_PUNO_FULL = r(area)

* RE – PUNO_FULL
 xtlogit pob_monetaria $X_panel, re vce(cluster idhogar) nolog
estimates store RE_PUNO_FULL

capture drop phat_re_PUNO_FULL yhat_re_PUNO_FULL
quietly predict double phat_re_PUNO_FULL

gen byte yhat_re_PUNO_FULL = (phat_re_PUNO_FULL >= 0.5) if e(sample)

tempname M_re_PUNO_FULL
tab pob_monetaria yhat_re_PUNO_FULL if e(sample), matcell(`M_re_PUNO_FULL')

scalar TN_re_PUNO_FULL = `M_re_PUNO_FULL'[1,1]
scalar FP_re_PUNO_FULL = `M_re_PUNO_FULL'[1,2]
scalar FN_re_PUNO_FULL = `M_re_PUNO_FULL'[2,1]
scalar TP_re_PUNO_FULL = `M_re_PUNO_FULL'[2,2]

scalar CCR_re_PUNO_FULL = (TP_re_PUNO_FULL + TN_re_PUNO_FULL) / ///
                          (TP_re_PUNO_FULL + TN_re_PUNO_FULL + FP_re_PUNO_FULL + FN_re_PUNO_FULL)
scalar SEN_re_PUNO_FULL = TP_re_PUNO_FULL / (TP_re_PUNO_FULL + FN_re_PUNO_FULL)
scalar SPE_re_PUNO_FULL = TN_re_PUNO_FULL / (TN_re_PUNO_FULL + FP_re_PUNO_FULL)

roctab pob_monetaria phat_re_PUNO_FULL if e(sample), nograph
scalar AUC_re_PUNO_FULL = r(area)

* Dinámico GEE – PUNO_FULL
xtgee pob_monetaria L.pob_monetaria $X_panel, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)
estimates store DYN_PUNO_FULL

capture drop phat_dyn_PUNO_FULL yhat_dyn_PUNO_FULL
quietly predict double phat_dyn_PUNO_FULL, mu

gen byte yhat_dyn_PUNO_FULL = (phat_dyn_PUNO_FULL >= 0.5) if e(sample)

tempname M_dyn_PUNO_FULL
tab pob_monetaria yhat_dyn_PUNO_FULL if e(sample), matcell(`M_dyn_PUNO_FULL')

scalar TN_dyn_PUNO_FULL = `M_dyn_PUNO_FULL'[1,1]
scalar FP_dyn_PUNO_FULL = `M_dyn_PUNO_FULL'[1,2]
scalar FN_dyn_PUNO_FULL = `M_dyn_PUNO_FULL'[2,1]
scalar TP_dyn_PUNO_FULL = `M_dyn_PUNO_FULL'[2,2]

scalar CCR_dyn_PUNO_FULL = (TP_dyn_PUNO_FULL + TN_dyn_PUNO_FULL) / ///
                           (TP_dyn_PUNO_FULL + TN_dyn_PUNO_FULL + FP_dyn_PUNO_FULL + FN_dyn_PUNO_FULL)
scalar SEN_dyn_PUNO_FULL = TP_dyn_PUNO_FULL / (TP_dyn_PUNO_FULL + FN_dyn_PUNO_FULL)
scalar SPE_dyn_PUNO_FULL = TN_dyn_PUNO_FULL / (TN_dyn_PUNO_FULL + FP_dyn_PUNO_FULL)

roctab pob_monetaria phat_dyn_PUNO_FULL if e(sample), nograph
scalar AUC_dyn_PUNO_FULL = r(area)

restore


******************************************************
* 1.3 PERÚ – PANEL PURO 2018–2022 (hpan1822==1)
******************************************************
di as text "================ PERU_P1822 2018–2022 ================"

preserve
keep if hpan1822 == 1
xtset idhogar year

* FE
xtlogit pob_monetaria $X_panel, fe
estimates store FE_PERU_P1822

margins, dydx($X_panel)
estimates store MFE_PERU_P1822

capture drop phat_fe_PERU_P1822 yhat_fe_PERU_P1822
quietly predict double phat_fe_PERU_P1822, pu0

gen byte yhat_fe_PERU_P1822 = (phat_fe_PERU_P1822 >= 0.5) if e(sample)

tempname M_fe_PERU_P1822
quietly tab pob_monetaria yhat_fe_PERU_P1822 if e(sample), matcell(`M_fe_PERU_P1822')

scalar TN_fe_PERU_P1822 = `M_fe_PERU_P1822'[1,1]
scalar FP_fe_PERU_P1822 = `M_fe_PERU_P1822'[1,2]
scalar FN_fe_PERU_P1822 = `M_fe_PERU_P1822'[2,1]
scalar TP_fe_PERU_P1822 = `M_fe_PERU_P1822'[2,2]

scalar CCR_fe_PERU_P1822 = (TP_fe_PERU_P1822 + TN_fe_PERU_P1822) / ///
                           (TP_fe_PERU_P1822 + TN_fe_PERU_P1822 + FP_fe_PERU_P1822 + FN_fe_PERU_P1822)
scalar SEN_fe_PERU_P1822 = TP_fe_PERU_P1822 / (TP_fe_PERU_P1822 + FN_fe_PERU_P1822)
scalar SPE_fe_PERU_P1822 = TN_fe_PERU_P1822 / (TN_fe_PERU_P1822 + FP_fe_PERU_P1822)

quietly roctab pob_monetaria phat_fe_PERU_P1822 if e(sample), nograph
scalar AUC_fe_PERU_P1822 = r(area)

* RE
quietly xtlogit pob_monetaria $X_panel, re vce(cluster idhogar) nolog
estimates store RE_PERU_P1822

capture drop phat_re_PERU_P1822 yhat_re_PERU_P1822
quietly predict double phat_re_PERU_P1822

gen byte yhat_re_PERU_P1822 = (phat_re_PERU_P1822 >= 0.5) if e(sample)

tempname M_re_PERU_P1822
quietly tab pob_monetaria yhat_re_PERU_P1822 if e(sample), matcell(`M_re_PERU_P1822')

scalar TN_re_PERU_P1822 = `M_re_PERU_P1822'[1,1]
scalar FP_re_PERU_P1822 = `M_re_PERU_P1822'[1,2]
scalar FN_re_PERU_P1822 = `M_re_PERU_P1822'[2,1]
scalar TP_re_PERU_P1822 = `M_re_PERU_P1822'[2,2]

scalar CCR_re_PERU_P1822 = (TP_re_PERU_P1822 + TN_re_PERU_P1822) / ///
                           (TP_re_PERU_P1822 + TN_re_PERU_P1822 + FP_re_PERU_P1822 + FN_re_PERU_P1822)
scalar SEN_re_PERU_P1822 = TP_re_PERU_P1822 / (TP_re_PERU_P1822 + FN_re_PERU_P1822)
scalar SPE_re_PERU_P1822 = TN_re_PERU_P1822 / (TN_re_PERU_P1822 + FP_re_PERU_P1822)

quietly roctab pob_monetaria phat_re_PERU_P1822 if e(sample), nograph
scalar AUC_re_PERU_P1822 = r(area)

* Dinámico GEE
quietly xtgee pob_monetaria L.pob_monetaria $X_panel, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)
estimates store DYN_PERU_P1822

capture drop phat_dyn_PERU_P1822 yhat_dyn_PERU_P1822
quietly predict double phat_dyn_PERU_P1822, mu

gen byte yhat_dyn_PERU_P1822 = (phat_dyn_PERU_P1822 >= 0.5) if e(sample)

tempname M_dyn_PERU_P1822
quietly tab pob_monetaria yhat_dyn_PERU_P1822 if e(sample), matcell(`M_dyn_PERU_P1822')

scalar TN_dyn_PERU_P1822 = `M_dyn_PERU_P1822'[1,1]
scalar FP_dyn_PERU_P1822 = `M_dyn_PERU_P1822'[1,2]
scalar FN_dyn_PERU_P1822 = `M_dyn_PERU_P1822'[2,1]
scalar TP_dyn_PERU_P1822 = `M_dyn_PERU_P1822'[2,2]

scalar CCR_dyn_PERU_P1822 = (TP_dyn_PERU_P1822 + TN_dyn_PERU_P1822) / ///
                            (TP_dyn_PERU_P1822 + TN_dyn_PERU_P1822 + FP_dyn_PERU_P1822 + FN_dyn_PERU_P1822)
scalar SEN_dyn_PERU_P1822 = TP_dyn_PERU_P1822 / (TP_dyn_PERU_P1822 + FN_dyn_PERU_P1822)
scalar SPE_dyn_PERU_P1822 = TN_dyn_PERU_P1822 / (TN_dyn_PERU_P1822 + FP_dyn_PERU_P1822)

quietly roctab pob_monetaria phat_dyn_PERU_P1822 if e(sample), nograph
scalar AUC_dyn_PERU_P1822 = r(area)

restore


******************************************************
* 1.4 PUNO – PANEL PURO 2018–2022
******************************************************
di as text "================ PUNO_P1822 2018–2022 ================"

preserve
keep if hpan1822 == 1 & $DEPVAR == 21
xtset idhogar year

* FE
quietly xtlogit pob_monetaria $X_panel, fe
estimates store FE_PUNO_P1822

quietly margins, dydx($X_panel)
estimates store MFE_PUNO_P1822

capture drop phat_fe_PUNO_P1822 yhat_fe_PUNO_P1822
quietly predict double phat_fe_PUNO_P1822, pu0

gen byte yhat_fe_PUNO_P1822 = (phat_fe_PUNO_P1822 >= 0.5) if e(sample)

tempname M_fe_PUNO_P1822
quietly tab pob_monetaria yhat_fe_PUNO_P1822 if e(sample), matcell(`M_fe_PUNO_P1822')

scalar TN_fe_PUNO_P1822 = `M_fe_PUNO_P1822'[1,1]
scalar FP_fe_PUNO_P1822 = `M_fe_PUNO_P1822'[1,2]
scalar FN_fe_PUNO_P1822 = `M_fe_PUNO_P1822'[2,1]
scalar TP_fe_PUNO_P1822 = `M_fe_PUNO_P1822'[2,2]

scalar CCR_fe_PUNO_P1822 = (TP_fe_PUNO_P1822 + TN_fe_PUNO_P1822) / ///
                           (TP_fe_PUNO_P1822 + TN_fe_PUNO_P1822 + FP_fe_PUNO_P1822 + FN_fe_PUNO_P1822)
scalar SEN_fe_PUNO_P1822 = TP_fe_PUNO_P1822 / (TP_fe_PUNO_P1822 + FN_fe_PUNO_P1822)
scalar SPE_fe_PUNO_P1822 = TN_fe_PUNO_P1822 / (TN_fe_PUNO_P1822 + FP_fe_PUNO_P1822)

quietly roctab pob_monetaria phat_fe_PUNO_P1822 if e(sample), nograph
scalar AUC_fe_PUNO_P1822 = r(area)

* RE
quietly xtlogit pob_monetaria $X_panel, re vce(cluster idhogar) nolog
estimates store RE_PUNO_P1822

capture drop phat_re_PUNO_P1822 yhat_re_PUNO_P1822
quietly predict double phat_re_PUNO_P1822

gen byte yhat_re_PUNO_P1822 = (phat_re_PUNO_P1822 >= 0.5) if e(sample)

tempname M_re_PUNO_P1822
quietly tab pob_monetaria yhat_re_PUNO_P1822 if e(sample), matcell(`M_re_PUNO_P1822')

scalar TN_re_PUNO_P1822 = `M_re_PUNO_P1822'[1,1]
scalar FP_re_PUNO_P1822 = `M_re_PUNO_P1822'[1,2]
scalar FN_re_PUNO_P1822 = `M_re_PUNO_P1822'[2,1]
scalar TP_re_PUNO_P1822 = `M_re_PUNO_P1822'[2,2]

scalar CCR_re_PUNO_P1822 = (TP_re_PUNO_P1822 + TN_re_PUNO_P1822) / ///
                           (TP_re_PUNO_P1822 + TN_re_PUNO_P1822 + FP_re_PUNO_P1822 + FN_re_PUNO_P1822)
scalar SEN_re_PUNO_P1822 = TP_re_PUNO_P1822 / (TP_re_PUNO_P1822 + FN_re_PUNO_P1822)
scalar SPE_re_PUNO_P1822 = TN_re_PUNO_P1822 / (TN_re_PUNO_P1822 + FP_re_PUNO_P1822)

quietly roctab pob_monetaria phat_re_PUNO_P1822 if e(sample), nograph
scalar AUC_re_PUNO_P1822 = r(area)

* Dinámico GEE
quietly xtgee pob_monetaria L.pob_monetaria $X_panel, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)
estimates store DYN_PUNO_P1822

capture drop phat_dyn_PUNO_P1822 yhat_dyn_PUNO_P1822
quietly predict double phat_dyn_PUNO_P1822, mu

gen byte yhat_dyn_PUNO_P1822 = (phat_dyn_PUNO_P1822 >= 0.5) if e(sample)

tempname M_dyn_PUNO_P1822
quietly tab pob_monetaria yhat_dyn_PUNO_P1822 if e(sample), matcell(`M_dyn_PUNO_P1822')

scalar TN_dyn_PUNO_P1822 = `M_dyn_PUNO_P1822'[1,1]
scalar FP_dyn_PUNO_P1822 = `M_dyn_PUNO_P1822'[1,2]
scalar FN_dyn_PUNO_P1822 = `M_dyn_PUNO_P1822'[2,1]
scalar TP_dyn_PUNO_P1822 = `M_dyn_PUNO_P1822'[2,2]

scalar CCR_dyn_PUNO_P1822 = (TP_dyn_PUNO_P1822 + TN_dyn_PUNO_P1822) / ///
                            (TP_dyn_PUNO_P1822 + TN_dyn_PUNO_P1822 + FP_dyn_PUNO_P1822 + FN_dyn_PUNO_P1822)
scalar SEN_dyn_PUNO_P1822 = TP_dyn_PUNO_P1822 / (TP_dyn_PUNO_P1822 + FN_dyn_PUNO_P1822)
scalar SPE_dyn_PUNO_P1822 = TN_dyn_PUNO_P1822 / (TN_dyn_PUNO_P1822 + FP_dyn_PUNO_P1822)

quietly roctab pob_monetaria phat_dyn_PUNO_P1822 if e(sample), nograph
scalar AUC_dyn_PUNO_P1822 = r(area)

restore


******************************************************
* 1.5 PERÚ – PANEL PURO 2020–2022 (hpan2022==1)
******************************************************
di as text "================ PERU_P2022 2020–2022 ================"

preserve
keep if hpan2022 == 1
xtset idhogar year

* FE
quietly xtlogit pob_monetaria $X_panel, fe
estimates store FE_PERU_P2022

quietly margins, dydx($X_panel)
estimates store MFE_PERU_P2022

capture drop phat_fe_PERU_P2022 yhat_fe_PERU_P2022
quietly predict double phat_fe_PERU_P2022, pu0

gen byte yhat_fe_PERU_P2022 = (phat_fe_PERU_P2022 >= 0.5) if e(sample)

tempname M_fe_PERU_P2022
quietly tab pob_monetaria yhat_fe_PERU_P2022 if e(sample), matcell(`M_fe_PERU_P2022')

scalar TN_fe_PERU_P2022 = `M_fe_PERU_P2022'[1,1]
scalar FP_fe_PERU_P2022 = `M_fe_PERU_P2022'[1,2]
scalar FN_fe_PERU_P2022 = `M_fe_PERU_P2022'[2,1]
scalar TP_fe_PERU_P2022 = `M_fe_PERU_P2022'[2,2]

scalar CCR_fe_PERU_P2022 = (TP_fe_PERU_P2022 + TN_fe_PERU_P2022) / ///
                           (TP_fe_PERU_P2022 + TN_fe_PERU_P2022 + FP_fe_PERU_P2022 + FN_fe_PERU_P2022)
scalar SEN_fe_PERU_P2022 = TP_fe_PERU_P2022 / (TP_fe_PERU_P2022 + FN_fe_PERU_P2022)
scalar SPE_fe_PERU_P2022 = TN_fe_PERU_P2022 / (TN_fe_PERU_P2022 + FP_fe_PERU_P2022)

quietly roctab pob_monetaria phat_fe_PERU_P2022 if e(sample), nograph
scalar AUC_fe_PERU_P2022 = r(area)

* RE
quietly xtlogit pob_monetaria $X_panel, re vce(cluster idhogar) nolog
estimates store RE_PERU_P2022

capture drop phat_re_PERU_P2022 yhat_re_PERU_P2022
quietly predict double phat_re_PERU_P2022

gen byte yhat_re_PERU_P2022 = (phat_re_PERU_P2022 >= 0.5) if e(sample)

tempname M_re_PERU_P2022
quietly tab pob_monetaria yhat_re_PERU_P2022 if e(sample), matcell(`M_re_PERU_P2022')

scalar TN_re_PERU_P2022 = `M_re_PERU_P2022'[1,1]
scalar FP_re_PERU_P2022 = `M_re_PERU_P2022'[1,2]
scalar FN_re_PERU_P2022 = `M_re_PERU_P2022'[2,1]
scalar TP_re_PERU_P2022 = `M_re_PERU_P2022'[2,2]

scalar CCR_re_PERU_P2022 = (TP_re_PERU_P2022 + TN_re_PERU_P2022) / ///
                           (TP_re_PERU_P2022 + TN_re_PERU_P2022 + FP_re_PERU_P2022 + FN_re_PERU_P2022)
scalar SEN_re_PERU_P2022 = TP_re_PERU_P2022 / (TP_re_PERU_P2022 + FN_re_PERU_P2022)
scalar SPE_re_PERU_P2022 = TN_re_PERU_P2022 / (TN_re_PERU_P2022 + FP_re_PERU_P2022)

quietly roctab pob_monetaria phat_re_PERU_P2022 if e(sample), nograph
scalar AUC_re_PERU_P2022 = r(area)

* Dinámico GEE
quietly xtgee pob_monetaria L.pob_monetaria $X_panel, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)
estimates store DYN_PERU_P2022

capture drop phat_dyn_PERU_P2022 yhat_dyn_PERU_P2022
quietly predict double phat_dyn_PERU_P2022, mu

gen byte yhat_dyn_PERU_P2022 = (phat_dyn_PERU_P2022 >= 0.5) if e(sample)

tempname M_dyn_PERU_P2022
quietly tab pob_monetaria yhat_dyn_PERU_P2022 if e(sample), matcell(`M_dyn_PERU_P2022')

scalar TN_dyn_PERU_P2022 = `M_dyn_PERU_P2022'[1,1]
scalar FP_dyn_PERU_P2022 = `M_dyn_PERU_P2022'[1,2]
scalar FN_dyn_PERU_P2022 = `M_dyn_PERU_P2022'[2,1]
scalar TP_dyn_PERU_P2022 = `M_dyn_PERU_P2022'[2,2]

scalar CCR_dyn_PERU_P2022 = (TP_dyn_PERU_P2022 + TN_dyn_PERU_P2022) / ///
                            (TP_dyn_PERU_P2022 + TN_dyn_PERU_P2022 + FP_dyn_PERU_P2022 + FN_dyn_PERU_P2022)
scalar SEN_dyn_PERU_P2022 = TP_dyn_PERU_P2022 / (TP_dyn_PERU_P2022 + FN_dyn_PERU_P2022)
scalar SPE_dyn_PERU_P2022 = TN_dyn_PERU_P2022 / (TN_dyn_PERU_P2022 + FP_dyn_PERU_P2022)

quietly roctab pob_monetaria phat_dyn_PERU_P2022 if e(sample), nograph
scalar AUC_dyn_PERU_P2022 = r(area)

restore


******************************************************
* 1.6 PUNO – PANEL PURO 2020–2022
******************************************************
di as text "================ PUNO_P2022 2020–2022 ================"

preserve
keep if hpan2022 == 1 & $DEPVAR == 21
xtset idhogar year

* FE
quietly xtlogit pob_monetaria $X_panel, fe
estimates store FE_PUNO_P2022

quietly margins, dydx($X_panel)
estimates store MFE_PUNO_P2022

capture drop phat_fe_PUNO_P2022 yhat_fe_PUNO_P2022
quietly predict double phat_fe_PUNO_P2022, pu0

gen byte yhat_fe_PUNO_P2022 = (phat_fe_PUNO_P2022 >= 0.5) if e(sample)

tempname M_fe_PUNO_P2022
quietly tab pob_monetaria yhat_fe_PUNO_P2022 if e(sample), matcell(`M_fe_PUNO_P2022')

scalar TN_fe_PUNO_P2022 = `M_fe_PUNO_P2022'[1,1]
scalar FP_fe_PUNO_P2022 = `M_fe_PUNO_P2022'[1,2]
scalar FN_fe_PUNO_P2022 = `M_fe_PUNO_P2022'[2,1]
scalar TP_fe_PUNO_P2022 = `M_fe_PUNO_P2022'[2,2]

scalar CCR_fe_PUNO_P2022 = (TP_fe_PUNO_P2022 + TN_fe_PUNO_P2022) / ///
                           (TP_fe_PUNO_P2022 + TN_fe_PUNO_P2022 + FP_fe_PUNO_P2022 + FN_fe_PUNO_P2022)
scalar SEN_fe_PUNO_P2022 = TP_fe_PUNO_P2022 / (TP_fe_PUNO_P2022 + FN_fe_PUNO_P2022)
scalar SPE_fe_PUNO_P2022 = TN_fe_PUNO_P2022 / (TN_fe_PUNO_P2022 + FP_fe_PUNO_P2022)

quietly roctab pob_monetaria phat_fe_PUNO_P2022 if e(sample), nograph
scalar AUC_fe_PUNO_P2022 = r(area)

* RE
quietly xtlogit pob_monetaria $X_panel, re vce(cluster idhogar) nolog
estimates store RE_PUNO_P2022

capture drop phat_re_PUNO_P2022 yhat_re_PUNO_P2022
quietly predict double phat_re_PUNO_P2022

gen byte yhat_re_PUNO_P2022 = (phat_re_PUNO_P2022 >= 0.5) if e(sample)

tempname M_re_PUNO_P2022
quietly tab pob_monetaria yhat_re_PUNO_P2022 if e(sample), matcell(`M_re_PUNO_P2022')

scalar TN_re_PUNO_P2022 = `M_re_PUNO_P2022'[1,1]
scalar FP_re_PUNO_P2022 = `M_re_PUNO_P2022'[1,2]
scalar FN_re_PUNO_P2022 = `M_re_PUNO_P2022'[2,1]
scalar TP_re_PUNO_P2022 = `M_re_PUNO_P2022'[2,2]

scalar CCR_re_PUNO_P2022 = (TP_re_PUNO_P2022 + TN_re_PUNO_P2022) / ///
                           (TP_re_PUNO_P2022 + TN_re_PUNO_P2022 + FP_re_PUNO_P2022 + FN_re_PUNO_P2022)
scalar SEN_re_PUNO_P2022 = TP_re_PUNO_P2022 / (TP_re_PUNO_P2022 + FN_re_PUNO_P2022)
scalar SPE_re_PUNO_P2022 = TN_re_PUNO_P2022 / (TN_re_PUNO_P2022 + FP_re_PUNO_P2022)

quietly roctab pob_monetaria phat_re_PUNO_P2022 if e(sample), nograph
scalar AUC_re_PUNO_P2022 = r(area)

* Dinámico GEE
quietly xtgee pob_monetaria L.pob_monetaria $X_panel, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)
estimates store DYN_PUNO_P2022

capture drop phat_dyn_PUNO_P2022 yhat_dyn_PUNO_P2022
quietly predict double phat_dyn_PUNO_P2022, mu

gen byte yhat_dyn_PUNO_P2022 = (phat_dyn_PUNO_P2022 >= 0.5) if e(sample)

tempname M_dyn_PUNO_P2022
quietly tab pob_monetaria yhat_dyn_PUNO_P2022 if e(sample), matcell(`M_dyn_PUNO_P2022')

scalar TN_dyn_PUNO_P2022 = `M_dyn_PUNO_P2022'[1,1]
scalar FP_dyn_PUNO_P2022 = `M_dyn_PUNO_P2022'[1,2]
scalar FN_dyn_PUNO_P2022 = `M_dyn_PUNO_P2022'[2,1]
scalar TP_dyn_PUNO_P2022 = `M_dyn_PUNO_P2022'[2,2]

scalar CCR_dyn_PUNO_P2022 = (TP_dyn_PUNO_P2022 + TN_dyn_PUNO_P2022) / ///
                            (TP_dyn_PUNO_P2022 + TN_dyn_PUNO_P2022 + FP_dyn_PUNO_P2022 + FN_dyn_PUNO_P2022)
scalar SEN_dyn_PUNO_P2022 = TP_dyn_PUNO_P2022 / (TP_dyn_PUNO_P2022 + FN_dyn_PUNO_P2022)
scalar SPE_dyn_PUNO_P2022 = TN_dyn_PUNO_P2022 / (TN_dyn_PUNO_P2022 + FP_dyn_PUNO_P2022)

quietly roctab pob_monetaria phat_dyn_PUNO_P2022 if e(sample), nograph
scalar AUC_dyn_PUNO_P2022 = r(area)

restore


************************************************************
* 2. TABLA COMPARATIVA DE EFECTOS MARGINALES FE (collect)
************************************************************

collect clear

* Incluir Perú y Puno, full y paneles
foreach S in PERU_FULL PERU_P1822 PERU_P2022 PUNO_FULL PUNO_P1822 PUNO_P2022 {
    estimates restore MFE_`S'
    collect get _r_b _r_se, tag(scope[`S'])
}

collect label dim colname "Variable"
collect label dim scope   "Ámbito/panel"
collect label dim result  "Estadístico"

collect label levels scope ///
    PERU_FULL   "Perú 2018–2022 (full)" ///
    PERU_P1822  "Perú panel 2018–2022" ///
    PERU_P2022  "Perú panel 2020–2022" ///
    PUNO_FULL   "Puno 2018–2022 (full)" ///
    PUNO_P1822  "Puno panel 2018–2022" ///
    PUNO_P2022  "Puno panel 2020–2022", modify

collect style cell result[_r_b],  nformat(%9.3f)
collect style cell result[_r_se], nformat(%9.3f)

* Una fila por variable, columnas = ámbitos (solo dy/dx)
collect layout (colname) (result[_r_b]#scope)

collect export "tabla_marginales_FE_logit_panel_PERU_PUNO.docx", ///
    replace as(docx)


************************************************************
* 3. PODER PREDICTIVO – EJEMPLO PUNO_FULL (FE, RE, DYN)
************************************************************

matrix POWER_PUNO_FULL = ///
    ( CCR_fe_PUNO_FULL  , SEN_fe_PUNO_FULL  , SPE_fe_PUNO_FULL  , AUC_fe_PUNO_FULL  \ ///
      CCR_re_PUNO_FULL  , SEN_re_PUNO_FULL  , SPE_re_PUNO_FULL  , AUC_re_PUNO_FULL  \ ///
      CCR_dyn_PUNO_FULL , SEN_dyn_PUNO_FULL , SPE_dyn_PUNO_FULL , AUC_dyn_PUNO_FULL )

matrix rownames POWER_PUNO_FULL = FE RE DYN
matrix colnames POWER_PUNO_FULL = CCR SEN SPE AUC

matrix list POWER_PUNO_FULL

collect clear

* Cargar la matriz POWER_PUNO_FULL a la colección
collect get stat = matrix(POWER_PUNO_FULL), tag(scope[PUNO_FULL])

collect label dim rowname "Modelo"
collect label dim colname "Indicador"

collect layout (rowname) (colname)

collect export "tabla_poder_prediccion_PUNO_FULL.docx", ///
    replace as(docx)

************************************************************
* FIN
************************************************************


*==============================================================*
* 4. MODELOS DINÁMICOS (xtgee) – PERÚ Y PUNO
*    pob_monetaria L.pob_monetaria lwage_ totmieho_ internet_
*==============================================================*

* Asegurarse que el panel está declarado
xtset idhogar year

*--------------------------------------------------------------*
* 4.1 PERÚ – FULL 2018–2022
*--------------------------------------------------------------*
xtgee pob_monetaria L.pob_monetaria lwage_ totmieho_ internet_, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PERU_FULL

*--------------------------------------------------------------*
* 4.2 PERÚ – PANEL PURO 2018–2022 (hpan1822==1)
*--------------------------------------------------------------*
xtgee pob_monetaria L.pob_monetaria lwage_ totmieho_ internet_ ///
    if hpan1822==1, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PERU_P1822

*--------------------------------------------------------------*
* 4.3 PERÚ – PANEL PURO 2020–2022 (hpan2022==1)
*--------------------------------------------------------------*
xtgee pob_monetaria L.pob_monetaria lwage_ totmieho_ internet_ ///
    if hpan2022==1, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PERU_P2022

*--------------------------------------------------------------*
* 4.4 PUNO – FULL 2018–2022 ($DEPVAR==21)
*--------------------------------------------------------------*
xtgee pob_monetaria L.pob_monetaria lwage_ totmieho_ internet_ ///
    if $DEPVAR==21, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PUNO_FULL

*--------------------------------------------------------------*
* 4.5 PUNO – PANEL PURO 2018–2022 (hpan1822==1 & dpto==21)
*--------------------------------------------------------------*
xtgee pob_monetaria L.pob_monetaria lwage_ totmieho_ internet_ ///
    if hpan1822==1 & $DEPVAR==21, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PUNO_P1822

*--------------------------------------------------------------*
* 4.6 PUNO – PANEL PURO 2020–2022 (hpan2022==1 & dpto==21)
*--------------------------------------------------------------*
xtgee pob_monetaria L.pob_monetaria lwage_ totmieho_ internet_ ///
    if hpan2022==1 & $DEPVAR==21, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PUNO_P2022

/*==============================================================*
* 5. TABLA – EFECTOS MARGINALES DEL MODELO DINÁMICO
*==============================================================*

* 5.1. Obtener matrices de ME por ámbito
me_dyn GEE_PERU_FULL
matrix ME_PERU_FULL = r(ME)

me_dyn GEE_PERU_P1822
matrix ME_PERU_P1822 = r(ME)

me_dyn GEE_PERU_P2022
matrix ME_PERU_P2022 = r(ME)

me_dyn GEE_PUNO_FULL
matrix ME_PUNO_FULL = r(ME)

me_dyn GEE_PUNO_P1822
matrix ME_PUNO_P1822 = r(ME)

me_dyn GEE_PUNO_P2022
matrix ME_PUNO_P2022 = r(ME)

* 5.2. Armar la colección
collect clear

collect get dy_dx = matrix(ME_PERU_FULL),   tag(scope[PERU_FULL_D])
collect get dy_dx = matrix(ME_PERU_P1822),  tag(scope[PERU_P1822_D])
collect get dy_dx = matrix(ME_PERU_P2022),  tag(scope[PERU_P2022_D])
collect get dy_dx = matrix(ME_PUNO_FULL),   tag(scope[PUNO_FULL_D])
collect get dy_dx = matrix(ME_PUNO_P1822),  tag(scope[PUNO_P1822_D])
collect get dy_dx = matrix(ME_PUNO_P2022),  tag(scope[PUNO_P2022_D])

* 5.3. Etiquetas y formato
collect label levels scope ///
    PERU_FULL_D    "Perú 2018–2022 (dinámico)" ///
    PERU_P1822_D   "Perú panel 2018–2022 (dinámico)" ///
    PERU_P2022_D   "Perú panel 2020–2022 (dinámico)" ///
    PUNO_FULL_D    "Puno 2018–2022 (dinámico)" ///
    PUNO_P1822_D   "Puno panel 2018–2022 (dinámico)" ///
    PUNO_P2022_D   "Puno panel 2020–2022 (dinámico)", modify

collect label dim rowname "Variable"
collect label dim scope   "Ámbito"
collect label dim result  "Estadístico"

collect style cell, nformat(%9.3f)

* 5.4. Diseño de tabla: filas = variables; columnas = ámbitos
collect layout (rowname) (scope#result[dy_dx])

* 5.5. Nota y exportación
collect notes add ///
"Nota. Modelo logit dinámico (xtgee) con L.pob_monetaria. Se reportan los efectos marginales promedio (dy/dx) de lwage_, totmieho_ e internet_ calculados como β·p·(1–p)."

collect export "tabla_efectos_marginales_dinamico_peru_puno.docx", ///
    replace as(docx)
*/
*****************
*1. Programa para efectos marginales – modelo estático FE

*==============================================================*
* PROGRAMA: me_static
* Calcula efectos marginales promedio (logit FE estático) para:
*   lwage_, totmieho_, internet_
* tras un xtlogit, fe ya estimado.
*==============================================================*
program define me_static, rclass
    syntax name(name=estname)

    estimates restore `estname'

    quietly margins, dydx(lwage_ totmieho_ internet_) post

    * r(b) es 1xK -> lo pasamos a 3x1
    matrix ME = r(b)'
    matrix rownames ME = lwage_ totmieho_ internet_

    return matrix ME = ME
end

*2. (Ya lo tienes) Programa dinámico – recordatorio
*==============================================================*
* PROGRAMA: me_dyn
* Efectos marginales promedio (logit dinámico xtgee):
*   lwage_, totmieho_, internet_
* ME_k = promedio( beta_k * p_i * (1 - p_i) )
*==============================================================*
program define me_dyn, rclass
    syntax name(name=estname)

    estimates restore `estname'

    * Predicción de probabilidad (mu) – sin opción, por defecto en xtgee
    predict double phat if e(sample)

    gen double me_lwage    = _b[lwage_]*phat*(1-phat)    if e(sample)
    gen double me_totm     = _b[totmieho_]*phat*(1-phat) if e(sample)
    gen double me_internet = _b[internet_]*phat*(1-phat) if e(sample)

    quietly summarize me_lwage, meanonly
    scalar mlw = r(mean)

    quietly summarize me_totm, meanonly
    scalar mtot = r(mean)

    quietly summarize me_internet, meanonly
    scalar mint = r(mean)

    matrix ME = (mlw \ mtot \ mint)
    matrix rownames ME = lwage_ totmieho_ internet_

    return matrix ME = ME

    drop phat me_lwage me_totm me_internet
end

*3. Construir matrices de efectos marginales (estático y dinámico)
*==============================================================*
* 6. EFECTOS MARGINALES: ESTÁTICO (FE) vs DINÁMICO (GEE)
*==============================================================*

*------------- PERÚ 2018–2022 (full) -------------*
me_static MFE_PERU_FULL
matrix ME_S_PERU_FULL = r(ME)

me_dyn GEE_PERU_FULL
matrix ME_D_PERU_FULL = r(ME)

*------------- PERÚ panel puro 2018–2022 ---------*
me_static MFE_PERU_P1822
matrix ME_S_PERU_P1822 = r(ME)

me_dyn GEE_PERU_P1822
matrix ME_D_PERU_P1822 = r(ME)

*------------- PERÚ panel puro 2020–2022 ---------*
me_static MFE_PERU_P2022
matrix ME_S_PERU_P2022 = r(ME)

me_dyn GEE_PERU_P2022
matrix ME_D_PERU_P2022 = r(ME)

*------------- PUNO 2018–2022 (full) -------------*
me_static MFE_PUNO_FULL
matrix ME_S_PUNO_FULL = r(ME)

me_dyn GEE_PUNO_FULL
matrix ME_D_PUNO_FULL = r(ME)

*------------- PUNO panel puro 2018–2022 ---------*
me_static MFE_PUNO_P1822
matrix ME_S_PUNO_P1822 = r(ME)

me_dyn GEE_PUNO_P1822
matrix ME_D_PUNO_P1822 = r(ME)

*------------- PUNO panel puro 2020–2022 ---------*
me_static MFE_PUNO_P2022
matrix ME_S_PUNO_P2022 = r(ME)

me_dyn GEE_PUNO_P2022
matrix ME_D_PUNO_P2022 = r(ME)

**4. Tabla combinada con collect: estático vs dinámico
*****Ahora armamos una sola tabla con filas = variables, columnas = (ámbito × tipo de modelo):
*==============================================================*
* 7. TABLA COMBINADA – ESTÁTICO (FE) vs DINÁMICO (GEE)
*==============================================================*

collect clear

* Perú full
collect get dy_dx = matrix(ME_S_PERU_FULL), tag(scope[PERU_FULL]   model[FE (estático)])
collect get dy_dx = matrix(ME_D_PERU_FULL), tag(scope[PERU_FULL]   model[GEE (dinámico)])

* Perú panel 2018–2022
collect get dy_dx = matrix(ME_S_PERU_P1822), tag(scope[PERU_P1822] model[FE (estático)])
collect get dy_dx = matrix(ME_D_PERU_P1822), tag(scope[PERU_P1822] model[GEE (dinámico)])

* Perú panel 2020–2022
collect get dy_dx = matrix(ME_S_PERU_P2022), tag(scope[PERU_P2022] model[FE (estático)])
collect get dy_dx = matrix(ME_D_PERU_P2022), tag(scope[PERU_P2022] model[GEE (dinámico)])

* Puno full
collect get dy_dx = matrix(ME_S_PUNO_FULL), tag(scope[PUNO_FULL]   model[FE (estático)])
collect get dy_dx = matrix(ME_D_PUNO_FULL), tag(scope[PUNO_FULL]   model[GEE (dinámico)])

* Puno panel 2018–2022
collect get dy_dx = matrix(ME_S_PUNO_P1822), tag(scope[PUNO_P1822] model[FE (estático)])
collect get dy_dx = matrix(ME_D_PUNO_P1822), tag(scope[PUNO_P1822] model[GEE (dinámico)])

* Puno panel 2020–2022
collect get dy_dx = matrix(ME_S_PUNO_P2022), tag(scope[PUNO_P2022] model[FE (estático)])
collect get dy_dx = matrix(ME_D_PUNO_P2022), tag(scope[PUNO_P2022] model[GEE (dinámico)])

* Etiquetas legibles
collect label levels scope ///
    PERU_FULL   "Perú 2018–2022" ///
    PERU_P1822  "Perú panel 2018–2022" ///
    PERU_P2022  "Perú panel 2020–2022" ///
    PUNO_FULL   "Puno 2018–2022" ///
    PUNO_P1822  "Puno panel 2018–2022" ///
    PUNO_P2022  "Puno panel 2020–2022", modify

collect label dim rowname "Variable"
collect label dim scope   "Ámbito"
collect label dim model   "Modelo"
collect label dim result  "Estadístico"

* Formato numérico
collect style cell, nformat(%9.3f)

* Diseño: filas = variables; columnas = (ámbito × modelo)
collect layout (rowname) (scope#model#result[dy_dx])

* Nota para el documento
collect notes add ///
"Nota. Se reportan efectos marginales promedio (dy/dx) de lwage_, totmieho_ e internet_. Modelos FE estáticos estimados con xtlogit, fe; modelos dinámicos poblacionales estimados con xtgee (binomial-logit) con L.pob_monetaria."

* Exportar a Word
collect export "tabla_ME_estatico_vs_dinamico_peru_puno.docx", ///
    replace as(docx)
