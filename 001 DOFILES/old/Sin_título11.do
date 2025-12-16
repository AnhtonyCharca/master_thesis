************************************************************
* 3. PODER DE PREDICCIÓN – MODELOS FE (ESTÁTICOS)
*    Perú y Puno – Full, panel 2018–2022 y panel 2020–2022
************************************************************

*-----------------------------------------------------------*
* 3.1 PERÚ – FE
*   (AUC, Sensibilidad, Especificidad)
*-----------------------------------------------------------*

*-------------------------*
* 3.1.1 Perú full 2018–2022
*-------------------------*
preserve
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, fe

    capture drop xb_fe_pe_full yhat_fe_pe_full
    predict xb_fe_pe_full, xb        // log-odds

    * AUC de la ROC (sin detail para evitar error 134)
    roctab pob_monetaria xb_fe_pe_full
    scalar AUC_FE_PE_FULL   = r(area)

    * Clasificación: xb>=0 <=> prob>=0,5
    gen byte yhat_fe_pe_full = xb_fe_pe_full >= 0
    tab pob_monetaria yhat_fe_pe_full, matcell(MFE_PE_FULL)

    scalar TP_FE_PE_FULL = MFE_PE_FULL[2,2]
    scalar FP_FE_PE_FULL = MFE_PE_FULL[1,2]
    scalar FN_FE_PE_FULL = MFE_PE_FULL[2,1]
    scalar TN_FE_PE_FULL = MFE_PE_FULL[1,1]

    scalar SENS_FE_PE_FULL = TP_FE_PE_FULL / (TP_FE_PE_FULL + FN_FE_PE_FULL)
    scalar SPEC_FE_PE_FULL = TN_FE_PE_FULL / (TN_FE_PE_FULL + FP_FE_PE_FULL)
restore


*-------------------------*
* 3.1.2 Perú panel puro 2018–2022 (hpan1822==1)
*-------------------------*
preserve
    keep if hpan1822 == 1
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, fe

    capture drop xb_fe_pe_p1822 yhat_fe_pe_p1822
    predict xb_fe_pe_p1822, xb

    roctab pob_monetaria xb_fe_pe_p1822
    scalar AUC_FE_PE_P1822   = r(area)

    gen byte yhat_fe_pe_p1822 = xb_fe_pe_p1822 >= 0
    tab pob_monetaria yhat_fe_pe_p1822, matcell(MFE_PE_P1822)

    scalar TP_FE_PE_P1822 = MFE_PE_P1822[2,2]
    scalar FP_FE_PE_P1822 = MFE_PE_P1822[1,2]
    scalar FN_FE_PE_P1822 = MFE_PE_P1822[2,1]
    scalar TN_FE_PE_P1822 = MFE_PE_P1822[1,1]

    scalar SENS_FE_PE_P1822 = TP_FE_PE_P1822 / (TP_FE_PE_P1822 + FN_FE_PE_P1822)
    scalar SPEC_FE_PE_P1822 = TN_FE_PE_P1822 / (TN_FE_PE_P1822 + FP_FE_PE_P1822)
restore


*-------------------------*
* 3.1.3 Perú panel puro 2020–2022 (hpan2022==1)
*-------------------------*
preserve
    keep if hpan2022 == 1
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, fe

    capture drop xb_fe_pe_p2022 yhat_fe_pe_p2022
    predict xb_fe_pe_p2022, xb

    roctab pob_monetaria xb_fe_pe_p2022
    scalar AUC_FE_PE_P2022   = r(area)

    gen byte yhat_fe_pe_p2022 = xb_fe_pe_p2022 >= 0
    tab pob_monetaria yhat_fe_pe_p2022, matcell(MFE_PE_P2022)

    scalar TP_FE_PE_P2022 = MFE_PE_P2022[2,2]
    scalar FP_FE_PE_P2022 = MFE_PE_P2022[1,2]
    scalar FN_FE_PE_P2022 = MFE_PE_P2022[2,1]
    scalar TN_FE_PE_P2022 = MFE_PE_P2022[1,1]

    scalar SENS_FE_PE_P2022 = TP_FE_PE_P2022 / (TP_FE_PE_P2022 + FN_FE_PE_P2022)
    scalar SPEC_FE_PE_P2022 = TN_FE_PE_P2022 / (TN_FE_PE_P2022 + FP_FE_PE_P2022)
restore


* Matriz resumen PERÚ (3 filas: full, pan18–22, pan20–22)
matrix POWER_PERU = ///
    (AUC_FE_PE_FULL,   SENS_FE_PE_FULL,   SPEC_FE_PE_FULL \ ///
     AUC_FE_PE_P1822,  SENS_FE_PE_P1822,  SPEC_FE_PE_P1822 \ ///
     AUC_FE_PE_P2022,  SENS_FE_PE_P2022,  SPEC_FE_PE_P2022)

matrix rownames POWER_PERU = "Peru_18_22_full" "Peru_pan_18_22" "Peru_pan_20_22"
matrix colnames POWER_PERU = "AUC" "Sens" "Spec"


*-----------------------------------------------------------*
* 3.2 PUNO – FE
*   (AUC, Sensibilidad, Especificidad)
*-----------------------------------------------------------*

*-------------------------*
* 3.2.1 Puno full 2018–2022
*-------------------------*
preserve
    keep if $DEPVAR == 21
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, fe

    capture drop xb_fe_pu_full yhat_fe_pu_full
    predict xb_fe_pu_full, xb

    roctab pob_monetaria xb_fe_pu_full
    scalar AUC_FE_PU_FULL   = r(area)

    gen byte yhat_fe_pu_full = xb_fe_pu_full >= 0
    tab pob_monetaria yhat_fe_pu_full, matcell(MFE_PU_FULL)

    scalar TP_FE_PU_FULL = MFE_PU_FULL[2,2]
    scalar FP_FE_PU_FULL = MFE_PU_FULL[1,2]
    scalar FN_FE_PU_FULL = MFE_PU_FULL[2,1]
    scalar TN_FE_PU_FULL = MFE_PU_FULL[1,1]

    scalar SENS_FE_PU_FULL = TP_FE_PU_FULL / (TP_FE_PU_FULL + FN_FE_PU_FULL)
    scalar SPEC_FE_PU_FULL = TN_FE_PU_FULL / (TN_FE_PU_FULL + FP_FE_PU_FULL)
restore


*-------------------------*
* 3.2.2 Puno panel puro 2018–2022
*-------------------------*
preserve
    keep if hpan1822 == 1 & $DEPVAR == 21
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, fe

    capture drop xb_fe_pu_p1822 yhat_fe_pu_p1822
    predict xb_fe_pu_p1822, xb

    roctab pob_monetaria xb_fe_pu_p1822
    scalar AUC_FE_PU_P1822   = r(area)

    gen byte yhat_fe_pu_p1822 = xb_fe_pu_p1822 >= 0
    tab pob_monetaria yhat_fe_pu_p1822, matcell(MFE_PU_P1822)

    scalar TP_FE_PU_P1822 = MFE_PU_P1822[2,2]
    scalar FP_FE_PU_P1822 = MFE_PU_P1822[1,2]
    scalar FN_FE_PU_P1822 = MFE_PU_P1822[2,1]
    scalar TN_FE_PU_P1822 = MFE_PU_P1822[1,1]

    scalar SENS_FE_PU_P1822 = TP_FE_PU_P1822 / (TP_FE_PU_P1822 + FN_FE_PU_P1822)
    scalar SPEC_FE_PU_P1822 = TN_FE_PU_P1822 / (TN_FE_PU_P1822 + FP_FE_PU_P1822)
restore


*-------------------------*
* 3.2.3 Puno panel puro 2020–2022
*-------------------------*
preserve
    keep if hpan2022 == 1 & $DEPVAR == 21
    xtset idhogar year

    quietly xtlogit pob_monetaria $Xcore, fe

    capture drop xb_fe_pu_p2022 yhat_fe_pu_p2022
    predict xb_fe_pu_p2022, xb

    roctab pob_monetaria xb_fe_pu_p2022
    scalar AUC_FE_PU_P2022   = r(area)

    gen byte yhat_fe_pu_p2022 = xb_fe_pu_p2022 >= 0
    tab pob_monetaria yhat_fe_pu_p2022, matcell(MFE_PU_P2022)

    scalar TP_FE_PU_P2022 = MFE_PU_P2022[2,2]
    scalar FP_FE_PU_P2022 = MFE_PU_P2022[1,2]
    scalar FN_FE_PU_P2022 = MFE_PU_P2022[2,1]
    scalar TN_FE_PU_P2022 = MFE_PU_P2022[1,1]

    scalar SENS_FE_PU_P2022 = TP_FE_PU_P2022 / (TP_FE_PU_P2022 + FN_FE_PU_P2022)
    scalar SPEC_FE_PU_P2022 = TN_FE_PU_P2022 / (TN_FE_PU_P2022 + FP_FE_PU_P2022)
restore


* Matriz resumen PUNO
matrix POWER_PUNO = ///
    (AUC_FE_PU_FULL,   SENS_FE_PU_FULL,   SPEC_FE_PU_FULL \ ///
     AUC_FE_PU_P1822,  SENS_FE_PU_P1822,  SPEC_FE_PU_P1822 \ ///
     AUC_FE_PU_P2022,  SENS_FE_PU_P2022,  SPEC_FE_PU_P2022)

matrix rownames POWER_PUNO = "Puno_18_22_full" "Puno_pan_18_22" "Puno_pan_20_22"
matrix colnames POWER_PUNO = "AUC" "Sens" "Spec"

* Puedes revisar así:
matrix list POWER_PERU
matrix list POWER_PUNO
