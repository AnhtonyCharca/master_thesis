************************************************************
* DO-FILE: MODELOS LOGIT PANEL – Pobreza monetaria ENAHO
* Modelos: FE, RE y Dinámicos
* Ámbitos: Perú y Puno
* Paneles: Full (2018–2022), Puro 2018–2022 y Puro 2020–2022
************************************************************

clear all
set more off

*-----------------------------------------------------------*
* 0. CARGA BASE Y PREPARACIÓN INICIAL
*-----------------------------------------------------------*

use "$dclea/pobreza_panel_18-22_full.dta", clear

rename pobre2_ pob_monetaria, replace
label define lbl_pmon 0 "No pobre" 1 "Pobre", replace
label values pob_monetaria lbl_pmon

* Variables auxiliares
gen nativo_    = (race_==3)
gen es_soltero_ = (ecivil_==1)
gen vive_altura_ = (zone_==2)

* Sets panel
xtset idhogar year

* Dpto variable
capture confirm variable dpto
if !_rc global DEPVAR dpto
else global DEPVAR dpto_

* Variables explicativas
global X lwage_ totmieho_ internet_ analfa_

************************************************************
* 1. FUNCIÓN PARA CORRER MODELOS
************************************************************

program define run_models
    syntax , scope(string)

    di "------------------------------------------------------"
    di " Ejecutando modelos para: `scope' "
    di "------------------------------------------------------"

    * Efectos Aleatorios
    quietly xtlogit pob_monetaria $X , re vce(cluster idhogar) nolog
    estimates store RE_`scope'
    outreg2 using "RE_`scope'.doc", word replace ///
        ctitle("Logit RE – `scope'") dec(3)

    * Efectos Fijos
    quietly xtlogit pob_monetaria $X , fe
    estimates store FE_`scope'
    outreg2 using "FE_`scope'.doc", word replace ///
        ctitle("Logit FE – `scope'") dec(3)

    * Modelo dinámico RE
    capture drop L_pobreza
    gen L_pobreza = L.pob_monetaria

    quietly xtlogit pob_monetaria L_pobreza $X , re vce(cluster idhogar) nolog
    estimates store DYN_RE_`scope'
    outreg2 using "DYN_RE_`scope'.doc", word replace ///
        ctitle("Logit Dinámico RE – `scope'") dec(3)

    * GEE dinámico
    quietly xtgee pob_monetaria L_pobreza $X , ///
        family(binomial) link(logit) corr(exchangeable) vce(robust)
    estimates store DYN_GEE_`scope'
    outreg2 using "DYN_GEE_`scope'.doc", word replace ///
        ctitle("GEE Dinámico – `scope'") dec(3)
end

************************************************************
* 2. CORRER MODELOS PARA CADA ESCENARIO
************************************************************

*-----------------------------------------------------------------*
* 2.1 PERÚ – TODA LA DATA (2018–2022)
*-----------------------------------------------------------------*
preserve
run_models , scope("PERU_FULL")
restore

*-----------------------------------------------------------------*
* 2.2 PUNO – TODA LA DATA (2018–2022)
*-----------------------------------------------------------------*
preserve
keep if $DEPVAR == 21
run_models , scope("PUNO_FULL")
restore

*-----------------------------------------------------------------*
* 2.3 PERÚ – PANEL PURO 2018–2022
*-----------------------------------------------------------------*
preserve
keep if hpan1822 == 1
run_models , scope("PERU_PAN1822")
restore

*-----------------------------------------------------------------*
* 2.4 PUNO – PANEL PURO 2018–2022
*-----------------------------------------------------------------*
preserve
keep if hpan1822 == 1 & $DEPVAR == 21
run_models , scope("PUNO_PAN1822")
restore

*-----------------------------------------------------------------*
* 2.5 PERÚ – PANEL PURO 2020–2022
*-----------------------------------------------------------------*
preserve
keep if hpan2022 == 1
run_models , scope("PERU_PAN2022")
restore

*-----------------------------------------------------------------*
* 2.6 PUNO – PANEL PURO 2020–2022
*-----------------------------------------------------------------*
preserve
keep if hpan2022 == 1 & $DEPVAR == 21
run_models , scope("PUNO_PAN2022")
restore

************************************************************
* 3. FIN
************************************************************
di "======================================================"
di "   MODELOS COMPLETADOS EXITOSAMENTE – ARCHIVOS LISTOS"
di "======================================================"
