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
svy: mean pob_mont_100 if dpto==21 , over(year_2)

**TABLA 05:
svy: mean pob_mont_100 , over(year_2 area)
svy: mean pob_mont_100 if dpto==21 , over(year_2 area)
**TABLA 06:
svy: mean pob_mont_100 , over(year_2 sex)
svy: mean pob_mont_100 if dpto==21 , over(year_2 sex)
**TABLA 07:
svy: mean pob_mont_100 , over(year_2 g_edad)
svy: mean pob_mont_100 if dpto==21 , over(year_2 g_edad)
**TABLA 08:
svy: mean pob_mont_100 , over(year_2 ocupinf )
svy: mean pob_mont_100 if dpto==21 , over(year_2 ocupinf )
**TABLA 09:
svy: mean pob_mont_100 , over(year_2 nempljh  )
svy: mean pob_mont_100 if dpto==21 , over(year_2 nempljh  )
**TABLA 10:
svy: mean pob_mont_100 , over(year_2 sec_ocu)
svy: mean pob_mont_100 if dpto==21 , over(year_2 sec_ocu)

**POBREZA INTEGRADA
**TABLA 11:
svy: mean pobre_integra~1 , over( year_2 )
svy: mean pobre_integra~2 , over( year_2 )
svy: mean pobre_integra~3 , over( year_2 )
svy: mean pobre_integra~4 , over( year_2 )

svy: mean pobre_integra~1 if dpto==21 , over( year_2 )
svy: mean pobre_integra~2 if dpto==21 , over( year_2 )
svy: mean pobre_integra~3 if dpto==21 , over( year_2 )
svy: mean pobre_integra~4 if dpto==21 , over( year_2 )

**TABLA 12:
svy: mean pobre_integra~1 , over( year_2  area)
svy: mean pobre_integra~2 , over( year_2 area)
svy: mean pobre_integra~3 , over( year_2 area)
svy: mean pobre_integra~4 , over( year_2 area)

svy: mean pobre_integra~1 if dpto==21 , over( year_2 area)
svy: mean pobre_integra~2 if dpto==21 , over( year_2 area)
svy: mean pobre_integra~3 if dpto==21 , over( year_2 area)
svy: mean pobre_integra~4 if dpto==21 , over( year_2 area)

**TABLA 13:
svy: mean pobre_integra~1 , over( year_2 sex)
svy: mean pobre_integra~2 , over( year_2 sex)
svy: mean pobre_integra~3 , over( year_2 sex)
svy: mean pobre_integra~4 , over( year_2 sex)

svy: mean pobre_integra~1 if dpto==21 , over( year_2 sex)
svy: mean pobre_integra~2 if dpto==21 , over( year_2 sex)
svy: mean pobre_integra~3 if dpto==21 , over( year_2 sex)
svy: mean pobre_integra~4 if dpto==21 , over( year_2 sex)