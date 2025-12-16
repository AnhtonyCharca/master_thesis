/*
BY: ALEX ANTONI QUISPE CHARCA
TEMA: POBREZA MONETARIA Y POBREZA INTEGRADA, panel 2020-2022
MASTER TESIS
UNIVERSIDAD NACIONAL DEL ALTIPLANO - PUNO

PARTE II: RESULTADOS
*/

clear all
set more off
*************************************
******DIRECTORIOS DE TRABAJO ********
*************************************
*glo maestria	"C:\Users\anton\OneDrive\MI TESIS EPG MASTER\MAESTRIA"
glo maestria	"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA"
glo tempo		"$maestria\002 BASE DE DATOS\001 TEMP"
glo dclea		"$maestria\002 BASE DE DATOS\002 CLEAN"
glo dofil		"$maestria\001 DOFILES"
glo tablas		"$maestria\005 TABLAS Y CUADROS"
glo graficos	"$maestria\008 GRAFICOS"
cd "$maestria"

use  "$dclea/master_tesis_2024.dta", clear

* Descriptive statistics:
* -----------------------

svyset conglome_ [pweight = facpanel2022], strata(estrato_) 
	****OBEJTIVO 2:
	gen edad2=age*age
	
	xtset id year
	


		*NACIONAL
asdoc xtmlogit pobre_integrado l_ingre sch_ morbi dic_segur_  ag_pot  enerlectr inter mieperho  tit_prop age  inc_finc_ , baseoutcome(4) save(XTMLOG_margins_PERU3.doc) replace
		
		***PUNO
asdoc xtmlogit pobre_integrado l_ingre sch_ morbi dic_segur_  ag_pot  enerlectr inter mieperho  tit_prop age  inc_finc_ if depto==21, baseoutcome(4) save(XTMLOG_margins_PUNO3.doc) replace







