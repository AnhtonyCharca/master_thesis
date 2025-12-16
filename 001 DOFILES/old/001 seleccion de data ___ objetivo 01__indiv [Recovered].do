clear all
set more off
**en lapto personal	(home)
*************************************
******DIRECTORIOS DE TRABAJO ********
*************************************
glo enaho_bas	"F:\ENAHO\001 BASES"
glo mod01		"$enaho_bas\001 modulo 01"
glo mod02		"$enaho_bas\002 modulo 02"
glo mod03		"$enaho_bas\003 modulo 03"
glo mod04		"$enaho_bas\004 modulo 04"	
glo mod05		"$enaho_bas\005 modulo 05"
glo mod037		"$enaho_bas\037 programas sociales"
glo sumr		"$enaho_bas\034 sumarias"
*glo maestria	"C:\Users\CI-EPG-THONY\OneDrive\MI TESIS EPG MASTER\MAESTRIA"
glo maestria	"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA"
glo tempo		"$maestria\002 BASE DE DATOS\001 TEMP"
glo dclea		"$maestria\002 BASE DE DATOS\002 CLEAN"
glo dofil		"$maestria\001 DOFILES"

cd "$enaho_bas"

**# Bookmark #1
*========================
* Modulo 03 (Educacion)
*========================
foreach year of numlist 2018/2022 {
use "$mod03/enaho01a-`year'-300.dta" , clear

/*VARIABLES A SELECCIONAR:
--> nivel de educacion
--> años de educacion
--> analfabetismo
*/
**Manter solo JEFES de hogar
keep if p203==1 
	
* Mantener a las personas que formaron parte del hogar durante todo el período
drop if p204==2

* Instruction/Education Level
lab def niveduc 0 "No level" 1 "Primary" 2 "Secondary" 3 "Superior non-university" 4 "Superior university" 5 "Postgraduated" 
lab def yesno 	0 "Si" 1 "No"


*foreach i in 20 21 22 {

**Nivel de educacion
gen educ=.
replace educ = 0 if p301a == 1 | p301a == 2
replace educ = 1 if p301a == 3 | p301a == 4
replace educ = 2 if p301a == 5 | p301a == 6
replace educ = 3 if p301a == 7 | p301a == 8
replace educ = 4 if p301a == 9 | p301a == 10
replace educ = 5 if p301a == 11
label values educ niveduc
label variable educ "Nivel de educacion"	
drop if educ==.

* Escolaridad alcanzada (años)
gen sch =.
replace sch =0  if p301a ==1 | p301a ==2 					                                                            // Sin nivel ni nivel inicial
replace sch =0  if p301a ==3 & (p301b ==0 & p301c ==0)																    // Nivel Inicial
replace sch =1  if (p301a ==3 & p301b ==1) | (p301a ==3 & p301c ==1) | (p301a ==4 & p301b ==1) | (p301a ==4 & p301c ==1)     // 1 years  
replace sch =2  if (p301a ==3 & p301b ==2) | (p301a ==3 & p301c ==2) | (p301a ==4 & p301b ==2) | (p301a ==4 & p301c ==2)     // 2 years 
replace sch =3  if (p301a ==3 & p301b ==3) | (p301a ==3 & p301c ==3) | (p301a ==4 & p301b ==3) | (p301a ==4 & p301c ==3)     // 3 years 
replace sch =4  if (p301a ==3 & p301b ==4) | (p301a ==3 & p301c ==4) | (p301a ==4 & p301b ==4) | (p301a ==4 & p301c ==4)     // 4 years 
replace sch =5  if (p301a ==3 & p301b ==5) | (p301a ==3 & p301c ==5) | (p301a ==4 & p301b ==5) | (p301a ==4 & p301c ==5)     // 5 years 
replace sch =6  if (p301a ==3 & p301b ==6) | (p301a ==3 & p301c ==6) | (p301a ==4 & p301b ==6) | (p301a ==4 & p301c ==6)     // 6 years 
replace sch =7  if (p301a ==5 & p301b ==1) | (p301a ==6 & p301b ==1)                                                     // 7 years 
replace sch =8  if (p301a ==5 & p301b ==2) | (p301a ==6 & p301b ==2)   											        // 8 years 
replace sch =9  if (p301a ==5 & p301b ==3) | (p301a ==6 & p301b ==3)   												    // 9 years 
replace sch =10 if (p301a ==5 & p301b ==4) | (p301a ==6 & p301b ==4)   												    // 10 years 
replace sch =11 if (p301a ==5 & p301b ==5) | (p301a ==6 & p301b ==5)   												    // 11 years 
replace sch =12 if (p301a ==6 & p301b ==6) 	         																	// Nivel Secundaria
replace sch =12 if (p301a ==7 & p301b ==1) | (p301a ==8 & p301b ==1) | (p301a ==9 & p301b ==1) | (p301a ==10 & p301b ==1)   // 12 years 
replace sch =13 if (p301a ==7 & p301b ==2) | (p301a ==8 & p301b ==2) | (p301a ==9 & p301b ==2) | (p301a ==10 & p301b ==2)   // 13 years 
replace sch =14 if (p301a ==7 & p301b ==3) | (p301a ==8 & p301b ==3) | (p301a ==9 & p301b ==3) | (p301a ==10 & p301b ==3)   // 14 years 
replace sch =15 if (p301a ==7 & p301b ==4) | (p301a ==8 & p301b ==4) | (p301a ==9 & p301b ==4) | (p301a ==10 & p301b ==4)   // 15 years 
replace sch =16 if (p301a ==7 & p301b ==5) | (p301a ==8 & p301b ==5) | (p301a ==9 & p301b ==5) | (p301a ==10 & p301b ==5)   // 16 years 
replace sch =17 if (p301a ==9 & p301b ==6) | (p301a ==10 & p301b ==6) | (p301a ==11 & p301b ==1)	// 18 years 
replace sch =18 if (p301a ==9 & p301b ==7) | (p301a ==10 & p301b ==7) | (p301a ==11 & p301b ==2)	// 18 years 
label variable sch  "Años de escolaridad"

***TASA DE ANALFABETISMO

gen          analfa  =0 if p208a  >=15 & p204  ==1
replace      analfa  =1 if p208a  >=15 & p302  ==2 & p204  ==1
label var    analfa  "Sabe leer y escribir"
label values analfa  yesno

* Lengua materna:
gen lengua_materna  =1 if p300a ==4
replace lengua_materna =2 if p300a ==1 | p300a  ==2 | p300a ==3 
replace lengua_materna =3 if p300a >=6 & p300a  !=.
label define lengua_materna  1 "Castellano" 2 "Quechua/Aymara/otra nativa" 3 "Otra lengua"
label values lengua_materna  lengua_materna 

keep conglome vivienda hogar codperso ubigeo dominio estrato  sch  analfa lengua_materna  educ yea* p207

label data "Modulo: EDUCACION - ENAHO "

save "$dclea/mod300_`year'.dta" , replace

**# Bookmark #2
*=====================
* Module 500 (Employment)
*=====================

use "$mod05/enaho01a-`year'-500.dta" , clear
**Manter solo JEFES de hogar
keep if p203==1

* Keep people who were part of the household for the entire period
drop if p204==2 

****INGRESO LABORAL

* Main Occupation Income
egen inc_pri  = rowtotal(i524a1  d529t  i530a  d536 )						
* Secondary Occupation Income
egen inc_sec  = rowtotal(i538a1  d540t i541a  d543 )

* Total labor Income
egen inc_lab  = rowtotal(inc_pri  inc_sec )  					

* Extraordinary Income (grati., bonus, CTS, etc)
rename d544t  inc_extra 

* Total monthly income
egen inc_total  = rowtotal(inc_lab  inc_extra ) 
replace inc_total =. if inc_lab ==0 | inc_lab ==. // It could happen that there is a missing at labor income and a payment of CTS

* Logarithm of wage from main occupation income
gen lw =ln(inc_pri +1)
replace lw =0 if lw ==.

* Logarithm of total wage
gen lwage =ln(inc_total +1)
replace lwage =0 if lwage ==.

*CIIU
gen      ciiu_aux1  =substr("0"+string(p506r4 ),1,.)
replace  ciiu_aux1  =substr(string(p506r4 ),1,.) if p506r4 >999
gen      ciiu_aux2  =substr(ciiu_aux1  ,1,2)
destring ciiu_aux2 , generate(ciiu_2d )
gen      ciiu_1d =1 if  ciiu_2d <=2
replace  ciiu_1d =2 if  ciiu_2d ==3
replace  ciiu_1d =3 if  ciiu_2d >=5  & ciiu_2d <=9
replace  ciiu_1d =4 if  ciiu_2d >=10 & ciiu_2d <=33
replace  ciiu_1d =5 if  ciiu_2d >=41 & ciiu_2d <=43
replace  ciiu_1d =6 if  ciiu_2d >=45 & ciiu_2d <=47
replace  ciiu_1d =7 if (ciiu_2d >=49 & ciiu_2d <=53) | (ciiu_2d >=58 & ciiu_2d <=63)
replace  ciiu_1d =8 if  ciiu_2d ==84
replace  ciiu_1d =9 if  ciiu_2d >=55 & ciiu_2d <=56
replace  ciiu_1d =10 if ciiu_2d ==68 | (ciiu_2d >=69 & ciiu_2d <=82)
replace  ciiu_1d =11 if ciiu_2d ==85 					 
replace  ciiu_1d =12 if (ciiu_2d >=35 & ciiu_2d <=39) | (ciiu_2d >=64 & ciiu_2d <=66)  | (ciiu_2d >=86 & ciiu_2d <=88) |  (ciiu_2d >=90 & ciiu_2d <=93)| (ciiu_2d >=94 & ciiu_2d <=98) |  ciiu_2d ==99
	
	gen sec_ocu  = ciiu_1d 
label var sec_ocu  "Division CIIU"
la de ciiu_1d  1 "Agricultura" 2 "Pesca"  3 "Mineria" 4 "Manufactura" 5 "Construccion" 6 "Comercio" 7 "Transportes y Comunicaciones"  8 "Gobierno" 9 "Hoteles y Restaurantes" 10 "Inmobiliarias y alquileres" 11 "Enseñanza" 12 "Otros Servicios 1/"
 label values sec_ocu  ciiu_1d 
 
 * Sector economico:
gen sector_econ=1 if p506>=100 & p506<=1000
replace sector_econ=2 if p506>=1010 & p506<4100
replace sector_econ=3 if (p506>=4510 & p506<=4799) | (p506>=4911 & p506<=5320) | (p506>=5811 & p506<=6399) | (p506>=5510 & p506<=5630)
replace sector_econ=4 if p506!=. & sector_econ==.
label define sector_econ 1 "Agro y pesca" 2 "Manufactura" 3 "Comercio, restaurantes, transportes y comunicaciones" /*
*/ 4 "Otros sectores"
label values sector_econ sector_econ


* Funcion en su trabajo:
gen funcion=1 if p507==1 
replace funcion=2 if p507==2
replace funcion=3 if p507==3
replace funcion=4 if p507==4
replace funcion=5 if p507>=5 & p507!=.
label define funcion 1 "Empleador/patrono" 2 "Trabajador independiente" 3 "Empleado" 4 "Obrero" 5 "Trabajador familiar no remunerado/otro"
label values funcion funcion

 
 *1/ Otros Servicios lo componen las ramas de actividad de Electricidad, Gas y Agua, 
*Intermediación Financiera, Actividades de Servicios Sociales y de Salud, Otras activ.
*de Serv. Comunitarias, Sociales y Personales y Hogares privados con servicio doméstico.


**NUMERO DE EMPLEOS DEL JEFE DE HOGAR
recode p514  (1=1) (2=0), gen(nempljh )
lab var nempljh  "Num Empleos Jefe Hogar"
lab def nempljh  1"Más de 01 empleo" 0"Solo 01 empleo"
lab val nempljh  nempljh 

***ACTIVOS EMPRESARIALES
gen act_empr =(p5571a ==1 | p5572a ==1 | p5573a ==1 | p5574a ==1 | p5575a ==1 | p5576a ==1 | p5577a ==1 | p5578a ==1)
label variable act_empr  "Posee activos empresariales 20`i'"
label define act_empr 1"Si" 0"No"
label values act_empr  act_empr 

**SITUACION DE EMPLEO:
recode ocupinf  (1=1 "E. Informal") (2=0 "E. Formal"), gen(informal )
label variable ocupinf "Situacion de informalidad (O. principal)"

* Race or ethnic group
recode p558c  (5=1 "Blanco") (6=2 "Mestizo") (1/3 9 =3 "Nativo peruano 1/") (4=4 "Afroperuvian") (7=5 "Otro") (8=6 "No sabe") (.=6 "No sabe"), gen(race )
label variable race "Race or ethnic group"
*1/ Incluye: Quechua, Aimara y Nativo o Indígena de la Amazonía.
*2/ Incluye: Blanco y otro

/* Mayores de 18 anios con acceso al sistema financiero:
gen acceso_financiero =(p558e1_6 ==6)
	recode acceso_financiero  (1=0 "No") (0=1 "Si"), gen(inc_finc )
	lab var inc_finc  "Tiene acceso al sistema financiero - 20`i'"
*/

keep conglome vivienda hogar codperso ubigeo dominio estrato nc lw  lwage  sec_ocu  nempljh  act_empr  ocupinf sector_econ race funcion   fac* ocupinf ocu500 yea*

label data "Modulo: EMPELO E INGRESOS - ENAHO Panel"
save "$dclea/mod500_`year'.dta" , replace

**# Bookmark #3
*=====================
* Module 100 (VIVIENDA)
*=====================

use "$mod01/enaho01a-`year'-100.dta" , clear
gen year = `year'
***Varibles capital publico (servicios basicos de la vivienda)
*"AGUA POTABLE" 
gen ag_pot =(p110 ==1 | p110 ==2 | p110 ==3)
	lab var ag_pot  "Agua potable"
	lab def ag_pot  1"Si" 0"No"
	lab val ag_pot  ag_pot 

*X12: enerlectr
gen enerlectr = (p112a ==1 | p112a ==2 | p112a ==3)
	lab var enerlectr  "Energia Electrica"
	lab def enerlectr  1"Si" 0"No"
	lab val enerlectr  enerlectr 
* : internet
gen internet = (p1144==1)
*capital institucional: prop_viv "Propiedad de la vivienda"
 
gen prop_viv =(p105a ==2 | p105a ==3 | p105a ==4)
	lab var prop_viv  "Tipo de vivienda"
	lab def prop_viv  1"Propia" 0"Alquilada / Cedida"
	lab val prop_viv prop_viv 

gen tit_prop =(p106a ==1)
	lab var tit_prop "Tiene titulo Propiedad"
	lab def tit_prop  1"Si" 0"No / En tramite"
	lab val tit_prop  prop_viv 

gen sunarp =(p106b ==1)
	label var sunarp  "T. P. registrado en SUNARP"
	label def sunarp 1"Si" 0"No / En tramite"
	label val sunarp  sunarp 

	* Area
recode estrato (1/5=1 "Urbano") (6/8=0 "Rural"), gen(urban ) 
	label variable urban  "Urbano `i'"

* Zone
recode dominio  (1/3=1 "Coast") (4/6=2 "Highlands") (7/7=3 "Jungle") (8/8=4 "Lima Metropolis"), gen(zone )
	label var zone "Zone "
 drop if nbi1==.

keep conglome vivienda hogar ubigeo dominio estrato   ag_pot  enerlectr  interne   prop_viv  tit_prop  sunarp  urban  zone  nbi*  fac* panel

label data "Modulo: CARACTERISTICAS DE LA VIVIENDA Y DEL HOGAR - ENAHO Panel"
save "$dclea/mod100_`year'.dta" , replace

**# Bookmark #5
*========================
* Modulo 1479 (MIEMBROS del HOGAR)
*========================
use "$mod02/enaho01-`year'-200.dta" , clear
gen year = `year'
**Manter solo JEFES de hogar
keep if p203==1
	
* Mantener a las personas que formaron parte del hogar durante todo el período
drop if p204==2 

lab def g_edad 1 "18-29 años" 2 "30-39 años" 3 "40-49 años" 4 "50-59 años" 5"60-70" 6 "Mayor de 70 años" 0"Menor de 18 años"

*Grupo de edad:
gen grupo_edad=1 if p208a>=14 & p208a<=20
replace grupo_edad=2 if p208a>=21 & p208a<=30
replace grupo_edad=3 if p208a>=31 & p208a<=40
replace grupo_edad=4 if p208a>=41 & p208a<=50
replace grupo_edad=5 if p208a>=51 & p208a<=60
replace grupo_edad=6 if p208a>=61 & p208a<=70
replace grupo_edad=7 if p208a>=70 & p208a<=200
label define grupo_edad 1 "De 14 a 20" 2 "De 21 a 30" 3 "De 31 a 40" 4 "De 41 a 50" 5 "De 51 a 60" 6 "De 61 a 70" 7 "De 71 a más"
label values grupo_edad grupo_edad


***DISCRIMINACION Y EXCLUSION SOCIAL

* Sexo
recode p207  (2=1 "Mujer") (1=0 "Varón"), gen(sex )
label variable sex  "Sexo del jefe del hogar_mujer"

* Edad en años
gen age = p208a  
label variable age  "Edad en (años cumplidos) "

*Grupos de edad
gen     g_edad =1 if p208a >=18 & p208a <30
replace g_edad =2 if p208a >=30 & p208a <40
replace g_edad =3 if p208a >=40 & p208a <50
replace g_edad =4 if p208a >=50 & p208a <60
replace g_edad =5 if p208a >=60 & p208a <70
replace g_edad =6 if p208a >=70
replace g_edad =0 if p208a <18

lab val g_edad  g_edad


*Estado civil

recode p209  (6=1 "Soltero/a") (1=2 "Casado/a o Conviviente") (2=2 "Casado/a o Conviviente") (4=3 "Separado/a o Divorciado") (5=3 "Separado/a o Divorciado") (3=4 "Viudo") , gen (ecivil )
	lab var ecivil  "Estado Civil"
	
	
	
	
 
keep conglome vivienda hogar codperso ubigeo dominio estrato  ecivil  sex  age  g_edad   fac*  year

label data "Modulo: CARACTERISTICAS DE MIEMBROS DEL HOGAR - ENAHO"
save "$dclea/mod200_`year'.dta" , replace
 
**# Bookmark #6
*========================
* Modulo 400 (SALUD)
*========================
use "$mod04/enaho01a-`year'-400.dta" , clear

**Manter solo JEFES de hogar
keep if p203==1
	
* Mantener a las personas que formaron parte del hogar durante todo el período
drop if p204==2

lab def seguro 1 "No tiene" 2 "Seguro privado/otro" 3 "Seguro público"
lab def limitacion 0 "Sin limitacion" 1 "Alguna limitacion"

* Seguro de salud:
gen seguro =1 		if p4191 ==2 & p4192 ==2 & p4193 ==2 & p4194 ==2 & p4195 ==2 & p4196 ==2 & p4197 ==2 & p4198 ==2
replace seguro =2 	if p4192 ==1 | p4193 ==1 | p4196 ==1 | p4197 ==1 | p4198 ==1 
replace seguro =3 	if p4191 ==1 | p4194 ==1 | p4195 ==1

label values seguro  seguro

gen dic_segur =(seguro ==1)
	lab var dic_segur  "Tiene seguro de Salud "
	lab val dic_segur yesno
	
* Limitaciones
gen limitacion =0 if p401h1 !=.
replace limitacion =1 if p401h1  ==1 | p401h2 ==1 | p401h3 ==1 | p401h4 ==1 | p401h5 ==1 | p401h6 ==1
	lab var limitacion  "Presenta alguna Limitacion"
	lab val limitacion  yesno
**Enfermedad cronica
gen croni  =(p401 ==1)
	lab var croni   "Presenta alguna enfermedad Crónica"
	label val croni   yesno
		
*MORBILIDAD
gen morbilid  =(p40314 ==0 | p4025 ==0)
replace morbilid =. if p4025 ==.
	lab var morbilid  "Morbilidad"
	lab val morbilid  yesno
	
***REDES DE APOYO SOCIAL
gen dni =(p401 ==1)
	lab var dni  "Tiene DNI"
	lab val dni  yesno	
 

	keep conglome vivienda hogar codperso ubigeo dominio estrato seguro  dic_segur  limitacion croni morbilid dni  fac*  year

	label data "Modulo: SALUD - ENAHO"
save "$dclea/mod400_`year'.dta" , replace

}

**# CONSTRUCCION DATA - NBI #1
****
*Bajamos los archivos zipeados del modulo 100 y sumaria de la pagina del INEI

*Descomprimir los archivos del modulo 100 y sumaria "Manualmente"
foreach year of numlist 2018/2022 {
use "$mod01\enaho01a-`year'-100.dta", clear
/* result: resultado final de la encuesta 
1: completa 
2: incompleta 
3: rechazo 
4: ausente 
5: vivienda desocupada 
6: otro */

*Se trabaja solo con las encuestas completas e incompletas 
drop if result>2

*NECESIDADES BASICAS INSATISFECHAS (ya se encuentran en el modulo 100)
sum nbi*

collapse (mean) nbi1 nbi2 nbi3 nbi4 nbi5, by(conglome vivienda hogar) cw

*Juntamos el modulo 100 con el modulo sumaria 
*(ambas bases presentan informacion a nivel del hogar)
merge 1:1  conglome vivienda hogar using  "$sumr\sumaria-`year'.dta", nogenerate

*Creamos la variable factor de expansion de la poblacion
gen    facpob=factor07*mieperho

*Establecemos las caracteristicas de la encuesta 
*usando las variable factor de expansion, conglomerado y estrato
svyset [pweight=facpob], psu(conglome) strata(estrato)


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
*Cambiamos el nombre de la variable ahno y le damos 
*nombre a los nbi para eliminar los caracteres que no reconoce STATA
rename a*o anio
label var nbi1 "Poblacion en viviendas con caracteristicas fisicas inadecuadas"
label var nbi2 "Poblacion en viviendas con hacinamiento"
label var nbi3 "Poblacion en viviendas sin desague de ningun tipo"
label var nbi4 "Poblacion en hogares con ninos (6 a 12) que no asisten a la escuela"
label var nbi5 "Poblacion en hogares con alta dependencia economica"
label var NBI1_POBRE "Con al menos una NBI"
label var NBI2_POBRE "De 2 a 5 NBI"

**# pobreza monetaria #1

*Estimamos el gasto promedio mensual de los hogares en términos per capita (indicador de bienestar)
gen gpcm=gashog2d/(mieperho*12)

*Contrastamos gpm con la linea de pobreza alimentaria (linpe) y pobreza total (linea)

gen pobre3=1 if gpcm < linpe
replace pobre3=2 if gpcm >= linpe & gpcm < linea
replace pobre3=3 if gpcm >= linea

*etiquetamos los valores de la variable

label define paz 1 "pobre_extremo" 2 "pobre_no_extremo" 3 "no_pobre"
label value pobre3 paz
label var pobre3 "Pobreza Monetaria"

gen pobre2=1 if gpcm < linea
replace pobre2=0 if gpcm >= linea
*Etiquetamos los valores de la variable

label define pobre2 1"pobre" 0"no_pobre"
label value pobre2 pobre2
label var pobre2 "Pobreza Monetaria"

gen year_2=`year'

save "$tempo\pobreza_`year'.dta" , replace
}



***JUNTANDO LAS BASES DE DATOS:

foreach year of numlist 2018/2022 {
use "$dclea/mod200_`year'.dta", clear
merge 1:1  conglome vivienda hogar codperso ubigeo dominio estrato using "$dclea/mod300_`year'.dta", nogen 
merge 1:1  conglome vivienda hogar codperso ubigeo dominio estrato using "$dclea/mod400_`year'.dta", nogen 
merge 1:1  conglome vivienda hogar codperso ubigeo dominio estrato using "$dclea/mod500_`year'.dta", nogen 
merge 1:1  conglome vivienda hogar ubigeo dominio estrato using "$dclea/mod100_`year'.dta", nogen 
merge 1:1  conglome vivienda hogar ubigeo dominio estrato using "$tempo\pobreza_`year'.dta", nogen 
save "$dclea/modpersonal_`year'.dta" , replace
}


use "$dclea/modpersonal_2018.dta", clear
foreach year of numlist 2019/2022 {
append using  "$dclea/modpersonal_`year'.dta" , force
}

*****RECODIFICANDO Y CREANDO VARIABLES PARA EL PRIMER OBJETIVO
generate depto_ = real(substr(ubigeo, 1,2))
label var depto "Departamento"
# delimit ;
label define dep 01 "Amazonas" 02 "ANCASH" 03 "APURIMAC" 04 "AREQUIPA" 05 "AYACUCHO" 06 "CAJAMARCA" 07 "CALLAO" 08 "CUSCO" 09"HUANCAVELICA" 10 "HUANUCO" 11 "ICA" 12 "JUNIN" 13 "LA LIBERTAD" 14 "LAMBAYEQUE"15 "LIMA" 16 "LORETO" 17 "MADRE DE DIOS" 18 "MOQUEGUA" 19 "PASCO" 20 "PIURA" 21 "Puno" 22 "San Martin" 23 "Tacna" 24 "Tumbes" 25 "Ucayali" ; # delimit cr
label value depto "dep"


tab   year urban
tab   year urban if depto_ ==21

****nbi
drop nbihog
sum nbi1 nbi2 nbi3 nbi4 nbi5
gen          nbihog=nbi1 + nbi2 + nbi3 + nbi4 + nbi5


***POBRE2 ES POBREZA MONETARIA
rename pobre2 pob_monetaria
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

	gen desag = nbi3
	lab var desag "Conexión a desague"
	lab val desag yesno
	
	lab def noyes 0"No" 1"Si"
	lab var internet "Conexión a internet"
	lab val internet noyes
	
	recode mieperho (1/2=1 "[1-2]") (3/4=2 "[3-4]") (5/15=3 ">=5") , gen(numinthog)
	label var numinthog "Numero de integrantes del hogar"
	
	recode percepho (0/1=1 "1") (2=2 "2") (3=3 "3") (4/10=4 ">=4") , gen(ingperc)
	label var ingperc "Numero de perceptores de ingresos del hogar"
	
	lab val tit_prop noyes 
	
	rename lengua_materna lmatr
gen l_ingre=log(inghog2d) 
lab var l_ingre "Ingreso neto (Logaritmo)"
recode race (1=1) (2=2) (3=3) (4=4) (5=5) (6=5) (.=5)
recode lmatr (1=1) (2=2) (3=3) (.=3)
	recode educ (.=0)
	recode analfa (.=0)
	recode morbilid (.=0)
	recode ecivil (.=1)
	recode inc_finc (.=1)
	
	*save "$dclea/master_tesis_2024.dta", replace

save "$dclea/modpersonal_18-22.dta" , replace





