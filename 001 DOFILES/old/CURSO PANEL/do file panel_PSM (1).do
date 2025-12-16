**ESTUDIOS ECONOMÉTRICOS DEL PERÚ***********************************************
**CURSO VIRTUAL: IA PARA DATOS DE PANEL CON STATA
********************************************************************************
**SESIÓN 4: PANEL PROPENSITY SCORE MATCHING*************************************
**ESPECIALISTA: DR. MAXIMO DAMIAN VALDERA***************************************
********************************************************************************


*Limipiar la data***************************************************************

clear all
set more off
 
cd "C:\Users\DAMIAN\Pictures\PANEL ESTÁTICO\ENAHO PANEL 2019 - 2023"
*Traslate a unicode
unicode analyze *
unicode encoding set ISO-8859-1 //código latino
unicode translate *


***Rura de la carpeta de los módulos de ENAHO PANEL***************************

cd "C:\Users\DAMIAN\Pictures\PANEL ESTÁTICO\ENAHO PANEL 2019 - 2023"

br


*****1. MODULO SUMARIA*****************************************************


*******************************************************************************
use sumaria-2019-2023-panel.dta,clear
br
**************************************************************************
***Solo nos quedamos con el panel hogares de 5 años****
**Muestra panel común entre los años 2015 – 2019, asciende a 1,866 hogares comparables.***
br

tab  hpanel_19_23

keep if hpanel_19_23==1 
count






br
***************************************************************
**visualizar el panel 5 años ****
br


generate hogar =   hogar_19
replace  hogar =   hogar_20 if hogar == ""
replace  hogar =   hogar_21 if hogar == ""
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""
 

br



***pobreza**********************************************************************

tab pobreza_19

tab pobreza_19, nolabel



 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate cod_pobreza_`v' = 0
	replace  cod_pobreza_`v' = 1 if  (pobreza_`v' == 1 |  pobreza_`v' == 2)  
	 
	
  } 
  
  

tab cod_pobreza_19
  
 tab pobreza_17
  

***urbana y rural************************************************************
  
  tab estrato_19
  
  tab estrato_19, nolabel
  
  
  
   set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate urbano_`v' = 0
	replace  urbano_`v' = 1 if  (estrato_`v' == 1|estrato_`v' == 2|estrato_`v' == 3|estrato_`v' == 4|estrato_`v' == 5)  
	 
	
  } 
  
  
tab urbano_19
  
   

  
***Total de miembros del hogar**************************************************

tab mieperho_19



***CONSUMO: 
GRU11HD  -->Grupo 1 : Alimentos - gasto
GRU21HD  -->Grupo 2 : Vestido y Calzado - gasto
GRU31HD --> Grupo 3 : Alquiler de vivienda, Combustible, Electricidad y Conservación de la Vivienda - gasto
GRU41HD --> Grupo 4 : Muebles, Enseres y Mantenimiento de la vivienda - gasto
GRU51HD --> Grupo 5 : Cuidado, Conservación de la Salud y Servicios Médicos - gasto
GRU61HD --> Grupo 6 : Transportes y Comunicaciones - gasto
GRU71HD --> Grupo 7 : Esparcimiento, Diversión, Servicios Culturales y de Enseñanza - gasto
GRU81HD --> Grupo 8 : Otros bienes y servicios - gasto



****Ingreso:

INGNETHD  Ingreso neto de la actividad principal monetario (dependiente) 
INGINDHD  Ingreso por actividad principal independiente 
INSEDLHD  Ingreso neto de la actividad secundaria dependiente 
INGSEIHD  Ingreso neto de la actividad secundaria independiente 
INGEXTHD  Ingresos extraordinarios por trabajo
INGTRAHD  Ingreso por transferencias corrientes monetarias del pais 
INGRENHD  Ingreso por rentas de la propiedad monetaria
INGOEXHD  Otros Ingresos Extraordinarios 


****INVERSIÓN:
IG03HD1 --> Credito,compra casa, departamento
IG03HD2 --> Credito,comprar, terreno para vivienda
IG03HD3 --> Crédito, mejoramiento y/o ampliación de la vivienda
IG03HD4 --> Crédito, construcción de nueva vivienda 



***seleccionar las variables importantes****************************************

  
keep  conglome vivienda hogar  cod_pobreza_*  inghog2d_* urbano_* mieperho_* gru11hd_* gru21hd_* gru31hd_* gru41hd_* gru51hd_* gru61hd_* gru71hd_* gru81hd_* ingnethd_*  ingindhd_*  insedlhd_*  ingseihd_*  ingexthd_*  ingtrahd_*  ingrenhd_*  ingoexhd_*  ig03hd1_* ig03hd2_* ig03hd3_* ig03hd4_* 



br

save pobreza,replace

use pobreza,replace

count

*********************************************************************************
*Módulo 100: Características de la vivienda**
********************************************************************************  
use enaho01-2019-2023-100-panel.dta,clear

*****************************************************************************
br
***PASO 1. FILTRAER Y QUEDARNOS CON LA MUESTRA DE LA DATA PANEL****
**************************************************
***********************************************************************************
**Escoger el panel hogares que desean trabajar****
**Escogo un panel de 5 años, donde hay 1866 hogares***

tab hpanel_19_23

keep if hpanel_19_23==1 

count
**********************************************************************************
*******************************************************************************
br


generate hogar =   hogar_19
replace  hogar =   hogar_20 if hogar == ""
replace  hogar =   hogar_21 if hogar == ""
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""
 
 

br


keep conglome vivienda hogar  facpanel1923 aÑo_* 
br

**guardar el panel ***
save panel1519, replace

count

*********************************************************************************
*Módulo 100: Características de la vivienda**
********************************************************************************  
use enaho01-2019-2023-100-panel.dta,clear

*****************************************************************************
br
***PASO 1. FILTRAER Y QUEDARNOS CON LA MUESTRA DE LA DATA PANEL****
**************************************************
***********************************************************************************
**Escoger el panel hogares que desean trabajar****
**Escogo un panel de 5 años, donde hay 1866 hogares***

tab hpanel_19_23


keep if hpanel_19_23==1 
count

**********************************************************************************
*******************************************************************************
br

generate hogar =   hogar_19
replace  hogar =   hogar_20 if hogar == ""
replace  hogar =   hogar_21 if hogar == ""
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""


br
**Su hogar tiene : Internet******
 **************************

 tab p1144_19
 tab p1144_19, nolabel
 
  
  set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate hogarinternet_`v' = 0
	replace  hogarinternet_`v' = 1 if  (p1144_`v' == 1 )  
	 
	
  } 
  

 tab hogarinternet_19
 
 

 ***El material predominante en las paredes exteriores del hogar es :***
 
 
 tab p102_19
 tab p102_19, nolabel
 
 
 
 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate paredcemento_`v' = 0
	replace  paredcemento_`v' = 1 if  (p102_`v' == 1 )  
	 
	
  } 
 
 
tab paredcemento_19
 
 
 
 **El material predominante en los pisos es :**
 
 tab p103_19
 tab p103_19, nolabel
 
 
 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate pisocemento_`v' = 0
	replace  pisocemento_`v' = 1 if  (p103_`v' == 1 |  p103_`v' == 2 |  p103_`v' == 3|  p103_`v' == 5 )  
	 
	
  } 
 
 
 tab pisocemento_19
 
 
 
 
 ***El material predominante en los techos es:***
 
 tab p103a_19
 
 tab p103a_19, nolabel
 
 
 
 
 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate techoconcreto_`v' = 0
	replace  techoconcreto_`v' = 1 if  (p103a_`v' == 1 )  
	 
	
  } 
 
 
 tab techoconcreto_19
 
 
 
 **El abastecimiento de agua en su hogar procede de :***
 *********************************************************
 
 tab p110_19
 
 tab p110_19, nolabel
 
 
 
 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate agua_`v' = 0
	replace  agua_`v' = 1 if  (p110_`v' == 1|  p110_`v' == 2  )  
	 
	
  } 
 
 
 tab agua_19
 
 
 
 ***El servicio higiénico que tiene su hogar esta conectado a :****
 
 
 tab p111a_19
 tab p111a_19, nolabel
 
 
  set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate baño_`v' = 0
	replace  baño_`v' = 1 if  (p111a_`v' == 1|  p111a_`v' == 2 )  
	 
	
  } 
 
 
 
 tab baño_19
 
 
 
 **Tipo de alumbrado del hogar***
 
tab p1121_19
 
tab p1121_19, nolabel
 
 
  set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate electricidadhogar_`v' = 0
	replace  electricidadhogar_`v' = 1 if  (p1121_`v' == 1 )  
	 
	
  } 
 
 
tab electricidadhogar_21
 
 

**Su hogar tiene : Celular***

tab p1142_19
tab p1142_19, nolabel


 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate celularhogar_`v' = 0
	replace celularhogar_`v' = 1 if  (p1142_`v' == 1 )  
	 
	
  } 


 tab celularhogar_19
  
  
  
  
***¿esta vivienda tiene titulo de propiedad?
  
 tab p106a_19
  
 tab p106a_19, nolabel
  
  
   set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate titulopropiedad_`v' = 0
	replace titulopropiedad_`v' = 1 if  (p106a_`v' == 1 )  
	 
	
  } 


  
tab titulopropiedad_19
  
  
**combustible que usan en el hogar para cocinar sus alimentos: gas (glp)****
  
tab p1132_19
  
tab p1132_19, nolabel
  
  

  set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate gas_`v' = 0
	replace gas_`v' = 1 if  (p1132_`v' == 1 )  
	 
	
  } 
  
  
 tab gas_23
  
  
  
***seleccionamos las variables importantes**************************************
  
keep conglome vivienda hogar  hogarinternet_* paredcemento_* pisocemento_* techoconcreto_* agua_* baño_* electricidadhogar_* celularhogar_* titulopropiedad_* gas_*


br
**guardar el panel ***
save caracteristicashogar, replace

count


use caracteristicashogar, replace



*Módulo 200: Características de los miembros por hogar  
******************************************************************
*Hijos menores de edad
use enaho01-2019-2023-200-panel.dta,clear 
br


tab hpanel_19_23


keep if hpanel_19_23==1 



tab p203_19
tab p203_19, nolabel


generate hogar =   hogar_19
replace  hogar =   hogar_20 if hogar == ""
replace  hogar =   hogar_21 if hogar == ""
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""


generate p203 = p203_19
replace  p203 = p203_20 if p203==.
replace  p203 = p203_21 if p203==.
replace  p203 = p203_22 if p203==.
replace  p203 = p203_23 if p203==.


 


tab p203
 

keep if p203 == 3


set more off
local anho 19 20 21 22 23
foreach v of local anho {

	generate menores_6anhos_`v' = 0
	replace  menores_6anhos_`v' = 1 if p208a_`v'<=6 
	
	generate menores_18anhos_`v' = 0
	replace  menores_18anhos_`v' = 1 if p208a_`v' >6 & p208a_`v'<=18

	generate mayores_18anhos_`v' = 0
	replace  mayores_18anhos_`v' = 1 if p208a_`v' >18
  } 
 
keep conglome vivienda hogar  menores_6anhos_* menores_18anhos_* mayores_18anhos_*
collapse (sum) menores_6anhos_* menores_18anhos_* mayores_18anhos_*, by(conglome vivienda hogar)

count

save hijos,replace

count

br

use hijos,replace




*Módulo 200: Características de los miembros por hogar  
******************************************************************
*sexo de los jefes de hogares
use enaho01-2019-2023-200-panel.dta,clear 



tab hpanel_19_23


keep if hpanel_19_23==1 



tab p203_19
tab p203_19, nolabel


generate hogar =   hogar_19
replace  hogar =   hogar_20 if hogar == ""
replace  hogar =   hogar_21 if hogar == ""
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""


generate p203 = p203_19
replace  p203 = p203_20 if p203==.
replace  p203 = p203_21 if p203==.
replace  p203 = p203_22 if p203==.
replace  p203 = p203_23 if p203==.


tab p203
 
keep if p203 == 1


tab p207_19
tab p207_19, nolabel



 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate JHhombre_`v' = 0
	replace JHhombre_`v' = 1 if  (p207_`v' == 1 )  
	 
	
  } 


tab JHhombre_18



 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate JHmujer_`v' = 0
	replace JHmujer_`v' = 1 if  (p207_`v' == 2 )  
	 
	
  } 


tab JHhombre_18






***estado civil: casados o convivientes****************************

tab p209_19

tab p209_19, nolabel



 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate JHcasado_`v' = 0
	replace  JHcasado_`v' = 1 if  (p209_`v' == 1|  p209_`v' == 2 )  
	 
	
  } 
 

 
tab JHcasado_19



***Edad del jefe de hogar***

tab p208a_21



***seleccionar las variables importantes****************************************

  
keep  conglome vivienda hogar  JHhombre_* JHmujer_* JHcasado_* p208a_*
br

save sexo,replace

count


use sexo,replace






*Módulo 300: Educación de los miembros por hogar  
******************************************************************
*educación de los jefes de hogares
use enaho01a-2019-2023-300-panel.dta,clear 


tab hpanel_19_23


keep if hpanel_19_23==1 



tab p203_19
tab p203_19, nolabel


generate hogar =   hogar_19
replace  hogar =   hogar_20 if hogar == ""
replace  hogar =   hogar_21 if hogar == ""
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""


generate p203 = p203_19
replace  p203 = p203_20 if p203==.
replace  p203 = p203_21 if p203==.
replace  p203 = p203_22 if p203==.
replace  p203 = p203_23 if p203==.


tab p203
 
keep if p203 == 1



**¿Sabe leer y escribir?********************

tab p302_21

tab p302_21, nolabel


 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate JHanalfabeto_`v' = 0
	replace JHanalfabeto_`v' = 1 if  (p302_`v' == 2 )  
	 
	
  } 


tab JHanalfabeto_19



***colegio estatal*************************************************************

tab p301d_21

tab p301d_21, nolabel



 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate colegioestatal_`v' = 0
	replace colegioestatal_`v' = 1 if  (p301d_`v' == 1 )  
	 
	
  } 


tab colegioestatal_19


***años de estudios de los JH*************************************


tab p301a_18

tab p301b_18



***seleccionar las variables importantes****************************************

  
keep  conglome vivienda hogar  JHanalfabeto_*  colegioestatal_* p301a_* p301b_*
br

save educación,replace

count


use educación,replace







*Módulo 400: salud de los miembros por hogar  
******************************************************************
*salud de los jefes de hogares
use enaho01a-2019-2023-400-panel.dta,clear 

br


tab hpanel_19_23


keep if hpanel_19_23==1 



tab p203_19
tab p203_19, nolabel


generate hogar =   hogar_19
replace  hogar =   hogar_20 if hogar == ""
replace  hogar =   hogar_21 if hogar == ""
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""


generate p203 = p203_19
replace  p203 = p203_20 if p203==.
replace  p203 = p203_21 if p203==.
replace  p203 = p203_22 if p203==.
replace  p203 = p203_23 if p203==.


tab p203
 
keep if p203 == 1

  

**¿Seguro integral de salud (SIS)?

tab p4195_21

tab p4195_21, nolabel
  
  
 set more off
local anho 19 20 21 22 23
*Bucle
foreach v of local anho {
	generate SIS_`v' = 0
	replace SIS_`v' = 1 if  (p4195_`v' == 1 )  
	 
	
  } 
  
  
tab SIS_23
  
  
  
***seleccionar las variables importantes****************************************

  
keep  conglome vivienda hogar  SIS_*
br

save salud,replace

count

  
****MODULO 500: EMPLEO E INGRESOS*********************************************** 
***instalar comando para extender la memoria

set maxvar 8000
help maxvar


use enaho01a-2019-2023-500-panel.dta,clear 
  
br
  
 
tab hpanel_19_23


keep if hpanel_19_23==1 



tab p203_19
tab p203_19, nolabel


generate hogar =   hogar_19
replace  hogar =   hogar_20 if hogar == ""
replace  hogar =   hogar_21 if hogar == ""
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""


generate p203 = p203_19
replace  p203 = p203_20 if p203==.
replace  p203 = p203_21 if p203==.
replace  p203 = p203_22 if p203==.
replace  p203 = p203_23 if p203==.


tab p203
 
keep if p203 == 1
  


***remesas nacionales***********

tab p5563c_19
codebook p5563c_18

tab p5563c_18



***remesas extranejras***********

tab p5563e_19

codebook p5563e_19


tab p5563e_19
  
  
  
***seleccionar las variables importantes****************************************

  
keep  conglome vivienda hogar  p5563c_* p5563e_*
br

save remesas,replace

count

  
 
********************************************************************************
*******************************************************
*Unir base de datos 1 
*******************************************************
use panel1519,clear


br
 
merge 1:1 conglome vivienda hogar  using pobreza, keepusing(cod_pobreza_*  inghog2d_* urbano_* mieperho_* gru11hd_* gru21hd_* gru31hd_* gru41hd_* gru51hd_* gru61hd_* gru71hd_* gru81hd_* ingnethd_*  ingindhd_*  insedlhd_*  ingseihd_*  ingexthd_*  ingtrahd_*  ingrenhd_*  ingoexhd_*  ig03hd1_* ig03hd2_* ig03hd3_* ig03hd4_* ) nogenerate

merge 1:1 conglome vivienda hogar  using caracteristicashogar , keepusing( hogarinternet_* paredcemento_* pisocemento_* techoconcreto_* agua_* baño_* electricidadhogar_* celularhogar_* titulopropiedad_* gas_*) nogenerate

merge 1:1 conglome vivienda hogar  using hijos, keepusing(menores_6anhos_* menores_18anhos_* mayores_18anhos_*) nogenerate


merge 1:1 conglome vivienda hogar  using sexo, keepusing(JHhombre_*  JHcasado_* p208a_* JHmujer_*) nogenerate



merge 1:1 conglome vivienda hogar  using educación, keepusing(JHanalfabeto_*  colegioestatal_* p301a_* p301b_*) nogenerate


merge 1:1 conglome vivienda hogar  using salud, keepusing(SIS_*) nogenerate


merge 1:1 conglome vivienda hogar  using remesas, keepusing(p5563c_* p5563e_*) nogenerate




br
*******************************************************************************
save base_consolidada.dta, replace



*******************************************************************************
use base_consolidada.dta, clear


***pivotear para el panel******
br

reshape long cod_pobreza  inghog2d urbano mieperho gru11hd gru21hd gru31hd gru41hd gru51hd gru61hd gru71hd gru81hd ingnethd  ingindhd  insedlhd  ingseihd  ingexthd  ingtrahd  ingrenhd  ingoexhd  ig03hd1 ig03hd2 ig03hd3 ig03hd4 hogarinternet paredcemento pisocemento techoconcreto agua baño electricidadhogar celularhogar titulopropiedad gas menores_6anhos menores_18anhos mayores_18anhos JHhombre  JHcasado p208a JHmujer JHanalfabeto  colegioestatal p301a p301b SIS p5563c p5563e, i(conglome vivienda hogar ) j(aÑo_) string

br


**identificador id: a nivel hogar***
egen idh =concat(conglome vivienda hogar)


br
**convertir el año, de texto a numerico**

replace aÑo_= "2019" if aÑo_=="_19"
replace aÑo_= "2020" if aÑo_=="_20"
replace aÑo_= "2021" if aÑo_=="_21"
replace aÑo_= "2022" if aÑo_=="_22"
replace aÑo_= "2023" if aÑo_=="_23"



*******************************************************************************
br

**asignamos valores mising por ceros***********

br menores_6anhos

display `i'
replace menores_6anhos`i' = 0 if menores_6anhos`i' == .


display `i'
replace menores_18anhos`i' = 0 if menores_18anhos`i' == .


display `i'
replace mayores_18anhos`i' = 0 if mayores_18anhos`i' == .



display `i'
replace JHhombre`i' = 0 if JHhombre`i' == .


display `i'
replace JHcasado`i' = 0 if JHcasado`i' == .


display `i'
replace JHanalfabeto`i' = 0 if JHanalfabeto`i' == .


display `i'
replace colegioestatal`i' = 0 if colegioestatal`i' == .


display `i'
replace SIS`i' = 0 if SIS`i' == .



display `i'
replace p5563c`i' = 0 if p5563c`i' == .


display `i'
replace p5563e`i' = 0 if p5563e`i' == .



display `i'
replace p301b`i' = 0 if p301b`i' == .


display `i'
replace JHmujer`i' = 0 if JHmujer`i' == .


***generamos un promedio de la edad de los jefes de hogares
br p208a



sum p208a

br p208a


display `i'
replace p208a`i' = 55 if p208a`i' == .


rename p208a edadJH

br edadJH




****años de estudios JH*************************************
br

br p301a


tab p301a
tab p301a, nolabel

tab p301a, m


recode p301a (1=1 " sin nivel ")(2=2 " educación inicial")(3=3 " primaria incompleta")(4=4 "primaria completa") (5=5 "secundaria incompleta")(6=6 "secundaria completa")(7=7 "superior no universitaria incompleta")(8=8 "superior no universitaria completa") (9=9 "superior universitaria incompleta")(10=10 " superior universitaria completa")(11=11 " postgrado universitario")(.=1 " sin nivel "),  gen(p301a1)

tab p301a1
tab p301a1, m




generate educ=.
replace educ=0 if p301a1==1
replace educ=p301b if p301a1==2
replace educ=p301b+2 if p301a1>=3 & p301a1<=4
replace educ=p301b+2+6 if p301a1>=5 & p301a1<=6
replace educ=p301b+2+6+5 if p301a1>=7 & p301a1<=10
replace educ=p301b+2+6+5+5 if p301a1==11

tab educ

br educ


sum educ



br




***remesas*********************************************************************
br p5563c p5563e

br p5563e

rename p5563c monto_nacional

rename p5563e monto_extranjero



***Monto del consumo privado en hogares****


br gru11hd gru21hd gru31hd gru41hd gru51hd gru61hd gru71hd gru81hd


gen consumo= gru11hd +gru21hd +gru31hd +gru41hd +gru51hd +gru61hd+ gru71hd +gru81hd



***Monto del ingreso******************************

br ingnethd  ingindhd  insedlhd  ingseihd  ingexthd  ingtrahd  ingrenhd  ingoexhd


gen ingreso_H=ingnethd + ingindhd + insedlhd + ingseihd + ingexthd  +ingtrahd + ingrenhd + ingoexhd




***Quedarme con las variables importantes****************************************

br idh conglome vivienda hogar  aÑo_ facpanel1923  cod_pobreza inghog2d urbano mieperho hogarinternet paredcemento pisocemento techoconcreto agua baño electricidadhogar celularhogar titulopropiedad gas menores_6anhos  menores_18anhos mayores_18anhos JHhombre JHcasado  edadJH JHanalfabeto colegioestatal  SIS monto_nacional monto_extranjero  educ JHmujer  consumo ingreso_H


keep idh conglome vivienda hogar  aÑo_ facpanel1923  cod_pobreza inghog2d urbano mieperho hogarinternet paredcemento pisocemento techoconcreto agua baño electricidadhogar celularhogar titulopropiedad gas menores_6anhos  menores_18anhos mayores_18anhos JHhombre JHcasado  edadJH JHanalfabeto colegioestatal  SIS monto_nacional monto_extranjero  educ JHmujer  consumo ingreso_H



********************************************************************************
save panelfinal19_23.dta, replace
********************************************************************************

***Exportar la data panel logit*************************************************

export excel panelfinal19_23, firstrow(variables)

********************************************************************************
use panelfinal19_23.dta, replace


------------------------------
*Seteamos como datos de panel:
*------------------------------

destring aÑo_, replace
destring idh, replace

xtset idh aÑo_




*****Remesas internas*********************************************************

gen flag_rinternas = 0
replace flag_rinternas = 1 if monto_nacional > 0

tab flag_rinternas

****Remesas externas************************************

gen flag_rexternas = 0
replace flag_rexternas = 1 if monto_extranjero > 0

tab flag_rexternas


***total_remesas**********************************************

gen total_remesas = monto_nacional + monto_extranjero


gen flag_rtotal = 0
replace flag_rtotal = 1 if total_remesas > 0

tab flag_rtotal




********************************************************************************
save panel1923.dta, replace

********************************************************************************

*****Panel de 5 años************************************************************
use panel1923.dta, replace

br


destring aÑo_, replace
destring idh, replace

xtset idh aÑo_



*****IMPACTO DE LAS REMESAS INTERNAS EN LA POBREZA MONETARIA********************

***PSM + DID (Propensity Score Matching + Diferencias en Diferencias) para evaluar ***el impacto de las remesas internas (flag_rinternas) sobre la pobreza monetaria ***(cod_pobreza) en un panel de hogares de 5 años (2019–2023):



***1. Crear una variable de tratamiento para el año base (2019)

gen treat2019 = flag_rinternas if aÑo_ == 2019


**2. Estimar el puntaje de propensión para 2019 (primer año)

logit treat2019 urbano hogarinternet paredcemento titulopropiedad gas if aÑo_ == 2019
predict pscore if e(sample), pr



***3. Emparejar con vecino más cercano (primer vecino, sin reemplazo)


ssc install psmatch2, replace


teffects psmatch (cod_pobreza) ///
    (treat2019 urbano hogarinternet paredcemento titulopropiedad gas) ///
    if aÑo_ == 2019, atet



******4.Luego, cree una variable de tratamiento por cada año, ejemplo:
gen treat2020 = flag_rinternas if aÑo_ == 2020
gen treat2021 = flag_rinternas if aÑo_ == 2021
gen treat2022 = flag_rinternas if aÑo_ == 2022
gen treat2023 = flag_rinternas if aÑo_ == 2023

***Código para 2020********************************************

teffects psmatch (cod_pobreza) ///
    (treat2020 urbano hogarinternet paredcemento titulopropiedad gas) ///
    if aÑo_ == 2020, atet


***Código para 2021************************************************
teffects psmatch (cod_pobreza) ///
    (treat2021 urbano hogarinternet paredcemento titulopropiedad gas) ///
    if aÑo_ == 2021, atet


****Código para 2022*********************************************

teffects psmatch (cod_pobreza) ///
    (treat2022 urbano hogarinternet paredcemento titulopropiedad gas) ///
    if aÑo_ == 2022, atet


****Código para 2023*****

teffects psmatch (cod_pobreza) ///
    (treat2023 urbano hogarinternet paredcemento titulopropiedad gas) ///
    if aÑo_ == 2023, atet




***CASO 2: PASOS PARA APLICAR PSM + DID EN STATA***************************

use panel1923.dta, replace

br


destring aÑo_, replace
destring idh, replace

xtset idh aÑo_





***1. Crear variable de tratamiento

gen treat = flag_rinternas > 0


**2. Identificar hogares tratados alguna vez
***Se crea un indicador para saber si el hogar fue tratado en algún año.

gen ever_treated = .
bysort idh (aÑo_): replace ever_treated = 1 if treat == 1
bysort idh (aÑo_): replace ever_treated = ever_treated[_n-1] if missing(ever_treated)
replace ever_treated = 0 if missing(ever_treated)



***3. Variable de tiempo POST por hogar

***Si el hogar fue tratado por primera vez en cierto año, se define post a partir de ese año:

gen year_treated = .
bysort idh (aÑo_): replace year_treated = aÑo_ if treat == 1 & missing(year_treated)
bysort idh (aÑo_): replace year_treated = year_treated[_n-1] if missing(year_treated)

gen post = aÑo_ >= year_treated if ever_treated == 1
replace post = 0 if ever_treated == 0



***4. Estimación Propensity Score (PSM)
***Seleccionamos un año base (por ejemplo, 2019) para estimar la probabilidad de recibir tratamiento. Ajuste las covariables según su modelo.

logit ever_treated urbano hogarinternet paredcemento titulopropiedad gas if aÑo_ == 2019
predict ps_score if aÑo_ == 2019


***5. Emparejamiento (PSM)

teffects psmatch (cod_pobreza) ///
    (ever_treated urbano hogarinternet paredcemento titulopropiedad gas) ///
    if aÑo_ == 2019, atet


***6. Filtrar muestra emparejada (opcional)

***Después del teffects, puede guardar los pesos o la muestra para usarlos en el DID.


***7. Diferencias en Diferencias (DID)

Una vez definida treat, post y cod_pobreza, aplique DID con efectos fijos:


xtreg cod_pobreza i.treat##i.post i.aÑo_, fe cluster(idh)


***3. Solución: definir variable post individualizada

**Debe definir una variable post para cada hogar, en función del año en que empieza a recibir remesas internas (flag_rinternas == 1). Por ejemplo:


* 1. Obtener el primer año en que cada hogar recibe remesas internas
gen primer_anio_tratamiento = .

bysort idh (aÑo_): replace primer_anio_tratamiento = aÑo_ if flag_rinternas == 1 & missing(primer_anio_tratamiento)
bysort idh (aÑo_): replace primer_anio_tratamiento = primer_anio_tratamiento[_n-1] if missing(primer_anio_tratamiento)

* 2. Crear la variable POST para cada hogar según su año de inicio del tratamiento
gen post = (aÑo_ >= primer_anio_tratamiento) if !missing(primer_anio_tratamiento)
replace post = 0 if missing(post)  // hogares nunca tratados: siempre 0



***4. Volver a correr el modelo**
xtreg cod_pobreza i.flag_rinternas##i.post i.aÑo_, fe cluster(idh)








***CASO 2: PASOS PARA APLICAR PSM + DID EN STATA***************************

use panel1923.dta, replace

br


destring aÑo_, replace
destring idh, replace

xtset idh aÑo_



**1. Verificar distribución por año de los hogares con remesas internas


tab aÑo_ if flag_rinternas == 1





***CASO 2: PASOS PARA APLICAR PSM + DID EN STATA***************************

use panel1923.dta, replace

br


destring aÑo_, replace
destring idh, replace

xtset idh aÑo_



***PASO 1: Identificar hogares tratados
**Creamos una variable que identifique si un hogar recibió remesas internas en algún año:

gen treat = 0
bysort idh (aÑo_): replace treat = 1 if flag_rinternas == 1


**Esto marca como treat = 1 a cualquier hogar que haya recibido remesas internas al menos una vez.


***PASO 2: Crear variable POST

***Dado que los tratamientos ocurrieron en distintos años, necesitamos crear una variable post relativa al primer año en que un hogar recibió remesas internas.


* Paso 2.1: Encontrar el primer año en que el hogar recibió remesas internas
gen year_rint = .
bysort idh (aÑo_): replace year_rint = aÑo_ if flag_rinternas == 1
bysort idh (aÑo_): replace year_rint = year_rint[_n-1] if missing(year_rint)

* Paso 2.2: Crear variable POST (1 si el año es igual o posterior al año de tratamiento)
gen post = 0
replace post = 1 if aÑo_ >= year_rint & !missing(year_rint)


**PASO 3: Variable de resultado (y)


gen y = cod_pobreza   // pobreza monetaria



**PASO 4: Realizar emparejamiento PSM

**Emparejamos hogares tratados y no tratados en el año anterior al tratamiento (pre-tratamiento). Por ejemplo, emparejamos usando datos solo de 2019.


gen x1 = urbano

gen x2 = celularhogar

gen x3 = JHmujer



preserve
keep if aÑo_ == 2019
pscore treat x1 x2 x3, pscore(pscore) blockid(bid) comsup neighbor(1) logit
restore





net install http://www.stata-journal.com/software/sj5-3/st0026_2.pkg, replace

which pscore
help pscore






pscore treat urbano hogarinternet paredcemento titulopropiedad gas ///
    , pscore(pscore) blockid(bid) comsup logit






gen _support = !missing(bid)


keep if _support == 1


***2. Estimación del efecto del tratamiento (ATT)

reg cod_pobreza treat [aw=1], robust


bysort bid (pscore): gen peso_b = _N
reg cod_pobreza treat [aw=peso_b], robust




***Opción 1: Con psmatch2 y estimación directa del ATT

psmatch2 treat urbano hogarinternet paredcemento titulopropiedad gas, ///
    out(cod_pobreza) logit neighbor(1) common


***Alternativa: teffects psmatch (más robusto)


teffects psmatch (cod_pobreza) (treat urbano hogarinternet paredcemento titulopropiedad gas), atet



***Bucle para estimar ATT por año

describe aÑo_


gen anio = real(aÑo_)


local covars urbano hogarinternet paredcemento titulopropiedad gas

foreach anio_loop in 2019 2020 2021 2022 2023 {
    use "panel1923.dta", clear
    gen anio = real(aÑo_)
    keep if anio == `anio_loop'

    di "-----------------------------"
    di "Estimación para el año `anio_loop'"
    di "-----------------------------"

    quietly psmatch2 treat `covars', out(cod_pobreza) logit neighbor(1) common

    quietly pstest `covars', both

    reg cod_pobreza _treated, robust
}






********************************************************************************
cd "C:\Users\DAMIAN\Pictures\PANEL ESTÁTICO\ENAHO PANEL 2019 - 2023"

use panel1923.dta, replace

br

***PSM por año en panel*****************************


* Instalar comandos si no están instalados
ssc install psmatch2, replace



* Abrir base
use panel1923.dta, clear

* Filtrar solo año 2019
destring aÑo_ , replace

keep if aÑo_ == 2023

* 1. Estimar logit para propensity score
***logit flag_rinternas edadJH JHmujer  SIS mieperho

probit flag_rinternas edadJH JHmujer  SIS mieperho


***Calcular efectos marginales promedio (AME)

margins, dydx(*) post


***Bondad de ajuste******************

fitstat

*****capacidad preditiva****
estat classification

****ROC
lroc

****Multicolienaliadd*********************
vif, uncentered


* 2. Guardar los scores predictivos (propensity scores)
predict pscore, pr

* 3. Ver distribución de propensity scores en tratados y controles
sum pscore if flag_rinternas==1
sum pscore if flag_rinternas==0

* 4. Metodos de estimación***************************************
ssc install psmatch2, replace

***Propensity Score Matching con vecino más cercano usando pscore

psmatch2 flag_rinternas, pscore(pscore) outcome(cod_pobreza) neighbor(1) ties
	
	
***Propensity Score Matching con kernel*****************************

psmatch2 flag_rinternas, pscore(pscore) outcome(cod_pobreza) kernel bw(0.06)
	
	
* 3. Eliminar observaciones fuera del soporte común
keep if _support == 1
	
	
* 5. Evaluar balance después del matching
pstest urbano hogarinternet paredcemento titulopropiedad gas, both




**Cómo separar hogares tratados y controles emparejados

* Tratados en la muestra emparejada
list if _treated == 1 & _weight > 0


* Controles emparejados
list if _treated == 0 & _weight > 0


* Después de correr psmatch2...
gen str40 grupo = ""
replace grupo = "Hogares tratado" if _treated == 1 & _weight > 0
replace grupo = "Hogares de control para el emparejamiento" if _treated == 0 & _weight > 0

* Ver tabla resumen
tab grupo

* Listar algunos ejemplos
list grupo flag_rinternas _pscore _weight in 1/20
















































