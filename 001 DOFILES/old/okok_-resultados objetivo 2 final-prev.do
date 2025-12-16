************************************************************
* 3. PODER DE PREDICCIÓN – PERÚ Y PUNO (FE, RE, GEE dinámico)
************************************************************

* Núcleo de regresores
global Xcore lwage_ totmieho_ internet_

*==========================================================*
* 3.1 PERÚ – FULL 2018–2022
*==========================================================*

*-------------------------*
* 3.1.1 RE Perú full
*-------------------------*
preserve
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog

    capture drop phat_re_pe yhat_re_pe
    * Usamos el xb (log-odds). Para AUC da lo mismo que la probabilidad
    predict phat_re_pe    // opción xb asumida

    * AUC de la ROC (sin detail para evitar el error 134)
    quietly roctab pob_monetaria phat_re_pe
    scalar AUC_RE_PE_FULL = r(area)

    * Clasificación: xb >= 0 <=> probabilidad >= 0,5
    gen byte yhat_re_pe = phat_re_pe >= 0
    tab pob_monetaria yhat_re_pe, matcell(MRE_PE)

    scalar TP_RE_PE = MRE_PE[2,2]
    scalar FP_RE_PE = MRE_PE[1,2]
    scalar FN_RE_PE = MRE_PE[2,1]
    scalar TN_RE_PE = MRE_PE[1,1]

    scalar SENS_RE_PE_FULL = TP_RE_PE / (TP_RE_PE + FN_RE_PE)
    scalar SPEC_RE_PE_FULL = TN_RE_PE / (TN_RE_PE + FP_RE_PE)

    matrix POWER_RE_PE_FULL = ///
        (AUC_RE_PE_FULL, SENS_RE_PE_FULL, SPEC_RE_PE_FULL)
restore

*-------------------------*
* 3.1.2 FE Perú full
*-------------------------*
preserve
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, fe

    capture drop phat_fe_pe yhat_fe_pe
    predict phat_fe_pe, pu0             // prob. con efecto fijo=0

   quietly roctab pob_monetaria phat_fe_pe
    scalar AUC_FE_PE_FULL = r(area)

    gen byte yhat_fe_pe = phat_fe_pe >= 0.5
    tab pob_monetaria yhat_fe_pe, matcell(MFE_PE)

    scalar TP_FE_PE = MFE_PE[2,2]
    scalar FP_FE_PE = MFE_PE[1,2]
    scalar FN_FE_PE = MFE_PE[2,1]
    scalar TN_FE_PE = MFE_PE[1,1]

    scalar SENS_FE_PE_FULL = TP_FE_PE / (TP_FE_PE + FN_FE_PE)
    scalar SPEC_FE_PE_FULL = TN_FE_PE / (TN_FE_PE + FP_FE_PE)

    matrix POWER_FE_PE_FULL = ///
        (AUC_FE_PE_FULL, SENS_FE_PE_FULL, SPEC_FE_PE_FULL)
restore

*-------------------------*
* 3.1.3 GEE dinámico Perú full
*-------------------------*
preserve
    xtset idhogar year

    quietly xtgee pob_monetaria L.pob_monetaria $Xcore, ///
        family(binomial) link(logit) ///
        corr(exchangeable) vce(robust)

    capture drop phat_gee_pe yhat_gee_pe
    predict phat_gee_pe, mu             // media poblacional

    quietly roctab pob_monetaria phat_gee_pe
    scalar AUC_GEE_PE_FULL = r(area)

    gen byte yhat_gee_pe = phat_gee_pe >= 0.5
    tab pob_monetaria yhat_gee_pe, matcell(MGEE_PE)

    scalar TP_GEE_PE = MGEE_PE[2,2]
    scalar FP_GEE_PE = MGEE_PE[1,2]
    scalar FN_GEE_PE = MGEE_PE[2,1]
    scalar TN_GEE_PE = MGEE_PE[1,1]

    scalar SENS_GEE_PE_FULL = TP_GEE_PE / (TP_GEE_PE + FN_GEE_PE)
    scalar SPEC_GEE_PE_FULL = TN_GEE_PE / (TN_GEE_PE + FP_GEE_PE)

    matrix POWER_GEE_PE_FULL = ///
        (AUC_GEE_PE_FULL, SENS_GEE_PE_FULL, SPEC_GEE_PE_FULL)
restore


*==========================================================*
* 3.2 PUNO – FULL 2018–2022
*==========================================================*

*-------------------------*
* 3.2.1 RE Puno full
*-------------------------*
preserve
    keep if $DEPVAR == 21
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, re vce(cluster idhogar) nolog

    capture drop phat_re_pu yhat_re_pu
    predict phat_re_pu

    quietly roctab pob_monetaria phat_re_pu
    scalar AUC_RE_PU_FULL = r(area)

    gen byte yhat_re_pu = phat_re_pu >= 0.5
    tab pob_monetaria yhat_re_pu, matcell(MRE_PU)

    scalar TP_RE_PU = MRE_PU[2,2]
    scalar FP_RE_PU = MRE_PU[1,2]
    scalar FN_RE_PU = MRE_PU[2,1]
    scalar TN_RE_PU = MRE_PU[1,1]

    scalar SENS_RE_PU_FULL = TP_RE_PU / (TP_RE_PU + FN_RE_PU)
    scalar SPEC_RE_PU_FULL = TN_RE_PU / (TN_RE_PU + FP_RE_PU)

    matrix POWER_RE_PU_FULL = ///
        (AUC_RE_PU_FULL, SENS_RE_PU_FULL, SPEC_RE_PU_FULL)
restore

*-------------------------*
* 3.2.2 FE Puno full
*-------------------------*
preserve
    keep if $DEPVAR == 21
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, fe

    capture drop phat_fe_pu yhat_fe_pu
    predict phat_fe_pu, pu0

    quietly roctab pob_monetaria phat_fe_pu
    scalar AUC_FE_PU_FULL = r(area)

    gen byte yhat_fe_pu = phat_fe_pu >= 0.5
    tab pob_monetaria yhat_fe_pu, matcell(MFE_PU)

    scalar TP_FE_PU = MFE_PU[2,2]
    scalar FP_FE_PU = MFE_PU[1,2]
    scalar FN_FE_PU = MFE_PU[2,1]
    scalar TN_FE_PU = MFE_PU[1,1]

    scalar SENS_FE_PU_FULL = TP_FE_PU / (TP_FE_PU + FN_FE_PU)
    scalar SPEC_FE_PU_FULL = TN_FE_PU / (TN_FE_PU + FP_FE_PU)

    matrix POWER_FE_PU_FULL = ///
        (AUC_FE_PU_FULL, SENS_FE_PU_FULL, SPEC_FE_PU_FULL)
restore

*-------------------------*
* 3.2.3 GEE dinámico Puno full
*-------------------------*
preserve
    keep if $DEPVAR == 21
    xtset idhogar year

    quietly xtgee pob_monetaria L.pob_monetaria $Xcore, ///
        family(binomial) link(logit) ///
        corr(exchangeable) vce(robust)

    capture drop phat_gee_pu yhat_gee_pu
    predict phat_gee_pu, mu

   quietly roctab pob_monetaria phat_gee_pu
    scalar AUC_GEE_PU_FULL = r(area)

    gen byte yhat_gee_pu = phat_gee_pu >= 0.5
    tab pob_monetaria yhat_gee_pu, matcell(MGEE_PU)

    scalar TP_GEE_PU = MGEE_PU[2,2]
    scalar FP_GEE_PU = MGEE_PU[1,2]
    scalar FN_GEE_PU = MGEE_PU[2,1]
    scalar TN_GEE_PU = MGEE_PU[1,1]

    scalar SENS_GEE_PU_FULL = TP_GEE_PU / (TP_GEE_PU + FN_GEE_PU)
    scalar SPEC_GEE_PU_FULL = TN_GEE_PU / (TN_GEE_PU + FP_GEE_PU)

    matrix POWER_GEE_PU_FULL = ///
        (AUC_GEE_PU_FULL, SENS_GEE_PU_FULL, SPEC_GEE_PU_FULL)
restore


************************************************************
* 4. MATRICES GLOBALES DE PODER PREDICTIVO
************************************************************

* Perú: RE estático, FE estático, GEE dinámico
matrix POWER_PERU =  ///
    (POWER_RE_PE_FULL \ ///
     POWER_FE_PE_FULL \ ///
     POWER_GEE_PE_FULL)

matrix rownames POWER_PERU = RE_PE_static FE_PE_static GEE_PE_dyn
matrix colnames POWER_PERU = AUC Sensibilidad Especificidad

* Puno: RE estático, FE estático, GEE dinámico
matrix POWER_PUNO =  ///
    (POWER_RE_PU_FULL \ ///
     POWER_FE_PU_FULL \ ///
     POWER_GEE_PU_FULL)

matrix rownames POWER_PUNO = RE_PU_static FE_PU_static GEE_PU_dyn
matrix colnames POWER_PUNO = AUC Sensibilidad Especificidad

* Matriz combinada Perú + Puno
matrix POWER_ALL = (POWER_PERU \ POWER_PUNO)
matrix list POWER_ALL


************************************************************
* 5. TABLA FINAL CON COLLECT – PODER PREDICTIVO
************************************************************

collect clear

* Cargar la matriz POWER_ALL a collect
collect get matrix(POWER_ALL)

* Renombrar dimensiones
collect label dim rowname "Ámbito–modelo"
collect label dim colname "Indicador"

* Etiquetar filas (ámbitos y modelos)
collect label levels rowname ///
    RE_PE_static "Perú RE estático 2018–2022" ///
    FE_PE_static "Perú FE estático 2018–2022" ///
    GEE_PE_dyn   "Perú GEE dinámico 2018–2022" ///
    RE_PU_static "Puno RE estático 2018–2022" ///
    FE_PU_static "Puno FE estático 2018–2022" ///
    GEE_PU_dyn   "Puno GEE dinámico 2018–2022", modify

* Etiquetar columnas (indicadores)
collect label levels colname ///
    AUC           "AUC (ROC)" ///
    Sensibilidad  "Sensibilidad (cutoff 0,5)" ///
    Especificidad "Especificidad (cutoff 0,5)", modify

* Formato numérico
collect style cell colname[AUC Sensibilidad Especificidad], nformat(%6.3f)

* Diseño: filas = modelos, columnas = indicadores
collect layout (rowname) (colname)

* Exportar a Word
collect export "tabla_poder_predictivo_peru_puno.docx", ///
    replace as(docx)
