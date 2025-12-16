/*
BY: ALEX ANTONI QUISPE CHARCA
TEMA: POBREZA MONETARIA Y POBREZA INTEGRADA, panel 2020-2022
MASTER TESIS
UNIVERSIDAD NACIONAL DEL ALTIPLANO - PUNO

PARTE I: TABLA 2: Muestra comparativa nacional y de la región Puno, panel balanceado 2020-2022
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
rename depto dpto

*codebook

***elaboracion de la tabla 2: 
***###transversal:
tab year
tab year if dpto==21

***###panel (del modulo 100, panel=1)
tab year if panel==1
tab year if dpto==21 & panel==1

