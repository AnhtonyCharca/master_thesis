***************************************
****###   0. Directorios  		###****
***************************************
clear all
set more off

*************************************
****** DIRECTORIOS DE TRABAJO *******
*************************************
glo mod01      "F:\ENAHO\001 BASES\PANEL\001 car_vivien_hogar"
glo mod02      "F:\ENAHO\001 BASES\PANEL\002 car_mhogar"
glo mod03      "F:\ENAHO\001 BASES\PANEL\003 educacion"
glo mod04      "F:\ENAHO\001 BASES\PANEL\004 salud"
glo mod05      "F:\ENAHO\001 BASES\PANEL\005 empleo_ingresos"
glo mod06      "F:\ENAHO\001 BASES\PANEL\034 sumarias"

*glo maestria   "C:\Users\CI-EPG-THONY\OneDrive\MI TESIS EPG MASTER\MAESTRIA\002 BASE DE DATOS"
glo maestria  	"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA\002 BASE DE DATOS"
glo tempo      "$maestria\001 TEMP"
glo dclea      "$maestria\002 CLEAN"
glo dofil      "$maestria\001 DOFILES"
glo tabyfig		"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA\005 TABLAS Y CUADROS"
glo graficos		"C:\Users\HP\OneDrive\MI TESIS EPG MASTER\MAESTRIA\008 GRAFICOS"

cd "$graficos"
************************************************************
* DO-FILE: Modelos logit panel de pobreza monetaria
* Perú y Puno – Toda la data (2018–2022) y paneles puros
************************************************************
*-----------------------------------------------------------*
* 0. CARGA DE BASE Y CONFIGURACIÓN GENERAL
*-----------------------------------------------------------*

use "$dclea/pobreza_panel_18-22_full.dta", clear

rename pobre2_ pob_monetaria   // si aún no lo hiciste
label define lbl_pobmon 0 "No pobre" 1 "Pobre", replace
label values pob_monetaria lbl_pobmon

gen nativo_=(race_==3)
gen vive_altura_ = (zone_==2)
gen es_soltero_=(ecivil_==1)
gen es_pea_=(ocu500_==1)
	recode sec_ocu_ (. = 12)
	recode limitacion_ (. = 1)

	gen trab_informa=( ocupinf_ ==1)
	gen sec_agricola=(sec_ocu_==1)
gen es_casado=(ecivil_ ==2)	
gen log_inghog2d_=log(inghog2d_)


* Variable dependiente (si fuera necesario renombrar)
capture confirm variable pob_monetaria
if _rc {
    capture rename pobre2_ pob_monetaria
}

* Identificar variable de departamento (dpto_ o depto)
capture confirm variable dpto_
if _rc==0 {
    global DEPVAR dpto_
}
else {
    capture confirm variable depto
    if _rc==0 global DEPVAR depto
}


*----------------------------------------------------*
* 0. Configuración previa                            *
*----------------------------------------------------*
xtset idhogar year
global X_static log_inghog2d_ totmieho_ internet_ es_casado es_pea_ trab_informa

* Asegurarse de tener Lpobre creado
capture confirm variable Lpobre
if _rc {
    gen Lpobre = L.pob_monetaria
}

******************************************************
* FIGURA 1. Probabilidad de pobreza según ingreso    *
*           Perú – Panel 2020–2022                   *
******************************************************
xtlogit pob_monetaria Lpobre $X_static if hpan2022==1, re vce(cluster idhogar) nolog

margins, at(log_inghog2d_ = (4(1)13)) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Panel 2020–2022") ///
    name(fig1_pe_ing_PeP2022, replace)

margins, at(totmieho_  = (1(1.25)21)) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Tamaño del hogar (Total de personas)") ///
    title("Perú: Panel 2020–2022") ///
    name(fig2_pe_totmi_PeP2022, replace)	
	
****Probabilidad de pobreza según ingreso y pobreza rezagada (Perú)
* Predicciones variando ingreso (4 a 9) y estado de pobreza previa (0/1)
margins, at(Lpobre = (0 1) log_inghog2d_ = (4(1)13)) atmeans
marginsplot, ///
    recast(connected) ///
    plotdimension(Lpobre) ///
    noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Panel 2020–2022") ///
    legend(order(1 "No pobre t-1" 2 "Pobre t-1") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig3_pe_Lpobre_PeP2022, replace)

	
margins, at(log_inghog2d_ = (4(1)13)) over(internet) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Panel 2020–2022") ///
    legend(order(1 "Sin internet (0)" 2 "Con internet (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig4_pe_internet_PeP2022, replace)
	
margins, at(log_inghog2d_ = (4(1)13)) over(es_casado) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Panel 2020–2022") ///
    legend(order(1 "Est. civil: Otro (0)" 2 "Est. civil: Casado (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig5_pe_casado_PeP2022, replace)	
	
margins, at(log_inghog2d_ = (4(1)13)) over(es_pea_) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Panel 2020–2022") ///
    legend(order(1 "No es PEA (0)" 2 "Si es PEA (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig6_pe_pea_PeP2022, replace)		
	
margins, at(log_inghog2d_ = (4(1)13)) over(trab_informa ) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Panel 2020–2022") ///
    legend(order(1 "No Informal (0)" 2 "Si es Informal (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig7_pe_trab_informa_PeP2022, replace)		
	
**************************************************************
* FIGURA 2. Probabilidad de pobreza según ingreso           *
*           Perú – Pseudo-panel 2018–2022                    *
**************************************************************
xtlogit pob_monetaria Lpobre $X_static, re vce(cluster idhogar) nolog

margins, at(log_inghog2d_ = (4(1)13)) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Pseudo-panel 2018–2022") ///
    name(fig1_pe_ing_PeSP1822, replace)

margins, at(totmieho_  = (1(1.25)18)) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Tamaño del hogar (Total de personas)") ///
    title("Perú: Pseudo-panel 2018–2022") ///
    name(fig2_pe_totmi_PeSP1822, replace)	
	
****Probabilidad de pobreza según ingreso y pobreza rezagada (Perú)
* Predicciones variando ingreso (4 a 9) y estado de pobreza previa (0/1)
margins, at(Lpobre = (0 1) log_inghog2d_ = (4(1)13)) atmeans
marginsplot, ///
    recast(connected) ///
    plotdimension(Lpobre) ///
    noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Pseudo-panel 2018–2022") ///
    legend(order(1 "No pobre t-1" 2 "Pobre t-1") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig3_pe_Lpobre_PeSP1822, replace)

	
margins, at(log_inghog2d_ = (4(1)13)) over(internet) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Pseudo-panel 2018–2022") ///
    legend(order(1 "Sin internet (0)" 2 "Con internet (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig4_pe_internet_PeSP1822, replace)
	
margins, at(log_inghog2d_ = (4(1)13)) over(es_casado) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Pseudo-panel 2018–2022") ///
    legend(order(1 "Est. civil: Otro (0)" 2 "Est. civil: Casado (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig5_pe_casado_PeSP1822, replace)	
	
margins, at(log_inghog2d_ = (4(1)13)) over(es_pea_) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Pseudo-panel 2018–2022") ///
    legend(order(1 "No es PEA (0)" 2 "Si es PEA (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig6_pe_pea_PeSP1822, replace)		
	
margins, at(log_inghog2d_ = (4(1)13)) over(trab_informa ) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Perú: Pseudo-panel 2018–2022") ///
    legend(order(1 "No Informal (0)" 2 "Si es Informal (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig7_pe_trab_informa_PeSP1822, replace)		

**************************************************************
* FIGURA 3. Probabilidad de pobreza según ingreso           *
*           Puno – Panel 2020–2022                          *
**************************************************************
xtlogit pob_monetaria Lpobre $X_static if hpan2022==1 & dpto_==21, ///
    re vce(cluster idhogar) nolog

margins, at(log_inghog2d_ = (4(1)13)) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Panel 2020–2022") ///
    name(fig1_pu_ing_PuP2022, replace)

margins, at(totmieho_  = (1(1.25)21)) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Tamaño del hogar (Total de personas)") ///
    title("Puno: Panel 2020–2022") ///
    name(fig2_pu_totmi_PuP2022, replace)	
	
****Probabilidad de pobreza según ingreso y pobreza rezagada (Perú)
* Predicciones variando ingreso (4 a 9) y estado de pobreza previa (0/1)
margins, at(Lpobre = (0 1) log_inghog2d_ = (4(1)13)) atmeans
marginsplot, ///
    recast(connected) ///
    plotdimension(Lpobre) ///
    noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
   title("Puno: Panel 2020–2022") ///
    legend(order(1 "No pobre t-1" 2 "Pobre t-1") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig3_pu_Lpobre_PuP2022, replace)

	
margins, at(log_inghog2d_ = (4(1)13)) over(internet) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
   title("Puno: Panel 2020–2022") ///
    legend(order(1 "Sin internet (0)" 2 "Con internet (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig4_pu_internet_PuP2022, replace)
	
margins, at(log_inghog2d_ = (4(1)13)) over(es_casado) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Panel 2020–2022") ///
    legend(order(1 "Est. civil: Otro (0)" 2 "Est. civil: Casado (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig5_pu_casado_PuP2022, replace)	
	
margins, at(log_inghog2d_ = (4(1)13)) over(es_pea_) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Panel 2020–2022") ///
    legend(order(1 "No es PEA (0)" 2 "Si es PEA (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig6_pu_pea_PuP2022, replace)		

margins, at(log_inghog2d_ = (4(1)13)) over(trab_informa ) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Panel 2020–2022") ///
    legend(order(1 "No Informal (0)" 2 "Si es Informal (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig7_pu_trab_informa_PuP2022, replace)	
**************************************************************
* FIGURA 4. Probabilidad de pobreza según ingreso           *
*           Puno – Pseudo-panel 2018–2022                   *
**************************************************************
xtlogit pob_monetaria Lpobre $X_static if dpto_==21, ///
    re vce(cluster idhogar) nolog

margins, at(log_inghog2d_ = (4(1)13)) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Pseudo-panel 2018–2022") ///
    name(fig1_pu_ing_PuSP1822, replace)

margins, at(totmieho_  = (1(1.25)18)) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Tamaño del hogar (Total de personas)") ///
    title("Puno: Pseudo-panel 2018–2022") ///
    name(fig2_pu_totmi_PuSP1822, replace)	
	
****Probabilidad de pobreza según ingreso y pobreza rezagada (Perú)
* Predicciones variando ingreso (4 a 9) y estado de pobreza previa (0/1)
margins, at(Lpobre = (0 1) log_inghog2d_ = (4(1)13)) atmeans
marginsplot, ///
    recast(connected) ///
    plotdimension(Lpobre) ///
    noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Pseudo-panel 2018–2022") ///
    legend(order(1 "No pobre t-1" 2 "Pobre t-1") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig3_pu_Lpobre_PuSP1822, replace)

	
margins, at(log_inghog2d_ = (4(1)13)) over(internet) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Pseudo-panel 2018–2022") ///
    legend(order(1 "Sin internet (0)" 2 "Con internet (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig4_pu_internet_PuSP1822, replace)
	
margins, at(log_inghog2d_ = (4(1)13)) over(es_casado) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Pseudo-panel 2018–2022") ///
    legend(order(1 "Est. civil: Otro (0)" 2 "Est. civil: Casado (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig5_pu_casado_PuSP1822, replace)	
	
margins, at(log_inghog2d_ = (4(1)13)) over(es_pea_) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Pseudo-panel 2018–2022") ///
    legend(order(1 "No es PEA (0)" 2 "Si es PEA (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig6_pu_pea_PuSP1822, replace)		
	
	
margins, at(log_inghog2d_ = (4(1)13)) over(trab_informa ) atmeans
marginsplot, ///
    recast(connected) noci ///
    ytitle("Pr(Pobreza monetaria = 1)") ///
    xtitle("Ingreso neto del hogar (En logaritmos)") ///
    title("Puno: Pseudo-panel 2018–2022") ///
    legend(order(1 "No Informal (0)" 2 "Si es Informal (1)") ///
           region(lcolor(none) fcolor(none)) ///
           pos(11) ring(0) bplacement(sw)) ///
    name(fig7_pu_trab_informa_PuSP1822, replace)	
*****************************************************************
* PANEL A: Comparar Perú vs Puno y periodos (Ingreso vs pobreza) *
*****************************************************************
cd "$graficos"
graph combine ///
    fig1_pe_ing_PeP2022 ///
    fig1_pu_ing_PuP2022 ///
	fig1_pe_ing_PeSP1822 ///
    fig1_pu_ing_PuSP1822, ///
    col(2)  ///
	name(fig1_ing_all, replace)
	graph export "fig1_ing_all.png", as(png) name("fig1_ing_all") replace
	
graph combine ///
    fig2_pe_totmi_PeP2022 ///
    fig2_pu_totmi_PuP2022 ///
	fig2_pe_totmi_PeSP1822 ///
    fig2_pu_totmi_PuSP1822, ///
    col(2)  ///
	name(fig2_totmi_all, replace)		
	graph export "fig2_totmi_all.png", as(png) name("fig2_totmi_all") replace
	
graph combine ///
    fig3_pe_Lpobre_PeP2022 ///
    fig3_pu_Lpobre_PuP2022 ///
	fig3_pe_Lpobre_PeSP1822 ///
    fig3_pu_Lpobre_PuSP1822, ///
    col(2)  ///
	name(fig3_totmi_all, replace)	
	graph export "fig3_totmi_all.png", as(png) name("fig3_totmi_all") replace
	
graph combine ///
    fig4_pe_internet_PeP2022 ///
    fig4_pu_internet_PuP2022 ///
	fig4_pe_internet_PeSP1822 ///
    fig4_pu_internet_PuSP1822, ///
    col(2)  ///
	graphregion(color(white)) ///
    imargin(zero) ///
    iscale(*1.2) ///
	name(fig4_internet_all, replace)	
	graph export "fig4_internet_all.png", as(png) name("fig4_internet_all") replace

graph combine ///
    fig5_pe_casado_PeP2022 ///
    fig5_pu_casado_PuP2022 ///
	fig5_pe_casado_PeSP1822 ///
    fig5_pu_casado_PuSP1822, ///
    col(2)  ///
	graphregion(color(white)) ///
    imargin(zero) ///
    iscale(*1.2) ///
	name(fig5_casado_all, replace)	
	graph export "fig5_casado_all.png", as(png) name("fig5_casado_all") replace
	
graph combine ///
    fig6_pe_pea_PeP2022 ///
    fig6_pu_pea_PuP2022 ///
	fig6_pe_pea_PeSP1822 ///
    fig6_pu_pea_PuSP1822, ///
    col(2)  ///
	graphregion(color(white)) ///
    imargin(zero) ///
    iscale(*1.2) ///
	name(fig6_pea_all, replace)	
	graph export "fig6_pea_all.png", as(png) name("fig6_pea_all") replace
	
	
graph combine ///
    fig7_pe_trab_informa_PeP2022 ///
    fig7_pu_trab_informa_PuP2022 ///
	fig7_pe_trab_informa_PeSP1822 ///
    fig7_pu_trab_informa_PuSP1822, ///
    col(2)  ///
	graphregion(color(white)) ///
    imargin(zero) ///
    iscale(*1.2) ///
	name(fig7_informa_all, replace)	
	graph export "fig7_trab_informa_all.png", as(png) name("fig7_trab_informa_all") replace
	
	
	