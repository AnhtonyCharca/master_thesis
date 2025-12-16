/*
BY: ALEX ANTONI QUISPE CHARCA
TEMA: POBREZA MONETARIA Y POBREZA INTEGRADA, panel 2020-2022
MASTER TESIS
UNIVERSIDAD NACIONAL DEL ALTIPLANO - PUNO

PARTE I: RESULTADOS OBJETIVO ESPECIFICO 01 
USO DE DATA TRANSVERSAL
*/
clear all
set more off
**2024 
*************************************
******DIRECTORIOS DE TRABAJO ********
*************************************
glo enaho_bas	"C:\Users\CI-EPG-THONY\OneDrive\ENAHO\001 BASES"
glo mod01		"$enaho_bas\001 modulo 01"
glo mod02		"$enaho_bas\002 modulo 02"
glo mod03		"$enaho_bas\003 modulo 03"
glo mod04		"$enaho_bas\004 modulo 04"	
glo mod05		"$enaho_bas\005 modulo 05"
glo mod037		"$enaho_bas\037 programas sociales"
glo fiorela_tes	"C:\Users\CI-EPG-THONY\OneDrive\tess_fiorela"
*glo maestria	"C:\Users\ANHTONY PC\OneDrive\TESIS\MAESTRIA"
glo tempo		"$fiorela_tes\002 BASE DE DATOS\001 TEMP"
glo dclea		"$fiorela_tes\002 BASE DE DATOS\002 CLEAN"
glo dofil		"$fiorela_tes\001 DOFILES"

ssc install outreg2 , replace


cd "$fiorela_tes"

use "$dclea/modpersonal_2024.dta", clear

gen is_pea=(ocu500==1)
gen is_nativo=(lengua_materna==2)
gen lg_gashog2d = log(gashog2d)
gen lg_inghog2d = log(inghog2d)
gen es_casado=(ecivil==2)
gen sec_agrico=(sec_ocu==1)
gen pob_mont_100=pob_monetaria*100


**# Bookmark #1 OBJETIVO 01

******* POBREZA MONETARIA
**TABLA 04:
svy: mean pob_mont_100 , over(year_2)

*svy: mean pob_mont_100 if dpto==21 , over(year_2)

**TABLA 05:
svy: mean pob_mont_100 , over(year_2  urban)
*svy: mean pob_mont_100 if dpto==21 , over(year_2 area)

****

**# Bookmark #1 OBJETIVO 01
global Y pob_monetaria
global X lg_inghog2d  sex age sch ecivil is_pea is_nativo croni morbilid mieperho nbi3 nbi5
 global X  lg_inghog2d mieperho
 logit $Y lg_inghog2d  sex  age ecivil is_pea is_nativo croni morbilid mieperho 
 
 mfx
 
 logit $Y ecivil sch  lengua_materna  dic_segur croni morbilid  lw sec_ocu sector_econ  act_empr race   nbi2 nbi3   internet sunarp urban zone mieperho is_pea is_nativo lg_inghog2d 
 
 
  logit $Y lg_inghog2d mieperho es_casado  act_empr    internet    urban
 
  mfx
  
  * Penalización L1 para selección
lassologit pob_monetaria lg_inghog2d mieperho es_casado  act_empr    internet    urban
 , selection(plugin)

* Modelo reducido sugerido por lasso
estat lasso

  
  
/*
> gashog2d  gasto total bruto 
> inghog2d 	ingreso neto total
lg_inghog2d  
lg_gashog2d 
sex  Sexo del jefe del hogar_mujer
age   Edad en (años cumplidos)
sch   Años de escolaridad
ecivil Estado Civil
is_pea es PEA (trabajador)
is_nativo   1 =Quechua/Aymara/otra nativa 
croni  Presenta alguna enfermedad Crónica
morbilid  
mieperho
nbi*
*/

codebook $Y lg_inghog2d   sch ecivil croni morbilid mieperho  internet  act_empr    urban  zone 

**MODELO LOGIT PROBIT
logit $Y lg_inghog2d   sch ecivil croni morbilid mieperho  internet  act_empr    urban  zone 