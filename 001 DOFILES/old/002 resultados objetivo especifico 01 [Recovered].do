/*
BY: ALEX ANTONI QUISPE CHARCA
TEMA: POBREZA MONETARIA Y POBREZA INTEGRADA, panel 2020-2022
MASTER TESIS
UNIVERSIDAD NACIONAL DEL ALTIPLANO - PUNO

PARTE I: RESULTADOS OBJETIVO ESPECIFICO 01 
USO DE DATA TRANSVERSAL
*/
set more off
clear all
***************
glo enaho_dat 	"F:\ENAHO"
	glo bases		"$enaho_dat\001 BASES"
		glo mod1		"$bases\001 modulo 01"
		glo mod2		"$bases\002 modulo 02"
		glo mod3		"$bases\003 modulo 03"
		glo mod4		"$bases\004 modulo 04"
		glo mod5		"$bases\005 modulo 05"
		glo sumr		"$bases\034 sumarias"
	glo	SINTAXIS 	"$enaho_dat\002 DO FILES"

glo maestria	"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA"
	glo tempo		"$maestria\002 BASE DE DATOS\001 TEMP"
	glo dclea		"$maestria\002 BASE DE DATOS\002 CLEAN"
	glo dofil		"$maestria\001 DOFILES"
	glo tablas		"$maestria\005 TABLAS Y CUADROS"
	glo graficos	"$maestria\008 GRAFICOS"
	
cd "$maestria"

*use "$dclea/data_objt_01.dta", clear

use "$dclea/modpersonal_18-22.dta", clear

******* POBREZA MONETARIA
**TABLA 04:
svy: mean pob_mont_100 , over(year_2)
svy: mean pob_mont_100 if depto==21 , over(year_2)

**TABLA 05:
svy: mean pob_mont_100 , over(year_2 area)
svy: mean pob_mont_100 if dpto==21 , over(year_2 area)

***TABLA 06:
svy: mean pob_mont_100 , over(year_2 g_edad)

tabulate   year g_edad  [aweight = facpanel2022], summarize(pob_intg_100 ) nostandard nofreq noobs

tabulate  year g_edad  [aweight = facpanel2022] if depto==21, summarize(pob_intg_100 ) nostandard nofreq noobs

svy: mean pob_mont_100 , over(year_2 area)