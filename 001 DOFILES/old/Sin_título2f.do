clear all
set obs 1000

* Simular años de educación (H) y un ingreso asociado
set seed 12345
gen H = round(rnormal(10, 3))     // años de educación (media 10, sd 3)
replace H = max(0, H)             // sin negativos

* Modelo teórico de ingreso: I_h = 400 + 150*H + error
gen u = rnormal(0, 300)           // término de error
gen Ih = 400 + 150*H + u          // ingreso del hogar

label var H "Años de educación (H)"
label var Ih "Ingreso del hogar (I_h)"

* Regresión para mostrar la relación
reg Ih H

* Gráfico: dispersión + recta ajustada
twoway ///
    (scatter Ih H, msize(tiny)) ///
    (lfit Ih H, lwidth(medthick)) ///
    , ///
    title("Figura 2. Ingreso del hogar y capital humano") ///
    xtitle("Años de educación (H)") ///
    ytitle("Ingreso del hogar (I_h)") ///
    legend(off)
