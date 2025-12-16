***************************************
****###   0. Directorios  		###****
***************************************
clear all
set more off

*************************************
****** DIRECTORIOS DE TRABAJO *******
*************************************
glo mod01      "F:\ENAHO\001 BASES\PANEL\001 car_vivien_hogar"
glo mod02      "F:\ENAHO\001 BASES\PANEL\002 car_mhogar"
glo mod03      "F:\ENAHO\001 BASES\PANEL\003 educacion"
glo mod04      "F:\ENAHO\001 BASES\PANEL\004 salud"
glo mod05      "F:\ENAHO\001 BASES\PANEL\005 empleo_ingresos"
glo mod06      "F:\ENAHO\001 BASES\PANEL\034 sumarias"

*glo maestria   "C:\Users\CI-EPG-THONY\OneDrive\MI TESIS EPG MASTER\MAESTRIA\002 BASE DE DATOS"
glo maestria  	"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA\002 BASE DE DATOS"
glo tempo      "$maestria\001 TEMP"
glo dclea      "$maestria\002 CLEAN"
glo dofil      "$maestria\001 DOFILES"
glo tabyfig		"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA\005 TABLAS Y CUADROS"


cd "$tabyfig"
************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – Toda la data (2018–2022) y paneles puros
************************************************************
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
gen es_pea_=(ocu500_==1)
	recode sec_ocu_ (. = 12)
	recode limitacion_ (. = 1)

	gen trab_informa=( ocupinf_ ==1)
	gen sec_agricola=(sec_ocu_==1)
gen es_casado=(ecivil_ ==2)	
gen log_inghog2d_=log(inghog2d_)


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

**# PERÚ: MODELOS – PANEL 2020–2022 #
xtset idhogar year
gen Lpobre = L.pob_monetaria

***1. Modelos (coeficientes)

*--------------------------------------------------------------*
*   MODELOS – PANEL 2020–2022
*--------------------------------------------------------------*
global X_static log_inghog2d_ totmieho_ internet_ es_casado es_pea_ trab_informa
*******************************
*** Modelo RE
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1, re vce(cluster idhogar) nolog
estimates store RE_PE_2022

outreg2 [RE_PE_2022] using "coef_peru_2020_22.doc", replace dec(4) ///
    ctitle("RE 2020–22") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo PA
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1, pa vce(robust) nolog
estimates store PA_PE_2022

outreg2 [PA_PE_2022] using "coef_peru_2020_22.doc", append dec(4) ///
    ctitle("PA 2020–22") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2))


*******************************
*** Modelo FE
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1, fe nolog
estimates store PA_PE_2022

outreg2 [PA_PE_2022] using "coef_peru_2020_22.doc", append dec(4) ///
    ctitle("FE 2020–22") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo Dinámico (RE + L.y)
*******************************
xtlogit pob_monetaria L.pob_monetaria $X_static if hpan2022==1, re vce(cluster idhogar) nolog
estimates store DYN_PE_2022

outreg2 [DYN_PE_2022] using "coef_peru_2020_22.doc", append dec(4) ///
    ctitle("RE Dinámico 2020–22") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))

**2. AME (Marginal Effects)

*--------------------------------------------------------------*
*        EFECTOS MARGINALES – PANEL 2020–2022
*--------------------------------------------------------------*

*******************************
*** AME RE
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1, re vce(cluster idhogar) nolog
margins, dydx(*) post
estimates store M_RE_PE_2022

outreg2 [M_RE_PE_2022] using "margins_peru_2020_22.doc", replace dec(6) ///
    ctitle("AME RE 2020–22")


*******************************
*** AME PA
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1, pa vce(robust) nolog
margins, dydx(*) predict(mu) post
estimates store M_PA_PE_2022

outreg2 [M_PA_PE_2022] using "margins_peru_2020_22.doc", append dec(6) ///
    ctitle("AME PA 2020–22")


*******************************
*** AME FE (usando MFX)
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1, fe nolog
margins, dydx(*) 
estimates store M_FE_PE_2022

outreg2 [M_FE_PE_2022] using "margins_peru_2020_22.doc", append dec(6) ///
    ctitle("AME FE 2020–22")


*******************************
*** AME Dinámico
*******************************
xtlogit pob_monetaria Lpobre $X_static if hpan2022==1, re vce(cluster idhogar) nolog
margins, dydx(*)  
estimates store M_DYN_PE_2022

outreg2 [M_DYN_PE_2022] using "margins_peru_2020_22.doc", append dec(6) ///
    ctitle("AME Dinámico 2020–22")

********END***************

**# PERÚ: MODELOS – PANEL 2018–2022 #

***1. Modelos (coeficientes)
*--------------------------------------------------------------*
*   MODELOS – PANEL 2018–2022
*--------------------------------------------------------------*
xtset idhogar year
global X_static log_inghog2d_ totmieho_ internet_ es_casado es_pea_ trab_informa 

*******************************
*** Modelo RE
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1, re vce(cluster idhogar) nolog
estimates store RE_PE_1822 

outreg2 [RE_PE_1822] using "coef_peru_1822.doc", replace dec(4) ///
    ctitle("RE 1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo PA
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1, pa vce(robust) nolog
estimates store PA_PE_1822

outreg2 [PA_PE_1822] using "coef_peru_1822.doc", append dec(4) ///
    ctitle("PA 1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2))


*******************************
*** Modelo FE
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1, fe nolog
estimates store PA_PE_1822

outreg2 [PA_PE_1822] using "coef_peru_1822.doc", append dec(4) ///
    ctitle("FE 1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo Dinámico (RE + L.y)
*******************************
xtlogit pob_monetaria L.pob_monetaria $X_static if hpan2022==1, re vce(cluster idhogar) nolog
estimates store DYN_PE_1822

outreg2 [DYN_PE_1822] using "coef_peru_1822.doc", append dec(4) ///
    ctitle("RE Dinámico 1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))

**2. AME (Marginal Effects)

*--------------------------------------------------------------*
*        EFECTOS MARGINALES – PANEL 2018–2022
*--------------------------------------------------------------*

*******************************
*** AME RE
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1, re vce(cluster idhogar) nolog
margins, dydx(*) post
estimates store M_RE_PE_1822

outreg2 [M_RE_PE_1822] using "margins_peru_1822.doc", replace dec(6) ///
    ctitle("AME RE 1822")


*******************************
*** AME PA
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1, pa vce(robust) nolog
margins, dydx(*) predict(mu) post
estimates store M_PA_PE_1822

outreg2 [M_PA_PE_1822] using "margins_peru_1822.doc", append dec(6) ///
    ctitle("AME PA 1822")


*******************************
*** AME FE (usando MFX)
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1, fe nolog
margins, dydx(*) 
estimates store M_FE_PE_1822

outreg2 [M_FE_PE_1822] using "margins_peru_1822.doc", append dec(6) ///
    ctitle("AME FE 1822")


*******************************
*** AME Dinámico
*******************************
xtlogit pob_monetaria Lpobre $X_static if hpan1822==1, re vce(cluster idhogar) nolog
margins, dydx(*) 
estimates store M_DYN_PE_1822

outreg2 [M_DYN_PE_1822] using "margins_peru_1822.doc", append dec(6) ///
    ctitle("AME Dinámico 1822")

********END***************

**# PERÚ: MODELOS – TODO PANEL #3

***1. Modelos (coeficientes)

*--------------------------------------------------------------*
*   MODELOS – TODO PANEL
*--------------------------------------------------------------*
xtset idhogar year
global X_static log_inghog2d_ totmieho_ internet_ es_casado es_pea_ trab_informa

*******************************
*** Modelo RE
*******************************
xtlogit pob_monetaria $X_static , re vce(cluster idhogar) nolog
estimates store RE_PE_A1822

outreg2 [RE_PE_A1822] using "coef_peru_A1822.doc", replace dec(4) ///
    ctitle("RE A1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo PA
*******************************
xtlogit pob_monetaria $X_static , pa vce(robust) nolog
estimates store PA_PE_A1822

outreg2 [PA_PE_A1822] using "coef_peru_A1822.doc", append dec(4) ///
    ctitle("PA A1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2))


*******************************
*** Modelo FE
*******************************
xtlogit pob_monetaria $X_static , fe nolog
estimates store PA_PE_A1822

outreg2 [PA_PE_A1822] using "coef_peru_A1822.doc", append dec(4) ///
    ctitle("FE A1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo Dinámico (RE + L.y)
*******************************
xtlogit pob_monetaria L.pob_monetaria $X_static , re vce(cluster idhogar) nolog
estimates store DYN_PE_A1822

outreg2 [DYN_PE_A1822] using "coef_peru_A1822.doc", append dec(4) ///
    ctitle("RE Dinámico A1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))

**2. AME (Marginal Effects)

*--------------------------------------------------------------*
*        EFECTOS MARGINALES – PANEL 2020–2022
*--------------------------------------------------------------*

*******************************
*** AME RE
*******************************
xtlogit pob_monetaria $X_static , re vce(cluster idhogar) nolog
margins, dydx(*) post
estimates store M_RE_PE_A1822

outreg2 [M_RE_PE_A1822] using "margins_peru_A1822.doc", replace dec(6) ///
    ctitle("AME RE A1822")


*******************************
*** AME PA
*******************************
xtlogit pob_monetaria $X_static , pa vce(robust) nolog
margins, dydx(*) predict(mu) post
estimates store M_PA_PE_A1822

outreg2 [M_PA_PE_A1822] using "margins_peru_A1822.doc", append dec(6) ///
    ctitle("AME PA A1822")


*******************************
*** AME FE (usando MFX)
*******************************
xtlogit pob_monetaria $X_static , fe nolog
margins, dydx(*) 
estimates store M_FE_PE_A1822

outreg2 [M_FE_PE_A1822] using "margins_peru_A1822.doc", append dec(6) ///
    ctitle("AME FE A1822")


*******************************
*** AME Dinámico
*******************************
xtlogit pob_monetaria Lpobre $X_static , re vce(cluster idhogar) nolog
margins, dydx(*)  
estimates store M_DYN_PE_A1822

outreg2 [M_DYN_PE_A1822] using "margins_peru_A1822.doc", append dec(6) ///
    ctitle("AME Dinámico A1822")

********END***************

**# PUNO: MODELOS – PANEL 2020–2022 #
xtset idhogar year

***1. Modelos (coeficientes)

*--------------------------------------------------------------*
*   MODELOS – PANEL 2020–2022
*--------------------------------------------------------------*
global X_static log_inghog2d_ totmieho_ internet_ es_casado es_pea_ trab_informa
*******************************
*** Modelo RE
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1 & dpto_==21, re vce(cluster idhogar) nolog
estimates store RE_PUNO_2022

outreg2 [RE_PUNO_2022] using "coef_PUNO_2020_22.doc", replace dec(4) ///
    ctitle("RE 2020–22") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo PA
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1 & dpto_==21, pa vce(robust) nolog
estimates store PA_PUNO_2022

outreg2 [PA_PUNO_2022] using "coef_PUNO_2020_22.doc", append dec(4) ///
    ctitle("PA 2020–22") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2))


*******************************
*** Modelo FE
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1 & dpto_==21, fe nolog
estimates store PA_PUNO_2022

outreg2 [PA_PUNO_2022] using "coef_PUNO_2020_22.doc", append dec(4) ///
    ctitle("FE 2020–22") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo Dinámico (RE + L.y)
*******************************
xtlogit pob_monetaria L.pob_monetaria $X_static if hpan2022==1 & dpto_==21, re vce(cluster idhogar) nolog
estimates store DYN_PUNO_2022

outreg2 [DYN_PUNO_2022] using "coef_PUNO_2020_22.doc", append dec(4) ///
    ctitle("RE Dinámico 2020–22") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))

**2. AME (Marginal Effects)

*--------------------------------------------------------------*
*        EFECTOS MARGINALES – PANEL 2020–2022
*--------------------------------------------------------------*

*******************************
*** AME RE
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1 & dpto_==21, re vce(cluster idhogar) nolog
margins, dydx(*) post
estimates store M_RE_PUNO_2022

outreg2 [M_RE_PUNO_2022] using "margins_PUNO_2020_22.doc", replace dec(6) ///
    ctitle("AME RE 2020–22")


*******************************
*** AME PA
******************************* 
xtlogit pob_monetaria $X_static if hpan2022==1 & dpto_==21, pa vce(robust) nolog
margins, dydx(*) predict(mu) post
estimates store M_PA_PUNO_2022

outreg2 [M_PA_PUNO_2022] using "margins_PUNO_2020_22.doc", append dec(6) ///
    ctitle("AME PA 2020–22")


*******************************
*** AME FE (usando MFX)
*******************************
xtlogit pob_monetaria $X_static if hpan2022==1 & dpto_==21, fe nolog
margins, dydx(*) 
estimates store M_FE_PUNO_2022

outreg2 [M_FE_PUNO_2022] using "margins_PUNO_2020_22.doc", append dec(6) ///
    ctitle("AME FE 2020–22")


*******************************
*** AME Dinámico
*******************************
xtlogit pob_monetaria Lpobre $X_static if hpan2022==1 & dpto_==21, re vce(cluster idhogar) nolog
margins, dydx(*) 
estimates store M_DYN_PUNO_2022

outreg2 [M_DYN_PUNO_2022] using "margins_PUNO_2020_22.doc", append dec(6) ///
    ctitle("AME Dinámico 2020–22")

********END***************

**# PUNO: MODELOS – PANEL 2018–2022 #

***1. Modelos (coeficientes)
*--------------------------------------------------------------*
*   MODELOS – PANEL 2018–2022
*--------------------------------------------------------------*
xtset idhogar year
global X_static log_inghog2d_ totmieho_ internet_ es_casado es_pea_ trab_informa

*******************************
*** Modelo RE
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1 & dpto_==21, re vce(cluster idhogar) nolog
estimates store RE_PUNO_1822

outreg2 [RE_PUNO_1822] using "coef_PUNO_1822.doc", replace dec(4) ///
    ctitle("RE 1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo PA
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1 & dpto_==21, pa vce(robust) nolog
estimates store PA_PUNO_1822

outreg2 [PA_PUNO_1822] using "coef_PUNO_1822.doc", append dec(4) ///
    ctitle("PA 1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2))


*******************************
*** Modelo FE
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1 & dpto_==21, fe nolog
estimates store PA_PUNO_1822

outreg2 [PA_PUNO_1822] using "coef_PUNO_1822.doc", append dec(4) ///
    ctitle("FE 1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo Dinámico (RE + L.y)
*******************************
xtlogit pob_monetaria L.pob_monetaria $X_static if hpan2022==1 & dpto_==21, re vce(cluster idhogar) nolog
estimates store DYN_PUNO_1822

outreg2 [DYN_PUNO_1822] using "coef_PUNO_1822.doc", append dec(4) ///
    ctitle("RE Dinámico 1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))

**2. AME (Marginal Effects)

*--------------------------------------------------------------*
*        EFECTOS MARGINALES – PANEL 2018–2022
*--------------------------------------------------------------*

*******************************
*** AME RE
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1 & dpto_==21, re vce(cluster idhogar) nolog
margins, dydx(*) post
estimates store M_RE_PUNO_1822

outreg2 [M_RE_PUNO_1822] using "margins_PUNO_1822.doc", replace dec(6) ///
    ctitle("AME RE 1822")


*******************************
*** AME PA
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1 & dpto_==21, pa vce(robust) nolog
margins, dydx(*) predict(mu) post
estimates store M_PA_PUNO_1822

outreg2 [M_PA_PUNO_1822] using "margins_PUNO_1822.doc", append dec(6) ///
    ctitle("AME PA 1822")


*******************************
*** AME FE (usando MFX)
*******************************
xtlogit pob_monetaria $X_static if hpan1822==1 & dpto_==21, fe nolog
margins, dydx(*)  
estimates store M_FE_PUNO_1822

outreg2 [M_FE_PUNO_1822] using "margins_PUNO_1822.doc", append dec(6) ///
    ctitle("AME FE 1822")


*******************************
*** AME Dinámico
*******************************
xtlogit pob_monetaria Lpobre $X_static if hpan1822==1 & dpto_==21, re vce(cluster idhogar) nolog
margins, dydx(*) 
estimates store M_DYN_PUNO_1822

outreg2 [M_DYN_PUNO_1822] using "margins_PUNO_1822.doc", append dec(6) ///
    ctitle("AME Dinámico 1822")

********END***************

**# PUNO: MODELOS – TODO PANEL #3

***1. Modelos (coeficientes)

*--------------------------------------------------------------*
*   MODELOS – TODO PANEL
*--------------------------------------------------------------*
xtset idhogar year
global X_static log_inghog2d_ totmieho_ internet_ es_casado es_pea_ trab_informa

*******************************
*** Modelo RE
*******************************
xtlogit pob_monetaria $X_static if dpto_==21, re vce(cluster idhogar) nolog
estimates store RE_PUNO_A1822

outreg2 [RE_PUNO_A1822] using "coef_PUNO_A1822.doc", replace dec(4) ///
    ctitle("RE A1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo PA
*******************************
xtlogit pob_monetaria $X_static if dpto_==21, pa vce(robust) nolog
estimates store PA_PUNO_A1822

outreg2 [PA_PUNO_A1822] using "coef_PUNO_A1822.doc", append dec(4) ///
    ctitle("PA A1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2))


*******************************
*** Modelo FE
*******************************
xtlogit pob_monetaria $X_static if dpto_==21 , fe nolog
estimates store PA_PUNO_A1822

outreg2 [PA_PUNO_A1822] using "coef_PUNO_A1822.doc", append dec(4) ///
    ctitle("FE A1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))


*******************************
*** Modelo Dinámico (RE + L.y)
*******************************
xtlogit pob_monetaria L.pob_monetaria $X_static if dpto_==21 , re vce(cluster idhogar) nolog
estimates store DYN_PUNO_A1822

outreg2 [DYN_PUNO_A1822] using "coef_PUNO_A1822.doc", append dec(4) ///
    ctitle("RE Dinámico A1822") addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log pseudolikelihood", e(ll))

**2. AME (Marginal Effects)

**#*******EFECTOS MARGINALES #5

*--------------------------------------------------------------*
*        PERU: EFECTOS MARGINALES – PANEL 2020–2022
*--------------------------------------------------------------*

*******************************
*** AME RE
*******************************
xtlogit pob_monetaria $X_static  if dpto_==21, re vce(cluster idhogar) nolog
margins, dydx(*) post
estimates store M_RE_PUNO_A1822

outreg2 [M_RE_PUNO_A1822] using "margins_PUNO_A1822.doc", replace dec(6) ///
    ctitle("AME RE A1822")


*******************************
*** AME PA
*******************************
xtlogit pob_monetaria $X_static if dpto_==21, pa vce(robust) nolog
margins, dydx(*) predict(mu) post
estimates store M_PA_PUNO_A1822

outreg2 [M_PA_PUNO_A1822] using "margins_PUNO_A1822.doc", append dec(6) ///
    ctitle("AME PA A1822")


*******************************
*** AME FE (usando MFX)
*******************************
xtlogit pob_monetaria $X_static if dpto_==21, fe nolog
margins, dydx(*) 
estimates store M_FE_PUNO_A1822

outreg2 [M_FE_PUNO_A1822] using "margins_PUNO_A1822.doc", append dec(6) ///
    ctitle("AME FE A1822")


*******************************
*** AME Dinámico
*******************************
xtlogit pob_monetaria Lpobre $X_static if dpto_==21, re vce(cluster idhogar) nolog
margins, dydx(*) 
estimates store M_DYN_PUNO_A1822

outreg2 [M_DYN_PUNO_A1822] using "margins_PUNO_A1822.doc", append dec(6) ///
    ctitle("AME Dinámico A1822")

********END***************