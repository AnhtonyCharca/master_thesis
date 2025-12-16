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


************************************
***CONSTRUCCION POBREZA INTEGRADA***
************************************
use "$dclea/pobreza_panel_20-22_v2.dta", clear

tab   year urban_
tab   year urban_ if depto==21

****nbi

sum nbi1 nbi2 nbi3 nbi4 nbi5
gen          nbihog=nbi1 + nbi2 + nbi3 + nbi4 + nbi5

gen    		 NBI1_POBRE=.
replace 	 NBI1_POBRE=1 if nbihog>0
replace		 NBI1_POBRE=0 if nbihog==0

label define NBI1_POBRE 0 "ninguna NBI" 1 "al menos un NBI"
label value  NBI1_POBRE NBI1_POBRE
label var    NBI1_POBRE "Con al menos una NBI"
tab          NBI1_POBRE

gen    		 NBI2_POBRE=.
replace		 NBI2_POBRE=1 if nbihog>1
replace		 NBI2_POBRE=0 if nbihog<2

label define NBI2_POBRE 0 "menos de dos NBI" 1 "al menos dos NBI"
label value  NBI2_POBRE NBI2_POBRE
label var    NBI2_POBRE "Con al menos dos NBI"
tab          NBI2_POBRE

***POBRE2 ES POBREZA MONETARIA
rename pobre2_ pob_monetaria
	lab var pob_monetaria "Pobreza Monetaria"
	lab def pob_monetaria 1"Pobre monetario" 0"No pobre monetario"

gen pobre_integrado=.
replace pobre_integrado=1 if pob_monetaria==0 & NBI1_POBRE==0
replace pobre_integrado=2 if pob_monetaria==1 & NBI1_POBRE==0
replace pobre_integrado=3 if pob_monetaria==0 & NBI1_POBRE==1
replace pobre_integrado=4 if pob_monetaria==1 & NBI1_POBRE==1

**Etiqueta de "pobre integrado"
	lab def pob_inte 1"Socialmente integrado" 2"P. Coyuntural" 3"P. Estructural" 4"P. Crónico"
	lab var pobre_integrado "Pobreza Integrada"
	lab val pobre_integrado pob_inte
	
	fre pobre_integrado
	
	fre pob_monetaria
	gen pob_mon_puno=pob_monetaria if depto==21
	gen pob_mont_100=pob_monetaria*100
	gen pob_mont_puno_100=pob_monetaria*100 if depto==21
	
	gen pob_intg_100=pobre_integrado*100
	gen pob_intg_puno_100=pobre_integrado*100 if depto==21

	gen desag_ = nbi3_
	lab var desag_ "Conexión a desague"
	lab val desag_ yesno
	
	
	
	lab def noyes 0"No" 1"Si"
	lab var internet_ "Conexión a internet"
	lab val internet_ noyes
	
	recode mieperho_ (1/2=1 "[1-2]") (3/4=2 "[3-4]") (5/15=3 ">=5") , gen(numinthog_)
	label var numinthog_ "Numero de integrantes del hogar"
	
	recode percepho_ (0/1=1 "1") (2=2 "2") (3=3 "3") (4/10=4 ">=4") , gen(ingperc_)
	label var ingperc_ "Numero de perceptores de ingresos del hogar"
	
	lab val tit_prop_ noyes 
	
	rename lengua_materna_ lmatr_
gen l_ingre=log(inghog2d_) 
lab var l_ingre "Ingreso neto (Logaritmo)"
recode race_ (1=1) (2=2) (3=3) (4=4) (5=5) (6=5) (.=5)
recode lmatr_ (1=1) (2=2) (3=3) (.=3)
	recode educ_ (.=0)
	recode analfa_ (.=0)
	recode morbilid_ (.=0)
	recode ecivil_ (.=1)
	recode inc_finc_ (.=1)
	
	save "$dclea/master_tesis_2024.dta", replace

* Descriptive statistics:
* -----------------------

svyset conglome_ [pweight = facpanel2022], strata(estrato_) 

*******************************************************
* PObreza (Nacional)
svy: tab pob_monetaria year, format(%15.1fc) column percent

svy: tab pobre_integrado year, format(%15.1fc) column percent

* PObreza (Puno)
svy: tab pob_monetaria year 	if depto==21, format(%15.1fc) column percent
svy: tab pobre_integrado year	if depto==21, format(%15.1fc) column percent

collect: tabulate year urban_ [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs
**# Bookmark #2
****************OBJETIVO 01***************************
**# Bookmark #3
**POBREZA MONETARIA
svy: tab pob_monetaria year,  column percent
svy: tab pob_monetaria year 	if depto==21, column percent
***VIVIENDA Y CONDICIONES DE VIDA
*VCC.: Area de residencia
tabulate year urban_ [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate year urban_ [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs

***CAPITAL PUBLICO
*CP.: Agua potable:									ag_pot_
tabulate year ag_pot_  [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate year ag_pot_  [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs
*CP.: Conexión a desagüe:							desag_
tabulate year desag_  [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate year desag_  [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs
*CP.: Cuenta con electricidad:						enerlectr_ 
tabulate year enerlectr_  [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate year enerlectr_  [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs
*CP.: Acceso a internet:							internet_ 
tabulate year internet_  [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate year internet_  [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs
***CARACTERISTICAS DEL HOGAR
*CH.: Número de integrantes del hogar: 				numinthog_
*CH.: Número de perceptores de ingresos del hogar:	ingperc_
***CAPITAL INSTITUCIONAL
*CI.: Tipo de vivienda ocupada: 					prop_viv_
*CI.: Título de la vivienda en SUNARP: 				tit_prop_
***DISCRIMINACION Y EXCLUSION SOCIAL
*DES.: Sexo del jefe de hogar
*DES.: Grupo de edad del jefe del hogar
tabulate    g_edad_ year [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate   g_edad_ year [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs
*DES.: Idioma predominante: 	lmatr_
*DES.: Raza o grupo étnico: 	race_ 
*DES.:Estado civil
*** EMPLEO Y OCUPACION:
*EO.: Situacion de empleo
tabulate year ocupinf_ [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate year ocupinf_ [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs
*EO.: Numero de empleos del jefe de hogar
tabulate year nempljh_ [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate year nempljh_ [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs
*EO.: Ingreso total mensual
*EO.: Sector de ocupacion principal
tabulate  sec_ocu_ year [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate sec_ocu_ year [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs

***EDUCACION
*Edu.: Nivel de educación
*Edu.: Años de educación
*Edu.: Analfabetismo
*Edu.: Tipo de centro de estudios
***SALUD
*Sa.: Tiene seguro de salud
*Sa.: Presenta alguna limitación o dificultad permanente
*Sa.: Padece alguna enfermedad crónica
*Sa.: Las 4 ultimas semanas presentó alguna enfermedad
*Sa.: Recibió la vacuna del COVID-19
*Sa.: Tiene seguro de salud
***REDES DE APOYO SOCIAL
*RAS.: Cuenta con algún servicio financiero
*RAS.: Tiene DNI

cd "$tablas"
**# Bookmark #4
****POBREZA INTEGRADA****
svy: tab pob_monetaria year,  column percent
svy: tab pob_monetaria year 	if depto==21, column percent

svy: tab pobre_integrado year,  column percent 
svy: tab pobre_integrado year 	if depto==21, column percent


asdoc save(Table_pb_intnac.doc)
asdoc svy: tab pobre_integrado year 	if depto==21, column percent save(Table_pb_intpun.doc)
***VIVIENDA Y CONDICIONES DE VIDA 
*VCC.: Area de residencia
tabulate year urban_ [aweight = facpanel2022], summarize(pob_intg_100 ) nostandard nofreq noobs

tabulate year urban_ [aweight = facpanel2022] if depto==21, summarize(pob_intg_100 ) nostandard nofreq noobs

***CAPITAL PUBLICO
*CP.: Agua potable
*CP.: Conexión a desagüe
*CP.: Cuenta con electricidad
*CP.: Acceso a internet
***CARACTERISTICAS DEL HOGAR
*CH.: Número de integrantes del hogar
*CH.: Número de perceptores de ingresos del hogar
***CAPITAL INSTITUCIONAL
*CI.: Tipo de vivienda ocupada
*CI.: Título de la vivienda en SUNARP
***DISCRIMINACION Y EXCLUSION SOCIAL
*DES.: Sexo del jefe de hogar
*DES.: Grupo de edad del jefe del hogar
tabulate   year g_edad_ [aweight = facpanel2022], summarize(pob_intg_100 ) nostandard nofreq noobs

tabulate  year g_edad_ [aweight = facpanel2022] if depto==21, summarize(pob_intg_100 ) nostandard nofreq noobs
*DES.: Idioma predominante
*DES.: Raza o grupo étnico
*DES.:Estado civil
*** EMPLEO Y OCUPACION:
*EO.: Situacion de empleo
tabulate year ocupinf_ [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate year ocupinf_ [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs
*EO.: Numero de empleos del jefe de hogar
tabulate year nempljh_ [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate year nempljh_ [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs
*EO.: Ingreso total mensual
*EO.: Sector de ocupacion principal
tabulate  sec_ocu_ year [aweight = facpanel2022], summarize(pob_mont_100) nostandard nofreq noobs

tabulate sec_ocu_ year [aweight = facpanel2022] if depto==21, summarize(pob_mont_100) nostandard nofreq noobs

***EDUCACION
*Edu.: Nivel de educación
*Edu.: Años de educación
*Edu.: Analfabetismo
*Edu.: Tipo de centro de estudios
***SALUD
*Sa.: Tiene seguro de salud
*Sa.: Presenta alguna limitación o dificultad permanente
*Sa.: Padece alguna enfermedad crónica
*Sa.: Las 4 ultimas semanas presentó alguna enfermedad
*Sa.: Recibió la vacuna del COVID-19
*Sa.: Tiene seguro de salud
***REDES DE APOYO SOCIAL
*RAS.: Cuenta con algún servicio financiero
*RAS.: Tiene DNI

	****OBEJTIVO 2:
	gen edad2=age*age
	xtset id year
	 *xtlogit pob_monetaria percepho_ internet_ ag_pot_ enerlectr_ 
	 
	  *xtlogit pob_monetaria ocupinf nempljh lwage_ sec_ocu educ_ sch_ analfa_ seguro  croni_ morbi vac_cov dic_segur_ urban_  ag_pot  desag enerlectr inter mieperho percepho prop_viv tit_prop sex age g_edad lmatr_ race ecivil_ inc_finc_
	  
	  sum pob_monetaria  l_ingre i.educ_  analfa_ croni_ morbi dic_segur_ urban_ ag_pot  desag enerlectr inter mieperho percepho prop_viv tit_prop sex i.g_edad ib2.lmatr_ ib2.race ib4.ecivil_ inc_finc_ sch_
	  **ocupinf nempljh ib11.sec_ocu_ vac_cov  sch_
	  *NACIONAL
		xtlogit pob_monetaria  l_ingre i.educ_  analfa_ croni_ morbi dic_segur_ urban_ ag_pot  desag enerlectr inter mieperho percepho prop_viv tit_prop sex i.g_edad ib2.lmatr_ ib2.race ib4.ecivil_ inc_finc_ , nolog
		
		
		***JUST MORE SIGNIFICANCE
		**PERU
xtlogit pob_monetaria l_ingre i.educ_  croni_ morbi dic_segur_ urban_ desag enerlectr inter mieperho prop_viv tit_prop sex i.g_edad ib2.lmatr_ ib2.race ib4.ecivil_ inc_finc_ 
estimates store XTLOG_PE1

est tab XTLOG_PE1, star(0.01 0.05 0.1) stat(_all)
outreg2 [XTLOG_PE1] using XTLOG_PE1, e(all) see excel word replace 
outreg2 using obj_01_peru, word excel replace
	 *PUNO
asdoc	 xtlogit pob_monetaria l_ingre i.educ_  croni_ morbi dic_segur_ urban_ desag enerlectr inter mieperho prop_viv tit_prop sex i.g_edad ib2.lmatr_ ib2.race ib4.ecivil_ inc_finc_  if depto==21  , title(Table 1: Regression Puno) save(XTLOG_PU1.doc) replace

		estimates store XTLOG_PU1
	  outreg2 [XTLOG_PU1] using XTLOG_PU1, e(all) see excel word replace 
	  
	 ****OBEJTIVO 3:
	 xtmlogit pobre_integrado percepho_ internet_ ag_pot_ enerlectr_ 
	  /*NACIONAL
		xtmlogit pobre_integrado ocupinf lwage_ i.sec_ocu_ i.educ_ sch_ croni_ morbi vac_cov dic_segur_ ag_pot  desag enerlectr inter mieperho percepho tit_prop ib3.lmatr_ ib2.race ib4.ecivil_ inc_finc_  , baseoutcome(4)
	 *PUNO
		xtmlogit pobre_integrado ocupinf lwage_ sec_ocu i.educ_ sch_ croni_ morbi vac_cov dic_segur_ ag_pot  desag enerlectr inter mieperho percepho tit_prop ib3.lmatr_ ib2.race ib4.ecivil_ inc_finc_ ib11.sec_ocu_ if depto_==21
		*/
		
		*NACIONAL
		asdoc xtmlogit pobre_integrado l_ingre i.educ_  analfa_ croni_ morbi dic_segur_ urban_ ag_pot  desag enerlectr inter mieperho percepho prop_viv tit_prop sex i.g_edad ib2.lmatr_ ib2.race ib4.ecivil_ inc_finc_ , baseoutcome(4)
		
		***PUNO
		asdoc	xtmlogit pobre_integrado l_ingre i.educ_  croni_  urban_   enerlectr inter mieperho   sex  inc_finc_ if depto_==21
		
		
		
		asdoc xtmlogit pobre_integrado l_ingre i.educ_  analfa_ croni_ morbi dic_segur_ urban_ ag_pot  desag enerlectr inter mieperho percepho prop_viv tit_prop sex i.g_edad ib2.lmatr_ ib2.race ib4.ecivil_ inc_finc_ if depto==21, baseoutcome(4)
		
		summarize pobre_integrado l_ingre i.educ_  analfa_ croni_ morbi dic_segur_ urban_ ag_pot  desag enerlectr inter mieperho percepho prop_viv tit_prop sex i.g_edad ib2.lmatr_ ib2.race ib4.ecivil_ inc_finc_ if depto==21