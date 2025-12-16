clear all
set obs 101

* Parámetros teóricos
local y 100      // ingreso
local p1 1      // precio bien 1
local p2 2      // precio bien 2

* Cantidad de bien 1 en el eje X
gen q1 = _n - 1

* Derivar la cantidad máxima de bien 2 compatible con el presupuesto:
* p1*q1 + p2*q2 = y  =>  q2 = (y - p1*q1)/p2
gen q2 = (`y' - `p1'*q1)/`p2'

* Mantener solo puntos no negativos
drop if q2 < 0

label var q1 "Cantidad del bien 1 (q1)"
label var q2 "Cantidad del bien 2 (q2)"

twoway ///
    (line q2 q1, lwidth(medthick)) ///
    , ///
    title("Figura 1. Restricción presupuestaria") ///
    xtitle("q1") ytitle("q2") ///
    legend(off)
