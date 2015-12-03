;;2015/11/24 Wowzers
;;At KSAT in Tromsø
PRO JOURNAL__20151124__HISTOPLOTS_OF_15_ION_FLUX_DURING_STORMPHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ION_FLUX
  
  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=15, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[4,11.5], $
     HISTYRANGE_MAXIND=[0,0.12], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     /ONLY_POS, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=15, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[4,11.5], $
     HISTYRANGE_MAXIND=[0,0.12], $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     /ONLY_POS, $
     PLOTTITLE='Dayside--black Nightside--red (Only positive vals)', $
     PLOTSUFFIX='dayside_black--nightside_red--only_pos', $
     /SAVEPLOT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

  ;;normalized dayside, neg
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=15, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[4,11.5], $
     HISTYRANGE_MAXIND=[0,0.12], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     /ONLY_NEG, $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr


  ;;normalized nightside, neg
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=15, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[4,11.5], $
     HISTYRANGE_MAXIND=[0,0.12], $
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