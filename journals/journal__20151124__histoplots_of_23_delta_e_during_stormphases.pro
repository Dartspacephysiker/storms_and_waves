;;2015/11/24 Wowzers
;;At KSAT in Tromsø
PRO JOURNAL__20151124__HISTOPLOTS_OF_23_DELTA_E_DURING_STORMPHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DELTA_E
  
  ;;normalized dayside, pos and neg
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=23, $
     HISTBINSIZE_MAXIND=0.125, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0,4], $
     HISTYRANGE_MAXIND=[0,0.20], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=23, $
     HISTBINSIZE_MAXIND=0.125, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0,4], $
     HISTYRANGE_MAXIND=[0,0.20], $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     ;; PLOTSUFFIX='nightside', $
     PLOTTITLE='Dayside--black Nightside--red', $
     PLOTSUFFIX='dayside_black--nightside_red', $
     /SAVEPLOT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND



END