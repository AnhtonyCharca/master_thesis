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

cd "$graficos"
************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – Toda la data (2018–2022) y paneles puros
************************************************************
*-----------------------------------------------------------*
* 0. CARGA DE BASE Y CONFIGURACIÓN GENERAL
*-----------------------------------------------------------*

use "$dclea/pobreza_panel_18-22_full.dta", clear



*----------------------------------------------------*
* 0. Configuración previa                            *
*----------------------------------------------------*
xtset idhogar year
global X_static log_inghog2d_ totmieho_ internet_ es_casado es_pea_ trab_informa

* Asegurarse de tener Lpobre creado
capture confirm variable Lpobre
if _rc {
    gen Lpobre = L.pob_monetaria
}
****************
* Limpiar predicciones previas
capture drop phat_*
capture drop yhat_*

*------------------------------------------------------*
* 3. FUNCIONES AUXILIARES: CLASIFICACIÓN Y AUC
*------------------------------------------------------*
* NOTA: estat classification y lroc NO son compatibles con xtlogit;
*       por ello se calculan manualmente (tabulate + roctab).

*------------------------------------------------------*
* 4. MODELO 1: Perú – Panel 2020–2022 (hpan2022==1)
*------------------------------------------------------*
xtlogit pob_monetaria Lpobre $X_static if hpan2022==1, re vce(cluster idhogar) nolog

* Probabilidades predichas
predict phat_PE_P2022 if hpan2022==1, pr

* Clasificación (cutoff 0,50)
capture drop yhat_PE_P2022
gen yhat_PE_P2022 = (phat_PE_P2022 >= 0.5) if !missing(phat_PE_P2022)

tabulate pob_monetaria yhat_PE_P2022 if hpan2022==1, matcell(M1)

scalar acc_PE_P2022  = (M1[1,1] + M1[2,2]) / (M1[1,1] + M1[1,2] + M1[2,1] + M1[2,2])
scalar sens_PE_P2022 = M1[2,2] / (M1[2,1] + M1[2,2])
scalar esp_PE_P2022  = M1[1,1] / (M1[1,1] + M1[1,2])

* Curva ROC y AUC
roctab pob_monetaria phat_PE_P2022 if hpan2022==1, graph ///
    title("Perú: Panel 2020–2022", size(vtiny)) ///
    name(roc_PE_P2022, replace)
scalar auc_PE_P2022 = r(area)

*------------------------------------------------------*
* 5. MODELO 2: Perú – Pseudo-panel 2018–2022 (toda la muestra)
*------------------------------------------------------*
xtlogit pob_monetaria Lpobre $X_static, re vce(cluster idhogar) nolog

* Probabilidades predichas
predict phat_PE_A1822, pr

* Clasificación (cutoff 0,50)
capture drop yhat_PE_A1822
gen yhat_PE_A1822 = (phat_PE_A1822 >= 0.5) if !missing(phat_PE_A1822)

tabulate pob_monetaria yhat_PE_A1822, matcell(M2)

scalar acc_PE_A1822  = (M2[1,1] + M2[2,2]) / (M2[1,1] + M2[1,2] + M2[2,1] + M2[2,2])
scalar sens_PE_A1822 = M2[2,2] / (M2[2,1] + M2[2,2])
scalar esp_PE_A1822  = M2[1,1] / (M2[1,1] + M2[1,2])

	
	roctab pob_monetaria phat_PE_A1822, graph ///
    title("Perú: Pseudo-panel 2018–2022" , size(medsmall)) ///
    name(roc_PE_A1822, replace) ///
    lwidth(vthin) lcolor(navy)
	
scalar auc_PE_A1822 = r(area)

*------------------------------------------------------*
* 6. MODELO 3: Puno – Panel 2020–2022 (hpan2022==1 & dpto_==21)
*------------------------------------------------------*
xtlogit pob_monetaria Lpobre $X_static if hpan2022==1 & dpto_==21, ///
    re vce(cluster idhogar) nolog

* Probabilidades predichas
predict phat_PU_P2022 if hpan2022==1 & dpto_==21, pr

* Clasificación (cutoff 0,50)
capture drop yhat_PU_P2022
gen yhat_PU_P2022 = (phat_PU_P2022 >= 0.5) if !missing(phat_PU_P2022)

tabulate pob_monetaria yhat_PU_P2022 if hpan2022==1 & dpto_==21, matcell(M3)

scalar acc_PU_P2022  = (M3[1,1] + M3[2,2]) / (M3[1,1] + M3[1,2] + M3[2,1] + M3[2,2])
scalar sens_PU_P2022 = M3[2,2] / (M3[2,1] + M3[2,2])
scalar esp_PU_P2022  = M3[1,1] / (M3[1,1] + M3[1,2])

* Curva ROC y AUC
roctab pob_monetaria phat_PU_P2022 if hpan2022==1 & dpto_==21, graph ///
    title("Puno: Panel 2020–2022", size(medium)) ///
    name(roc_PU_P2022, replace)
scalar auc_PU_P2022 = r(area)

*------------------------------------------------------*
* 7. MODELO 4: Puno – Pseudo-panel 2018–2022 (dpto_==21)
*------------------------------------------------------*
xtlogit pob_monetaria Lpobre $X_static if dpto_==21, ///
    re vce(cluster idhogar) nolog

* Probabilidades predichas
predict phat_PU_A1822 if dpto_==21, pr

* Clasificación (cutoff 0,50)
capture drop yhat_PU_A1822
gen yhat_PU_A1822 = (phat_PU_A1822 >= 0.5) if !missing(phat_PU_A1822)

tabulate pob_monetaria yhat_PU_A1822 if dpto_==21, matcell(M4)

scalar acc_PU_A1822  = (M4[1,1] + M4[2,2]) / (M4[1,1] + M4[1,2] + M4[2,1] + M4[2,2])
scalar sens_PU_A1822 = M4[2,2] / (M4[2,1] + M4[2,2])
scalar esp_PU_A1822  = M4[1,1] / (M4[1,1] + M4[1,2])

* Curva ROC y AUC
roctab pob_monetaria phat_PU_A1822 if dpto_==21, graph ///
    title("Puno: Pseudo-panel 2018–2022", size(medium)) ///
    name(roc_PU_A1822, replace)
scalar auc_PU_A1822 = r(area)

*------------------------------------------------------*
* 8. MATRIZ RESUMEN PARA TABLA (Accuracy, Sensibilidad, Especificidad, AUC)
*------------------------------------------------------*
matrix RES = J(4,4,.)
matrix rownames RES = PE_P2022 PE_A1822 PU_P2022 PU_A1822
matrix colnames RES = Accuracy Sensibilidad Especificidad AUC

matrix RES[1,1] = acc_PE_P2022  , sens_PE_P2022  , esp_PE_P2022  , auc_PE_P2022
matrix RES[2,1] = acc_PE_A1822  , sens_PE_A1822  , esp_PE_A1822  , auc_PE_A1822
matrix RES[3,1] = acc_PU_P2022  , sens_PU_P2022  , esp_PU_P2022  , auc_PU_P2022
matrix RES[4,1] = acc_PU_A1822  , sens_PU_A1822  , esp_PU_A1822  , auc_PU_A1822

* Mostrar resultados en pantalla
matlist RES, format(%6.3f)

*------------------------------------------------------*
* 9. (OPCIONAL) Exportar matriz a LaTeX / texto
*------------------------------------------------------*
* putexcel / estout / outtable se pueden usar aquí si deseas
* por ejemplo, para exportar a Excel:
* putexcel set "tabla_desempeno_modelos.xlsx", replace
* putexcel A1=matrix(RES), names

*******************************************************
* FIN DEL DO-FILE
*******************************************************

graph combine ///
		roc_PE_P2022 ///
		roc_PE_A1822 ///
		roc_PU_P2022 ///
		roc_PU_A1822, ///
    col(2)  ///
	graphregion(color(white)) ///
    imargin(zero) ///
    iscale(*1.2) ///
	name(fig8_curvas_roc, replace)	
	graph export "fig8_curvas_roc.png", as(png) name("fig8_curvas_roc") replace
	

