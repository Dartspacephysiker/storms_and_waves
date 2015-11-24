;;2015/11/24 Wowzers
;;At KSAT in Tromsø
PRO JOURNAL__20151124__HISTOPLOTS_OF_18_INTEG_ION_FLUX_UP_DURING_STORMPHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;INTEG_ION_FLUX_UP
  
  ;;normalized dayside, pos
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=18, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[5.5,15], $
     HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     /ONLY_POS, $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside, pos
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=18, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[5.5,15], $
     HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     /ONLY_POS, $
     /NORMALIZE_MAXIND_HIST, $
     PLOTTITLE='Dayside--black Nightside--red (Only positive vals)', $
     PLOTSUFFIX='dayside_black--nightside_red--only_pos', $
     /SAVEPLOT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

  ;;;;;;;;;;;;;;;;;;;;;;;
  ;;normalized dayside, neg
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=18, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[5.5,15], $
     HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     /ONLY_NEG, $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside, neg
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=18, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[5.5,15], $
     HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     /ONLY_NEG, $
     /NORMALIZE_MAXIND_HIST, $
     PLOTTITLE='Dayside--black Nightside--red (Only negative vals)', $
     PLOTSUFFIX='dayside_black--nightside_red--only_neg', $
     /SAVEPLOT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

END