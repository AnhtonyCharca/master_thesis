****GRAFICOS:

*POBREZA MONETARIA


	#delimit ;
graph 	bar (mean) pob_mont_100 
			(mean) pob_mont_puno_100 
			[pweight = facpanel2022]
			, 
			over(year) 
			bar(1, fcolor(pink) lcolor(pink)) 
			bar(2, fcolor(midblue) lcolor(midblue))
				blabel(	bar, size(medlarge) 
						format(%3.1f) 
						justification(center) 
						alignment(top)
						) 
				ytitle("Porcentaje (%)" , size(medlarge)) 
				legend(	on order(
							1 "Perú"
							2 "Puno" ) 
						cols(2) 
						position(6)
						) 
				clegend(on) 
				name(graph_001, replace) 
				xsize(5) 
				ysize(2.8)
	;
#delimit cr

graph export "$graficos\Graph_001.jpg", as(png) name("Graph_001") quality(100) replace


xtline lwage_
