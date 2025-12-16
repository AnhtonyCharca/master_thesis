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
glo enaho_dat 	"C:\Users\CI-EPG-THONY\OneDrive\ENAHO"
glo maestria	"C:\Users\CI-EPG-THONY\OneDrive\MI TESIS EPG MASTER\MAESTRIA"
glo tempo		"$maestria\002 BASE DE DATOS\001 TEMP"
glo dclea		"$maestria\002 BASE DE DATOS\002 CLEAN"
glo dofil		"$maestria\001 DOFILES"
glo tablas		"$maestria\005 TABLAS Y CUADROS"
glo graficos	"$maestria\008 GRAFICOS"
glo bases		"$enaho_dat\001 BASES"
glo prsoc		"$bases\037 programas sociales"
glo mod1		"$bases\001 modulo 01"
glo mod2		"$bases\002 modulo 02"
glo mod3		"$bases\003 modulo 03"
glo mod4		"$bases\004 modulo 04"
glo mod5		"$bases\005 modulo 05"
glo sumr		"$bases\034 sumarias"
glo	SINTAXIS 	"$enaho_dat\002 DO FILES"
glo CUADROS		"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA\005 TABLAS Y CUADROS"

cd "$maestria"


**juntamos las bases de datos - transversales:


use "$dclea/modpersonal_2020.dta", clear
foreach year of numlist 2021/2022 {
append using "$dclea/modpersonal_`year'.dta" 
	 }

**correr la sintaxis de cortes geograficos y politicos
do "${SINTAXIS}\cortesgeograficosypoliticos2.do"


**ANALISIS PARA AÑOS
***loops**
sort year_2 


***POBRE2 ES POBREZA MONETARIA
rename pobre2 pob_monetaria
	lab var pob_monetaria "Pobreza Monetaria"
	lab def pob_monetaria 1"Pobre monetario" 0"No pobre monetario"
	
***CALCULO DE LA VARIABLE: PROBREZA INTEGRADA
gen pobre_integrado=.
replace pobre_integrado=1 if pob_monetaria==0 & NBI1_POBRE==0
replace pobre_integrado=2 if pob_monetaria==1 & NBI1_POBRE==0
replace pobre_integrado=3 if pob_monetaria==0 & NBI1_POBRE==1
replace pobre_integrado=4 if pob_monetaria==1 & NBI1_POBRE==1

**Etiqueta de "pobre integrado"
	lab def pob_inte 1"Socialmente integrado" 2"P. Coyuntural" 3"P. Estructural" 4"P. Crónico"
	lab var pobre_integrado "Pobreza Integrada"
	lab val pobre_integrado pob_inte
	
***CALCULO A NIVEL PORCENTUAL DE LA VARIABLE: PROBREZA INTEGRADA
gen pobre_integrado_1=(pob_monetaria==0 & NBI1_POBRE==0)*100
gen pobre_integrado_2=(pob_monetaria==1 & NBI1_POBRE==0)*100
gen pobre_integrado_3=(pob_monetaria==0 & NBI1_POBRE==1)*100
gen pobre_integrado_4=(pob_monetaria==1 & NBI1_POBRE==1)*100

	lab var pobre_integrado_1 "Socialmente integrado"
	lab var pobre_integrado_2 "P. Coyuntural"
	lab var pobre_integrado_3 "P. Estructural"
	lab var pobre_integrado_4 "P. Crónico"
	
	fre pobre_integrado
******************************************************************	
	fre pob_monetaria
	gen pob_mon_puno=pob_monetaria if dpto==21
	gen pob_mont_100=pob_monetaria*100
	gen pob_mont_puno_100=pob_monetaria*100 if dpto==21
	
	gen pob_intg_100=pobre_integrado*100
	gen pob_intg_puno_100=pobre_integrado*100 if dpto==21


******* POBREZA MONETARIA
svy: mean pob_mont_100 , over(year_2)

svy: mean pob_mont_100 , over(year_2 area)


****** POBREZA POR NBI
svy: mean nbi1 nbi2 nbi3 nbi4 nbi5 , over(year_2)
**construccion en terminos porcentuales:
foreach i of numlist 1/5 {
	gen nbi`i'_100=nbi`i'*100
	 }
****** POBREZA POR NBI: Perú	 
svy: mean nbi1_100 nbi2_100 nbi3_100 nbi4_100 nbi5_100 , over(year_2)
svy: mean nbi1_100 nbi2_100 nbi3_100 nbi4_100 nbi5_100 , over(year_2 area)
****** POBREZA POR NBI: Puno
svy: mean nbi1_100 nbi2_100 nbi3_100 nbi4_100 nbi5_100 if dpto==21, over(year_2)
svy: mean nbi1_100 nbi2_100 nbi3_100 nbi4_100 nbi5_100 if dpto==21, over(year_2 area)

gen NBI1_POBRE_100 = NBI1_POBRE*100
gen NBI2_POBRE_100 = NBI2_POBRE*100
 label var    NBI1_POBRE_100  "Con al menos una NBI"
 label var    NBI2_POBRE_100  "Con al menos dos NBI"

 
 ****** POBREZA INTEGRADA: Perú
 svy: mean pobre_integrado_1 pobre_integrado_2 pobre_integrado_3 pobre_integrado_4 , over(year_2)
 
svy: tab pobre_integrado year,  column percent 
 
 
 ****** POBREZA INTEGRADA: Puno:
  svy: mean pobre_integrado_1 pobre_integrado_2 pobre_integrado_3 pobre_integrado_4 if dpto==21, over(year_2)
 
 svy: tab pobre_integrado year if dpto==21,  column percent collect
 
 
 
***************
save "$dclea/data_objt_01.dta", replace