*============================================================*
* 1. LOGIT RE – PERÚ 2018–2022 (modelo estático)
*============================================================*

* Asegura panel
xtset idhogar year

*------------------------------------------------------------*
* 1.1. Estimación del modelo RE
*------------------------------------------------------------*
xtlogit pob_monetaria lwage_ totmieho_ internet_, ///
    re vce(cluster idhogar) nolog

estimates store RE_PERU_FULL   // guardamos el modelo

*------------------------------------------------------------*
* 1.2. Efectos marginales (ME) de las X
*------------------------------------------------------------*
margins, dydx(lwage_ totmieho_ internet_) post
estimates store ME_RE_PERU_FULL

* (Aquí puedes exportar con outreg2/collect si quieres)
* p.ej.: outreg2 [ME_RE_PERU_FULL] using "me_re_peru_full.doc", replace

*------------------------------------------------------------*
* 1.3. Poder de predicción: AUC y matriz de clasificación
*     (usando ROC con probabilidad predicha)
*------------------------------------------------------------*

* Volvemos al modelo RE original (no el de margins)
estimates restore RE_PERU_FULL

* 1) Obtener el índice lineal y convertirlo a probabilidad
predict xb_re_pe, xb                 // índice lineal (log-odds)
gen phat_re_pe = invlogit(xb_re_pe)  // probabilidad Pr(y=1|X)

* 2) Curva ROC y AUC
*    Nota: no uses ", detail" porque puede dar error de labels.
roctab pob_monetaria phat_re_pe

* 3) Matriz de clasificación con corte 0.5
gen yhat_re_pe = (phat_re_pe >= 0.5)

tab pob_monetaria yhat_re_pe, row col

* Con esta tabla ves:
* - Sensibilidad: Pr(yhat=1 | y=1)
* - Especificidad: Pr(yhat=0 | y=0)
* - Exactitud global: (correctos / total)
