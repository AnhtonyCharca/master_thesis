svyset conglome_ [pweight = facpanel2022], strata(estrato_)
svy: mean pob_mont_100 , over(year_2)
svy: mean pobre_integradaX , over(year_2)


xtlogit pob_monetaria $X_static if hpan2022==1, re vce(cluster idhogar)
xtlogit pob_monetaria $X_static if hpan2022==1, fe
xtlogit pob_monetaria L.pob_monetaria $X_static if hpan2022==1, re
