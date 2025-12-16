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


****1. PERÚ – FULL 2018–2022 (panel desbalanceado)

*Filtro: if inrange(year,2018,2022)

*1.1. Modelo estático RE
* LOGIT RE – Perú 2018–2022 (full)
xtlogit pob_monetaria $Xcore , re vce(cluster idhogar)

* Guardar
estimates store RE_PERU_FULL

* Efectos marginales (variables X)
margins, dydx($Xcore) post
estimates store ME_RE_PERU_FULL

* Poder de predicción
estimates restore RE_PERU_FULL
lroc
estat classification

*1.2. Modelo estático FE
* LOGIT FE – Perú 2018–2022 (full)
xtlogit pob_monetaria $Xcore, fe

estimates store FE_PERU_FULL

margins, dydx($Xcore) post
estimates store ME_FE_PERU_FULL

lroc, nograph
estat classification

*1.3. Modelo dinámico RE (con rezago de pobreza)
*Usar solo años donde el rezago está definido (desde 2019):

* LOGIT RE DINÁMICO – Perú 2019–2022
xtlogit pob_monetaria L.pob_monetaria $Xcore ///
   , re vce(cluster idhogar) nolog

estimates store DYN_RE_PERU_FULL

* Efectos marginales solo para X (no pedir dy/dx del rezago)
margins, dydx($Xcore) post
estimates store ME_DYN_RE_PERU_FULL

* Interpreta el rezago con odds ratio:
display "OR(L.pob_monetaria) = " %6.3f exp(_b[L.pob_monetaria])

lroc, nograph
estat classification

**2. PERÚ – PANEL PURO 2018–2022 (hpan1822==1)

*Filtro: if hpan1822==1 & inrange(year,2018,2022)

***2.1. Estático RE
xtlogit pob_monetaria $Xcore ///
    if hpan1822==1 , re vce(cluster idhogar)

estimates store RE_PERU_P1822

margins, dydx($Xcore) post
estimates store ME_RE_PERU_P1822

lroc, nograph
estat classification

***2.2. Estático FE
xtlogit pob_monetaria $Xcore ///
    if hpan1822==1 , fe

estimates store FE_PERU_P1822

margins, dydx($Xcore) post
estimates store ME_FE_PERU_P1822

lroc, nograph
estat classification

***2.3. Dinámico RE
xtlogit pob_monetaria L.pob_monetaria $Xcore ///
    if hpan1822==1 ), re vce(cluster idhogar) nolog

estimates store DYN_RE_PERU_P1822

margins, dydx($Xcore) post
estimates store ME_DYN_RE_PERU_P1822

display "OR(L.pob_monetaria) = " %6.3f exp(_b[L.pob_monetaria])

lroc, nograph
estat classification

*******************************************************
*********3. PERÚ – PANEL PURO 2020–2022 (hpan2022==1)**
*******************************************************
*Filtro: if hpan2022==1 & inrange(year,2020,2022)

*3.1. Estático RE
xtlogit pob_monetaria $Xcore ///
    if hpan2022==1 , re vce(cluster idhogar)

estimates store RE_PERU_P2022

margins, dydx($Xcore) post
estimates store ME_RE_PERU_P2022

lroc, nograph
estat classification

*3.2. Estático FE
xtlogit pob_monetaria $Xcore ///
    if hpan2022==1 , fe

estimates store FE_PERU_P2022

margins, dydx($Xcore) post
estimates store ME_FE_PERU_P2022

lroc, nograph
estat classification

*3.3. Dinámico RE

*Aquí solo hay rezago para 2021–2022:

xtlogit pob_monetaria L.pob_monetaria $Xcore ///
    if hpan2022==1 , re vce(cluster idhogar) nolog

estimates store DYN_RE_PERU_P2022

margins, dydx($Xcore) post
estimates store ME_DYN_RE_PERU_P2022

display "OR(L.pob_monetaria) = " %6.3f exp(_b[L.pob_monetaria])

lroc, nograph
estat classification

******************************
***4. PUNO – FULL 2018–2022***
******************************

*Filtro: if $DEPVAR==21 & inrange(year,2018,2022)
*(o if dpto==21 & inrange(year,2018,2022) según tu variable)

*4.1. Estático RE
xtlogit pob_monetaria $Xcore ///
    if $DEPVAR==21 , re vce(cluster idhogar)

estimates store RE_PUNO_FULL

margins, dydx($Xcore) post
estimates store ME_RE_PUNO_FULL

lroc, nograph
estat classification

*4.2. Estático FE
xtlogit pob_monetaria $Xcore ///
    if $DEPVAR==21 , fe

estimates store FE_PUNO_FULL

margins, dydx($Xcore) post
estimates store ME_FE_PUNO_FULL

lroc, nograph
estat classification

*4.3. Dinámico RE
xtlogit pob_monetaria L.pob_monetaria $Xcore ///
    if $DEPVAR==21 , re vce(cluster idhogar) nolog

estimates store DYN_RE_PUNO_FULL

margins, dydx($Xcore) post
estimates store ME_DYN_RE_PUNO_FULL

display "OR(L.pob_monetaria) = " %6.3f exp(_b[L.pob_monetaria])

lroc, nograph
estat classification

***********************
**5. PUNO – PANEL PURO 2018–2022 (hpan1822==1 & dpto==21)
***********************
*Filtro: if hpan1822==1 & $DEPVAR==21 & inrange(year,2018,2022)

*5.1. Estático RE
xtlogit pob_monetaria $Xcore ///
    if hpan1822==1 & $DEPVAR==21 , re vce(cluster idhogar)

estimates store RE_PUNO_P1822

margins, dydx($Xcore) post
estimates store ME_RE_PUNO_P1822

lroc, nograph
estat classification

*5.2. Estático FE
xtlogit pob_monetaria $Xcore ///
    if hpan1822==1 & $DEPVAR==21 , fe

estimates store FE_PUNO_P1822

margins, dydx($Xcore) post
estimates store ME_FE_PUNO_P1822

lroc, nograph
estat classification

*5.3. Dinámico RE
xtlogit pob_monetaria L.pob_monetaria $Xcore ///
    if hpan1822==1 & $DEPVAR==21 , re vce(cluster idhogar) nolog

estimates store DYN_RE_PUNO_P1822

margins, dydx($Xcore) post
estimates store ME_DYN_RE_PUNO_P1822

display "OR(L.pob_monetaria) = " %6.3f exp(_b[L.pob_monetaria])

lroc, nograph
estat classification
***********
****6. PUNO – PANEL PURO 2020–2022 (hpan2022==1 & dpto==21)
*
*Filtro: if hpan2022==1 & $DEPVAR==21 & inrange(year,2020,2022)

*6.1. Estático RE
xtlogit pob_monetaria $Xcore ///
    if hpan2022==1 & $DEPVAR==21 , re vce(cluster idhogar)

estimates store RE_PUNO_P2022

margins, dydx($Xcore) post
estimates store ME_RE_PUNO_P2022

lroc, nograph
estat classification

*6.2. Estático FE
xtlogit pob_monetaria $Xcore ///
    if hpan2022==1 & $DEPVAR==21, fe

estimates store FE_PUNO_P2022

margins, dydx($Xcore) post
estimates store ME_FE_PUNO_P2022

lroc, nograph
estat classification

*6.3. Dinámico RE
xtlogit pob_monetaria L.pob_monetaria $Xcore ///
    if hpan2022==1 & $DEPVAR==21 , re vce(cluster idhogar) nolog

estimates store DYN_RE_PUNO_P2022

margins, dydx($Xcore) post
estimates store ME_DYN_RE_PUNO_P2022

display "OR(L.pob_monetaria) = " %6.3f exp(_b[L.pob_monetaria])

lroc, nograph
estat classification
