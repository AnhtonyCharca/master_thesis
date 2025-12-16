**modelo logit multinomial

*******************************************************
* DO-FILE: Evaluación predictiva de modelos logit dinámicos
* Modelos: Perú/Puno – Panel 2020–2022 y pseudo-panel 2018–2022
* Salidas: Accuracy, Sensibilidad, Especificidad, AUC y curvas ROC
*******************************************************

clear all
set more off

*------------------------------------------------------*
* 1. Cargar base y declarar panel
*------------------------------------------------------*
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
glo graficos		"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA\008 GRAFICOS"

cd "$tabyfig"
************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – Toda la data (2018–2022) y paneles puros
************************************************************
*-----------------------------------------------------------*
* 0. CARGA DE BASE Y CONFIGURACIÓN GENERAL
*-----------------------------------------------------------*

use "$dclea/pobreza_panel_18-22_full.dta", clear


*----------pobre_integrada ------------------------------------------*
* 1. Bloque de do-file para el Objetivo 2 (pobreza integrada)        *
*--------------------------------------------------------------------*
/*
Supuestos previos

Ya tienes:

Panel ENAHO:

hpan2022 == 1 → panel 2020–2022

hpan1822 == 1 → pseudo panel 2018–2022
*/
***Panel definido:
xtset idhogar year

*Regressoras:
global X_static log_inghog2d_ totmieho_ internet_ trab_informa

*Dependiente multinomial (4 categorías):
* 1 = Crónicos (monetaria y multidimensional)
* 2 = Estructurales (solo multidimensional)
* 3 = Coyunturales (solo monetaria)
* 4 = Integrados (no pobres)

**# 1.1. PERÚ – Panel 2020–2022
*============================================================*
* OBJETIVO ESPECÍFICO 3 – POBREZA INTEGRADA (MULTINOMIAL)
* PERÚ – PANEL 2020–2022
*============================================================*

xtset idhogar year
global X_static log_inghog2d_ totmieho_ internet_ trab_informa

*--------------------------------------------------------------*
* 1. MODELOS (COEFICIENTES) – PERÚ 2020–2022
*--------------------------------------------------------------*

*******************************
*** 1.1. Modelo Pooled (mlogit)
*******************************
mlogit pobre_integrada $X_static if hpan2022==1, ///
    baseoutcome(4) vce(cluster idhogar)
estimates store MLOGIT_POOL_PE_2022

outreg2 [MLOGIT_POOL_PE_2022] using "coef_multinomial_peru_2020_22.doc", ///
    replace dec(4) ctitle("Pooled 2020–22") addstat("N", e(N), "LR chi2", e(chi2) )

*******************************
*** 1.2. Modelo Panel RE (xtmlogit)
*******************************
xtmlogit pobre_integrada $X_static if hpan2022==1, ///
    re baseoutcome(4) vce(cluster idhogar) nolog
estimates store MLOGIT_RE_PE_2022

outreg2 [MLOGIT_RE_PE_2022] using "coef_multinomial_peru_2020_22.doc", ///
    append dec(4) ctitle("RE 2020–22") addstat("N", e(N), "Hogares", e(N_g), ///
    "Wald chi2", e(chi2), "Log likelihood", e(ll))

*--------------------------------------------------------------*
* 2. EFECTOS MARGINALES – PERÚ 2020–2022
*--------------------------------------------------------------*

*******************************
*** 2.1. Probabilidades predichas por outcome
*******************************
predict phat_cron   if e(sample), outcome(1)
predict phat_estr   if e(sample), outcome(2)
predict phat_coy    if e(sample), outcome(3)
predict phat_integ  if e(sample), outcome(4)

label var phat_cron  "Pr(Crónico)"
label var phat_estr  "Pr(Estructural)"
label var phat_coy   "Pr(Coyuntural)"
label var phat_integ "Pr(Integrado)"

*******************************
*** 2.2. Efectos marginales por categoría
*** (sobre el modelo RE, que es el principal)
*******************************
* Volver a llamar resultados RE (por si se hizo algo después)
estimates restore MLOGIT_RE_PE_2022

* AME para cada outcome
margins, dydx($X_static) predict(outcome(1))
estimates store M_RE_PE_2022_O1

margins, dydx($X_static) predict(outcome(2))
estimates store M_RE_PE_2022_O2

margins, dydx($X_static) predict(outcome(3))
estimates store M_RE_PE_2022_O3

margins, dydx($X_static) predict(outcome(4))
estimates store M_RE_PE_2022_O4

outreg2 [M_RE_PE_2022_O1 M_RE_PE_2022_O2 M_RE_PE_2022_O3 M_RE_PE_2022_O4] ///
    using "margins_multinomial_peru_2020_22.doc", replace dec(6) ///
    ctitle("AME RE – O1 Crón" "AME RE – O2 Estr" "AME RE – O3 Coy" "AME RE – O4 Int")

**# 1.2. PERÚ – Pseudo panel 2018–2022 #2
*============================================================*
* PERÚ – PSEUDO PANEL 2018–2022
*============================================================*

xtset idhogar year

*-----------------------------*
* 1. Modelos (coeficientes)
*-----------------------------*

*******************************
*** 1.1. Modelo Pooled
*******************************
mlogit pobre_integrada $X_static if hpan1822==1, ///
    baseoutcome(4) vce(cluster idhogar)
estimates store MLOGIT_POOL_PE_1822

outreg2 [MLOGIT_POOL_PE_1822] using "coef_multinomial_peru_1822.doc", ///
    replace dec(4) ctitle("Pooled 2018–22") addstat("N", e(N), "LR chi2", e(chi2))

*******************************
*** 1.2. Modelo Panel RE
*******************************
xtmlogit pobre_integrada $X_static if hpan1822==1, ///
    re baseoutcome(4) vce(cluster idhogar) nolog
estimates store MLOGIT_RE_PE_1822

outreg2 [MLOGIT_RE_PE_1822] using "coef_multinomial_peru_1822.doc", ///
    append dec(4) ctitle("RE 2018–22") addstat("N", e(N), "Hogares", e(N_g), ///
    "Wald chi2", e(chi2), "Log likelihood", e(ll))

*-----------------------------*
* 2. AME – Pseudo panel
*-----------------------------*
estimates restore MLOGIT_RE_PE_1822

margins, dydx($X_static) predict(outcome(1))
estimates store M_RE_PE_1822_O1

margins, dydx($X_static) predict(outcome(2))
estimates store M_RE_PE_1822_O2

margins, dydx($X_static) predict(outcome(3))
estimates store M_RE_PE_1822_O3

margins, dydx($X_static) predict(outcome(4))
estimates store M_RE_PE_1822_O4

outreg2 [M_RE_PE_1822_O1 M_RE_PE_1822_O2 M_RE_PE_1822_O3 M_RE_PE_1822_O4] ///
    using "margins_multinomial_peru_1822.doc", replace dec(6) ///
    ctitle("AME RE – O1 Crón" "AME RE – O2 Estr" "AME RE – O3 Coy" "AME RE – O4 Int")

**# 1.3. PUNO – Panel 2020–2022 y pseudo-panel 2018–2022 #3
*============================================================*
* PUNO – PANEL 2020–2022 (dpto_==21)
*============================================================*

xtset idhogar year

*******************************
*** 1. Modelo Pooled – PUNO
*******************************
mlogit pobre_integrada $X_static if hpan2022==1 & dpto_==21, ///
    baseoutcome(4) vce(cluster idhogar)
estimates store MLOGIT_POOL_PU_2022

outreg2 [MLOGIT_POOL_PU_2022] using "coef_multinomial_PUNO_2020_22.doc", ///
    replace dec(4) ctitle("Pooled PUNO 2020–22") ///
    addstat("N", e(N), "LR chi2", e(chi2))

*******************************
*** 2. Modelo RE – PUNO
*******************************
xtmlogit pobre_integrada $X_static if hpan2022==1 & dpto_==21, ///
    re baseoutcome(4) vce(cluster idhogar) nolog
estimates store MLOGIT_RE_PU_2022

outreg2 [MLOGIT_RE_PU_2022] using "coef_multinomial_PUNO_2020_22.doc", ///
    append dec(4) ctitle("RE PUNO 2020–22") ///
    addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log likelihood", e(ll))

* AME – PUNO 2020–22
estimates restore MLOGIT_RE_PU_2022

margins, dydx($X_static) predict(outcome(1))
estimates store M_RE_PU_2022_O1

margins, dydx($X_static) predict(outcome(2))
estimates store M_RE_PU_2022_O2

margins, dydx($X_static) predict(outcome(3))
estimates store M_RE_PU_2022_O3

margins, dydx($X_static) predict(outcome(4))
estimates store M_RE_PU_2022_O4

outreg2 [M_RE_PU_2022_O1 M_RE_PU_2022_O2 M_RE_PU_2022_O3 M_RE_PU_2022_O4] ///
    using "margins_multinomial_PUNO_2020_22.doc", replace dec(6) ///
    ctitle("AME RE – O1 Crón" "AME RE – O2 Estr" "AME RE – O3 Coy" "AME RE – O4 Int")


*============================================================*
* PUNO – PSEUDO PANEL 2018–2022
*============================================================*

*******************************
*** 1. Modelos – PUNO 2018–22
*******************************
mlogit pobre_integrada $X_static if hpan1822==1 & dpto_==21, ///
    baseoutcome(4) vce(cluster idhogar)
estimates store MLOGIT_POOL_PU_1822

outreg2 [MLOGIT_POOL_PU_1822] using "coef_multinomial_PUNO_1822.doc", ///
    replace dec(4) ctitle("Pooled PUNO 2018–22") ///
    addstat("N", e(N), "LR chi2", e(chi2))

xtmlogit pobre_integrada $X_static if hpan1822==1 & dpto_==21, ///
    re baseoutcome(4) vce(cluster idhogar) nolog
estimates store MLOGIT_RE_PU_1822

outreg2 [MLOGIT_RE_PU_1822] using "coef_multinomial_PUNO_1822.doc", ///
    append dec(4) ctitle("RE PUNO 2018–22") ///
    addstat("N", e(N), "Hogares", e(N_g), "Wald chi2", e(chi2), "Log likelihood", e(ll))

* AME – PUNO 2018–22
estimates restore MLOGIT_RE_PU_1822

margins, dydx($X_static) predict(outcome(1))
estimates store M_RE_PU_1822_O1

margins, dydx($X_static) predict(outcome(2))
estimates store M_RE_PU_1822_O2

margins, dydx($X_static) predict(outcome(3))
estimates store M_RE_PU_1822_O3

margins, dydx($X_static) predict(outcome(4))
estimates store M_RE_PU_1822_O4

outreg2 [M_RE_PU_1822_O1 M_RE_PU_1822_O2 M_RE_PU_1822_O3 M_RE_PU_1822_O4] ///
    using "margins_multinomial_PUNO_1822.doc", replace dec(6) ///
    ctitle("AME RE – O1 Crón" "AME RE – O2 Estr" "AME RE – O3 Coy" "AME RE – O4 Int")
	




