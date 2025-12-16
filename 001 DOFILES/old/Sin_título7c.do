clear all
set more off

local y 100
local p1 1
local p2 2
local U 60

set obs 101
gen q1 = _n - 1

gen q2 = (`y' - `p1'*q1)/`p2'
drop if q2 < 0

gen q2_u = `U' - q1
drop if q2_u < 0

twoway ///
    (line q2 q1, lwidth(medthick)) ///
    (line q2_u q1, lpattern(dash) lwidth(medthick)) ///
    , ///
    title("Figura 1. Restricción presupuestaria y curva de indiferencia (lineal)") ///
    legend(order(1 "Restricción" 2 "Indiferencia U fija"))
