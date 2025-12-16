/*
BY: ALEX ANTONI QUISPE CHARCA
TEMA: POBREZA MONETARIA Y POBREZA INTEGRADA, panel 2020-2022
MASTER TESIS
UNIVERSIDAD NACIONAL DEL ALTIPLANO - PUNO

PARTE I: CONSTRUCCION DE BASE DE DATOS
*/

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

glo maestria   "C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA\002 BASE DE DATOS"
glo tempo      "$maestria\001 TEMP"
glo dclea      "$maestria\002 CLEAN"
glo dofil      "$maestria\001 DOFILES"

cd "$maestria"

/*
NOTA CLAVE:
Cuando quieras pasar a panel estricto 2018–2022, en cada módulo solo tendrás que descomentar las líneas marcadas como:
*/
* >>> ACTIVAR PANEL ESTRICTO AQUÍ
* keep if hpan1822   == 1
* keep if perpanel22 == 1   // cuando exista a nivel persona

******************************************************
****### 1. Módulo 300 – EDUCACIÓN (2018–2022)  ###****
******************************************************
use "$mod03/enaho01a-2018-2022-300-panel.dta", clear

* >>> ACTIVAR PANEL ESTRICTO AQUÍ (AHORA DESACTIVADO)
* keep if perpanel2022 == 1     // persona está en panel 18–22
* keep if hpan1822     == 1     // hogar está en panel 18–22

* OPCIONAL: solo jefes de hogar
* keep if p203b_18==1 | p203b_19==1 | p203b_20==1 | p203b_21==1 | p203b_22==1

label def niveduc 0 "No level" 1 "Primary" 2 "Secondary" 3 "Superior non-university" 4 "Superior university" 5 "Postgraduated"
label def yesno   0 "Si" 1 "No"

foreach i in 18 19 20 21 22 {
   **Nivel de educacion
gen educ_`i'=.
replace educ_`i'=0 if p301a_`i'==1 | p301a_`i'==2
replace educ_`i'=1 if p301a_`i'==3 | p301a_`i'==4
replace educ_`i'=2 if p301a_`i'==5 | p301a_`i'==6
replace educ_`i'=3 if p301a_`i'==7 | p301a_`i'==8
replace educ_`i'=4 if p301a_`i'==9 | p301a_`i'==10
replace educ_`i'=5 if p301a_`i'==11
label values educ_`i' niveduc
label variable educ_`i' "Nivel de educacion `i'"	

* Escolaridad alcanzada (años)
gen sch_`i'=.
replace sch_`i'=0  if p301a_`i'==1 | p301a_`i'==2 					                                                            // Sin nivel ni nivel inicial
replace sch_`i'=0  if p301a_`i'==3 & (p301b_`i'==0 & p301c_`i'==0)																    // Nivel Inicial
replace sch_`i'=1  if (p301a_`i'==3 & p301b_`i'==1) | (p301a_`i'==3 & p301c_`i'==1) | (p301a_`i'==4 & p301b_`i'==1) | (p301a_`i'==4 & p301c_`i'==1)     // 1 years  
replace sch_`i'=2  if (p301a_`i'==3 & p301b_`i'==2) | (p301a_`i'==3 & p301c_`i'==2) | (p301a_`i'==4 & p301b_`i'==2) | (p301a_`i'==4 & p301c_`i'==2)     // 2 years 
replace sch_`i'=3  if (p301a_`i'==3 & p301b_`i'==3) | (p301a_`i'==3 & p301c_`i'==3) | (p301a_`i'==4 & p301b_`i'==3) | (p301a_`i'==4 & p301c_`i'==3)     // 3 years 
replace sch_`i'=4  if (p301a_`i'==3 & p301b_`i'==4) | (p301a_`i'==3 & p301c_`i'==4) | (p301a_`i'==4 & p301b_`i'==4) | (p301a_`i'==4 & p301c_`i'==4)     // 4 years 
replace sch_`i'=5  if (p301a_`i'==3 & p301b_`i'==5) | (p301a_`i'==3 & p301c_`i'==5) | (p301a_`i'==4 & p301b_`i'==5) | (p301a_`i'==4 & p301c_`i'==5)     // 5 years 
replace sch_`i'=6  if (p301a_`i'==3 & p301b_`i'==6) | (p301a_`i'==3 & p301c_`i'==6) | (p301a_`i'==4 & p301b_`i'==6) | (p301a_`i'==4 & p301c_`i'==6)     // 6 years 
replace sch_`i'=7  if (p301a_`i'==5 & p301b_`i'==1) | (p301a_`i'==6 & p301b_`i'==1)                                                     // 7 years 
replace sch_`i'=8  if (p301a_`i'==5 & p301b_`i'==2) | (p301a_`i'==6 & p301b_`i'==2)   											        // 8 years 
replace sch_`i'=9  if (p301a_`i'==5 & p301b_`i'==3) | (p301a_`i'==6 & p301b_`i'==3)   												    // 9 years 
replace sch_`i'=10 if (p301a_`i'==5 & p301b_`i'==4) | (p301a_`i'==6 & p301b_`i'==4)   												    // 10 years 
replace sch_`i'=11 if (p301a_`i'==5 & p301b_`i'==5) | (p301a_`i'==6 & p301b_`i'==5)   												    // 11 years 
replace sch_`i'=12 if (p301a_`i'==6 & p301b_`i'==6) 	         																	// Nivel Secundaria
replace sch_`i'=12 if (p301a_`i'==7 & p301b_`i'==1) | (p301a_`i'==8 & p301b_`i'==1) | (p301a_`i'==9 & p301b_`i'==1) | (p301a_`i'==10 & p301b_`i'==1)   // 12 years 
replace sch_`i'=13 if (p301a_`i'==7 & p301b_`i'==2) | (p301a_`i'==8 & p301b_`i'==2) | (p301a_`i'==9 & p301b_`i'==2) | (p301a_`i'==10 & p301b_`i'==2)   // 13 years 
replace sch_`i'=14 if (p301a_`i'==7 & p301b_`i'==3) | (p301a_`i'==8 & p301b_`i'==3) | (p301a_`i'==9 & p301b_`i'==3) | (p301a_`i'==10 & p301b_`i'==3)   // 14 years 
replace sch_`i'=15 if (p301a_`i'==7 & p301b_`i'==4) | (p301a_`i'==8 & p301b_`i'==4) | (p301a_`i'==9 & p301b_`i'==4) | (p301a_`i'==10 & p301b_`i'==4)   // 15 years 
replace sch_`i'=16 if (p301a_`i'==7 & p301b_`i'==5) | (p301a_`i'==8 & p301b_`i'==5) | (p301a_`i'==9 & p301b_`i'==5) | (p301a_`i'==10 & p301b_`i'==5)   // 16 years 
replace sch_`i'=17 if (p301a_`i'==9 & p301b_`i'==6) | (p301a_`i'==10 & p301b_`i'==6) | (p301a_`i'==11 & p301b_`i'==1)	// 18 years 
replace sch_`i'=18 if (p301a_`i'==9 & p301b_`i'==7) | (p301a_`i'==10 & p301b_`i'==7) | (p301a_`i'==11 & p301b_`i'==2)	// 18 years 
label variable sch_`i' "Años de escolaridad `i' "

***TASA DE ANALFABETISMO

gen          analfa_`i' =0 if p208a_`i' >=15 & p204_`i' ==1
replace      analfa_`i' =1 if p208a_`i' >=15 & p302_`i' ==2 & p204_`i' ==1
label var    analfa_`i' "Sabe leer y escribir _`i'"
label values analfa_`i' yesno

* Lengua materna:
gen lengua_materna_`i' =1 if p300a_`i'==4
replace lengua_materna_`i'=2 if p300a_`i'==1 | p300a_`i' ==2 | p300a_`i' ==3 
replace lengua_materna_`i'=3 if p300a_`i'>=6 & p300a_`i' !=.
label define lengua_materna_`i' 1 "Castellano" 2 "Quechua/Aymara/otra nativa" 3 "Otra lengua"
label values lengua_materna_`i' lengua_materna_`i'

}

keep conglome* vivienda* hogar* codperso* sch_* analfa_* facpanel2022 facpanel1822 lengua_materna_* educ_*

label data "Módulo EDUCACIÓN - ENAHO Panel 2018–2022"
* Renombrar años si falta
capture rename a*o_18 año_18
capture rename a*o_19 año_19
capture rename a*o_20 año_20
capture rename a*o_21 año_21
capture rename a*o_22 año_22
save "$dclea/mod300_panel_1822.dta", replace

******************************************************
****### Módulo 500 – EMPLEO/INGRESOS (2018–2022) ###****
******************************************************
use conglome* vivienda* hogar* codperso* p203b* p204_* p301a_* p207_* ///
    i524a1_* d529t_* i530a_* d536_* i538a1_* d540t_* i541a_* d543_* d544t_* ///
    p558c* p505* p506* p507* p516* p554* p514* p557* p558e1_6_* ///
    estrato_* dominio_* ocupinf_* ocu500* perpanel2022 hpan1822 hpan2022 ///
    facpanel2022  facpanel1822 fac500a* facpob07* facpob* fac500_p* ///
    using "$mod05/enaho01a-2018-2022-500-panel.dta", clear

* >>> ACTIVAR PANEL ESTRICTO AQUÍ (AHORA DESACTIVADO)
* keep if perpanel2022 == 1
* keep if hpan1822     == 1

* OPCIONAL: solo jefes de hogar
* keep if p203b_18==1 | p203b_19==1 | p203b_20==1 | p203b_21==1 | p203b_22==1

foreach i in 18 19 20 21 22 {
****INGRESO LABORAL

* Main Occupation Income
egen inc_pri_`i' = rowtotal(i524a1_`i' d529t_`i' i530a_`i' d536_`i')						
* Secondary Occupation Income
egen inc_sec_`i' = rowtotal(i538a1_`i' d540t_`i' i541a_`i' d543_`i')

* Total labor Income
egen inc_lab_`i' = rowtotal(inc_pri_`i' inc_sec_`i')  					

* Extraordinary Income (grati., bonus, CTS, etc)
rename d544t_`i' inc_extra_`i'

* Total monthly income
egen inc_total_`i' = rowtotal(inc_lab_`i' inc_extra_`i') 
replace inc_total_`i'=. if inc_lab_`i'==0 | inc_lab_`i'==. // It could happen that there is a missing at labor income and a payment of CTS

* Logarithm of wage from main occupation income
gen lw_`i'=ln(inc_pri_`i'+1)
replace lw_`i'=0 if lw_`i'==.

* Logarithm of total wage
gen lwage_`i'=ln(inc_total_`i'+1)
replace lwage_`i'=0 if lwage_`i'==.

*CIIU
gen      ciiu_aux1_`i' =substr("0"+string(p506r4_`i'),1,.)
replace  ciiu_aux1_`i' =substr(string(p506r4_`i'),1,.) if p506r4_`i'>999
gen      ciiu_aux2_`i' =substr(ciiu_aux1_`i' ,1,2)
destring ciiu_aux2_`i', generate(ciiu_2d_`i')
gen      ciiu_1d_`i'=1 if  ciiu_2d_`i'<=2
replace  ciiu_1d_`i'=2 if  ciiu_2d_`i'==3
replace  ciiu_1d_`i'=3 if  ciiu_2d_`i'>=5  & ciiu_2d_`i'<=9
replace  ciiu_1d_`i'=4 if  ciiu_2d_`i'>=10 & ciiu_2d_`i'<=33
replace  ciiu_1d_`i'=5 if  ciiu_2d_`i'>=41 & ciiu_2d_`i'<=43
replace  ciiu_1d_`i'=6 if  ciiu_2d_`i'>=45 & ciiu_2d_`i'<=47
replace  ciiu_1d_`i'=7 if (ciiu_2d_`i'>=49 & ciiu_2d_`i'<=53) | (ciiu_2d_`i'>=58 & ciiu_2d_`i'<=63)
replace  ciiu_1d_`i'=8 if  ciiu_2d_`i'==84
replace  ciiu_1d_`i'=9 if  ciiu_2d_`i'>=55 & ciiu_2d_`i'<=56
replace  ciiu_1d_`i'=10 if ciiu_2d_`i'==68 | (ciiu_2d_`i'>=69 & ciiu_2d_`i'<=82)
replace  ciiu_1d_`i'=11 if ciiu_2d_`i'==85 					 
replace  ciiu_1d_`i'=12 if (ciiu_2d_`i'>=35 & ciiu_2d_`i'<=39) | (ciiu_2d_`i'>=64 & ciiu_2d_`i'<=66)  | (ciiu_2d_`i'>=86 & ciiu_2d_`i'<=88) |  (ciiu_2d_`i'>=90 & ciiu_2d_`i'<=93)| (ciiu_2d_`i'>=94 & ciiu_2d_`i'<=98) |  ciiu_2d_`i'==99
	
	gen sec_ocu_`i' = ciiu_1d_`i'
label var sec_ocu_`i'  "Division CIIU"
la de ciiu_1d_`i' 1 "Agricultura" 2 "Pesca"  3 "Mineria" 4 "Manufactura" 5 "Construccion" 6 "Comercio" 7 "Transportes y Comunicaciones"  8 "Gobierno" 9 "Hoteles y Restaurantes" 10 "Inmobiliarias y alquileres" 11 "Enseñanza" 12 "Otros Servicios 1/"
 label values sec_ocu_`i' ciiu_1d_`i'
*1/ Otros Servicios lo componen las ramas de actividad de Electricidad, Gas y Agua, 
*Intermediación Financiera, Actividades de Servicios Sociales y de Salud, Otras activ.
*de Serv. Comunitarias, Sociales y Personales y Hogares privados con servicio doméstico.


**NUMERO DE EMPLEOS DEL JEFE DE HOGAR
recode p514_`i' (1=1) (2=0), gen(nempljh_`i')
lab var nempljh_`i' "Num Empleos Jefe Hogar"
lab def nempljh_`i' 1"Más de 01 empleo" 0"Solo 01 empleo"
lab val nempljh_`i' nempljh_`i'

***ACTIVOS EMPRESARIALES
gen act_empr_`i'=(p5571a_`i'==1 | p5572a_`i'==1 | p5573a_`i'==1 | p5574a_`i'==1 | p5575a_`i'==1 | p5576a_`i'==1 | p5577a_`i'==1 | p5578a_`i'==1)
label variable act_empr_`i' "Posee activos empresariales 20`i'"
label define act_empr_`i' 1"Si" 0"No"
label values act_empr_`i' act_empr_`i'

**SITUACION DE EMPLEO:
recode ocupinf_`i' (1=1 "E. Informal") (2=0 "E. Formal"), gen(informal_`i')
label variable ocupinf_`i' "Situacion de informalidad (O. principal)"

* Race or ethnic group
recode p558c_`i' (5=1 "Blanco") (6=2 "Mestizo") (1/3 9 =3 "Nativo peruano 1/") (4=4 "Afroperuvian") (7=5 "Otro") (8=6 "No sabe") (.=6 "No sabe"), gen(race_`i')
label variable race_`i' "Race or ethnic group"
*1/ Incluye: Quechua, Aimara y Nativo o Indígena de la Amazonía.
*2/ Incluye: Blanco y otro

/* Mayores de 18 anios con acceso al sistema financiero:
gen acceso_financiero_`i'=(p558e1_6_`i'==6)
	recode acceso_financiero_`i' (1=0 "No") (0=1 "Si"), gen(inc_finc_`i')
	lab var inc_finc_`i' "Tiene acceso al sistema financiero - 20`i'"
*/
/* Funcion en su trabajo:
gen funcion_`i'=1 		if 	p507_`i'==1 
replace funcion_`i'=2 	if p507_`i'==2
replace funcion_`i'=3 	if p507_`i'==3
replace funcion_`i'=4 	if p507_`i'==4
replace funcion_`i'=5 	if p507_`i'>=5 & p507_`i'!=.
label define funcion_`i' 1 "Empleador/patrono" 2 "Trabajador independiente" 3 "Empleado" 4 "Obrero" 5 "Trabajador familiar no remunerado/otro"
label values funcion_`i' funcion_`i'
*/
}

keep conglome* vivienda* hogar* codperso* inc_* lw_* lwage_* sec_ocu_* ///
     nempljh_* act_empr_* ocupinf_* race_* ///
       hpan2022 facpanel2022 fac500a* facpob07* facpob* fac500_p* ocu500*

label data "Módulo EMPLEO/INGRESOS - ENAHO Panel 2018–2022"
* Renombrar años si falta
capture rename a*o_18 año_18
capture rename a*o_19 año_19
capture rename a*o_20 año_20
capture rename a*o_21 año_21
capture rename a*o_22 año_22
save "$dclea/mod500_panel_1822.dta", replace

******************************************************
****### 3. Módulo 100 – VIVIENDA (2018–2022)   ###****
******************************************************
use "$mod01/enaho01-2018-2022-100-panel.dta", clear

* >>> ACTIVAR PANEL ESTRICTO AQUÍ (AHORA DESACTIVADO)
* keep if hpan1822 == 1

foreach i in 18 19 20 21 22 {
*"AGUA POTABLE" 
gen ag_pot_`i'=(p110_`i'==1 | p110_`i'==2 | p110_`i'==3)
	lab var ag_pot_`i' "Agua potable"
	lab def ag_pot_`i' 1"Si" 0"No"
	lab val ag_pot_`i' ag_pot_`i'

*X12: enerlectr
gen enerlectr_`i'= (p112a_`i'==1 | p112a_`i'==2 | p112a_`i'==3)
	lab var enerlectr_`i' "Energia Electrica"
	lab def enerlectr_`i' 1"Si" 0"No"
	lab val enerlectr_`i' enerlectr_`i'
* : internet

gen internet_`i' = (p1144_`i' ==1)

*capital institucional: prop_viv "Propiedad de la vivienda"
 
gen prop_viv_`i'=(p105a_`i'==2 | p105a_`i'==3 | p105a_`i'==4)
	lab var prop_viv_`i' "Tipo de vivienda"
	lab def prop_viv_`i' 1"Propia" 0"Alquilada / Cedida"
	lab val prop_viv_`i' prop_viv_`i'

gen tit_prop_`i'=(p106a_`i'==1)
	lab var tit_prop_`i' "Tiene titulo Propiedad"
	lab def tit_prop_`i' 1"Si" 0"No / En tramite"
	lab val tit_prop_`i' prop_viv_`i'

gen sunarp_`i'=(p106b_`i'==1)
	label var sunarp_`i' "T. P. registrado en SUNARP"
	label def sunarp_`i' 1"Si" 0"No / En tramite"
	label val sunarp_`i' sunarp_`i'

	* Area
recode estrato_`i' (1/5=1 "Urbano") (6/8=0 "Rural"), gen(urban_`i') 
	label variable urban_`i' "Urbano `i'"

* Zone
recode dominio_`i' (1/3=1 "Coast") (4/6=2 "Highlands") (7/7=3 "Jungle") (8/8=4 "Lima Metropolis"), gen(zone_`i')
	label var zone_`i' "Zone `i'"
}

keep conglome* vivienda* hogar* ag_pot_* enerlectr_* internet_* prop_viv_* ///
     tit_prop_* sunarp_* urban_* zone_* nbi* hpan1822 hpan2022 factor07*

label data "Módulo VIVIENDA - ENAHO Panel 2018–2022"
* Renombrar años si falta
capture rename a*o_18 año_18
capture rename a*o_19 año_19
capture rename a*o_20 año_20
capture rename a*o_21 año_21
capture rename a*o_22 año_22
save "$dclea/mod100_panel_1822.dta", replace

**************************************************************
****### 4. Módulo 200 – MIEMBROS DEL HOGAR (2018–2022) ###****
**************************************************************
use "$mod02/enaho01-2018-2022-200-panel.dta", clear

* >>> ACTIVAR PANEL ESTRICTO AQUÍ (AHORA DESACTIVADO)
* keep if perpanel2022 == 1
* keep if hpan1822     == 1

* OPCIONAL: solo jefes de hogar
* keep if p203b_18==1 | p203b_19==1 | p203b_20==1 | p203b_21==1 | p203b_22==1

label def g_edad 0 "Menor de 18" 1 "18–29" 2 "30–39" 3 "40–49" 4 "50–59" 5 "60–69" 6 "70+"

foreach i in 18 19 20 21 22 {
    
***DISCRIMINACION Y EXCLUSION SOCIAL

* Sexo
recode p207_`i' (2=0 "Mujer") (1=1 "Varón"), gen(sex_`i')
label variable sex_`i' "Sexo del jefe del hogar"

* Edad en años
gen age_`i'= p208a_`i' 
label variable age_`i' "Edad en (años cumplidos) `i'"

*Grupos de edad
gen     g_edad_`i'=1 if p208a_`i'>=18 & p208a_`i'<30
replace g_edad_`i'=2 if p208a_`i'>=30 & p208a_`i'<40
replace g_edad_`i'=3 if p208a_`i'>=40 & p208a_`i'<50
replace g_edad_`i'=4 if p208a_`i'>=50 & p208a_`i'<60
replace g_edad_`i'=5 if p208a_`i'>=60 & p208a_`i'<70
replace g_edad_`i'=6 if p208a_`i'>=70
replace g_edad_`i'=0 if p208a_`i'<18

lab val g_edad_`i' g_edad


*Estado civil

recode p209_`i' (6=1 "Soltero/a") (1=2 "Casado/a o Conviviente") (2=2 "Casado/a o Conviviente") (4=3 "Separado/a o Divorciado") (5=3 "Separado/a o Divorciado") (3=4 "Viudo") , gen (ecivil_`i')
	lab var ecivil_`i' "Estado Civil"
}

keep conglome* vivienda* hogar* codperso* p203* p203b* ecivil_* sex* age* g_edad* ///
     hpan1822 hpan2022 factor07*
	 

label data "Módulo MIEMBROS - ENAHO Panel 2018–2022"
* Renombrar años si falta
capture rename a*o_18 año_18
capture rename a*o_19 año_19
capture rename a*o_20 año_20
capture rename a*o_21 año_21
capture rename a*o_22 año_22
save "$dclea/mod200_panel_1822.dta", replace

***************************************************
****### 5. Módulo 400 – SALUD (2018–2022)   ###****
***************************************************
use "$mod04/enaho01a-2018-2022-400-panel.dta", clear

* >>> ACTIVAR PANEL ESTRICTO AQUÍ (AHORA DESACTIVADO)
* keep if perpanel2022 == 1
* keep if hpan1822     == 1

label def seguro    1 "No tiene" 2 "Seguro privado/otro" 3 "Seguro público"
label def limitacion 0 "Sin limitación" 1 "Alguna limitación"
label def yesno 0 "Si" 1 "No"

foreach i in 18 19 20 21 22 {
  * Seguro de salud:
gen seguro_`i'=1 		if p4191_`i'==2 & p4192_`i'==2 & p4193_`i'==2 & p4194_`i'==2 & p4195_`i'==2 & p4196_`i'==2 & p4197_`i'==2 & p4198_`i'==2
replace seguro_`i'=2 	if p4192_`i'==1 | p4193_`i'==1 | p4196_`i'==1 | p4197_`i'==1 | p4198_`i'==1 
replace seguro_`i'=3 	if p4191_`i'==1 | p4194_`i'==1 | p4195_`i'==1

label values seguro_`i' seguro

gen dic_segur_`i'=(seguro_`i'==1)
	lab var dic_segur_`i' "Tiene seguro de Salud - 20`i'"
	lab val dic_segur_`i' yesno
	
* Limitaciones
gen limitacion_`i' =0 if p401h1_`i' !=.
replace limitacion_`i' =1 if p401h1_`i' ==1 | p401h2_`i'==1 | p401h3_`i'==1 | p401h4_`i'==1 | p401h5_`i'==1 | p401h6_`i'==1
	lab var limitacion_`i' "Presenta alguna Limitacion - 20`i'"
	lab val limitacion_`i' yesno
**Enfermedad cronica
gen croni_`i' =(p401_`i' ==1)
	lab var croni_`i'  "Presenta alguna enfermedad Crónica - 20`i'"
	label val croni_`i'  yesno
		
*MORBILIDAD
gen morbilid_`i' =(p40314_`i'==0 | p4025_`i'==0)
replace morbilid_`i'=. if p4025_`i'==.
	lab var morbilid_`i' "Morbilidad - 20`i'"
	lab val morbilid_`i' yesno
	
***REDES DE APOYO SOCIAL
gen dni_`i'=(p401_`i' ==1)
	lab var dni_`i' "Tiene DNI"
	lab val dni_`i' yesno	
}

gen vac_covid_22 = (p413f_22==1)
label var vac_covid_22 "Recibió vacuna COVID-19"
label values vac_covid_22 yesno

keep conglome* vivienda* hogar* codperso* seguro_* dic_segur_* limitacion_* ///
     croni_* morbilid_* dni_* vac_covid_* hpan1822 hpan2022 perpanel1822 perpanel2022 factor07* facpob* factor_*

label data "Módulo SALUD - ENAHO Panel 2018–2022"
* Renombrar años si falta
capture rename a*o_18 año_18
capture rename a*o_19 año_19
capture rename a*o_20 año_20
capture rename a*o_21 año_21
capture rename a*o_22 año_22
save "$dclea/mod400_panel_1822.dta", replace

*****************************************************************
****### 6. Módulo SUMARIA – Pobreza monetaria (2018–2022) ###****
*****************************************************************
use "$mod06/sumaria-2018-2022-panel.dta", clear

* >>> ACTIVAR PANEL ESTRICTO AQUÍ (AHORA DESACTIVADO)
* keep if hpan1822 == 1

foreach i in 18 19 20 21 22 {

    gen ratio_dep_`i' = percepho_`i'/mieperho_`i'

    gen gpcm_`i' = gashog2d_`i'/(mieperho_`i'*12)

    gen pobre2_`i' = (gpcm_`i' < linea_`i')
    label define pobre2_`i' 1 "Pobre" 0 "No pobre"
    label values pobre2_`i' pobre2_`i'
    label var pobre2_`i' "Pobreza monetaria `i'"

    gen facpob_`i' = factor07_`i'*mieperho_`i'*12
}

rename hpanel_18_22 hpan1822 
rename hpanel_20_22 hpan2022

keep a*o_* conglome_* vivienda_* hogar_* estrato* ubigeo_* mieperho_* totmieho_* ///
     percepho_* estrsocial_* pobre2_* pobreza_* pobrezav_* linea_* linpe_* ///
     gpcm_* ingmo1hd* ingmo2hd* inghog1d* inghog2d* hpan1822 hpan2022 factor07* facpob*

label data "Módulo SUMARIA - ENAHO Panel 2018–2022"
* Renombrar años si falta
capture rename a*o_18 año_18
capture rename a*o_19 año_19
capture rename a*o_20 año_20
capture rename a*o_21 año_21
capture rename a*o_22 año_22


save "$dclea/mod_sumaria_panel_1822.dta", replace

***************************************************************************
****### 7. Juntar módulos (IDs 2022, pero datos 2018–2022 "todo junto") ###
***************************************************************************
********************************
*** JUNTAMOS LAS BASES DE DATOS
********************************

* 1) BASE MAESTRA: SUMARIA (nivel hogar)
use "$dclea/mod_sumaria_panel_1822.dta", clear

* 2) VIVIENDA (también a nivel hogar)
*    Se usa toda la firma conglome* vivienda* hogar* (2018–2022)
merge m:1 conglome* vivienda* hogar* using "$dclea/mod100_panel_1822.dta", nogen


* 3) MIEMBROS DEL HOGAR (nivel persona)
*    Aquí hay varias personas por hogar, por eso debe ser m:m si la firma
*    conglome* vivienda* hogar* no es única en el using.
merge m:m conglome* vivienda* hogar* ///
    using "$dclea/mod200_panel_1822.dta", nogen

* 4) EDUCACIÓN (nivel persona)
merge m:m conglome* vivienda* hogar* codperso* ///
    using "$dclea/mod300_panel_1822.dta", nogen

* 5) SALUD (nivel persona)
merge m:m  conglome* vivienda* hogar* codperso* ///
    using "$dclea/mod400_panel_1822.dta", nogen

* 6) EMPLEO (nivel persona)
merge m:m conglome* vivienda* hogar* codperso* ///
    using "$dclea/mod500_panel_1822.dta", nogen

label data "DATA POBREZA - ENAHO Panel 2018–2022 (wide, 18–22)"

* Renombrar años si falta
capture rename a*o_18 año_18
capture rename a*o_19 año_19
capture rename a*o_20 año_20
capture rename a*o_21 año_21
capture rename a*o_22 año_22

sort conglome_22 vivienda_22 hogar_22 codperso_22
save "$dclea/mod_all_panel_1822.dta", replace




******************************************************
****### 8. Reshape a panel largo (2018–2022)   ###****
******************************************************
use "$dclea/mod_all_panel_1822.dta", clear

gen id = _n

reshape long año_ conglome_ vivienda_ hogar_ estrato ubigeo_ ratio_dep_ gpcm_ ///
    codperso_ inc_extra_ ocupinf_ inc_pri_ inc_sec_ inc_lab_ inc_total_ p203_ p203b_ ///
    lw_ lwage_ sec_ocu_ nempljh_ act_empr_ race_ inc_finc_ funcion_ ///
    seguro_ dic_segur_ limitacion_ croni_ morbilid_ dni_ vac_covid_ ///
    sch_ analfa_ sex_ age_ g_edad_ lengua_materna_ ecivil_ internet_ ///
    nbi1_ nbi2_ nbi3_ nbi4_ nbi5_ ag_pot_ enerlectr_ prop_viv_ tit_prop_ ///
    sunarp_ urban_ zone_ mieperho_ totmieho_ percepho_ estrsocial_ ///
    pobre2_ pobreza_ pobrezav_ linea_ linpe_ fac500a_ facpob07_ factor07_ ///
    fac500_p_ facpob_ ocu500_ ingmo1hd_ ingmo1hd1_ ingmo2hd_ ingmo2hd1_ ///
    inghog1d_ inghog1d1_ inghog2d_ inghog2d1_ lineav_ lineav_rpl_ estrato_ ///
    educ_ , i(id) j(year)

label var year "Año"
label define year 18 "2018" 19 "2019" 20 "2020" 21 "2021" 22 "2022"
label values year year

gen dpto_ = real(substr(ubigeo_,1,2))
label var dpto_ "Departamento"

#delimit ;
label define dep 01 "Amazonas" 02 "Ancash" 03 "Apurímac" 04 "Arequipa" 05 "Ayacucho"
                 06 "Cajamarca" 07 "Callao" 08 "Cusco" 09 "Huancavelica" 10 "Huánuco"
                 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Lima"
                 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco"
                 20 "Piura" 21 "Puno" 22 "San Martín" 23 "Tacna" 24 "Tumbes"
                 25 "Ucayali" ;
#delimit cr

label values dpto_ dep

*-----------------------------------------------------------*
*  POBREZA MULTIDIMENSIONAL Y POBREZA INTEGRADA (2018–2022) *
*-----------------------------------------------------------*

* 1. Número de NBI por hogar-año
*   Supone que nbi1_–nbi5_ son indicadores (1 = tiene carencia).
capture confirm var nbi1_ nbi2_ nbi3_ nbi4_ nbi5_
if _rc==0 {
    
    egen nbi_count = rowtotal(nbi1_ nbi2_ nbi3_ nbi4_ nbi5_), missing
    label var nbi_count "Número de NBI (1–5) del hogar"

    * 2. Pobreza multidimensional (ajustar el umbral según tu definición)
    *    Aquí: pobre multidimensional si tiene ≥1 NBI.
    gen pobre_multi = (nbi_count >= 1) if nbi_count < .
    label define pobre_multi 0 "No pobre multidimensional" 1 "Pobre multidimensional"
    label values pobre_multi pobre_multi
    label var pobre_multi "Condición de pobreza multidimensional"

    * 3. Pobreza integrada: pobre si es pobre monetario o pobre multidimensional
    *    (unión de pobreza monetaria y multidimensional)
    gen pobre_integrada = .
    replace pobre_integrada = 1 if pobre2_ == 1 | pobre_multi == 1
    replace pobre_integrada = 0 if pobre2_ == 0 & pobre_multi == 0

    label define pobre_int 0 "No pobre integrada" 1 "Pobre integrada"
    label values pobre_integrada pobre_int
    label var pobre_integrada "Condición de pobreza integrada"

    * 4. Clasificación cruzada (opcional, útil para tablas descriptivas)
    *    1: no pobre por ninguna
    *    2: solo pobre monetario
    *    3: solo pobre multidimensional
    *    4: pobre en ambas dimensiones
    gen pobre_clase = .
    replace pobre_clase = 1 if pobre2_==0 & pobre_multi==0
    replace pobre_clase = 2 if pobre2_==1 & pobre_multi==0
    replace pobre_clase = 3 if pobre2_==0 & pobre_multi==1
    replace pobre_clase = 4 if pobre2_==1 & pobre_multi==1

    label define pobre_clase 1 "No pobre" ///
                             2 "Solo monetaria" ///
                             3 "Solo multidimensional" ///
                             4 "Monetaria y multidimensional"
    label values pobre_clase pobre_clase
    label var pobre_clase "Tipo de pobreza (monetaria/multidimensional)"

} 
else {
    di as error "Advertencia: no se encontraron las variables nbi1_–nbi5_. Revise nombres en módulo de vivienda."
}

drop if dpto_ ==.
drop if sch_ ==.
drop if  inghog2d_ ==.
*a) Panel a nivel HOGAR (recomendado para pobreza):
egen idhogar = group(conglome_ vivienda_ hogar_)
*xtset idhogar year

*b) Panel a nivel HOGAR–PERSONA (si estás usando jefes u otra persona):
egen idhp = group(conglome_ vivienda_ hogar_ codperso_)
*xtset idhp year

*para que sea un panel estricto.
*keep if hpan1822 == 1
*xtset idhogar year   // o idhp, según el nivel de análisis
* 1 = jefe de hogar (relación de parentesco con el hogar)
keep if p203_ ==1
***elaboracion de la tabla 2: 
***###transversal:
tab year
tab year if dpto==21

***###panel (del modulo 100, panel=1)
tab year if hpan1822 == 1
tab year if hpan2022 == 1
*tab year urban if hpan1822 == 1

tab year if dpto==21 & hpan1822 == 1
tab year if dpto==21 & hpan2022 == 1
*tab year urban if dpto==21 & hpan1822 == 1

save "$dclea/pobreza_panel_18-22_full.dta", replace

******************************************************
use "$dclea/pobreza_panel_18-22_full.dta", clear


