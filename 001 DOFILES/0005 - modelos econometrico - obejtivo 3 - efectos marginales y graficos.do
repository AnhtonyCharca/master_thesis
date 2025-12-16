*============================================================*
* 1. RESTAURAR MODELO Y GENERAR PROBABILIDADES
*    Perú – Panel 2020–2022
*============================================================*

* Modelo multinomial RE ya estimado
estimates restore MLOGIT_RE_PE_2022

* Probabilidades predichas por categoría
capture drop phat1 phat2 phat3 phat4
predict phat1, outcome(1)   // Crónicos
predict phat2, outcome(2)   // Estructurales
predict phat3, outcome(3)   // Coyunturales
predict phat4, outcome(4)   // Integrados

label var phat1 "Pr(Crónicos)"
label var phat2 "Pr(Estructurales)"
label var phat3 "Pr(Coyunturales)"
label var phat4 "Pr(Integrados)"

* Dummies reales para ROC
capture drop real1 real2 real3 real4
gen byte real1 = (pobre_integrada==1)
gen byte real2 = (pobre_integrada==2)
gen byte real3 = (pobre_integrada==3)
gen byte real4 = (pobre_integrada==4)


*============================================================*
* 2. GRAFICOS: EFECTOS MARGINALES SEGÚN INGRESO
*    Perú – Panel 2020–2022
*============================================================*

* Rango de la variable de ingreso en la muestra del modelo
summ log_inghog2d_ if e(sample), meanonly
local xmin = r(min)
local xmax = r(max)

* Se usa una secuencia simple, por ejemplo de xmin a xmax cada 0.25
* Puedes cambiar el paso si quieres más o menos puntos
margins, at(log_inghog2d_ = (`xmin'(0.25)`xmax')) predict(outcome(1))
marginsplot, recast(line) ///
    title("Perú 2020–2022: Pr(Crónicos) según ingreso") ///
    ytitle("Probabilidad predicha") ///
    xtitle("Logaritmo del ingreso del hogar") ///
    name(marg_PE2022_O1, replace)

margins, at(log_inghog2d_ = (`xmin'(0.25)`xmax')) predict(outcome(2))
marginsplot, recast(line) ///
    title("Perú 2020–2022: Pr(Estructurales) según ingreso") ///
    ytitle("Probabilidad predicha") ///
    xtitle("Logaritmo del ingreso del hogar") ///
    name(marg_PE2022_O2, replace)

margins, at(log_inghog2d_ = (`xmin'(0.25)`xmax')) predict(outcome(3))
marginsplot, recast(line) ///
    title("Perú 2020–2022: Pr(Coyunturales) según ingreso") ///
    ytitle("Probabilidad predicha") ///
    xtitle("Logaritmo del ingreso del hogar") ///
    name(marg_PE2022_O3, replace)

margins, at(log_inghog2d_ = (`xmin'(0.25)`xmax')) predict(outcome(4))
marginsplot, recast(line) ///
    title("Perú 2020–2022: Pr(Integrados) según ingreso") ///
    ytitle("Probabilidad predicha") ///
    xtitle("Logaritmo del ingreso del hogar") ///
    name(marg_PE2022_O4, replace)
