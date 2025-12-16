clear all
set more off

*--------------------------
* 1. Parámetros del modelo
*--------------------------
local y 100     // ingreso
local p1 1
local p2 2
local U 40     // nivel de utilidad de la curva de indiferencia

*--------------------------
* 2. Restricción presupuestaria
*--------------------------
set obs 101
gen q1 = _n - 1

gen q2 = (`y' - `p1'*q1)/`p2'
drop if q2 < 0

label var q1 "Cantidad del bien 1 (q1)"
label var q2 "Cantidad del bien 2 (q2)"

*--------------------------
* 3. Curva de indiferencia (U = 40)
*    U = sqrt(q1)*sqrt(q2)  =>  q2 = (U/sqrt(q1))^2
*--------------------------
gen q2_u = .
replace q2_u = (`U'/sqrt(q1))^2 if q1>0 & !missing(q1)

* Nota: si q1 = 0, no se define sqrt(0) en el denominador, por eso el if q1>0

*--------------------------
* 4. Gráfico
*--------------------------
twoway ///
    (line q2 q1, lwidth(medthick)) ///
    (line q2_u q1 if q1>0, lpattern(dash) lwidth(medthick)) ///
    , ///
    title("Figura 1. Restricción presupuestaria y curva de indiferencia") ///
    xtitle("Bien 1 (q1)") ///
    ytitle("Bien 2 (q2)") ///
    legend(order(1 "Restricción presupuestaria" 2 "Curva de indiferencia U=40"))
