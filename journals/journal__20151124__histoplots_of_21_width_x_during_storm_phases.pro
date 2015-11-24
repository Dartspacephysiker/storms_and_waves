;;2015/11/24 Wowzers
;;At KSAT in Tromsø
PRO JOURNAL__20151124__HISTOPLOTS_OF_21_WIDTH_X_DURING_STORM_PHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;WIDTH_X
  
  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=21, $
     HISTBINSIZE_MAXIND=0.125, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[2,4.5], $
     HISTYRANGE_MAXIND=[0,0.30], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     ;; /ONLY_POS, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=21, $
     HISTBINSIZE_MAXIND=0.125, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[2,4.5], $
     HISTYRANGE_MAXIND=[0,0.30], $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     ;; /ONLY_POS, $
     ;; PLOTTITLE='Dayside--black Nightside--red (Only positive vals)', $
     ;; PLOTSUFFIX='dayside_black--nightside_red--only_pos', $
     PLOTTITLE='Dayside--black Nightside--red', $
     PLOTSUFFIX='dayside_black--nightside_red', $
     /SAVEPLOT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

  ;;;;;;;;;;;;;;;;;;;;;;;;
  ;; ;;normalized dayside, neg
  ;; HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
  ;;    MAXIND=21, $
  ;;    HISTBINSIZE_MAXIND=0.125, $
  ;;    /USE_DARTDB_START_ENDDATE, $
  ;;    HISTXRANGE_MAXIND=[2,4.5], $
  ;;    HISTYRANGE_MAXIND=[0,0.30], $
  ;;    /LOG_DBQUANTITY, $
  ;;    /DAYSIDE, $
  ;;    /ONLY_NEG, $
  ;;    /NORMALIZE_MAXIND_HIST, $
  ;;    HISTOPLOT_PARAM_STRUCT=pHP, $
  ;;    CURRENT_WINDOW=window, $
  ;;    OUTPLOTARR=outplotArr

  ;; ;;normalized nightside, neg
  ;; HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
  ;;    MAXIND=21, $
  ;;    HISTBINSIZE_MAXIND=0.125, $
  ;;    /USE_DARTDB_START_ENDDATE, $
  ;;    HISTXRANGE_MAXIND=[2,4.5], $
  ;;    HISTYRANGE_MAXIND=[0,0.30], $
  ;;    /LOG_DBQUANTITY, $
  ;;    /NIGHTSIDE, $
  ;;    /ONLY_NEG, $
  ;;    /NORMALIZE_MAXIND_HIST, $
  ;;    PLOTTITLE='Dayside--black Nightside--red (Only negative vals)', $
  ;;    PLOTSUFFIX='dayside_black--nightside_red--only_neg', $
  ;;    /SAVEPLOT, $
  ;;    HISTOPLOT_PARAM_STRUCT=pHP, $
  ;;    CURRENT_WINDOW=window, $
  ;;    OUTPLOTARR=outplotArr, $
  ;;    PLOTCOLOR='RED', $
  ;;    /FILL_BACKGROUND

END