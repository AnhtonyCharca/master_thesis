/***modelo logit probit panel:
use "$dclea/pobreza_panel_18-22_full.dta", clear

rename pobre2_ pob_monetaria   // si aún no lo hiciste
label define lbl_pobmon 0 "No pobre" 1 "Pobre", replace
label values pob_monetaria lbl_pobmon

gen nativo_=(race_==3)
gen vive_altura_ = (zone_==2)
gen es_soltero_=(ecivil_==1)
*/
*logit pobre2_ inghog2d_ nbi1_ nbi2_  internet_ prop_viv_ tit_prop_ sunarp_ urban_ zone_  sex_ age_ ecivil_ sch_ seguro_ dic_segur_ croni_ morbilid_   lw_ race_ act_empr_

* Mantener solo hogares panel 2018–2022
*keep if hpan1822 == 1

************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – Toda la data (2018–2022) y paneles puros
************************************************************

clear all
set more off

*-----------------------------------------------------------*
* 0. CARGA DE BASE Y CONFIGURACIÓN GENERAL
*-----------------------------------------------------------*

use "$dclea/pobreza_panel_18-22_full.dta", clear

rename pobre2_ pob_monetaria   // si aún no lo hiciste
label define lbl_pobmon 0 "No pobre" 1 "Pobre", replace
label values pob_monetaria lbl_pobmon

gen nativo_=(race_==3)
gen vive_altura_ = (zone_==2)
gen es_soltero_=(ecivil_==1)


* Declarar estructura de panel: hogar-año (panel desbalanceado)
xtset idhogar year

* Variable dependiente (si fuera necesario renombrar)
capture confirm variable pob_monetaria
if _rc {
    capture rename pobre2_ pob_monetaria
}

* Identificar variable de departamento (dpto_ o depto)
capture confirm variable dpto_
if _rc==0 {
    global DEPVAR dpto_
}
else {
    capture confirm variable depto
    if _rc==0 global DEPVAR depto
}

* Dummies mejoradas (solo si no existen)
capture gen vive_altura_ = (zone_==2)      // 1 = Sierra, 0 = otras zonas
capture gen es_soltero_  = (ecivil_==1)    // 1 = soltero/a, 0 = otros

* Macro con regresores estáticos
*global X_static nbi1_ nbi2_ internet_ tit_prop_ urban_ vive_altura_ sex_ age_ es_soltero_ sch_   dic_segur_ croni_ morbilid_ nativo_ act_empr_ lw_
global X_static nbi1_ nbi2_ internet_ tit_prop_  es_soltero_ morbilid_  act_empr_ lw_
************************************************************
* 1. MODELOS CON TODA LA DATA (SIN FILTRAR POR HPAN)      *
*    PERÚ Y PUNO – 2018–2022                              *
************************************************************

*-----------------------------------------------------------*
* 1.A LOGIT PANEL – PERÚ COMPLETO (2018–2022)              *
*     (panel desbalanceado, todos los hogares)             *
*-----------------------------------------------------------*

* No filtramos nada, usamos la base completa
xtset idhogar year

* LOGIT RE – Perú, toda la data
xtlogit pob_monetaria $X_static , re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PE_FULL

outreg2 [LOGIT_RE_PE_FULL] using "logit_re_pe_full.doc", ///
    word replace ctitle("Logit RE - Perú, toda la data 2018–2022") dec(3)

* LOGIT FE – Perú, toda la data
xtlogit pob_monetaria $X_static , fe
estimates store LOGIT_FE_PE_FULL

margins, dydx(*)
estimates store MARG_FE_PE_FULL

outreg2 [LOGIT_FE_PE_FULL] using "logit_fe_pe_full.doc", ///
    word replace ctitle("Logit FE - Perú, toda la data 2018–2022") dec(3)

*-----------------------------------------------------------*
* 1.B LOGIT PANEL – PUNO (dpto==21), TODA LA DATA          *
*-----------------------------------------------------------*

capture restore        // por si venías de un preserve previo
preserve

keep if $DEPVAR == 21
xtset idhogar year

* LOGIT RE – Puno, toda la data
xtlogit pob_monetaria $X_static , re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PU_FULL

* Efectos marginales para el modelo RE – Puno
margins, dydx(*)
estimates store MARG_RE_PU_FULL

outreg2 [LOGIT_RE_PU_FULL] using "logit_re_pu_full.doc", ///
    word replace ctitle("Logit RE - Puno, toda la data 2018–2022") dec(3)

* LOGIT FE – Puno, toda la data
xtlogit pob_monetaria $X_static , fe
estimates store LOGIT_FE_PU_FULL

margins, dydx(*)
estimates store MARG_FE_PU_FULL

outreg2 [LOGIT_FE_PU_FULL] using "logit_fe_pu_full.doc", ///
    word replace ctitle("Logit FE - Puno, toda la data 2018–2022") dec(3)

restore

************************************************************
* 2. MODELOS PARA PANELES PUROS                            *
*    (HPAN1822 y HPAN2022) – PERÚ Y PUNO                   *
************************************************************

*-----------------------------------------------------------*
* 2.A PERÚ – PANEL PURO 2018–2022 (hpan1822==1)            *
*-----------------------------------------------------------*

capture restore
preserve

keep if hpan1822 == 1
xtset idhogar year

* LOGIT RE – Perú, panel puro 2018–2022
xtlogit pob_monetaria $X_static , re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PE_P1822

outreg2 [LOGIT_RE_PE_P1822] using "logit_re_pe_panel1822.doc", ///
    word replace ctitle("Logit RE - Perú, panel 2018–2022") dec(3)

* LOGIT FE – Perú, panel puro 2018–2022

capture restore
preserve

    keep if hpan1822 == 1
    xtset idhogar year
    * Reestimar el modelo FE – Perú, panel 2018–2022
    xtlogit pob_monetaria $X_static, fe
		estimates store LOGIT_FE_PE_P1822
    * Efectos marginales
    margins, dydx(*)
    estimates store MARG_FE_PE_P1822
restore

*-----------------------------------------------------------*
* 2.B PUNO – PANEL PURO 2018–2022 (hpan1822==1 & dpto==21) *
*-----------------------------------------------------------*

capture restore
preserve

keep if hpan1822 == 1 & $DEPVAR == 21
xtset idhogar year

* LOGIT RE – Puno, panel puro 2018–2022
xtlogit pob_monetaria $X_static , re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PU_P1822

outreg2 [LOGIT_RE_PU_P1822] using "logit_re_pu_panel1822.doc", ///
    word replace ctitle("Logit RE - Puno, panel 2018–2022") dec(3)

* LOGIT FE – Puno, panel puro 2018–2022
xtlogit pob_monetaria $X_static , fe
estimates store LOGIT_FE_PU_P1822

margins, dydx(*)
estimates store MARG_FE_PU_P1822

outreg2 [LOGIT_FE_PU_P1822] using "logit_fe_pu_panel1822.doc", ///
    word replace ctitle("Logit FE - Puno, panel 2018–2022") dec(3)

restore

*-----------------------------------------------------------*
* 2.C PERÚ – PANEL PURO 2020–2022 (hpan2022==1)            *
*-----------------------------------------------------------*

capture restore
preserve

keep if hpan2022 == 1
xtset idhogar year

* LOGIT RE – Perú, panel puro 2020–2022
xtlogit pob_monetaria $X_static , re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PE_P2022

outreg2 [LOGIT_RE_PE_P2022] using "logit_re_pe_panel2020_2022.doc", ///
    word replace ctitle("Logit RE - Perú, panel 2020–2022") dec(3)

* LOGIT FE – Perú, panel puro 2020–2022
xtlogit pob_monetaria $X_static , fe
estimates store LOGIT_FE_PE_P2022

margins, dydx(*)
estimates store MARG_FE_PE_P2022

outreg2 [LOGIT_FE_PE_P2022] using "logit_fe_pe_panel2020_2022.doc", ///
    word replace ctitle("Logit FE - Perú, panel 2020–2022") dec(3)

restore

*-----------------------------------------------------------*
* 2.D PUNO – PANEL PURO 2020–2022 (hpan2022==1 & dpto==21) *
*-----------------------------------------------------------*

capture restore
preserve

keep if hpan2022 == 1 & $DEPVAR == 21
xtset idhogar year

* LOGIT RE – Puno, panel puro 2020–2022
xtlogit pob_monetaria $X_static , re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PU_P2022

outreg2 [LOGIT_RE_PU_P2022] using "logit_re_pu_panel2020_2022.doc", ///
    word replace ctitle("Logit RE - Puno, panel 2020–2022") dec(3)

* LOGIT FE – Puno, panel puro 2020–2022
xtlogit pob_monetaria $X_static , fe
estimates store LOGIT_FE_PU_P2022

margins, dydx(*)
estimates store MARG_FE_PU_P2022

outreg2 [LOGIT_FE_PU_P2022] using "logit_fe_pu_panel2020_2022.doc", ///
    word replace ctitle("Logit FE - Puno, panel 2020–2022") dec(3)

restore


************************************************************
* 3. MODELOS DINÁMICOS LOGIT PANEL – POBREZA MONETARIA
*    (incluye L.pob_monetaria)
************************************************************

* Asegurarse de estar con la base original cargada
capture restore
xtset idhogar year

*-----------------------------------------------------------*
* 3.A PERÚ – DINÁMICO RE, TODA LA DATA 2018–2022
*-----------------------------------------------------------*

* No filtramos nada, usamos la base completa
xtset idhogar year

* LOGIT RE DINÁMICO – Perú, toda la data
xtlogit pob_monetaria L.pob_monetaria $X_static, ///
    re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PE_DYN_FULL

* Efecto marginal de la pobreza rezagada (persistencia)
margins, dydx(L.pob_monetaria) predict(pu0) post
estimates store MARG_RE_PE_DYN_FULL

outreg2 [LOGIT_RE_PE_DYN_FULL] using "logit_re_pe_dyn_full.doc", ///
    word replace ctitle("Logit RE dinámico - Perú, toda la data 2018–2022") dec(3)

*-----------------------------------------------------------*
* 3.B PUNO – DINÁMICO RE, TODA LA DATA 2018–2022
*-----------------------------------------------------------*

capture restore
preserve

keep if $DEPVAR == 21
xtset idhogar year

* Modelo logit RE dinámico – Perú, toda la data
xtlogit pob_monetaria L.pob_monetaria $X_static, re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PE_DYN_FULL

* Efecto marginal de L.pob_monetaria en la escala de log-odds
margins, dydx(L.pob_monetaria) predict(xb) post
estimates store MARG_RE_PE_DYN_FULL

outreg2 [LOGIT_RE_PU_DYN_FULL] using "logit_re_pu_dyn_full.doc", ///
    word replace ctitle("Logit RE dinámico - Puno, toda la data 2018–2022") dec(3)

restore

*-----------------------------------------------------------*
* 3.C PERÚ – DINÁMICO RE, PANEL PURO 2018–2022 (hpan1822==1)
*-----------------------------------------------------------*

capture restore
preserve

keep if hpan1822 == 1
xtset idhogar year

xtlogit pob_monetaria L.pob_monetaria $X_static, ///
    re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PE_DYN_P1822

margins, dydx(L.pob_monetaria) post
estimates store MARG_RE_PE_DYN_P1822

outreg2 [LOGIT_RE_PE_DYN_P1822] using "logit_re_pe_dyn_panel1822.doc", ///
    word replace ctitle("Logit RE dinámico - Perú, panel 2018–2022") dec(3)

restore

*-----------------------------------------------------------*
* 3.D PUNO – DINÁMICO RE, PANEL PURO 2018–2022
*       (hpan1822==1 & dpto==21)
*-----------------------------------------------------------*

capture restore
preserve

keep if hpan1822 == 1 & $DEPVAR == 21
xtset idhogar year

xtlogit pob_monetaria L.pob_monetaria $X_static, ///
    re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PU_DYN_P1822

margins, dydx(L.pob_monetaria) post
estimates store MARG_RE_PU_DYN_P1822

outreg2 [LOGIT_RE_PU_DYN_P1822] using "logit_re_pu_dyn_panel1822.doc", ///
    word replace ctitle("Logit RE dinámico - Puno, panel 2018–2022") dec(3)

restore

*-----------------------------------------------------------*
* 3.E PERÚ – DINÁMICO RE, PANEL PURO 2020–2022 (hpan2022==1)
*-----------------------------------------------------------*

capture restore
preserve

keep if hpan2022 == 1
xtset idhogar year

xtlogit pob_monetaria L.pob_monetaria $X_static, ///
    re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PE_DYN_P2022

margins, dydx(L.pob_monetaria) post
estimates store MARG_RE_PE_DYN_P2022

outreg2 [LOGIT_RE_PE_DYN_P2022] using "logit_re_pe_dyn_panel2020_2022.doc", ///
    word replace ctitle("Logit RE dinámico - Perú, panel 2020–2022") dec(3)

restore

*-----------------------------------------------------------*
* 3.F PUNO – DINÁMICO RE, PANEL PURO 2020–2022
*       (hpan2022==1 & dpto==21)
*-----------------------------------------------------------*

capture restore
preserve

keep if hpan2022 == 1 & $DEPVAR == 21
xtset idhogar year

xtlogit pob_monetaria L.pob_monetaria $X_static, ///
    re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PU_DYN_P2022

margins, dydx(L.pob_monetaria) post
estimates store MARG_RE_PU_DYN_P2022

outreg2 [LOGIT_RE_PU_DYN_P2022] using "logit_re_pu_dyn_panel2020_2022.doc", ///
    word replace ctitle("Logit RE dinámico - Puno, panel 2020–2022") dec(3)

restore

*==============================================================*
* 3. MODELO LOGIT PANEL DINÁMICO (xtgee) – POBREZA MONETARIA  *
*    (Perú y Puno, 2018–2022)                                 *
*==============================================================*

* Asegurarse de que la data original está cargada
capture restore
xtset idhogar year

***************************************************************
* 3.A PERÚ – MODELO LOGIT DINÁMICO (GEE)                      *
***************************************************************

capture restore
preserve

* Estructura de panel
xtset idhogar year

* GEE logit dinámico, correlación exchangeable, VCE robusta
xtgee pob_monetaria L.pob_monetaria $X_static, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_LOGIT_DYN_PE

* Predicción de probabilidad (media condicional)
predict phat_dyn_pe, mu

* Extraer beta de la pobreza rezagada
matrix b = e(b)
scalar bL_pe = b[1,"L.pob_monetaria"]

* Derivada del logit: dP/dL = beta_L * p*(1-p)
gen dL_pe = bL_pe * phat_dyn_pe * (1 - phat_dyn_pe)

summarize dL_pe
scalar ame_L_pe = r(mean)

display "AME de L.pob_monetaria – Perú, GEE dinámico = " ame_L_pe

restore


***************************************************************
* 3.B PUNO – MODELO LOGIT DINÁMICO (GEE)                      *
***************************************************************

capture restore
preserve

keep if $DEPVAR == 21
xtset idhogar year

* GEE logit dinámico, correlación exchangeable, VCE robusta
xtgee pob_monetaria L.pob_monetaria $X_static, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)

estimates store GEE_LOGIT_DYN_PU

predict phat_dyn_pu, mu

matrix b = e(b)
scalar bL_pu = b[1,"L.pob_monetaria"]

gen dL_pu = bL_pu * phat_dyn_pu * (1 - phat_dyn_pu)

summarize dL_pu
scalar ame_L_pu = r(mean)

display "AME de L.pob_monetaria – Puno, GEE dinámico = " ame_L_pu

restore


*==============================================================*
* 3. TABLA RESUMEN – EFECTOS MARGINALES (dy/dx)
*==============================================================*

collect clear

*--------------------------------------------------------------*
* 3.1. Cargar cada conjunto de margins a la colección
*--------------------------------------------------------------*

* FE – Perú, toda la data 2018–2022
estimates restore MARG_FE_PE_FULL
ereturn list           // opcional, para verificar que hay _r_b y _r_se
collect get _r_b _r_se, tag(model[FE_PE_18_22])

* FE – Perú panel puro 2018–2022
estimates restore MARG_FE_PE_P1822
collect get _r_b _r_se, tag(model[FE_PE_PAN_18_22])

* FE – Perú panel puro 2020–2022
estimates restore MARG_FE_PE_P2022
collect get _r_b _r_se, tag(model[FE_PE_PAN_20_22])

* RE – Puno, toda la data 2018–2022
estimates restore MARG_RE_PU_FULL
collect get _r_b _r_se, tag(model[RE_PU_18_22])

*--------------------------------------------------------------*
* 3.2. Limpiar y etiquetar
*--------------------------------------------------------------*

* Quitar (por si aparece) la constante
collect drop if colname=="_cons"

collect label levels model ///
    FE_PE_18_22       "FE – Perú 2018–2022" ///
    FE_PE_PAN_18_22   "FE – Perú panel 2018–2022" ///
    FE_PE_PAN_20_22   "FE – Perú panel 2020–2022" ///
    RE_PU_18_22       "RE – Puno 2018–2022", modify

collect label dim colname "Variable"
collect label dim model   "Modelo"
collect label dim result  "Estadístico"

* Formato numérico
collect style cell result[_r_b],  nformat(%9.3f)
collect style cell result[_r_se], nformat(%9.3f)

*--------------------------------------------------------------*
* 3.3. Diseño de la tabla
*   Una fila por variable, columnas = modelos
*   (solo dy/dx; si quieres también errores, te lo dejo comentado)
*--------------------------------------------------------------*

* Opción simple: solo dy/dx
collect layout (colname) (result[_r_b]#model)

* Si quisieras coef y se:
* collect layout (colname) (result[_r_b _r_se]#model)

*--------------------------------------------------------------*
* 3.4. Exportar a Word
*--------------------------------------------------------------*
collect export "tabla_marginales_pobreza_logit_panel.docx", ///
    replace as(docx)



* Asegurar la estructura panel
xtset idhogar year

* GEE logit dinámico, correlación exchangeable, VCE robusta por panel
xtgee pob_monetaria L.pob_monetaria $X_static, ///
    family(binomial) link(logit) ///
    corr(exchangeable) vce(robust)