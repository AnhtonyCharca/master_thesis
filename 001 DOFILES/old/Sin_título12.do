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

cd "$maestria"
************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – Toda la data (2018–2022) y paneles puros
************************************************************
*-----------------------------------------------------------*
* 0. CARGA DE BASE Y CONFIGURACIÓN GENERAL
*-----------------------------------------------------------*

use "$dclea/pobreza_panel_18-22_full.dta", clear


*----------pobre_integrada ------------------------------------------*
* 0. Configuración previa                            *
*----------------------------------------------------*
xtset idhogar year
global X_static log_inghog2d_ totmieho_ internet_ trab_informa


**LOGIT MULTINOMIAL PANEL

xtmlogit pobre_integrada  $X_static , re baseoutcome(4) vce(cluster idhogar)


mlogit pobre_integrada  $X_static , baseoutcome(4)
mlogit pobre_integrada  $X_static if dpto==21, baseoutcome(4)