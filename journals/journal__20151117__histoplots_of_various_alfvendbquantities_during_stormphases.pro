
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ION_FLUX_UP
;counts
histoplot_alfvendbquantities_during_stormphases,MAXIND=16,HISTBINSIZE_MAXIND=0.25,/USE_DARTDB_START_ENDDATE,/LOG_DBQUANTITY,HISTYRANGE_MAXIND=[0,8500],HISTXRANGE_MAXIND=[4,10.5]
;normalized
histoplot_alfvendbquantities_during_stormphases,MAXIND=16,HISTBINSIZE_MAXIND=0.25,/USE_DARTDB_START_ENDDATE,/LOG_DBQUANTITY,HISTYRANGE_MAXIND=[0,0.15],HISTXRANGE_MAXIND=[4,10.5],/NORMALIZE_MAXIND_HIST,PLOTSUFFIX='all_MLT'

;normalized nightside
histoplot_alfvendbquantities_during_stormphases,MAXIND=16,HISTBINSIZE_MAXIND=0.25,/USE_DARTDB_START_ENDDATE,/LOG_DBQUANTITY,HISTYRANGE_MAXIND=[0,0.15],HISTXRANGE_MAXIND=[4,10.5],/NIGHTSIDE,/NORMALIZE_MAXIND_HIST,PLOTSUFFIX='nightside'

;normalized dayside
histoplot_alfvendbquantities_during_stormphases,MAXIND=16,HISTBINSIZE_MAXIND=0.25,/USE_DARTDB_START_ENDDATE,/LOG_DBQUANTITY,HISTYRANGE_MAXIND=[0,0.15],HISTXRANGE_MAXIND=[4,10.5],/DAYSIDE,/NORMALIZE_MAXIND_HIST,PLOTSUFFIX='dayside'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;INTEG_ION_FLUX_UP
;counts
histoplot_alfvendbquantities_during_stormphases,MAXIND=18,HISTBINSIZE_MAXIND=0.25,/USE_DARTDB_START_ENDDATE,/LOG_DBQUANTITY,HISTYRANGE_MAXIND=[0,8500] ;,HISTXRANGE_MAXIND=[4,10.5]
;normalized
histoplot_alfvendbquantities_during_stormphases,MAXIND=18,HISTBINSIZE_MAXIND=0.25,/USE_DARTDB_START_ENDDATE,/LOG_DBQUANTITY,HISTYRANGE_MAXIND=[0,0.15] ;,HISTXRANGE_MAXIND=[4,10.5],/NORMALIZE_MAXIND_HIST

;normalized nightside
histoplot_alfvendbquantities_during_stormphases,MAXIND=18,HISTBINSIZE_MAXIND=0.25,/USE_DARTDB_START_ENDDATE,/LOG_DBQUANTITY,HISTYRANGE_MAXIND=[0,0.15],HISTXRANGE_MAXIND=[4,10.5],/NIGHTSIDE,/NORMALIZE_MAXIND_HIST,PLOTSUFFIX='nightside'

;normalized dayside
histoplot_alfvendbquantities_during_stormphases,MAXIND=18,HISTBINSIZE_MAXIND=0.25,/USE_DARTDB_START_ENDDATE,/LOG_DBQUANTITY,HISTYRANGE_MAXIND=[0,0.15],HISTXRANGE_MAXIND=[4,10.5],/DAYSIDE,/NORMALIZE_MAXIND_HIST,PLOTSUFFIX='dayside'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;CHAR ION ENERGY
;counts
histoplot_alfvendbquantities_during_stormphases,MAXIND=19,HISTBINSIZE_MAXIND=2.0,/USE_DARTDB_START_ENDDATE,HISTXRANGE_MAXIND=[-500,500],HISTYRANGE_MAXIND=[0,10000]
;normalized
histoplot_alfvendbquantities_during_stormphases,MAXIND=19,HISTBINSIZE_MAXIND=5.0,/USE_DARTDB_START_ENDDATE,HISTXRANGE_MAXIND=[-50,250],/NORMALIZE_MAXIND_HIST

;normalized nightside
histoplot_alfvendbquantities_during_stormphases,MAXIND=19,HISTBINSIZE_MAXIND=2.0,/USE_DARTDB_START_ENDDATE,HISTXRANGE_MAXIND=[-50,250],HISTYRANGE_MAXIND=[0,0.11],/NIGHTSIDE,/NORMALIZE_MAXIND_HIST,PLOTSUFFIX='nightside'

;normalized dayside
histoplot_alfvendbquantities_during_stormphases,MAXIND=19,HISTBINSIZE_MAXIND=2.0,/USE_DARTDB_START_ENDDATE,HISTXRANGE_MAXIND=[-50,250],HISTYRANGE_MAXIND=[0,0.11],/DAYSIDE,/NORMALIZE_MAXIND_HIST,PLOTSUFFIX='dayside'
