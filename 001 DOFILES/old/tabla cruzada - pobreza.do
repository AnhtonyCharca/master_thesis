***********************************************
***UNIVERSIDAD NACIONAL DEL ALTIPLANO**********
****FACULTAD DE INGENEIRIA ECONOMICA***********
****TABLA CRUZADA POBREZA MONETARIA************
****ADAPTADO POR: ALEX ANTONI QUISPE CHARCA****
***********************************************
clear all
clear matrix
set more off 

*******
global BASES "D:\data\stata"
global CUADROS "D:\programacionestadistica2021\clase7\cuadro"
global SINTAXIS "D:\programacionestadistica2021\clase7\sintaxis"
global anio1 "2004"
global anio2 "2005"
global anio3 "2006"
global anio4 "2007"
global anio5 "2008"
global anio6 "2009"
global anio7 "2010"
global anio8 "2011"
global anio9 "2012"
global anio10 "2013"
global anio11 "2014"
global anio12 "2015"
global anio13 "2016"
global anio14 "2017"
global anio15 "2018"
global anio16 "2019"


cd "${BASES}"
use "sumaria-${anio1}", clear
append using "sumaria-${anio2}"
append using "sumaria-${anio3}"
append using "sumaria-${anio4}"
append using "sumaria-${anio5}"
append using "sumaria-${anio6}"
append using "sumaria-${anio7}"
append using "sumaria-${anio8}"
append using "sumaria-${anio9}"
append using "sumaria-${anio10}"
append using "sumaria-${anio11}"
append using "sumaria-${anio12}"
append using "sumaria-${anio13}"
append using "sumaria-${anio14}"
append using "sumaria-${anio15}"
append using "sumaria-${anio16}"

 
sort aÑo 
egen id = group(aÑo) 


*Estimamos el gasto promedio mensual de los hogares en términos per capita (indicador de bienestar)
gen gpcm=gashog2d/(mieperho*12)

*Calculamos el factor de ponderación a nivel de la población
gen facpob=factor07*mieperho

*Contrastamos gpm con la linea de pobreza alimentaria (linpe) y pobreza total (linea)

gen pobre3=1 if gpcm < linpe
replace pobre3=2 if gpcm >= linpe & gpcm < linea
replace pobre3=3 if gpcm >= linea

*etiquetamos los valores de la variable

label define paz 1 "pobre_extremo" 2 "pobre_no_extremo" 3 "no_pobre"
label value pobre3 paz
label var pobre3 "Pobreza Monetaria"

gen pobre2=1 if gpcm < linea
replace pobre2=0 if gpcm >= linea
*Etiquetamos los valores de la variable

label define pobre2 1"pobre" 0"no_pobre"
label value pobre2 pobre2
label var pobre2 "Pobreza Monetaria"

**correr la sintaxis de cortes geograficos y politicos
do ${SINTAXIS}\cortesgeograficosypoliticos.do


**tablas 
tab  pobre2 id [iw=facpob] , nofreq col 
tab  dpto id [iw=facpob] if pobre2==1, nofreq col 

*asdoc tab  p107 id [iw=facpob] if pea==1,   replace
*asdoc tab  g_edad id [iw=facpob] if pea==1   
*asdoc tab  nivedu id [iw=facpob] if pea==1


*Abra el archivo de salida.
putexcel set "${CUADROS}\anexo2.xlsx", sheet("C1") replace     

*Cree la variable de número de fila local.
local rownum = 2

*Cree títulos generales y de columna.
*Escriba el título en la primera fila y escriba los títulos de las columnas con la configuración adecuada.


*txtwrap y notxtwrap especifican si el texto se ajustará o no en una celda o dentro de cada celda en un rango de celdas

putexcel A`rownum' = "CUADRO N°01", bold font(calibri, 12, black)

local rownum = `rownum' + 1
putexcel A`rownum':S`rownum'= "Perú: Evolución de la Incidencia de la pobreza monetaria total, según ámbito geográfico y político", merge left txtwrap font(calibri, 11, black)

local rownum = `rownum' + 1
putexcel A`rownum':S`rownum' = "Año: ${anio1} - ${anio16}", merge left vcenter txtwrap font(calibri, 11, black) 
local rownum = `rownum' + 1                                    
putexcel A`rownum':S`rownum' = "(Porcentaje respecto del total de población)", merge left vcenter txtwrap font(calibri, 11, black) border(bottom, medium, black)
local rownum = `rownum' + 1
local Rownum=`rownum'+1
putexcel A`rownum':C`Rownum' = "Ámbito", merge bold txtwrap vcenter hcenter font(calibri, 10, black) border(bottom, medium, black)

forvalues i=1/17 { 
local Cell = char(67 + `i')
local i=`i'
putexcel `Cell'`rownum':`Cell'`Rownum' = "${anio`i'}", merge bold txtwrap vcenter hcenter font(calibri, 10, black) border(bottom, medium, black)
local a=`rownum'-1
putexcel `Cell'`a':`Cell'`a',border("bottom", "medium", "black")  
}



*#####################EXPORTA PORCENTAJES############################
*##############Autor: Andrés Talavera Cuya########################### 


/*
xcontract pobre2 [pweight = facpob], by(id dpto) saving(filename,replace)
use filename,clear 
keep if pobre2==1
reshape wide _percent _freq, i(dpto) j(id)
drop _freq* pobre2*
mkmat dpto _percent*, mat(pobreza)
mat list pobreza
putexcel B8 = matrix(pobreza), names nformat(#,###.0) hcenter 
*/


/*
foreach x of varlist dominio1 { 
preserve  
xcontract pobre2 [pweight = facpob], by(id `x') saving(filename,replace)
use filename,clear 
keep if pobre2==1
reshape wide _percent _freq, i(`x') j(id)
drop _freq* pobre2*
mkmat `x' _percent*, mat(pobreza)
mat list pobreza
putexcel B8 = matrix(pobreza), names nformat(#,###.0) hcenter
restore 
}
*/
*#####################################################################


gen nacional=1
la var nacional "Nacional"
la def nacional 1 "Nacional"
la val nacional nacional
 
local Rownum=`Rownum'+2
foreach x of varlist nacional dominio1 dpto { 
preserve 
*extraer filas y columnas* 
tabulate  `x' id, matcell(x)
mat list x 
local RowCount = r(r)
local ColCount = r(c)
*** 					***
xcontract pobre2 [pweight = facpob], by(id `x') saving(filename,replace)
use filename,clear 
keep if pobre2==1
reshape wide _percent _freq, i(`x') j(id) 
mkmat _percent*, mat(pobreza)
mat list pobreza

        ***aquí pego la sintaxis (1) 
        forvalues row = 1/`RowCount' {
            forvalues col = 1/`ColCount' {
            local CellContents = pobreza[`row',`col']
            local Cell = char(67 + `col') + string(`row'+`Rownum')
            putexcel `Cell' = `CellContents',nformat(#,###.0) hcenter 
		                               
		 ****Aquí pego la sintaxis (2)						   
			local RowVar = "`x'"
               local RowValueLabel : value label `RowVar'
               levelsof `RowVar', local(RowLevels)
               local RowValueLabelNum = word("`RowLevels'", `row')
               local RowLabel : label `RowValueLabel' `RowValueLabelNum'
               local Cell = char(65) + string(`row'+`Rownum') 
			   putexcel `Cell'="`RowLabel'", font(calibri, 10, black) txtindent(1) 						   
									   
									  									   
									   
									   }
                                     }

***aquí pego la sintaxis (3)
local Cell = char(65) + string(`row'+`Rownum') 
local ColVarLabel : variable label `RowVar'                
putexcel `Cell' = "`ColVarLabel'", bold									 									 
        local Rownum=`Rownum'+`RowCount'+1
        local ++Rownum

restore
		
		}


mata
b = xl()
b.load_book("${CUADROS}\anexo2.xlsx")
b.set_sheet("C1")
b.set_column_width(1,20, 4) 
b.close_book()
end

*Escribe notas a pie de página.
putexcel A`Rownum':S`Rownum'= "1/.Lima incluye la prov. del Callao ", font(calibri, 10, black) nobold merge border(top, medium, black)
local Rownum=`Rownum'+1
putexcel A`Rownum' = "Fuente: Instituto Nacional de Estadística e Informática -Encuesta Nacional de Hogares.", font(calibri, 10, black) nobold

