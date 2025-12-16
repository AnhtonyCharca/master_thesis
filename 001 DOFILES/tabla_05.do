/*
BY: ALEX ANTONI QUISPE CHARCA
TEMA: POBREZA MONETARIA Y POBREZA INTEGRADA, panel 2020-2022
MASTER TESIS
UNIVERSIDAD NACIONAL DEL ALTIPLANO - PUNO

PARTE I: RESULTADOS OBJETIVO ESPECIFICO 01 - tablas con collect 
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
******* POBREZA MONETARIA
**TABLA 04:
svy: mean pob_mont_100 , over(year_2)
svy: mean pob_mont_100 if dpto==21 , over(year_2)


***1. Estimar pobreza monetaria Perú vs Puno, 2020–2022
* Mantener solo los años 2020–2022
preserve
keep if inlist(year_2, 2020, 2021, 2022)

* Scalars para guardar los promedios
tempname Peru2020 Peru2021 Peru2022 Puno2020 Puno2021 Puno2022

foreach y in 2020 2021 2022 {
    * Perú (total)
    svy: mean pob_mont_100 if year_2==`y'
    scalar Peru`y' = _b[pob_mont_100]

    * Puno
    svy: mean pob_mont_100 if dpto==21 & year_2==`y'
    scalar Puno`y' = _b[pob_mont_100]
}

*2. Calcular brechas y variaciones porcentuales (∆%)

* Brechas (Puno - Perú)
scalar Brecha2020 = Puno2020 - Peru2020
scalar Brecha2021 = Puno2021 - Peru2021
scalar Brecha2022 = Puno2022 - Peru2022

* Variación porcentual respecto a 2020 (Perú y Puno)
scalar dPeru2020  = .
scalar dPeru2021  = 100*(Peru2021 - Peru2020)/Peru2020
scalar dPeru2022  = 100*(Peru2022 - Peru2020)/Peru2020

scalar dPuno2020  = .
scalar dPuno2021  = 100*(Puno2021 - Puno2020)/Puno2020
scalar dPuno2022  = 100*(Puno2022 - Puno2020)/Puno2020

* Promedios "Total 2020–2022"
scalar PeruTot   = (Peru2020 + Peru2021 + Peru2022)/3
scalar PunoTot   = (Puno2020 + Puno2021 + Puno2022)/3
scalar BrechaTot = (Brecha2020 + Brecha2021 + Brecha2022)/3

* Variación total 2020–2022 (respecto a 2020)
scalar dPeruTot  = 100*(Peru2022 - Peru2020)/Peru2020
scalar dPunoTot  = 100*(Puno2022 - Puno2020)/Puno2020


*3. Construir el dataset "Tabla 5"
* Dataset con 4 filas: 2020, 2021, 2022, Total
clear
set obs 4

gen anio = .
replace anio = 2020 in 1
replace anio = 2021 in 2
replace anio = 2022 in 3
replace anio = 9999 in 4   // usaremos 9999 como "Total"

label define anio_lab 2020 "2020" 2021 "2021" 2022 "2022" 9999 "Total"
label values anio anio_lab

gen peru    = .
gen puno    = .
gen brecha  = .
gen dperu   = .
gen dpuno   = .

* Asignar valores por año
replace peru   = Peru2020   in 1
replace puno   = Puno2020   in 1
replace brecha = Brecha2020 in 1
replace dperu  = dPeru2020  in 1
replace dpuno  = dPuno2020  in 1

replace peru   = Peru2021   in 2
replace puno   = Puno2021   in 2
replace brecha = Brecha2021 in 2
replace dperu  = dPeru2021  in 2
replace dpuno  = dPuno2021  in 2

replace peru   = Peru2022   in 3
replace puno   = Puno2022   in 3
replace brecha = Brecha2022 in 3
replace dperu  = dPeru2022  in 3
replace dpuno  = dPuno2022  in 3

* Fila Total (promedios y variación total 2020–2022)
replace peru   = PeruTot    in 4
replace puno   = PunoTot    in 4
replace brecha = BrechaTot  in 4
replace dperu  = dPeruTot   in 4
replace dpuno  = dPunoTot   in 4

label var anio   "Año"
label var peru   "Perú"
label var puno   "Puno"
label var brecha "Brecha (Puno - Perú)"
label var dperu  "Δ% Perú"
label var dpuno  "Δ% Puno"

* Formato de una decimal
format peru puno brecha dperu dpuno %6.1f

*En este punto puedes ver la tabla en Stata:
list, noobs sepby(anio)


list anio peru puno brecha dperu dpuno, noobs
asdoc list anio peru puno brecha dperu dpuno,     save(Tabla5_pobreza_monetaria_Peru_Puno_2020_2022.docx) replace     title(Tabla 5. Evolucion de la pobreza monetaria de los hogares del Peru y Puno, 2020-2022)





/* 4. Exportar la tabla al Word con putdocx (Stata 18)
putdocx clear
putdocx begin

putdocx paragraph, style(Heading1)
putdocx text("Tabla 5")


* Primera fila: cabeceras de grupos
putdocx table t1 = (5,6)

putdocx table t1(1,1) = ("Anio")
putdocx table t1(1,2) = ("Pobreza monetaria (en %)")
putdocx table t1(1,5) = ("Variación porcentual (Δ%)")

putdocx table t1(1,2), colspan(3)
putdocx table t1(1,5), colspan(2)

putdocx table t1(2,2) = ("Perú")
putdocx table t1(2,3) = ("Puno")
putdocx table t1(2,4) = ("Brecha")
putdocx table t1(2,5) = ("Perú")
putdocx table t1(2,6) = ("Puno")

forvalues i = 1/4 {
    local r = `i' + 2
    putdocx table t1(`r',1) = (anio[`i'])
    putdocx table t1(`r',2) = (peru[`i'])
    putdocx table t1(`r',3) = (puno[`i'])
    putdocx table t1(`r',4) = (brecha[`i'])
    putdocx table t1(`r',5) = (dperu[`i'])
    putdocx table t1(`r',6) = (dpuno[`i'])
}

putdocx paragraph
putdocx text("Nota. Δ% es la variación porcentual respecto al año 2020. Valores 'Total' corresponden al promedio 2020-2022 y la variación total entre 2020 y 2022. Elaborado con microdatos de la ENAHO 2020-2022 (INEI).")

putdocx save "Tabla5_pobreza_monetaria_Peru_Puno_2020_2022.docx", replace*/
