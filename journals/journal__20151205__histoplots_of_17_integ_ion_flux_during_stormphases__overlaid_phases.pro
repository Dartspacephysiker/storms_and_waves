;;2015/12/05 Wowzers
;;Back at Dartmouth getting ready for AGU 2015
PRO JOURNAL__20151205__HISTOPLOTS_OF_17_INTEG_ION_FLUX_DURING_STORMPHASES__OVERLAID_PHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;INTEG_ION_FLUX
  
  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=17, $
     ;; HISTBINSIZE_MAXIND=0.125, $
     HISTBINSIZE_MAXIND=0.20, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE='Dayside', $
     HISTXRANGE_MAXIND=[6,15], $
     HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     LAYOUT=[2,1,1], $
     /NORMALIZE_MAXIND_HIST, $
     /ONLY_POS, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=17, $
     HISTBINSIZE_MAXIND=0.20, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE='Nightside', $
     HISTXRANGE_MAXIND=[6,15], $
     HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     LAYOUT=[2,1,2], $
     /NORMALIZE_MAXIND_HIST, $
     /ONLY_POS, $
     /SAVEPLOT, $
     PLOTSUFFIX='dayside--nightside----normalized--only_pos', $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

 
END