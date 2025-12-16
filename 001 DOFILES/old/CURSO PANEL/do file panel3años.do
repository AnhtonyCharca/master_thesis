**ESTUDIOS ECONOMÉTRICOS********************************************************
**CURSO VIRTUAL: IA PARA DATOS DE PANEL CON STATA
********************************************************************************
**SESIÓN 2:PANEL PROBIT*********************************************************
**ESPECIALISTA: DR. MAXIMO DAMIAN VALDERA***************************************
********************************************************************************
****Panel de 3 años*************************************************************

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

tab  hpanel_21_23

keep if hpanel_21_23==1 
count






br
***************************************************************
**visualizar el panel 3 años ****
br


generate hogar =   hogar_21
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""
 

br



***pobreza**********************************************************************

tab pobreza_19

tab pobreza_19, nolabel



 set more off
local anho 21 22 23
*Bucle
foreach v of local anho {
	generate cod_pobreza_`v' = 0
	replace  cod_pobreza_`v' = 1 if  (pobreza_`v' == 1 |  pobreza_`v' == 2)  
	 
	
  } 
  
  

tab cod_pobreza_21
  
 tab pobreza_17
  

***urbana y rural************************************************************
  
  tab estrato_19
  
  tab estrato_19, nolabel
  
  
  
   set more off
local anho 21 22 23
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

  
keep  conglome vivienda hogar  cod_pobreza_*  inghog2d_* urbano_* mieperho_* gru11hd_* gru21hd_* gru31hd_* gru41hd_* gru51hd_* gru61hd_* gru71hd_* gru81hd_* ingnethd_*  ingindhd_*  insedlhd_*  ingseihd_*  ingexthd_*  ingtrahd_*  ingrenhd_*  ingoexhd_*  ig03hd1_* ig03hd2_* ig03hd3_* ig03hd4_* dominio_*



br

save pobreza,replace

use pobreza,replace

count


drop dominio_19 mieperho_19 dominio_20



drop ig03hd1_19 ig03hd2_19 ig03hd3_19 ig03hd4_19 ingnethd_19 ingindhd_19 insedlhd_19 ingseihd_19 ingexthd_19 ingtrahd_19 ingrenhd_19 ingoexhd_19 gru11hd_19 gru21hd_19 gru31hd_19 gru41hd_19 gru51hd_19 gru61hd_19 gru71hd_19 gru81hd_19 inghog2d_19 mieperho_20 ig03hd1_20 ig03hd2_20 ig03hd3_20 ig03hd4_20 ingnethd_20 ingindhd_20 insedlhd_20 ingseihd_20 ingexthd_20 ingtrahd_20 ingrenhd_20 ingoexhd_20 gru11hd_20 gru21hd_20 gru31hd_20 gru41hd_20 gru51hd_20 gru61hd_20 gru71hd_20 gru81hd_20 inghog2d_20 






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

tab hpanel_21_23

keep if hpanel_21_23==1 

count
**********************************************************************************
*******************************************************************************
br


generate hogar =   hogar_21
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""
 
 

br


keep conglome vivienda hogar facpanel2123 aÑo_* 
br

drop aÑo_19 aÑo_20



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

tab hpanel_21_23


keep if hpanel_21_23==1 
count

**********************************************************************************
*******************************************************************************
br

generate hogar =   hogar_21
replace  hogar =   hogar_22 if hogar == ""
replace  hogar =   hogar_23 if hogar == ""


br
**Su hogar tiene : Internet******
 **************************

 tab p1144_19
 tab p1144_19, nolabel
 
  
  set more off
local anho 21 22 23
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
local anho 21 22 23
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
local anho 21 22 23
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
local anho 21 22 23
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
local anho 21 22 23
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
local anho 21 22 23
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
local anho 21 22 23
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
local anho 21 22 23
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
local anho 21 22 23
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
local anho 21 22 23
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


****UNIR LOS MODULOS***********************************************************

use panel1519,clear


br
 
merge 1:1 conglome vivienda hogar  using pobreza, keepusing(cod_pobreza_*  inghog2d_* urbano_* mieperho_* gru11hd_* gru21hd_* gru31hd_* gru41hd_* gru51hd_* gru61hd_* gru71hd_* gru81hd_* ingnethd_*  ingindhd_*  insedlhd_*  ingseihd_*  ingexthd_*  ingtrahd_*  ingrenhd_*  ingoexhd_*  ig03hd1_* ig03hd2_* ig03hd3_* ig03hd4_*  dominio_*    ) nogenerate

merge 1:1 conglome vivienda hogar  using caracteristicashogar , keepusing( hogarinternet_* paredcemento_* pisocemento_* techoconcreto_* agua_* baño_* electricidadhogar_* celularhogar_* titulopropiedad_* gas_*) nogenerate

*******************************************************************************
br

*******************************************************************************
save base_consolidada.dta, replace



*******************************************************************************
use base_consolidada.dta, clear


***pivotear para el panel******
br

reshape long cod_pobreza  inghog2d urbano mieperho gru11hd gru21hd gru31hd gru41hd gru51hd gru61hd gru71hd gru81hd ingnethd  ingindhd  insedlhd  ingseihd  ingexthd  ingtrahd  ingrenhd  ingoexhd  ig03hd1 ig03hd2 ig03hd3 ig03hd4 dominio hogarinternet paredcemento pisocemento techoconcreto agua baño electricidadhogar celularhogar titulopropiedad gas , i(conglome vivienda hogar ) j(aÑo_) string

br


**identificador id: a nivel hogar***
egen idh =concat(conglome vivienda hogar)


br
**convertir el año, de texto a numerico**

replace aÑo_= "2021" if aÑo_=="_21"
replace aÑo_= "2022" if aÑo_=="_22"
replace aÑo_= "2023" if aÑo_=="_23"


*******************************************************************************
br

**Seleccionar las variables importaantes**************************************

br aÑo_ conglome vivienda hogar idh facpanel2123 cod_pobreza  inghog2d urbano mieperho gru11hd gru21hd gru31hd gru41hd gru51hd gru61hd gru71hd gru81hd ingnethd  ingindhd  insedlhd  ingseihd  ingexthd  ingtrahd  ingrenhd  ingoexhd  ig03hd1 ig03hd2 ig03hd3 ig03hd4 dominio hogarinternet paredcemento pisocemento techoconcreto agua baño electricidadhogar celularhogar titulopropiedad gas 


keep aÑo_ conglome vivienda hogar idh facpanel2123 cod_pobreza  inghog2d urbano mieperho gru11hd gru21hd gru31hd gru41hd gru51hd gru61hd gru71hd gru81hd ingnethd  ingindhd  insedlhd  ingseihd  ingexthd  ingtrahd  ingrenhd  ingoexhd  ig03hd1 ig03hd2 ig03hd3 ig03hd4 dominio hogarinternet paredcemento pisocemento techoconcreto agua baño electricidadhogar celularhogar titulopropiedad gas 


*******************************************************************************
save panel3años.dta, replace


*******************************************************************************
use panel3años.dta, replace


***Indicarle a stata que es un panel*******************************************


destring aÑo_, replace
destring idh, replace

xtset idh aÑo_



br


// PANELES PROBAILÍSTICOS (1,0)-----------------------------------------------

//1. PANEL LOGIT**************************************************************

//1.1.Panel Logit con Efectos Fijos (Conditional Fixed Effects Logit)

xtlogit cod_pobreza     hogarinternet  baño gas, fe
estimates store fe

///1.2. Panel Logit con Efectos aleatorios

xtlogit cod_pobreza     hogarinternet  baño gas, re
estimates store re

//1.3. Test Hausman***********************************************************

hausman fe re, sigmamore



* Estimar modelo con efectos fijos (lineal)
xtreg cod_pobreza  hogarinternet baño gas titulopropiedad, fe
estimates store fe

* Estimar modelo con efectos aleatorios (lineal)
xtreg cod_pobreza  hogarinternet baño gas, re
estimates store re

* Ejecutar prueba de Hausman
hausman fe re, sigmamore



//2.PANEL PROBIT*********************************************************


//PANEL PROBIT CON EFECTOS ALEATORIOS***********************************


xtprobit cod_pobreza mieperho hogarinternet baño gas, re




***Primero, diagnostique su base:***
bysort idh: egen variacion = sd(cod_pobreza)
tab variacion





*****POR LO TANTO EL MODELO FINAL: PANEL PROBIT EFECTOS ALEATORIOS*************

xtprobit cod_pobreza mieperho hogarinternet baño gas, re



***efectos marginales: efectos marginales promedio

margins, dydx(*) 


********Generar la tabla*****************************************************

xtprobit cod_pobreza mieperho hogarinternet baño gas, re

margins, dydx(*) predict(pr)


ssc install outreg2, replace


xtprobit cod_pobreza mieperho hogarinternet baño gas, re
outreg2 using panel_probit_resultados.doc, replace ctitle("Coeficientes del modelo Probit") dec(3)



margins, dydx(*) predict(pr)
outreg2 using panel_probit_resultados.doc, append ctitle("Efectos marginales promedio (AME)") dec(3)
















































