/*
BY: ALEX ANTONI QUISPE CHARCA
TEMA: POBREZA MONETARIA Y POBREZA INTEGRADA, panel 2020-2022
MASTER TESIS
UNIVERSIDAD NACIONAL DEL ALTIPLANO - PUNO

PARTE II: RESULTADOS - objetivo 02
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
	
	gen castell=(lmatr_==1)
	gen nativo=(race==3)
	gen soltero=(ecivil_==1)
	 *xtlogit pob_monetaria percepho_ internet_ ag_pot_ enerlectr_ 
	 
	  *xtlogit pob_monetaria ocupinf nempljh lwage_ sec_ocu educ_ sch_ analfa_ seguro  croni_ morbi vac_cov dic_segur_ urban_  ag_pot  desag enerlectr inter mieperho percepho prop_viv tit_prop sex age g_edad lmatr_ race ecivil_ inc_finc_
	  
	  sum pob_monetaria  l_ingre sch_  analfa_ croni_ morbi dic_segur_ urban_ ag_pot  desag enerlectr inter mieperho percepho prop_viv tit_prop sex age edad2 castell nativo soltero inc_finc_
	  **ocupinf nempljh ib11.sec_ocu_ vac_cov  sch_
	  *NACIONAL
		xtlogit pob_monetaria  l_ingre sch_  analfa_ croni_ morbi dic_segur_  ag_pot  desag enerlectr inter mieperho percepho prop_viv tit_prop sex age castell nativo soltero inc_finc_, fe nolog
		***JUST MORE SIGNIFICANCE
		**PERU
xtlogit pob_monetaria  l_ingre sch_  morbi dic_segur_  ag_pot  desag enerlectr inter mieperho tit_prop  age soltero inc_finc_, fe nolog
estimates store XTLOG_PE1
* Predecir la probabilidad estimada (limitada en FE)
predict p_fe, p

* Calcular efectos marginales aproximados para cada variable
gen mfx_l_ingre    = p_fe * (1 - p_fe) * _b[l_ingre]
gen mfx_sch_       = p_fe * (1 - p_fe) * _b[sch_]
gen mfx_morbi      = p_fe * (1 - p_fe) * _b[morbi]
gen mfx_dic_segur_ = p_fe * (1 - p_fe) * _b[dic_segur_]
gen mfx_ag_pot     = p_fe * (1 - p_fe) * _b[ag_pot]
gen mfx_desag      = p_fe * (1 - p_fe) * _b[desag]
gen mfx_enerlectr  = p_fe * (1 - p_fe) * _b[enerlectr]
gen mfx_inter      = p_fe * (1 - p_fe) * _b[inter]
gen mfx_mieperho   = p_fe * (1 - p_fe) * _b[mieperho]
gen mfx_tit_prop   = p_fe * (1 - p_fe) * _b[tit_prop]
gen mfx_age        = p_fe * (1 - p_fe) * _b[age]
gen mfx_soltero    = p_fe * (1 - p_fe) * _b[soltero]
gen mfx_inc_finc_  = p_fe * (1 - p_fe) * _b[inc_finc_]

summarize mfx_*

foreach var in l_ingre sch_ morbi dic_segur_ ag_pot desag enerlectr inter mieperho tit_prop age soltero inc_finc_ {
    summarize mfx_`var', detail
}

asdoc summarize mfx_*, title(Table 1: efectos marginales Perú) save(XTLOG_margins_PE1.doc) replace

est tab XTLOG_PE1, star(0.01 0.05 0.1) stat(_all)
outreg2 [XTLOG_PE1] using XTLOG_PE1, e(all) excel word replace 
outreg2 using obj_01_peru, word excel replace
	
	
	
	*PUNO
xtlogit pob_monetaria  l_ingre sch_  morbi dic_segur_  ag_pot  desag enerlectr inter mieperho tit_prop  age soltero inc_finc_  if depto==21  , fe nolog
estimates store XTLOG_PU1

predict p_fe_puno, p

* Calcular efectos marginales aproximados para cada variable
gen mfxpu_l_ingre    = p_fe * (1 - p_fe_puno) * _b[l_ingre] 	if depto==21
gen mfxpu_sch_       = p_fe * (1 - p_fe_puno) * _b[sch_] 		if depto==21
gen mfxpu_morbi      = p_fe * (1 - p_fe_puno) * _b[morbi] 		if depto==21
gen mfxpu_dic_segur_ = p_fe * (1 - p_fe_puno) * _b[dic_segur_] 	if depto==21
gen mfxpu_ag_pot     = p_fe * (1 - p_fe_puno) * _b[ag_pot]		if depto==21
gen mfxpu_desag      = p_fe * (1 - p_fe_puno) * _b[desag]		if depto==21
gen mfxpu_enerlectr  = p_fe * (1 - p_fe_puno) * _b[enerlectr]	if depto==21
gen mfxpu_inter      = p_fe * (1 - p_fe_puno) * _b[inter]		if depto==21
gen mfxpu_mieperho   = p_fe * (1 - p_fe_puno) * _b[mieperho]	if depto==21
gen mfxpu_tit_prop   = p_fe * (1 - p_fe_puno) * _b[tit_prop]	if depto==21
gen mfxpu_age        = p_fe * (1 - p_fe_puno) * _b[age]			if depto==21
gen mfxpu_soltero    = p_fe * (1 - p_fe_puno) * _b[soltero]		if depto==21
gen mfxpu_inc_finc_  = p_fe * (1 - p_fe_puno) * _b[inc_finc_]	if depto==21

		est tab XTLOG_PU1, star(0.01 0.05 0.1) stat(_all)
		
summarize mfxpu* if depto==21	
asdoc summarize mfxpu* if depto==21 , title(Table 1: efectos marginales puno) save(XTLOG_margins_pu1.doc) replace

est tab XTLOG_PU1, star(0.01 0.05 0.1) stat(_all)
outreg2 [XTLOG_PU1] using XTLOG_PU1, e(all) excel word replace 
outreg2 using obj_01_puno, word excel replace
	
	  
