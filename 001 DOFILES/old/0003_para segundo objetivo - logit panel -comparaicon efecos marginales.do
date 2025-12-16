***************************************************************
* COMPARACIÓN – SOLO dy/dx FE vs RE
***************************************************************

* 1. LOGIT RE
xtlogit pob_monetaria $X_static2, re vce(cluster idhogar) nolog
margins, dydx(*) predict(pr) post

collect clear
collect get margins, tags(model[RE])

* 2. LOGIT FE
xtlogit pob_monetaria $X_static2, fe nolog
margins, dydx(*) post

collect get margins, tags(model[FE])

* 3. Etiquetas y formato
collect label dim model "Modelo"
collect label levels model RE "Logit RE" FE "Logit FE"

collect label levels result ///
    _r_b  "dy/dx" ///
    _r_se "Error estándar" ///
    _r_z  "z" ///
    _r_p  "p-valor"

collect style cell result[_r_b],  nformat(%9.4f)

* 4. Layout: filas = variables, columnas = modelos (solo dy/dx)
collect layout (colname) (model#result[_r_b])

* 5. Exportar
collect export "margins_logit_fe_re_peru_2018_2022_dx_only.docx", replace
