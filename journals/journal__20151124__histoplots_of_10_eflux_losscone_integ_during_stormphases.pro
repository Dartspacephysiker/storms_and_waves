;;2015/11/24 Wowzers
;;At KSAT in Tromsø
;; Looks like there are so few negs that it's not worth keeping them
;; I'm talking maybe 15 in total after screening.
PRO JOURNAL__20151124__HISTOPLOTS_OF_10_EFLUX_LOSSCONE_INTEG_DURING_STORMPHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;EFLUX_LOSSCONE_INTEG
  
  ;;normalized dayside, pos
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=10, $
     HISTBINSIZE_MAXIND=0.125, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0,6], $
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
     MAXIND=10, $
     HISTBINSIZE_MAXIND=0.125, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0,6], $
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

  ;;  .RESET_SESSION

  ;;normalized dayside, neg
  ;; HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
  ;;    MAXIND=10, $
  ;;    HISTBINSIZE_MAXIND=0.125, $
  ;;    /USE_DARTDB_START_ENDDATE, $
  ;;    HISTXRANGE_MAXIND=[0,6], $
  ;;    HISTYRANGE_MAXIND=[0,0.20], $
  ;;    /LOG_DBQUANTITY, $
  ;;    /DAYSIDE, $
  ;;    /ONLY_NEG, $
  ;;    /NORMALIZE_MAXIND_HIST, $
  ;;    HISTOPLOT_PARAM_STRUCT=pHP, $
  ;;    CURRENT_WINDOW=window, $
  ;;    OUTPLOTARR=outplotArr

  ;;normalized nightside, neg
  ;; HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
  ;;    MAXIND=10, $
  ;;    HISTBINSIZE_MAXIND=0.125, $
  ;;    /USE_DARTDB_START_ENDDATE, $
  ;;    HISTXRANGE_MAXIND=[0,6], $
  ;;    HISTYRANGE_MAXIND=[0,0.20], $
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