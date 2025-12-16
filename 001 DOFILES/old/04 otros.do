

*Aplicando la prueba de promedios
ttest inc_total_, by(sex_) unequal

ttest pob_monetaria, by(urban_  ) unequal

tab educ_ , gen(D)
*luego regresionamos INGRESO=f(Ds-D9)
regre inc_total_ D2-D6


ssc install inequal2 
ssc install  lorenz
inequal2  inc_total_  
lorenz inc_total_, over(year) graph


/* xtile calcula los nq quintiles de la variable ingreso neto total (inghog2d), 
en este caso se pondera por el factor de expansión factor07. */
xtile quintiles_ing =  inghog2d_ [w=factor07], nq(5) 

table (quintiles_ing) (pob_monetaria)[iw=factor07]

table (quintiles_ing) (year) 

sum inghog2d1_ quintiles_ing inc_total_

