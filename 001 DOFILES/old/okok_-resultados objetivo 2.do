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

* Variables auxiliares (ajusta nombres si difieren)
capture drop nativo_ es_soltero_ vive_altura_
gen nativo_     = (race_==3)
gen es_soltero_ = (ecivil_==1)
gen vive_altura_ = (zone_==2)

* Panel
xtset idhogar year

* Dpto (ajusta según tu base)
capture confirm variable dpto
if !_rc global DEPVAR dpto
else global DEPVAR dpto_

* Especificación parsimoniosa (la que te dio significancia en Puno)
global X lwage_ totmieho_ internet_ 

************************************************************
* 1. PROGRAMA PARA ESTIMAR MODELOS ESTÁTICOS Y DINÁMICOS
************************************************************

program define run_models_panel
    syntax , scope(string)

    di "------------------------------------------------------"
    di " Ejecutando modelos para: `scope' "
    di "------------------------------------------------------"

    *------------------*
    * 1.1 RE ESTÁTICO  *
    *------------------*
    quietly xtlogit pob_monetaria $X , re vce(cluster idhogar) nolog
    estimates store RE_`scope'
    
    * Predicciones RE: probabilidad (default = mu)
    capture drop phat_RE_`scope'
    predict phat_RE_`scope'          // SIN , p
    capture drop yhat_RE_`scope'
    gen yhat_RE_`scope' = phat_RE_`scope' >= 0.5
    tab pob_monetaria yhat_RE_`scope', row col
    
    * ROC para RE
    roctab pob_monetaria phat_RE_`scope', graph name(roc_RE_`scope', replace)
    graph export "roc_RE_`scope'.png", replace

    outreg2 using "RE_`scope'.doc", word replace ///
        ctitle("Logit RE – `scope'") dec(3)

    *------------------*
    * 1.2 FE ESTÁTICO  *
    *------------------*
    quietly xtlogit pob_monetaria $X , fe
    estimates store FE_`scope'
    
    * Hausman FE vs RE
    capture noisily hausman FE_`scope' RE_`scope', sigmaless

    * Margins (efectos marginales) FE
    margins, dydx($X)
    estimates store MARG_FE_`scope'

    * Predicciones FE (u_i=0)
    capture drop phat_FE_`scope'
    predict phat_FE_`scope', pu0
    capture drop yhat_FE_`scope'
    gen yhat_FE_`scope' = phat_FE_`scope' >= 0.5
    tab pob_monetaria yhat_FE_`scope', row col

    * ROC para FE
    roctab pob_monetaria phat_FE_`scope', graph name(roc_FE_`scope', replace)
    graph export "roc_FE_`scope'.png", replace

    outreg2 using "FE_`scope'.doc", word replace ///
        ctitle("Logit FE – `scope'") dec(3)

    * Gráfico de efectos marginales FE
		margins, dydx(lwage_ totmieho_ internet_)
		marginsplot, yline(0) name(mfx_FE_`scope', replace)
		graph export "mfx_FE_`scope'.png", replace

    *------------------*
    * 1.3 RE DINÁMICO  *
    *------------------*
    capture drop L_pobreza
    gen L_pobreza = L.pob_monetaria

    quietly xtlogit pob_monetaria L_pobreza $X , re vce(cluster idhogar) nolog
    estimates store DYN_RE_`scope'

    * Predicciones dinámico RE
    capture drop phat_DYN_RE_`scope'
    predict phat_DYN_RE_`scope'     // SIN , p
    capture drop yhat_DYN_RE_`scope'
    gen yhat_DYN_RE_`scope' = phat_DYN_RE_`scope' >= 0.5
    tab pob_monetaria yhat_DYN_RE_`scope', row col

    roctab pob_monetaria phat_DYN_RE_`scope', graph name(roc_DYN_RE_`scope', replace)
    graph export "roc_DYN_RE_`scope'.png", replace

    outreg2 using "DYN_RE_`scope'.doc", word replace ///
        ctitle("Logit Dinámico RE – `scope'") dec(3)

    *------------------------------*
    * 1.4 GEE DINÁMICO (PA model)  *
    *------------------------------*
    quietly xtgee pob_monetaria L_pobreza $X , ///
        family(binomial) link(logit) corr(exchangeable) vce(robust)
    estimates store DYN_GEE_`scope'

    capture drop phat_DYN_GEE_`scope'
    predict phat_DYN_GEE_`scope', mu
    capture drop yhat_DYN_GEE_`scope'
    gen yhat_DYN_GEE_`scope' = phat_DYN_GEE_`scope' >= 0.5
    tab pob_monetaria yhat_DYN_GEE_`scope', row col

    roctab pob_monetaria phat_DYN_GEE_`scope', graph name(roc_DYN_GEE_`scope', replace)
    graph export "roc_DYN_GEE_`scope'.png", replace

    outreg2 using "DYN_GEE_`scope'.doc", word replace ///
        ctitle("GEE Dinámico – `scope'") dec(3)
end


************************************************************
* 2. EJECUTAR MODELOS POR ÁMBITO Y PANEL
************************************************************

* 2.1 PERÚ – FULL 2018–2022
preserve
run_models_panel , scope("PERU_FULL")
restore

* 2.2 PUNO – FULL 2018–2022
preserve
keep if $DEPVAR == 21
run_models_panel , scope("PUNO_FULL")
restore

* 2.3 PERÚ – PANEL PURO 2018–2022 (hpan1822)
preserve
keep if hpan1822 == 1
run_models_panel , scope("PERU_PAN1822")
restore

* 2.4 PUNO – PANEL PURO 2018–2022 (hpan1822)
preserve
keep if hpan1822 == 1 & $DEPVAR == 21
run_models_panel , scope("PUNO_PAN1822")
restore

* 2.5 PERÚ – PANEL PURO 2020–2022 (hpan2022)
preserve
keep if hpan2022 == 1
run_models_panel , scope("PERU_PAN2022")
restore

* 2.6 PUNO – PANEL PURO 2020–2022 (hpan2022)
preserve
keep if hpan2022 == 1 & $DEPVAR == 21
run_models_panel , scope("PUNO_PAN2022")
restore

************************************************************
* 3. TABLA COMPARATIVA – EFECTOS MARGINALES (FE)
************************************************************

collect clear

* Los MARG_FE_* ya se generaron dentro de run_models_panel

foreach sc in PERU_FULL PUNO_FULL PERU_PAN1822 PUNO_PAN1822 PERU_PAN2022 PUNO_PAN2022 {
    quietly estimates restore MARG_FE_`sc'
    collect get _r_b _r_se, tag(model[`sc'])
}

* Etiquetas de modelos
collect label levels model ///
    PERU_FULL      "Perú Full 2018–2022" ///
    PUNO_FULL      "Puno Full 2018–2022" ///
    PERU_PAN1822   "Perú Panel 2018–2022" ///
    PUNO_PAN1822   "Puno Panel 2018–2022" ///
    PERU_PAN2022   "Perú Panel 2020–2022" ///
    PUNO_PAN2022   "Puno Panel 2020–2022", modify

collect label dim colname "Variable"
collect label dim model   "Modelo"
collect label dim result  "Estadístico"

* Formato numérico
collect style cell result[_r_b],  nformat(%9.3f)
collect style cell result[_r_se], nformat(%9.3f)

* Diseño: una fila por variable, columnas = modelos (solo dy/dx)
collect layout (colname) (result[_r_b]#model)

* Exportar a Word
collect export "tabla_marginales_FE_Peru_Puno.docx", ///
    replace as(docx)

* Alternativa con coeficiente y error estándar
* collect layout (colname) (result[_r_b _r_se]#model)

**4. Gráficos de efectos marginales
margins, dydx(lwage_ totmieho_ internet_ )
marginsplot, yline(0) name(mfx_FE_`scope', replace)
graph export "mfx_FE_`scope'.png", replace

*5. Prueba FE vs RE (Hausman)
hausman FE_`scope' RE_`scope', sigmaless

/*
Interpretación rápida para el informe:

Si el p-valor < 0,05 → se rechaza RE y se prefiere FE (hay correlación entre efectos no observados y X).

Si el p-valor ≥ 0,05 → no se rechaza RE, el modelo de efectos aleatorios es consistente y eficiente.

En tu tesis, la conclusión se redacta de manera narrativa, por ejemplo:

En el ámbito de Puno, la prueba de Hausman no rechazó la hipótesis nula (p ≥ 0,05), por lo que el modelo de efectos aleatorios se considera adecuado para explicar la probabilidad de pobreza monetaria en el periodo analizado.

(o al revés si el p-valor es bajo).*/

*6. Poder de predicción: clasificación, ROC y "calidad" del modelo

***6.1 Tabla de clasificación a partir de un corte de 0,5:
predict phat_FE_PERU_FULL, pu0
gen yhat_FE_PERU_FULL = phat_FE_PERU_FULL >= 0.5
tab pob_monetaria yhat_FE_PERU_FULL, row col

/*
De esa tabla puedes calcular en el informe:

Sensibilidad (TP / (TP+FN))

Especificidad (TN / (TN+FP))

Exactitud global ((TP+TN)/N)
*/

*2Curva ROC por modelo panel con roctab:
roctab pob_monetaria phat_FE_PERU_FULL, graph name(roc_FE_PERU_FULL, replace)
graph export "roc_FE_PERU_FULL.png", replace












	
	