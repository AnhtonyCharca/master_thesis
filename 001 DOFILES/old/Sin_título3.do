clear all
set obs 101

local y 100
local p1 1
local p2 2

gen q1 = _n - 1

* Caso base
gen q2_base = (`y' - `p1'*q1)/`p2'

* Inflación en bien 2
local p2_new = 4
gen q2_infla = (`y' - `p1'*q1)/`p2_new'

twoway ///
(line q2_base q1, lcolor(blue)) ///
(line q2_infla q1, lcolor(red)) ///
, title("Efecto de Precios: Rotación de la Restricción Presupuestaria") ///
legend(order(1 "Precios base" 2 "Inflación bien 2"))
