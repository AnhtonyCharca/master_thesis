capture restore        // por si venías de un preserve previo
preserve

keep if $DEPVAR == 21
xtset idhogar year

* LOGIT RE – Puno, toda la data
xtlogit pob_monetaria $X_static , re vce(cluster idhogar) nolog
estimates store LOGIT_RE_PU_FULL

* Efectos marginales para el modelo RE – Puno
margins, dydx(*)
estimates store MARG_RE_PU_FULL

outreg2 [LOGIT_RE_PU_FULL] using "logit_re_pu_full.doc", ///
    word replace ctitle("Logit RE - Puno, toda la data 2018–2022") dec(3)

* LOGIT FE – Puno, toda la data
xtlogit pob_monetaria $X_static , fe
estimates store LOGIT_FE_PU_FULL

margins, dydx(*)
estimates store MARG_FE_PU_FULL

outreg2 [LOGIT_FE_PU_FULL] using "logit_fe_pu_full.doc", ///
    word replace ctitle("Logit FE - Puno, toda la data 2018–2022") dec(3)

	
	

	
restore

	gen es_pea_=(ocu500_==1)
	recode sec_ocu_ (. = 12)
	recode limitacion_ (. = 1)

	gen trab_informa=( ocupinf_ ==1)
	gen sec_agricola=(sec_ocu_==1)
	gen log_ingtr=log(inc_total_ )
	
sum pob_monetaria lw_ mieperho_ totmieho_ percepho_ ingmo2hd_ nbi1_ nbi2_ nbi3_ nbi4_ nbi5_ ag_pot_ enerlectr_ internet_ prop_viv_ tit_prop_ sunarp_ urban_ zone_ sex_ age_ g_edad_ ecivil_ educ_ sch_ analfa_ lengua_materna_ dic_segur_ limitacion_ croni_ morbilid_ dni_ es_pea trab_informa  sec_agricola act_empr_ race_    nativo_ vive_altura_ es_soltero_

*keep if $DEPVAR == 21
xtlogit pob_monetaria lwage_   totmieho_  internet_     if $DEPVAR == 21 , fe
xtlogit pob_monetaria lwage_   totmieho_  internet_     if $DEPVAR == 21 & hpan1822 == 1 , fe
xtlogit pob_monetaria lwage_   totmieho_  internet_ 	if $DEPVAR == 21 & hpan2022 == 1 , fe




xtprobit pob_monetaria lw_ mieperho_ totmieho_ percepho_ ingmo2hd_ nbi1_ nbi2_ nbi3_ nbi4_ nbi5_ ag_pot_ enerlectr_ internet_ prop_viv_ tit_prop_ sunarp_ urban_ zone_ sex_ age_ g_edad_ ecivil_ educ_ sch_ analfa_ lengua_materna_ dic_segur_ limitacion_ croni_ morbilid_ dni_ es_pea trab_informa  sec_agricola act_empr_ race_    nativo_ vive_altura_ es_soltero_
