clear all
set obs 101
local p1 1
local p2 2

* Tres niveles de ingreso
local y1 60
local y2 100
local y3 140

gen q1 = _n - 1

gen q2_y1 = (`y1' - `p1'*q1)/`p2'
gen q2_y2 = (`y2' - `p1'*q1)/`p2'
gen q2_y3 = (`y3' - `p1'*q1)/`p2'

twoway ///
(line q2_y1 q1, lcolor(red)) ///
(line q2_y2 q1, lcolor(blue)) ///
(line q2_y3 q1, lcolor(green)) ///
, legend(order(1 "Pobreza severa" 2 "Ingreso base" 3 "Subsidio / mejora")) ytitle("Precio de 'X' (S/.)" ) xtitle("Cantidad del bien 'X'")

*title("Traslación de la restricción por cambios de ingreso") ///
