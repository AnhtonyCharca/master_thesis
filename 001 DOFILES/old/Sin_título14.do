************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – Panel estático (FE/RE) y dinámico (GEE)
* Efectos marginales y poder de predicción
* Autor: [Tu nombre]
* Fecha: [actualiza]
************************************************************

clear all
set more off

*-----------------------------------------------------------*
* 0. CARGA DE BASE Y CONFIGURACIÓN GENERAL
*-----------------------------------------------------------*

* Ajusta la ruta según tu estructura
use "$dclea/pobreza_panel_18-22_full.dta", clear

* Variable dependiente
capture confirm variable pob_monetaria
if _rc {
    capture rename pobre2_ pob_monetaria
}

label define lbl_pobmon 0 "No pobre" 1 "Pobre", replace
label values pob_monetaria lbl_pobmon

* Identificar variable de departamento (dpto_ o depto)
capture confirm variable dpto_
if _rc==0 {
    global DEPVAR dpto_
}
else {
    capture confirm variable depto
    if _rc==0 global DEPVAR depto
}

* Estructura de panel
xtset idhogar year

* Regresores FINALES (comunes para Perú y Puno)
global Xcore lwage_ totmieho_ internet_


************************************************************
* 1. MODELOS ESTÁTICOS (FE y RE) – PERÚ Y PUNO
*    Full 2018–2022, panel 2018–2022 y panel 2020–2022
************************************************************

*-----------------------------------------------------------*
* 1.1 PERÚ – FULL 2018–2022 (toda la data)
*-----------------------------------------------------------*

preserve
xtset idhogar year

* RE Perú full
xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
estimates store MRE_PERU_FULL
* Efectos marginales FE Perú full
margins, dydx(lwage_ totmieho_ internet_) post
estimates store MARG_RE_PERU_FULL

* FE Perú full
xtlogit pob_monetaria $Xcore, fe
estimates store MFE_PERU_FULL

* Efectos marginales FE Perú full
margins, dydx(lwage_ totmieho_ internet_) post
estimates store MARG_FE_PERU_FULL

restore

*-----------------------------------------------------------*
* 1.2 PERÚ – PANEL PURO 2018–2022 (hpan1822==1)
*-----------------------------------------------------------*

preserve
keep if hpan1822 == 1
xtset idhogar year

* RE Perú panel 18–22
xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
estimates store MRE_PERU_P1822

* FE Perú panel 18–22
xtlogit pob_monetaria $Xcore, fe
estimates store MFE_PERU_P1822

* Efectos marginales FE Perú panel 18–22
margins, dydx(lwage_ totmieho_ internet_) post
estimates store MARG_FE_PERU_P1822

restore

*-----------------------------------------------------------*
* 1.3 PERÚ – PANEL PURO 2020–2022 (hpan2022==1)
*-----------------------------------------------------------*

preserve
keep if hpan2022 == 1
xtset idhogar year

* RE Perú panel 20–22
xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
estimates store MRE_PERU_P2022

* FE Perú panel 20–22
xtlogit pob_monetaria $Xcore, fe
estimates store MFE_PERU_P2022

* Efectos marginales FE Perú panel 20–22
margins, dydx(lwage_ totmieho_ internet_) post
estimates store MARG_FE_PERU_P2022

restore

*-----------------------------------------------------------*
* 1.4 PUNO – FULL 2018–2022 (dpto==21)
*-----------------------------------------------------------*

preserve
keep if $DEPVAR == 21
xtset idhogar year

* RE Puno full
xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
estimates store MRE_PUNO_FULL

* FE Puno full
xtlogit pob_monetaria $Xcore, fe
estimates store MFE_PUNO_FULL

* Efectos marginales FE Puno full
margins, dydx(lwage_ totmieho_ internet_) post
estimates store MARG_FE_PUNO_FULL

restore

*-----------------------------------------------------------*
* 1.5 PUNO – PANEL PURO 2018–2022 (hpan1822==1 & dpto==21)
*-----------------------------------------------------------*

preserve
keep if hpan1822 == 1 & $DEPVAR == 21
xtset idhogar year

* RE Puno panel 18–22
xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
estimates store MRE_PUNO_P1822

* FE Puno panel 18–22
xtlogit pob_monetaria $Xcore, fe
estimates store MFE_PUNO_P1822

* Efectos marginales FE Puno panel 18–22
margins, dydx(lwage_ totmieho_ internet_) post
estimates store MARG_FE_PUNO_P1822

restore

*-----------------------------------------------------------*
* 1.6 PUNO – PANEL PURO 2020–2022 (hpan2022==1 & dpto==21)
*-----------------------------------------------------------*

preserve
keep if hpan2022 == 1 & $DEPVAR == 21
xtset idhogar year

* RE Puno panel 20–22
xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
estimates store MRE_PUNO_P2022

* FE Puno panel 20–22
xtlogit pob_monetaria $Xcore, fe
estimates store MFE_PUNO_P2022

* Efectos marginales FE Puno panel 20–22
margins, dydx(lwage_ totmieho_ internet_) post
estimates store MARG_FE_PUNO_P2022

restore


************************************************************
* 2. MODELOS DINÁMICOS (GEE LOGIT CON L.pob_monetaria)
*    PERÚ Y PUNO – MISMAS ESTRUCTURAS DE PANEL
************************************************************

* Nota: GEE es población-promedio (no FE/RE), pero captura persistencia
* vía L.pob_monetaria.

*-----------------------------------------------------------*
* 2.1 PERÚ – FULL 2018–2022
*-----------------------------------------------------------*

preserve
xtset idhogar year

xtgee pob_monetaria L.pob_monetaria $Xcore, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PERU_FULL

* Probabilidades predichas dinámicas
predict phat_dyn_pe_full, mu

restore

*-----------------------------------------------------------*
* 2.2 PERÚ – PANEL PURO 2018–2022
*-----------------------------------------------------------*

preserve
keep if hpan1822 == 1
xtset idhogar year

xtgee pob_monetaria L.pob_monetaria $Xcore, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PERU_P1822
predict phat_dyn_pe_p1822, mu

restore

*-----------------------------------------------------------*
* 2.3 PERÚ – PANEL PURO 2020–2022
*-----------------------------------------------------------*

preserve
keep if hpan2022 == 1
xtset idhogar year

xtgee pob_monetaria L.pob_monetaria $Xcore, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PERU_P2022
predict phat_dyn_pe_p2022, mu

restore

*-----------------------------------------------------------*
* 2.4 PUNO – FULL 2018–2022
*-----------------------------------------------------------*

preserve
keep if $DEPVAR == 21
xtset idhogar year

xtgee pob_monetaria L.pob_monetaria $Xcore, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PUNO_FULL
predict phat_dyn_pu_full, mu

restore

*-----------------------------------------------------------*
* 2.5 PUNO – PANEL PURO 2018–2022
*-----------------------------------------------------------*

preserve
keep if hpan1822 == 1 & $DEPVAR == 21
xtset idhogar year

xtgee pob_monetaria L.pob_monetaria $Xcore, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PUNO_P1822
predict phat_dyn_pu_p1822, mu

restore

*-----------------------------------------------------------*
* 2.6 PUNO – PANEL PURO 2020–2022
*-----------------------------------------------------------*

preserve
keep if hpan2022 == 1 & $DEPVAR == 21
xtset idhogar year

xtgee pob_monetaria L.pob_monetaria $Xcore, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_PUNO_P2022
predict phat_dyn_pu_p2022, mu

restore