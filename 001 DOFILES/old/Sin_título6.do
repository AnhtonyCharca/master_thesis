global X_panel lwage_ totmieho_ internet_

************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – Full (2018–2022) y paneles puros
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

* Asegurar variable dependiente
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

* Especificación final de regresores
* lwage_    = log(ingreso)
* totmieho_ = tamaño del hogar
* internet_ = dummy acceso internet
global X_panel lwage_ totmieho_ internet_

************************************************************
* 1. PROGRAMAS AUXILIARES
************************************************************

*-----------------------------------------------------------*
* 1.1 Programa: modelos estáticos FE/RE + poder de predicción
*-----------------------------------------------------------*
capture program drop run_static
program define run_static, rclass
    version 18
    args scope
    local S "`scope'"

    di as text "----------------------------------------------------------"
    di as yellow "   Modelos estáticos FE/RE para: `S'"
    di as text "----------------------------------------------------------"

    ******************************************************
    * 1. LOGIT FE
    ******************************************************
    quietly xtlogit pob_monetaria $X_panel, fe
    estimates store FE_`S'

    * Efectos marginales FE
    quietly margins, dydx($X_panel)
    estimates store MFE_`S'

    * Predicción y poder de clasificación FE
    capture drop phat_fe_`S' yhat_fe_`S'
    quietly predict double phat_fe_`S', pu0   // Pr(y=1 | FE=0)

    gen byte yhat_fe_`S' = (phat_fe_`S' >= 0.5) if e(sample)

    tempname M_fe
    quietly tab pob_monetaria yhat_fe_`S' if e(sample), matcell(`M_fe')

    scalar TN_fe_`S' = `M_fe'[1,1]
    scalar FP_fe_`S' = `M_fe'[1,2]
    scalar FN_fe_`S' = `M_fe'[2,1]
    scalar TP_fe_`S' = `M_fe'[2,2]

    scalar CCR_fe_`S' = (TP_fe_`S' + TN_fe_`S') / ///
                        (TP_fe_`S' + TN_fe_`S' + FP_fe_`S' + FN_fe_`S')
    scalar SEN_fe_`S' = TP_fe_`S' / (TP_fe_`S' + FN_fe_`S')
    scalar SPE_fe_`S' = TN_fe_`S' / (TN_fe_`S' + FP_fe_`S')

    quietly roctab pob_monetaria phat_fe_`S' if e(sample), nograph
    scalar AUC_fe_`S' = r(area)

    ******************************************************
    * 2. LOGIT RE – para Hausman y para inferencia robusta
    ******************************************************

    * RE sin clúster (para Hausman)
    quietly xtlogit pob_monetaria $X_panel, re nolog
    estimates store RE_nc_`S'

    capture noisily hausman FE_`S' RE_nc_`S', sigmamore
    if _rc == 0 {
        scalar haus_p_`S' = r(p)
    }
    else {
        scalar haus_p_`S' = .
    }

    * RE con VCE robusta cluster(idhogar) – resultados finales
    quietly xtlogit pob_monetaria $X_panel, re vce(cluster idhogar) nolog
    estimates store RE_`S'

    * Predicción y poder de clasificación RE
    capture drop phat_re_`S' yhat_re_`S'
    quietly predict double phat_re_`S', mu

    gen byte yhat_re_`S' = (phat_re_`S' >= 0.5) if e(sample)

    tempname M_re
    quietly tab pob_monetaria yhat_re_`S' if e(sample), matcell(`M_re')

    scalar TN_re_`S' = `M_re'[1,1]
    scalar FP_re_`S' = `M_re'[1,2]
    scalar FN_re_`S' = `M_re'[2,1]
    scalar TP_re_`S' = `M_re'[2,2]

    scalar CCR_re_`S' = (TP_re_`S' + TN_re_`S') / ///
                        (TP_re_`S' + TN_re_`S' + FP_re_`S' + FN_re_`S')
    scalar SEN_re_`S' = TP_re_`S' / (TP_re_`S' + FN_re_`S')
    scalar SPE_re_`S' = TN_re_`S' / (TN_re_`S' + FP_re_`S')

    quietly roctab pob_monetaria phat_re_`S' if e(sample), nograph
    scalar AUC_re_`S' = r(area)

end


*-----------------------------------------------------------*
* 1.2 Programa: modelo dinámico GEE + poder de predicción
*-----------------------------------------------------------*
capture program drop run_dynamic
program define run_dynamic, rclass
    version 18
    args scope
    local S "`scope'"

    di as text "----------------------------------------------------------"
    di as cyan  "   Modelo dinámico GEE para: `S'"
    di as text "----------------------------------------------------------"

    quietly xtset idhogar year

    * GEE logit con rezago de pobreza
    quietly xtgee pob_monetaria L.pob_monetaria $X_panel, ///
        family(binomial) link(logit) ///
        corr(exchangeable) vce(robust)

    estimates store DYN_`S'

    * Predicción y poder de clasificación DYN
    capture drop phat_dyn_`S' yhat_dyn_`S'
    quietly predict double phat_dyn_`S', mu

    gen byte yhat_dyn_`S' = (phat_dyn_`S' >= 0.5) if e(sample)

    tempname M_dyn
    quietly tab pob_monetaria yhat_dyn_`S' if e(sample), matcell(`M_dyn')

    scalar TN_dyn_`S' = `M_dyn'[1,1]
    scalar FP_dyn_`S' = `M_dyn'[1,2]
    scalar FN_dyn_`S' = `M_dyn'[2,1]
    scalar TP_dyn_`S' = `M_dyn'[2,2]

    scalar CCR_dyn_`S' = (TP_dyn_`S' + TN_dyn_`S') / ///
                         (TP_dyn_`S' + TN_dyn_`S' + FP_dyn_`S' + FN_dyn_`S')
    scalar SEN_dyn_`S' = TP_dyn_`S' / (TP_dyn_`S' + FN_dyn_`S')
    scalar SPE_dyn_`S' = TN_dyn_`S' / (TN_dyn_`S' + FP_dyn_`S')

    quietly roctab pob_monetaria phat_dyn_`S' if e(sample), nograph
    scalar AUC_dyn_`S' = r(area)

end


************************************************************
* 2. EJECUCIÓN DE MODELOS POR ÁMBITO Y PANEL
************************************************************

* 2.1 PERÚ – FULL 2018–2022
preserve
    xtset idhogar year
    run_static  PERU_FULL
    run_dynamic PERU_FULL
restore

* 2.2 PUNO – FULL 2018–2022 (dpto==21)
preserve
    keep if $DEPVAR == 21
    xtset idhogar year
    run_static  PUNO_FULL
    run_dynamic PUNO_FULL
restore

* 2.3 PERÚ – PANEL PURO 2018–2022 (hpan1822==1)
preserve
    keep if hpan1822 == 1
    xtset idhogar year
    run_static  PERU_P1822
    run_dynamic PERU_P1822
restore

* 2.4 PUNO – PANEL PURO 2018–2022 (hpan1822==1 & dpto==21)
preserve
    keep if hpan1822 == 1 & $DEPVAR == 21
    xtset idhogar year
    run_static  PUNO_P1822
    run_dynamic PUNO_P1822
restore

* 2.5 PERÚ – PANEL PURO 2020–2022 (hpan2022==1)
preserve
    keep if hpan2022 == 1
    xtset idhogar year
    run_static  PERU_P2022
    run_dynamic PERU_P2022
restore

* 2.6 PUNO – PANEL PURO 2020–2022 (hpan2022==1 & dpto==21)
preserve
    keep if hpan2022 == 1 & $DEPVAR == 21
    xtset idhogar year
    run_static  PUNO_P2022
    run_dynamic PUNO_P2022
restore


************************************************************
* 3. TABLA COMPARATIVA DE EFECTOS MARGINALES (FE) – collect
************************************************************

* Compararemos FE para:
*   PERU_FULL, PERU_P1822, PERU_P2022, PUNO_FULL

collect clear

foreach S in PERU_FULL PERU_P1822 PERU_P2022 PUNO_FULL {
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
    PUNO_FULL   "Puno 2018–2022 (full)", modify

collect style cell result[_r_b],  nformat(%9.3f)
collect style cell result[_r_se], nformat(%9.3f)

* Una fila por variable, columnas = ámbitos, mostrando solo dy/dx
collect layout (colname) (result[_r_b]#scope)

collect export "tabla_marginales_FE_logit_panel.docx", ///
    replace as(docx)


************************************************************
* 4. PODER PREDICTIVO – EJEMPLO PUNO_FULL (FE, RE, DYN)
************************************************************

matrix POWER_PUNO_FULL = ///
    ( CCR_fe_PUNO_FULL  , SEN_fe_PUNO_FULL  , SPE_fe_PUNO_FULL  , AUC_fe_PUNO_FULL  \ ///
      CCR_re_PUNO_FULL  , SEN_re_PUNO_FULL  , SPE_re_PUNO_FULL  , AUC_re_PUNO_FULL  \ ///
      CCR_dyn_PUNO_FULL , SEN_dyn_PUNO_FULL , SPE_dyn_PUNO_FULL , AUC_dyn_PUNO_FULL )

matrix rownames POWER_PUNO_FULL = FE RE DYN
matrix colnames POWER_PUNO_FULL = CCR SEN SPE AUC

matrix list POWER_PUNO_FULL

collect clear
collect get matrix(POWER_PUNO_FULL), tag(scope[PUNO_FULL])
collect label dim rowname "Modelo"
collect label dim colname "Indicador"
collect layout (rowname) (colname)
collect export "tabla_poder_prediccion_puno_full.docx", replace as(docx)

************************************************************
* FIN
************************************************************
