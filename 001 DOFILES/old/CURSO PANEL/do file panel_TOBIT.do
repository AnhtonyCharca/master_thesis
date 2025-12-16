**ESTUDIOS ECONOMÉTRICOS DEL PERÚ***********************************************
**CURSO VIRTUAL: IA PARA DATOS DE PANEL CON STATA
********************************************************************************
**SESIÓN 3:PANEL TOBIT**********************************************************
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

cd "C:\Users\DAMIAN\3D Objects\PANEL TOBIT"

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
save panelfinal23.dta, replace

********************************************************************************

***Exportar la data panel logit*************************************************
use panelfinal23.dta, replace


export excel panelfinal23, firstrow(variables)





*****Estadistica descriptiva en ENAHO PANEL************************************
use panelfinal23.dta, replace


------------------------------
*Seteamos como datos de panel:
*------------------------------

destring aÑo_, replace
destring idh, replace

xtset idh aÑo_



* Estimar pobreza promedio (no ponderada) por año
tab aÑo_ cod_pobreza, row


* Asegurar que los datos estén correctamente configurados como panel
xtset idh aÑo_

* Calcular pobreza ponderada por año
svyset idh [pweight=facpanel1923], strata(aÑo_)

* Pobreza ponderada por año con proporciones
svy: proportion cod_pobreza, over(aÑo_)



****GARFICOS DE POBREZA MONETARIA EN EL PANEL***************************

* Crear base agregada con proporción de pobreza ponderada por año
gen uno = 1
gen pobre = cod_pobreza

collapse (mean) pobre [pweight=facpanel1923], by(aÑo_)


****Opción A: Gráfico de líneas

twoway (line pobre aÑo_, lwidth(medium) lcolor(blue) lpattern(solid)), ///
    title("Evolución de la Pobreza Monetaria (2019–2023)") ///
    ytitle("Tasa de pobreza monetaria") ///
    xtitle("Año") ///
    ylabel(, format(%3.0f)) ///
    xlabel(2019(1)2023) ///
    graphregion(color(white)) ///
    legend(off)



**Opción B: Gráfico de barras*******************

	graph bar pobre, over(aÑo_, label(angle(0))) ///
    bar(1, color(blue)) ///
    ytitle("Tasa de pobreza monetaria") ///
    title("Pobreza Monetaria en el Perú (2019–2023)") ///
    blabel(bar, format(%4.1f)) ///
    legend(off) ///
    graphregion(color(white))
	
	
	
	
*****Grafico con porcentajes********************************************
use panelfinal23.dta, replace

* Crear copia de respaldo si desea
preserve

* Calcular proporción de hogares pobres ponderada por año
gen pobre = cod_pobreza

collapse (mean) pobreza=pobre [pweight=facpanel1923], by(aÑo_)

* Convertir a porcentaje para graficar
gen pobreza_pct = pobreza * 100
	
	
	
	
	graph bar pobreza_pct, over(aÑo_, label(angle(0))) ///
    bar(1, color(navy)) ///
    ytitle("Pobreza Monetaria (%)") ///
    title("Evolución de la Pobreza Monetaria (2019–2023)", size(medsmall)) ///
    blabel(bar, format(%4.1f) color(black) size(small)) ///
    ylabel(0(5)100, format(%2.0f)) ///
    legend(off) ///
    graphregion(color(white)) ///
    plotregion(margin(zero))
	
	
	
	
	*****Grafico de la pobreza en linea******************
	
	use panelfinal23.dta, replace
	
	
	destring aÑo_, replace
	
	
	
	* Crear copia de respaldo temporal
preserve

* Crear variable de pobreza (si no existe ya como binaria)
gen pobre = cod_pobreza

* Calcular pobreza ponderada por año
collapse (mean) pobreza=pobre [pweight=facpanel1923], by(aÑo_)

* Convertir a porcentaje
gen pobreza_pct = pobreza * 100
	
	
	
	
	twoway ///
    (line pobreza_pct aÑo_, lwidth(medium) lcolor(navy) lpattern(solid)) ///
    (scatter pobreza_pct aÑo_, mlabel(pobreza_pct) mlabformat(%4.1f) ///
     mlabposition(12) mlabcolor(black) msymbol(circle_hollow)), ///
    ytitle("Pobreza Monetaria (%)") ///
    xtitle("Año") ///
    title("Evolución de la Pobreza Monetaria (2019–2023)", size(medsmall)) ///
    ylabel(0(5)100, format(%2.0f)) ///
    xlabel(2019(1)2023) ///
    legend(off) ///
    graphregion(color(white))
	
	
	
	***************************************************************************
	
		use panelfinal23.dta, replace
	
	
	destring aÑo_, replace
	
	
	* Crear copia de respaldo de la base
preserve

* Crear variable binaria auxiliar si es necesario
gen pobre = cod_pobreza

* Calcular media ponderada por año
collapse (mean) pobreza=pobre [pweight=facpanel1923], by(aÑo_)

* Convertir a porcentaje
gen pobreza_pct = pobreza * 100
	
	
	
	
	twoway ///
    (line pobreza_pct aÑo_, lwidth(medthick) lcolor(navy)) ///
    (scatter pobreza_pct aÑo_, mlabel(pobreza_pct) mlabformat(%4.1f) ///
     mlabposition(12) mlabcolor(black) msymbol(circle_hollow)), ///
    ytitle("Pobreza Monetaria (%)") ///
    xtitle("Año") ///
    title("Promedio de la pobreza monetaria en ENAHO Panel 2019 – 2023 (%)", size(medsmall)) ///
    ylabel(0(5)50, format(%2.0f)) ///
    xlabel(2019(1)2023) ///
    legend(off) ///
    graphregion(color(white))
	
	
	
	
	******Grafico de las remesas internas**************************************
	
			use panelfinal23.dta, replace
	
		destring aÑo_, replace
	
	
	* Crear copia temporal de la base
preserve

* Asegurar que flag_rinternas esté bien codificada como 0/1

* Calcular porcentaje ponderado por año
collapse (mean) remesa_interna=flag_rinternas [pweight=facpanel1923], by(aÑo_)

* Convertir a porcentaje
gen remesa_pct = remesa_interna * 100
	
	
	
	twoway ///
    (line remesa_pct aÑo_, lwidth(medthick) lcolor(maroon)) ///
    (scatter remesa_pct aÑo_, mlabel(remesa_pct) mlabformat(%4.1f) ///
     mlabposition(12) mlabcolor(black) msymbol(circle_hollow)), ///
    ytitle("Porcentaje de Hogares con Remesas Internas") ///
    xtitle("Año") ///
    title("Promedio de remesas Internas en Enaho Panel 2019–2023 (%)", size(medsmall)) ///
    ylabel(0(2)20, format(%2.0f)) /// <-- puede ajustar el límite superior aquí
    xlabel(2019(1)2023) ///
    legend(off) ///
    graphregion(color(white))
	
	
	
	*****Remesas externas**********************************************
	
	use panelfinal23.dta, replace
	
		destring aÑo_, replace
		
		
		
	* Crear respaldo temporal de la base
preserve

* Asegurar que flag_rexternas está codificada como 0/1
* Calcular media ponderada por año
collapse (mean) remesa_externa=flag_rexternas [pweight=facpanel1923], by(aÑo_)

* Convertir a porcentaje
gen remesa_pct = remesa_externa * 100
	
	
	
	twoway ///
    (line remesa_pct aÑo_, lwidth(medthick) lcolor(orange)) ///
    (scatter remesa_pct aÑo_, mlabel(remesa_pct) mlabformat(%4.1f) ///
     mlabposition(12) mlabcolor(black) msymbol(circle_hollow)), ///
    ytitle("Porcentaje de Hogares con Remesas Externas") ///
    xtitle("Año") ///
    title("Evolución de Remesas Externas (2019–2023)", size(medsmall)) ///
    ylabel(0(1)10, format(%2.0f)) /// <-- ajustar el límite máximo según sus datos
    xlabel(2019(1)2023) ///
    legend(off) ///
    graphregion(color(white))
	
	
	
	
	*****Garficar los montos de remesas internas**************************************
	
		use panelfinal23.dta, replace
	
		destring aÑo_, replace
	
	
	* Crear respaldo de la base original
preserve

* Asegúrese de que 'monto_nacional' está en soles y bien definida

* Calcular promedio ponderado del monto de remesas por año
collapse (mean) monto_promedio=monto_nacional [pweight=facpanel1923], by(aÑo_)
	
	
	twoway ///
    (line monto_promedio aÑo_, lwidth(medthick) lcolor(blue)) ///
    (scatter monto_promedio aÑo_, mlabel(monto_promedio) mlabformat(%9.0fc) ///
     mlabposition(12) mlabcolor(black) msymbol(circle_hollow)), ///
    ytitle("Monto Promedio de Remesas Internas (S/.)") ///
    xtitle("Año") ///
    title("Evolución del Monto de Remesas Internas (2019–2023)", size(medsmall)) ///
    ylabel(, format(%9.0fc)) ///
    xlabel(2019(1)2023) ///
    legend(off) ///
    graphregion(color(white))
	
	
	
	***Calcular el monto total anual de remesas internas*****
	
		use panelfinal23.dta, replace
	
		destring aÑo_, replace
		
		
		* Crear copia temporal
preserve

* Calcular el total anual ponderado de remesas internas
gen monto_total = monto_nacional * facpanel1923

collapse (sum) total_remesas=monto_total, by(aÑo_)

* Convertir a millones para graficar mejor (opcional)
gen total_millones = total_remesas / 1e6
	
	
	
	twoway ///
    (line total_millones aÑo_, lwidth(medthick) lcolor(blue)) ///
    (scatter total_millones aÑo_, mlabel(total_millones) ///
     mlabformat(%9.2f) mlabposition(12) mlabcolor(black) msymbol(circle_hollow)), ///
    ytitle("Remesas Internas Totales (Millones de S/.)") ///
    xtitle("Año") ///
    title("Monto Total Anual de Remesas Internas (2019–2023)", size(medsmall)) ///
    ylabel(, format(%9.0fc)) ///
    xlabel(2019(1)2023) ///
    legend(off) ///
    graphregion(color(white))
	
	
	
	
	
	******Montos promedio mensual por hogar de las remesas externas**********
	
			use panelfinal23.dta, replace
	
		destring aÑo_, replace
		
	
	
	* Crear respaldo temporal
preserve

* Calcular promedio ponderado del monto mensual de remesas externas por año
collapse (mean) promedio_ext = monto_extranjero [pweight=facpanel1923], by(aÑo_)
	
	
	
	
	
	twoway ///
    (line promedio_ext aÑo_, lwidth(medthick) lcolor(green)) ///
    (scatter promedio_ext aÑo_, mlabel(promedio_ext) ///
     mlabformat(%9.0fc) mlabposition(12) mlabcolor(black) msymbol(circle_hollow)), ///
    ytitle("Monto Promedio Mensual de Remesas Externas (S/.)") ///
    xtitle("Año") ///
    title("Evolución del Promedio de Remesas Externas (2019–2023)", size(medsmall)) ///
    ylabel(, format(%9.0fc)) ///
    xlabel(2019(1)2023) ///
    legend(off) ///
    graphregion(color(white))
	
	
	
	***Monto total de remeas externas******************************************
	
			use panelfinal23.dta, replace
	
		destring aÑo_, replace
	
	
	* Crear respaldo de la base
preserve

* Calcular el total mensual ponderado (hogar x factor)
gen monto_total_ext = monto_extranjero * facpanel1923

* Sumar el total mensual de cada año
collapse (sum) total_remesas_ext = monto_total_ext, by(aÑo_)

* Convertir a millones de soles para facilitar la lectura
gen total_ext_millones = total_remesas_ext / 1e6
	
	
	
	twoway ///
    (line total_ext_millones aÑo_, lwidth(medthick) lcolor(green)) ///
    (scatter total_ext_millones aÑo_, mlabel(total_ext_millones) ///
     mlabformat(%9.2f) mlabposition(12) mlabcolor(black) msymbol(circle_hollow)), ///
    ytitle("Remesas Externas Totales (Millones de S/.)") ///
    xtitle("Año") ///
    title("Monto Total Anual de Remesas Externas (2019–2023)", size(medsmall)) ///
    ylabel(, format(%9.0fc)) ///
    xlabel(2019(1)2023) ///
    legend(off) ///
    graphregion(color(white))
	
	
	
	
	************************************************************************
	
	***GRAFICAR REMESAS INTERNAS Y POBREZA MONETARIA************************
	
			use panelfinal23.dta, replace
	
		destring aÑo_, replace
	
	
	* Crear respaldo temporal de la base
preserve

* Crear variable de pobreza si no existe
gen pobre = cod_pobreza

* Calcular pobreza promedio ponderada por año y grupo de remesas internas
collapse (mean) pobreza=pobre [pweight=facpanel1923], by(aÑo_ flag_rinternas)

* Convertir a porcentaje para graficar
gen pobreza_pct = pobreza * 100
	
	
	
	twoway ///
    (line pobreza_pct aÑo_ if flag_rinternas==1, lcolor(blue) lpattern(solid) ///
     lwidth(medthick) sort) ///
    (line pobreza_pct aÑo_ if flag_rinternas==0, lcolor(red) lpattern(dash) ///
     lwidth(medthick) sort), ///
    ytitle("Pobreza Monetaria (%)") ///
    xtitle("Año") ///
    title("Pobreza Monetaria según Recepción de Remesas Internas (2019–2023)", size(medsmall)) ///
    xlabel(2019(1)2023) ///
    ylabel(0(5)50) ///
    legend(order(1 "Recibe remesas internas" 2 "No recibe remesas internas")) ///
    graphregion(color(white))
	
	
	
	***GRAFICAR REMESAS INTERNAS Y POBREZA MONETARIA************************
	
			use panelfinal23.dta, replace
	
		destring aÑo_, replace
	
	
	* Crear respaldo de la base
preserve

* Asegurar que la variable de pobreza es binaria (ya lo es: cod_pobreza)
gen pobre = cod_pobreza

* Calcular pobreza promedio ponderada por año y grupo (recibe / no recibe remesas internas)
collapse (mean) pobreza=pobre [pweight=facpanel1923], by(aÑo_ flag_rinternas)

* Convertir a porcentaje
gen pobreza_pct = pobreza * 100
	
	
	
	twoway ///
    (line pobreza_pct aÑo_ if flag_rinternas==1, lcolor(blue) lpattern(solid) ///
     lwidth(medthick) sort) ///
    (scatter pobreza_pct aÑo_ if flag_rinternas==1, ///
     mlabel(pobreza_pct) mlabformat(%4.1f) mlabposition(12) ///
     mlabcolor(blue) msymbol(circle_hollow)) ///
    ///
    (line pobreza_pct aÑo_ if flag_rinternas==0, lcolor(red) lpattern(dash) ///
     lwidth(medthick) sort) ///
    (scatter pobreza_pct aÑo_ if flag_rinternas==0, ///
     mlabel(pobreza_pct) mlabformat(%4.1f) mlabposition(12) ///
     mlabcolor(red) msymbol(circle_hollow)), ///
    ///
    ytitle("Pobreza Monetaria (%)") ///
    xtitle("Año") ///
    title("Pobreza Monetaria según Remesas Internas (2019–2023)", size(medsmall)) ///
    xlabel(2019(1)2023) ///
    ylabel(0(5)50) ///
    legend(order(1 "Recibe remesas internas" 3 "No recibe remesas internas")) ///
    graphregion(color(white))
	
	
	
	
	****GRAFICAR REMESAS EXTERNAS Y POBREZA MONETARIA********************
	
	use panelfinal23.dta, replace
	
		destring aÑo_, replace
	
	
	
	* Crear copia de respaldo temporal
preserve

* Asegurar variable binaria de pobreza
gen pobre = cod_pobreza

* Calcular pobreza promedio ponderada por año y grupo de remesas externas
collapse (mean) pobreza = pobre [pweight=facpanel1923], by(aÑo_ flag_rexternas)

* Convertir a porcentaje
gen pobreza_pct = pobreza * 100
	
	
	
	twoway ///
    (line pobreza_pct aÑo_ if flag_rexternas == 1, lcolor(forest_green) lpattern(solid) ///
     lwidth(medthick) sort) ///
    (scatter pobreza_pct aÑo_ if flag_rexternas == 1, ///
     mlabel(pobreza_pct) mlabformat(%4.1f) mlabposition(12) ///
     mlabcolor(forest_green) msymbol(circle_hollow)) ///
    ///
    (line pobreza_pct aÑo_ if flag_rexternas == 0, lcolor(cranberry) lpattern(dash) ///
     lwidth(medthick) sort) ///
    (scatter pobreza_pct aÑo_ if flag_rexternas == 0, ///
     mlabel(pobreza_pct) mlabformat(%4.1f) mlabposition(12) ///
     mlabcolor(cranberry) msymbol(circle_hollow)), ///
    ///
    ytitle("Pobreza Monetaria (%)") ///
    xtitle("Año") ///
    title("Pobreza Monetaria según Remesas Externas (2019–2023)", size(medsmall)) ///
    xlabel(2019(1)2023) ///
    ylabel(0(5)50) ///
    legend(order(1 "Recibe remesas externas" 3 "No recibe remesas externas")) ///
    graphregion(color(white))
	
	
	
	
	
	****GARFICAR LAS REMESAS TOTALES Y POBREZA MONETARIA********************
	use panelfinal23.dta, replace
	
		destring aÑo_, replace
		
		
		
	* Crear copia de respaldo temporal
preserve

* Asegurar que la variable binaria de pobreza esté creada
gen pobre = cod_pobreza

* Calcular pobreza promedio ponderada por año y según remesas totales
collapse (mean) pobreza = pobre [pweight=facpanel1923], by(aÑo_ flag_rtotal)

* Convertir a porcentaje
gen pobreza_pct = pobreza * 100
	
	
	
	
	twoway ///
    (line pobreza_pct aÑo_ if flag_rtotal == 1, lcolor(navy) lpattern(solid) ///
     lwidth(medthick) sort) ///
    (scatter pobreza_pct aÑo_ if flag_rtotal == 1, ///
     mlabel(pobreza_pct) mlabformat(%4.1f) mlabposition(12) ///
     mlabcolor(navy) msymbol(circle_hollow)) ///
    ///
    (line pobreza_pct aÑo_ if flag_rtotal == 0, lcolor(maroon) lpattern(dash) ///
     lwidth(medthick) sort) ///
    (scatter pobreza_pct aÑo_ if flag_rtotal == 0, ///
     mlabel(pobreza_pct) mlabformat(%4.1f) mlabposition(12) ///
     mlabcolor(maroon) msymbol(circle_hollow)), ///
    ///
    ytitle("Pobreza Monetaria (%)") ///
    xtitle("Año") ///
    title("Pobreza Monetaria según Recepción de Remesas Totales (2019–2023)", size(medsmall)) ///
    xlabel(2019(1)2023) ///
    ylabel(0(5)50) ///
    legend(order(1 "Recibe remesas totales" 3 "No recibe remesas totales")) ///
    graphregion(color(white))
	
	
	
	
	
*********IMPACTO DEL PANEL HOGAR ********************************************	
	
		use panelfinal23.dta, replace
	
destring aÑo_, replace
destring idh, replace

xtset idh aÑo_
	
	
	
****HIPOTESIS GENERAL*****************************************************
***Remesas totales**********************************************************


******Estimación de panel logit efectos fijos********

xtlogit cod_pobreza flag_rtotal mieperho hogarinternet  mayores_18anhos titulopropiedad i.aÑo_, fe




***efectos margianles*****

margins, dydx(flag_rtotal) post

margins, dydx(*) post



****HIPOTESIS ESPECIFICA1*****************************************************
***Remesas INTERNAS**********************************************************


******Estimación de panel logit efectos fijos********

xtlogit cod_pobreza flag_rinternas mieperho hogarinternet  mayores_18anhos titulopropiedad i.aÑo_, fe




***efectos margianles*****

margins, dydx(flag_rtotal) post

margins, dydx(*) post




****HIPOTESIS ESPECIFICA2*****************************************************
***Remesas EXTERNAS**********************************************************


******Estimación de panel logit efectos fijos********

xtlogit cod_pobreza flag_rexternas mieperho hogarinternet  mayores_18anhos titulopropiedad i.aÑo_, fe




***efectos margianles*****

margins, dydx(flag_rtotal) post

margins, dydx(*) post







***Paso a paso en Stata para identificar hogares que no cambian de pobreza:


* Paso 1: capturar el estado de pobreza del primer año
bysort idh (aÑo_): gen pobreza_primera = cod_pobreza[1]


* Paso 2: identificar si cambia en algún año
gen cambio_pobreza = 0
replace cambio_pobreza = 1 if cod_pobreza != pobreza_primera


* Paso 3: sumar los cambios por hogar
bysort idh (aÑo_): egen suma_cambios = total(cambio_pobreza)


* Paso 4: crear indicador
gen flag_sin_cambios = .
replace flag_sin_cambios = 1 if suma_cambios == 0
replace flag_sin_cambios = 0 if suma_cambios > 0


* Paso 5: ver resumen
tab flag_sin_cambios




***OPCIÓN 1: Gráfico de barras simples (frecuencias absolutas)

graph bar (count), over(flag_sin_cambios, label(labsize(small) valuelabel)) ///
    bar(1, color(navy)) bar(2, color(maroon)) ///
    title("Distribución de hogares según cambio en pobreza") ///
    legend(label(1 "Con cambio en pobreza") label(2 "Sin cambio en pobreza")) ///
    ytitle("Número de observaciones")



**OPCIÓN 2: Gráfico de barras proporcionales (%)

gen grupo_cambio = cond(flag_sin_cambios==1, "Sin cambio", "Con cambio")

graph bar (count), over(grupo_cambio, relabel(1 "Con cambio" 2 "Sin cambio")) ///
    bar(1, color(dknavy)) bar(2, color(orange)) ///
    blabel(bar, format(%9.1g)) ///
    title("Proporción de hogares según variación en pobreza") ///
    ytitle("Frecuencia") ///
    note("Fuente: ENAHO Panel 2019–2023")    



***OPCIÓN 3: Pie chart (si desea mostrar proporciones)***

graph pie, over(grupo_cambio) plabel(_all name, size(small)) ///
    title("Hogares con y sin cambio en condición de pobreza") ///
    legend(order(1 "Con cambio" 2 "Sin cambio"))

	
	
***OPCIÓN 4 (opcional): Gráfico de barras con porcentaje
	
graph bar (count), over(flag_sin_cambios, label(labsize(small))) ///
    asyvars percent ///
    bar(1, color(blue)) bar(2, color(gs10)) ///
    blabel(bar, format(%4.1f) size(small)) ///
    title("Porcentaje de hogares según cambio en pobreza") ///
    ytitle("Porcentaje") ///
    subtitle("Panel balanceado 2019–2023")
	
	
	
**Paso 1: Calcular % de pobreza por año y por grupo de remesas*********

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


collapse (mean) pobreza=cod_pobreza, by(aÑo_ flag_rtotal)
	
	
	
**Paso 2: Graficar líneas comparando grupos	
	

	
twoway ///
    (line pobreza aÑo_ if flag_rtotal==1, sort lcolor(navy) lwidth(medthick) msymbol(circle) ///
     lpattern(solid)) ///
    (line pobreza aÑo_ if flag_rtotal==0, sort lcolor(maroon) lwidth(medthick) msymbol(square) ///
     lpattern(dash)), ///
    ///
    title("Evolución de la pobreza según recepción de remesas") ///
    subtitle("Panel ENAHO 2019–2023") ///
    xtitle("Año") ytitle("% de hogares pobres") ///
    ylabel(, format(%4.2f)) ///
    legend(order(1 "Con remesas" 2 "Sin remesas") position(6) rows(1)) ///
    graphregion(color(white))
	
	
	
	
** Si también desea agregar etiquetas (porcentajes) sobre los puntos:

	
	***Genere las etiquetas:
	gen etiqueta = string(round(pobreza*100,1)) + "%"
	
	
	**Luego, use esta versión con etiquetas:
	
	
	twoway ///
    (line pobreza aÑo_ if flag_rtotal==1, sort lcolor(navy) lwidth(medthick) msymbol(circle)) ///
    (scatter pobreza aÑo_ if flag_rtotal==1, ///
     mlabel(etiqueta) mlabcolor(navy) mlabposition(12) msymbol(none)) ///
    ///
    (line pobreza aÑo_ if flag_rtotal==0, sort lcolor(maroon) lwidth(medthick) msymbol(square)) ///
    (scatter pobreza aÑo_ if flag_rtotal==0, ///
     mlabel(etiqueta) mlabcolor(maroon) mlabposition(12) msymbol(none)), ///
    ///
    title("Evolución de la pobreza según recepción de remesas") ///
    subtitle("Panel ENAHO 2019–2023") ///
    xtitle("Año") ytitle("% de hogares pobres") ///
    ylabel(, format(%4.2f)) ///
    legend(order(1 "Con remesas" 3 "Sin remesas") position(6) rows(1)) ///
    graphregion(color(white))
	
	
	

	****************************************************
	twoway ///
    (line pobreza aÑo_ if flag_rtotal==1, sort lcolor(navy) lwidth(medthick) msymbol(circle)) ///
    (scatter pobreza aÑo_ if flag_rtotal==1, ///
     mlabel(etiqueta) mlabcolor(navy) mlabposition(12) msymbol(none)) ///
    ///
    (line pobreza aÑo_ if flag_rtotal==0, sort lcolor(maroon) lwidth(medthick) msymbol(square)) ///
    (scatter pobreza aÑo_ if flag_rtotal==0, ///
     mlabel(etiqueta) mlabcolor(maroon) mlabposition(12) msymbol(none)), ///
    ///
    title("Evolución de la pobreza monetaria según remesas totales") ///
    subtitle("Panel ENAHO 2019–2023") ///
    xtitle("Año") ytitle("% de hogares pobres") ///
    ylabel(, format(%4.1f)) ///
    legend(order(1 "Remesas totales: Sí" 3 "Remesas totales: No") ///
           position(6) ring(0) rows(1)) ///
    graphregion(color(white))
	
	
	
	
	*************************************************************************
	twoway ///
    (line pobreza aÑo_ if flag_rtotal==1, sort lcolor(navy) lwidth(medthick) msymbol(circle)) ///
    (scatter pobreza aÑo_ if flag_rtotal==1, ///
     mlabel(etiqueta) mlabcolor(navy) mlabposition(6) msymbol(none)) ///
    ///
    (line pobreza aÑo_ if flag_rtotal==0, sort lcolor(maroon) lwidth(medthick) msymbol(square)) ///
    (scatter pobreza aÑo_ if flag_rtotal==0, ///
     mlabel(etiqueta) mlabcolor(maroon) mlabposition(6) msymbol(none)), ///
    ///
    title("Evolución de la pobreza monetaria según remesas totales") ///
    subtitle("Panel ENAHO 2019–2023") ///
    xtitle("Año") ytitle("% de hogares pobres") ///
    ylabel(, format(%4.1f)) ///
    legend(order(1 "Remesas totales: Sí" 3 "Remesas totales: No") ///
           position(6) ring(0) rows(1)) ///
    graphregion(color(white))
	
	
	
	
	*******************************************************************
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	






****Panel estático: Impacto del ingreso al consumo de los hogares en Perú*******
br

***Conversión a logaritmos*****


gen lconsumo=ln(consumo)


gen lingreso=ln(ingreso_H)





br

****PANEL ESTÁTICO********************************************

****1. Panel pool****************************************

reg lconsumo lingreso 

reg consumo ingreso_H 



***2. Panel de efectos fijos*****************************

xtreg lconsumo lingreso , fe 

xtreg lconsumo lingreso, fe vce(cluster idh)



xtreg consumo ingreso_H  , fe 


****3. Panel de efectos aleatorios********************

xtreg lconsumo lingreso, re


xtreg lconsumo lingreso, re vce(robust)

xtreg consumo ingreso_H, re


***4. Tests Hausman: EF VS EA**********************************

**NOTA:
*Si la Prob>chi2 es superior a 0.05 (es decir, al 5%), entonces se debe usar el panel de datos de efectos aleatorios, porque no hay correlación entre los comportamientos individuales y las variables explicativas (independientes); pero si es menor o igual a 0.05, entonces se debe emplear el panel de datos de efectos Fijos, porque el comportamiento de cada individuo sí influye sobre las variables explicativas.


xtreg lconsumo lingreso, fe
estimates store fe

xtreg lconsumo lingreso, re
estimates store re

hausman fe re



***5. Estimación del mejor panel: Panel de efectos fijos*********************


xtreg lconsumo lingreso , fe 

xtreg lconsumo lingreso, fe vce(cluster idh)


****6. Evaluación del panel de efectos fijos*********************


***6.1. Autocorrelación************************************


xtserial lconsumo lingreso, output


****6.2. Heterocedasticidad********

xtreg lconsumo lingreso, fe

xttest3


*****6.3. Corrección de autocorrelación*************************

xtregar lconsumo lingreso, fe


****6.4. Corrección de heteroscedasticidad***********************

xtgls lconsumo lingreso, p(h)

xtpcse lconsumo lingreso, het



****6.5. Corrección de autocorrelación y heteroscedasticidad************

xtgls lconsumo lingreso, p(h) c(ar1)

xtpcse lconsumo lingreso, het c(ar1)


xtpcse lconsumo lingreso i.aÑo_, het c(ar1)


********Filtro remesas*********************************************************

br

keep if monto_nacional>0



keep if monto_extranjero>0




gen lremesas_nacional=ln(monto_nacional)


gen lremesas_externa=ln(monto_extranjero)


xtreg lconsumo lingreso lremesas_externa ledad leduc, fe
estimates store fe

xtreg lconsumo lingreso lremesas_externa ledad leduc, re
estimates store re

hausman fe re

































*I. MODELO PANEL DE EFECTOS FIJOS***

//1. ESTIMACIÓN DE PANEL DE EFECTOS FIJOS//

xtreg lconsumo lingreso , fe 

xtreg lconsumo lingreso, fe vce(cluster idh)


//2. PROBLEMAS ECONOMÉTRICOS//
********************************************************************************

**A.Autocorrelación***


xtserial lconsumo lingreso, output


***corrección de autocorrelación***
***Modelo con problema de autocorrelación solucionado***

xtregar lconsumo lingreso, fe


***B. Heterocedasticidad********

xtreg lconsumo lingreso, fe

xttest3

**solucionar la existencia de un problema de heterocedasticidad, sin la existencia de problemas de autocorrelación

xtgls lconsumo lingreso, p(h)

xtpcse lconsumo lingreso, het


**C. Solcuionar problemas de heterocedasticidad y autocorrelación**
**Para solucionar el problema de la heterocedasticidad y de autocorrelación a la vez***


xtgls lconsumo lingreso, p(h) c(ar1)

xtpcse lconsumo lingreso, het c(ar1)



****estimación del modelo de efectos fijos incluyeno efectos temporales****
xtpcse lconsumo lingreso i.aÑo_, het c(ar1) 


****estimación del modelo de efectos fijos incluyeno efectos transversales****
xtpcse logIngreso logIngresojuntos i.idh, het c(ar1) 




****estimación del modelo de efectos fijos incluyeno efectos transversales y efectos temporales****
xtpcse logIngreso logIngresojuntos i.idh  i.aÑo_, het c(ar1) 





*******************************************************************************
**II. MODELO PANEL DE EFECTOS ALEATORIOS
********************************************************************************

xtreg lconsumo lingreso, re


xtreg lconsumo lingreso, re vce(robust)



***Autocorrelación**********************

xtserial lconsumo lingreso, output


**Modelo con problema de autocorrelación solucionado***

xtregar lconsumo lingreso, re


***Heterocedasticidad************************************

**La prueba de Breusch-Pagan en el caso de los datos de panel permite saber si existe heterocedasticidad para los estimadores de efectos fijos o aleatorios.
**el número de grupos sea menor que el número de períodos:

xtgls lconsumo lingreso

xttest3

xttest2



***Cuando existen problemas de heterocedasticidad, pero no hay de autocorrelación, como alternativa a los estimadores robustos, debe ejecutarse el comando:

xtpcse lconsumo lingreso, het



***Para solucionar el problema de la heterocedasticidad y de autocorrelación a la vez,****


xtpcse lconsumo lingreso, het c(ar1)



**III. prueba de Hausman*************

**NOTA:
*Si la Prob>chi2 es superior a 0.05 (es decir, al 5%), entonces se debe usar el panel de datos de efectos aleatorios, porque no hay correlación entre los comportamientos individuales y las variables explicativas (independientes); pero si es menor o igual a 0.05, entonces se debe emplear el panel de datos de efectos Fijos, porque el comportamiento de cada individuo sí influye sobre las variables explicativas.


xtreg lconsumo lingreso, fe
estimates store fe

xtreg lconsumo lingreso, re
estimates store re

hausman fe re


***Panel final: Efectos fijos****************************


xtreg lconsumo lingreso , fe 

xtreg lconsumo lingreso, fe vce(cluster idh)



**A.Autocorrelación***

search xtserial
net sj 3-2 st0039         (or click on st0039)
net install st0039        (or click on click here to install)


xtserial lconsumo lingreso, output



***corrección de autocorrelación***
***Modelo con problema de autocorrelación solucionado***

xtregar lconsumo lingreso, fe


***B. Heterocedasticidad********

xtreg lconsumo lingreso, fe

ssc install xttest3

xttest3

xttest3


**solucionar la existencia de un problema de heterocedasticidad, sin la existencia de problemas de autocorrelación

xtgls lconsumo lingreso, p(h)

xtpcse lconsumo lingreso, het




**C. Solcuionar problemas de heterocedasticidad y autocorrelación**
**Para solucionar el problema de la heterocedasticidad y de autocorrelación a la vez***


xtgls lconsumo lingreso, p(h) c(ar1)

xtpcse lconsumo lingreso, het c(ar1)



xtpcse lconsumo lingreso i.aÑo_, het c(ar1)




**D. Histograma de los Residuales*****

xtreg lconsumo lingreso, fe

predict res, residuals

histogram res



xtreg lconsumo lingreso, fe

predict res, residuals

histogram res, bin(13)


line  res




******PANEL TOBIT***************************************************************


use panelfinal19_23.dta, replace


br

****Indicarle que es un panel**************************************************


destring aÑo_, replace
destring idh, replace

xtset idh aÑo_



***Panel Tobit: Monto de remesas internas**************************************
**Estimar el modelo Tobit con efectos aleatorios y censura inferior en 0

***Matriz de correlación: Multicolinealidad***

correlate mayores_18anhos JHmujer SIS JHcasado       edadJH_adultoMayor electricidadhogar

reg mayores_18anhos JHmujer SIS JHcasado edadJH_adultoMayor electricidadhogar

estat vif



xttobit monto_nacional  mayores_18anhos JHmujer SIS JHcasado       edadJH_adultoMayor electricidadhogar , ll(0) re





***Edadd del JH*************************************

tab edadJH

gen edadJH_joven = edadJH < 30
gen edadJH_adulto = edadJH >= 30 & edadJH < 60
gen edadJH_adultoMayor = edadJH >= 60

tab edadJH_joven
tab edadJH_adulto
tab edadJH_adultoMayor





******Exportarlo en excel**************************************************

ssc install estout



xttobit monto_nacional  mayores_18anhos JHmujer SIS JHcasado       edadJH_adultoMayor electricidadhogar , ll(0) re


estimates store modelo_tobit



esttab modelo_tobit using "Resultados_Tobit.xlsx", replace se

esttab modelo_tobit using "Resultados_Tobit_Completo.xlsx", replace se z p


esttab modelo_tobit using "Resultados_Tobit.csv", replace se z p csv


*** efectos marginales sobre la variable latente**********************

margins, dydx(*) predict(ystar(0,.))


***efectos marginales sobre la variable observada *****
margins, dydx(*) predict(e(0,.))


****efectos marginales tipo binario********************

margins, dydx(*) predict(pr(0,.))










****Obtener los residuos del modelo


predict residuals, xb
gen residuals_e = monto_nacional - residuals


qnorm residuals_e


swilk residuals_e


histogram residuals_e, normal
qnorm residuals_e



ssc install jb6



jb6 residuals_e

xtsktest residuals_e



histogram residuals_e, normal
graph save hist_resid, replace

qnorm residuals_e
graph save qnorm_resid, replace


***Para corregir mormalidad****************************************

tobit monto_nacional mayores_18anhos JHmujer SIS JHcasado ///
      edadJH_adultoMayor electricidadhogar, ll(0) vce(robust)


 ***Bootstrap para obtener errores robustos

use panelfinal19_23.dta, replace


br


generate newid = idh

****Indicarle que es un panel**************************************************


destring aÑo_, replace
destring idh, replace

xtset idh aÑo_
 
 

bootstrap _b, reps(200) seed(123) cluster(idh) idcluster(newid): ///
    xttobit monto_nacional mayores_18anhos JHmujer SIS JHcasado ///
             edadJH_adultoMayor electricidadhogar, ll(0) re
 
 
 
xttobit monto_nacional  mayores_18anhos JHmujer SIS JHcasado edadJH_adultoMayor electricidadhogar, ll(0) re vce(bootstrap, reps(200) seed(123))
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

