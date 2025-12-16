*==============================================================*
* BLOQUE: Pobreza integrada INEI + dummies + tablas a Word
*==============================================================*

*--------------------------------------------------------------*
* 0. Ajustar nombres de variables (si fuera necesario)
*--------------------------------------------------------------*
* Locales para fácil modificación:
local var_pmonet  pob_monetaria   // pobreza monetaria 0/1
local var_pnbi    NBI1_POBRE      // pobreza por NBI 0/1
local var_factor  facpob          // factor de expansión
local var_anio    anio            // año de encuesta
local var_urban   urban           // 1 urbano, 0 rural (opcional)

* Verificación rápida
tab ``var_pmonet''  , missing
tab ``var_pnbi''    , missing

*--------------------------------------------------------------*
* 1. Tipología de pobreza integrada (4 categorías)
*--------------------------------------------------------------*
capture drop pobre_integrado
gen pobre_integrado = .

* 1 = Socialmente integrado (no pobre monetario, no NBI)
replace pobre_integrado = 1 if ``var_pmonet''==0 & ``var_pnbi''==0

* 2 = Pobre coyuntural (pobre monetario, no NBI)
replace pobre_integrado = 2 if ``var_pmonet''==1 & ``var_pnbi''==0

* 3 = Pobre estructural (no pobre monetario, sí NBI)
replace pobre_integrado = 3 if ``var_pmonet''==0 & ``var_pnbi''==1

* 4 = Pobre crónico (pobre monetario y NBI)
replace pobre_integrado = 4 if ``var_pmonet''==1 & ``var_pnbi''==1

label define pob_inte ///
    1 "Socialmente integrado" ///
    2 "P. Coyuntural" ///
    3 "P. Estructural" ///
    4 "P. Crónico"

label values pobre_integrado pob_inte
label var pobre_integrado "Pobreza Integrada"

*--------------------------------------------------------------*
* 2. Dummies separadas por categoría (para análisis/gráficos)
*--------------------------------------------------------------*
capture drop integ_social pob_coyuntural pob_estructural pob_cronico

gen integ_social   = (pobre_integrado==1)
label var integ_social "Socialmente integrado (1=sí)"

gen pob_coyuntural = (pobre_integrado==2)
label var pob_coyuntural "P. Coyuntural (1=sí)"

gen pob_estructural = (pobre_integrado==3)
label var pob_estructural "P. Estructural (1=sí)"

gen pob_cronico    = (pobre_integrado==4)
label var pob_cronico "P. Crónico (1=sí)"

* Dummy global de pobreza integrada (1=pobre en alguna dimensión)
capture drop pobre_integrada
gen pobre_integrada = (``var_pmonet''==1 | ``var_pnbi''==1)
label var pobre_integrada "Pobreza integrada (1=pobre, 0=no pobre)"

*--------------------------------------------------------------*
* 3. Tablas de resumen (para revisión rápida en Stata)
*--------------------------------------------------------------*
display "Distribución de la pobreza integrada (4 categorías):"
tab pobre_integrado [iw= facpob]

display "Pobre vs no pobre integrado:"
tab pobre_integrada [iw= facpob]

*--------------------------------------------------------------*
* 4. Exportar tablas a Word con putdocx
*   (a) Tabla general de tipología
*   (b) Distribución por año
*   (c) Distribución por área urbano/rural (si existe)
*--------------------------------------------------------------*

*--------------------------------------------------------------*
* 4.a. Tabla general de tipología
*--------------------------------------------------------------*
table (pobre_integrado) ()  [iw=facpob], ///
    statistic(freq)      nformat("%12.0f") ///
    statistic(percent)   nformat("%6.2f") ///
      

putdocx begin
putdocx paragraph, style(Heading1)
putdocx text ("Tabla 1. Distribución de la pobreza integrada (total)")

putdocx table T1 = etable

putdocx save "pobreza_integrada_total.docx", replace
putdocx clear

*--------------------------------------------------------------*
* 4.b. Tabla por año (pobreza integrada binaria)
*--------------------------------------------------------------*
table ``var_anio'' , ///
    statistic(mean pobre_integrada) ///
    nformat(%6.3f)

putdocx begin
putdocx paragraph, style(Heading1)
putdocx text ("Tabla 2. Proporción de pobres integrados por año")

putdocx table T2 = etable

putdocx save "pobreza_integrada_por_anio.docx", replace
putdocx clear

*--------------------------------------------------------------*
* 4.c. Tabla por año y categoría integrada (si quieres más detalle)
*--------------------------------------------------------------*
table ``var_anio'' pobre_integrado [iw=``var_factor''], ///
    statistic(percent) ///
    nformat(%6.2f)

putdocx begin
putdocx paragraph, style(Heading1)
putdocx text ("Tabla 3. Distribución porcentual de la pobreza integrada por año y categoría")

putdocx table T3 = etable

putdocx save "pobreza_integrada_anio_categoria.docx", replace
putdocx clear

*--------------------------------------------------------------*
* 4.d. Tabla por área urbano/rural (opcional)
*--------------------------------------------------------------*
capture confirm variable ``var_urban''
if _rc==0 {
    table ``var_urban'' , ///
        statistic(mean integ_social) ///
        statistic(mean pob_coyuntural) ///
        statistic(mean pob_estructural) ///
        statistic(mean pob_cronico) ///
        nformat(%6.3f)

    putdocx begin
    putdocx paragraph, style(Heading1)
    putdocx text ("Tabla 4. Proporción de categorías de pobreza integrada por área urbano/rural")

    putdocx table T4 = etable

    putdocx save "pobreza_integrada_urban_rural.docx", replace
    putdocx clear
}

*==============================================================*
* FIN DEL BLOQUE
*==============================================================*
