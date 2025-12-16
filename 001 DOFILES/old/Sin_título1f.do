clear all
set obs 1000
set seed 13579

* Ingreso inicial I_t
gen It = runiform()*2000    // ingresos entre 0 y 2000

* Definir un umbral de activos/ingreso (aprox)
local threshold = 800

* Dinámica: si It < threshold -> crecimiento casi nulo
*          si It >= threshold -> crecimiento mayor
gen eps = rnormal(0, 50)

gen It1 = .
replace It1 = It + 0.05*It + eps if It >= `threshold'
replace It1 = It + 0.005*It + eps if It <  `threshold'

label var It  "Ingreso actual I_t"
label var It1 "Ingreso futuro I_{t+1}"

twoway ///
    (scatter It1 It, msize(vtiny)) ///
    (function y = x, range(0 2000) lpattern(dash)) ///
    , ///
    title("Figura 3. Dinámica ingreso actual–futuro y trampa de pobreza") ///
    xtitle("Ingreso actual I_t") ///
    ytitle("Ingreso futuro I_{t+1}") ///
    legend(off)
