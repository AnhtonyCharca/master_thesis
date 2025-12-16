*============================================================*
* 3. CURVAS 3D (CONTOUR) – Pr(Crónicos)
*    Perú – Panel 2020–2022
*============================================================*

* Contorno de probabilidad de ser crónico en espacio ingreso–tamaño del hogar
twoway contour phat1 log_inghog2d_ totmieho_ if e(sample), ///
    title("Perú 2020–2022: Pr(Crónicos) en ingreso–tamaño del hogar") ///
    xtitle("Logaritmo del ingreso del hogar") ///
    ytitle("Miembros del hogar") ///
    name(contour_PE2022_O1, replace)

* (Puedes repetir para phat2, phat3, phat4 si te interesa)
*============================================================*
* 4. TRAYECTORIAS PANEL – Pobreza integrada
*    Perú – Panel 2020–2022
*============================================================*

* Nos quedamos solo con hogares del panel 2020–2022
preserve
keep if hpan2022==1

* Asegurar que tenemos los tres años por hogar
bys idhogar: egen nyrs = nvals(year)
keep if nyrs==3

* Opción A: gráfico agregado de todas las trayectorias (puede verse denso)
xtset idhogar year
xtline pobre_integrada, overlay ///
    title("Trayectorias de pobreza integrada – Panel 2020–2022") ///
    xtitle("Año") ytitle("Categoría de pobreza integrada") ///
    name(tray_PE2022_all, replace)

* Opción B: muestra pequeña de hogares (por ejemplo 50) para que se vea mejor
preserve
bys idhogar: keep if _n==1   // un registro por hogar
sample 50, count
levelsof idhogar, local(lista_hogares)
restore

keep if inlist(idhogar, `lista_hogares')

xtset idhogar year
xtline pobre_integrada, overlay ///
    title("Trayectorias de pobreza integrada – Muestra de 50 hogares") ///
    xtitle("Año") ytitle("Categoría de pobreza integrada") ///
    name(tray_PE2022_muestra, replace)

restore
*============================================================*
* 5. CURVAS ROC – Perú
*    Usando phat# del modelo nacional MLOGIT_RE_PE_2022
*============================================================*

* Outcome 1 – Crónicos
lroc real1 phat1 if hpan2022==1, ///
    title("ROC – Crónicos, Perú 2020–2022") ///
    name(roc_PE2022_O1, replace)

* Outcome 2 – Estructurales
lroc real2 phat2 if hpan2022==1, ///
    title("ROC – Estructurales, Perú 2020–2022") ///
    name(roc_PE2022_O2, replace)

* Outcome 3 – Coyunturales
lroc real3 phat3 if hpan2022==1, ///
    title("ROC – Coyunturales, Perú 2020–2022") ///
    name(roc_PE2022_O3, replace)

* Outcome 4 – Integrados
lroc real4 phat4 if hpan2022==1, ///
    title("ROC – Integrados, Perú 2020–2022") ///
    name(roc_PE2022_O4, replace)
