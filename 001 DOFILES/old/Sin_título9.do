************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – estático (FE/RE) y tabla de efectos marginales
* Versión: limpia, sin me_static / me_dyn
************************************************************

clear all
set more off

*-----------------------------------------------------------*
* 0. CARGA DE BASE Y CONFIGURACIÓN GENERAL
*-----------------------------------------------------------*

use "$dclea/pobreza_panel_18-22_full.dta", clear
* DATA POBREZA - ENAHO Panel 2018–2022 (wide, 18–22)

* Variable dependiente
capture confirm variable pob_monetaria
if _rc {
    capture rename pobre2_ pob_monetaria
}
label define lbl_pobmon 0 "No pobre" 1 "Pobre", replace
label values pob_monetaria lbl_pobmon

* Identificar variable de departamento
capture confirm variable dpto_
if _rc==0 {
    global DEPVAR dpto_
}
else {
    capture confirm variable depto
    if _rc==0 global DEPVAR depto
}

* Declarar estructura de panel
xtset idhogar year

* Macro con regresores (modelo final)
* (Ya no usamos analfa_)
global Xcore lwage_ totmieho_ internet_

************************************************************
* 1. MODELOS ESTÁTICOS (FE / RE) PARA PERÚ Y PUNO
************************************************************

***************
* 1.1 PERÚ – FULL 2018–2022 (toda la data)
***************

* Asegurar panel
xtset idhogar year

* RE – Perú full
xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
estimates store MRE_PERU_FULL

* FE – Perú full
xtlogit pob_monetaria $Xcore, fe
estimates store MFE_PERU_FULL

* Efectos marginales FE – Perú full
margins, dydx($Xcore) post
estimates store MARG_FE_PERU_FULL


***************
* 1.2 PERÚ – PANEL PURO 2018–2022 (hpan1822==1)
***************
preserve
    keep if hpan1822 == 1
    xtset idhogar year

    * RE – Perú panel 18–22
    xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
    estimates store MRE_PERU_P1822

    * FE – Perú panel 18–22
    xtlogit pob_monetaria $Xcore, fe
    estimates store MFE_PERU_P1822

    * Efectos marginales FE – Perú panel 18–22
    margins, dydx($Xcore) post
    estimates store MARG_FE_PERU_P1822
restore


***************
* 1.3 PERÚ – PANEL PURO 2020–2022 (hpan2022==1)
***************
preserve
    keep if hpan2022 == 1
    xtset idhogar year

    * RE – Perú panel 20–22
    xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
    estimates store MRE_PERU_P2022

    * FE – Perú panel 20–22
    xtlogit pob_monetaria $Xcore, fe
    estimates store MFE_PERU_P2022

    * Efectos marginales FE – Perú panel 20–22
    margins, dydx($Xcore) post
    estimates store MARG_FE_PERU_P2022
restore


***************
* 1.4 PUNO – FULL 2018–2022 ($DEPVAR==21)
***************
preserve
    keep if $DEPVAR == 21
    xtset idhogar year

    * RE – Puno full
    xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
    estimates store MRE_PUNO_FULL

    * FE – Puno full
    xtlogit pob_monetaria $Xcore, fe
    estimates store MFE_PUNO_FULL

    * Efectos marginales FE – Puno full
    margins, dydx($Xcore) post
    estimates store MARG_FE_PUNO_FULL
restore


***************
* 1.5 PUNO – PANEL PURO 2018–2022 (hpan1822==1 & dpto==21)
***************
preserve
    keep if hpan1822 == 1 & $DEPVAR == 21
    xtset idhogar year

    * RE – Puno panel 18–22
    xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
    estimates store MRE_PUNO_P1822

    * FE – Puno panel 18–22
    xtlogit pob_monetaria $Xcore, fe
    estimates store MFE_PUNO_P1822

    * Efectos marginales FE – Puno panel 18–22
    margins, dydx($Xcore) post
    estimates store MARG_FE_PUNO_P1822
restore


***************
* 1.6 PUNO – PANEL PURO 2020–2022 (hpan2022==1 & dpto==21)
***************
preserve
    keep if hpan2022 == 1 & $DEPVAR == 21
    xtset idhogar year

    * RE – Puno panel 20–22
    xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog
    estimates store MRE_PUNO_P2022

    * FE – Puno panel 20–22
    xtlogit pob_monetaria $Xcore, fe
    estimates store MFE_PUNO_P2022

    * Efectos marginales FE – Puno panel 20–22
    margins, dydx($Xcore) post
    estimates store MARG_FE_PUNO_P2022
restore


************************************************************
* 2. TABLA COMPARATIVA DE EFECTOS MARGINALES FE – collect
************************************************************

collect clear

* Recuperar cada conjunto de margins FE y añadirlo a la colección
estimates restore MARG_FE_PERU_FULL
collect get _r_b, tag(scope[PERU_FULL])

estimates restore MARG_FE_PERU_P1822
collect get _r_b, tag(scope[PERU_P1822])

estimates restore MARG_FE_PERU_P2022
collect get _r_b, tag(scope[PERU_P2022])

estimates restore MARG_FE_PUNO_FULL
collect get _r_b, tag(scope[PUNO_FULL])

estimates restore MARG_FE_PUNO_P1822
collect get _r_b, tag(scope[PUNO_P1822])

estimates restore MARG_FE_PUNO_P2022
collect get _r_b, tag(scope[PUNO_P2022])

* Etiquetas
collect label levels scope ///
    PERU_FULL     "Perú 2018–2022 (full)" ///
    PERU_P1822    "Perú panel 2018–2022" ///
    PERU_P2022    "Perú panel 2020–2022" ///
    PUNO_FULL     "Puno 2018–2022 (full)" ///
    PUNO_P1822    "Puno panel 2018–2022" ///
    PUNO_P2022    "Puno panel 2020–2022", modify

collect label dim colname "Variable"
collect label dim scope   "Ámbito"
collect label dim result  "Estadístico"

collect style cell result[_r_b], nformat(%9.3f)

* Una fila por variable, columnas = ámbitos (solo dy/dx)
collect layout (colname) (result[_r_b]#scope)

* Exportar a Word
collect export "tabla_mfx_logit_fe_peru_puno.docx", ///
    replace as(docx)


************************************************************
* 3. PODER DE PREDICCIÓN – PUNO (FE, RE y GEE dinámico)
************************************************************

*----------------------------------------------------------*
* 3.1 RE Puno full – xtlogit (estático)
*----------------------------------------------------------*
preserve
    keep if $DEPVAR == 21
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog

    * Probabilidades predichas (RE)
   * drop _all_phat_re_pu
    capture drop phat_re_pu yhat_re_pu
    predict phat_re_pu                     // por defecto: prob. Pr(y=1)

    * AUC con roctab
   quietly roctab pob_monetaria phat_re_pu, detail
    scalar AUC_RE_PU_FULL = r(area)

    * Clasificación con cutoff 0.5
    gen byte yhat_re_pu = phat_re_pu >= 0.5
    tab pob_monetaria yhat_re_pu, matcell(MRE)

    scalar TP_RE = MRE[2,2]
    scalar FP_RE = MRE[1,2]
    scalar FN_RE = MRE[2,1]
    scalar TN_RE = MRE[1,1]

    scalar SENS_RE_PU_FULL = TP_RE / (TP_RE + FN_RE)
    scalar SPEC_RE_PU_FULL = TN_RE / (TN_RE + FP_RE)

    matrix POWER_RE_PU_FULL = ///
        (AUC_RE_PU_FULL, SENS_RE_PU_FULL, SPEC_RE_PU_FULL)
restore


*----------------------------------------------------------*
* 3.2 FE Puno full – xtlogit (estático)
*----------------------------------------------------------*
preserve
    keep if $DEPVAR == 21
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, fe

    * Probabilidades predichas con efecto fijo = 0
    capture drop phat_fe_pu yhat_fe_pu
    predict phat_fe_pu, pu0

    * AUC
    roctab pob_monetaria phat_fe_pu, detail
    scalar AUC_FE_PU_FULL = r(area)

    * Clasificación cutoff 0.5
    gen byte yhat_fe_pu = phat_fe_pu >= 0.5
    tab pob_monetaria yhat_fe_pu, matcell(MFE)

    scalar TP_FE = MFE[2,2]
    scalar FP_FE = MFE[1,2]
    scalar FN_FE = MFE[2,1]
    scalar TN_FE = MFE[1,1]

    scalar SENS_FE_PU_FULL = TP_FE / (TP_FE + FN_FE)
    scalar SPEC_FE_PU_FULL = TN_FE / (TN_FE + FP_FE)

    matrix POWER_FE_PU_FULL = ///
        (AUC_FE_PU_FULL, SENS_FE_PU_FULL, SPEC_FE_PU_FULL)
restore


*----------------------------------------------------------*
* 3.3 GEE dinámico Puno full – xtgee
*----------------------------------------------------------*
preserve
    keep if $DEPVAR == 21
    xtset idhogar year

    quietly xtgee pob_monetaria L.pob_monetaria $Xcore, ///
        family(binomial) link(logit) ///
        corr(exchangeable) vce(robust)

    * Probabilidades predichas (GEE)
    capture drop phat_gee_pu yhat_gee_pu
    predict phat_gee_pu, mu

    * AUC
    quietly roctab pob_monetaria phat_gee_pu, detail
    scalar AUC_GEE_PU_FULL = r(area)

    * Clasificación cutoff 0.5
    gen byte yhat_gee_pu = phat_gee_pu >= 0.5
    tab pob_monetaria yhat_gee_pu, matcell(MGEE)

    scalar TP_GEE = MGEE[2,2]
    scalar FP_GEE = MGEE[1,2]
    scalar FN_GEE = MGEE[2,1]
    scalar TN_GEE = MGEE[1,1]

    scalar SENS_GEE_PU_FULL = TP_GEE / (TP_GEE + FN_GEE)
    scalar SPEC_GEE_PU_FULL = TN_GEE / (TN_GEE + FP_GEE)

    matrix POWER_GEE_PU_FULL = ///
        (AUC_GEE_PU_FULL, SENS_GEE_PU_FULL, SPEC_GEE_PU_FULL)
restore


*----------------------------------------------------------*
* 3.4 Tabla comparativa del poder predictivo – Puno
*----------------------------------------------------------*

matrix POWER_PUNO =  ///
    (POWER_RE_PU_FULL \ ///
     POWER_FE_PU_FULL \ ///
     POWER_GEE_PU_FULL)

matrix rownames POWER_PUNO = RE_FE_static_FE_static_DYN_GEE
matrix colnames POWER_PUNO = AUC Sensibilidad Especificidad

matrix list POWER_PUNO



************************************************************
* 4. NOTA SOBRE MODELOS DINÁMICOS (GEE)
************************************************************
* Para panel dinámico (pob_monetaria rezagada) la idea es:
*
*   xtgee pob_monetaria L.pob_monetaria $Xcore, ///
*       family(binomial) link(logit) ///
*       corr(exchangeable) vce(robust)
*
*   predict phat_dyn, mu
*   lroc phat_dyn pob_monetaria, nograph
*   estat classification
*
* Podemos replicar ese esquema para:
*   - PERU_FULL, PERU_P1822, PERU_P2022
*   - PUNO_FULL, PUNO_P1822, PUNO_P2022
*
* y luego armar otra tabla collect comparando dy/dx o coeficientes
* estáticos (FE) vs dinámicos (GEE).
************************************************************
