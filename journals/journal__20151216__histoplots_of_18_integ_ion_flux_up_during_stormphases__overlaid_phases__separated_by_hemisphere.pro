;;2015/12/16 Eric Lund has suggested I try separating this by hemisphere to see what causes the
;;difference in the peaks
;;Back at Dartmouth getting ready for AGU 2015
PRO JOURNAL__20151216__HISTOPLOTS_OF_18_INTEG_ION_FLUX_UP_DURING_STORMPHASES__OVERLAID_PHASES__SEPARATED_BY_HEMISPHERE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  
  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=18, $
     ;; HISTBINSIZE_MAXIND=0.125, $
     HISTBINSIZE_MAXIND=0.20, $
     /USE_DARTDB_START_ENDDATE, $
     HEMI='NORTH', $
     PLOTTITLE='Dayside', $
     HISTXRANGE_MAXIND=[6.5,14.5], $
     ;; HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     LAYOUT=[2,1,1], $
     /ONLY_POS, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  pHP.yRange = [0,2.5e3]
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=18, $
     HISTBINSIZE_MAXIND=0.20, $
     /USE_DARTDB_START_ENDDATE, $
     HEMI='NORTH', $
     PLOTTITLE='Nightside', $
     HISTXRANGE_MAXIND=[6.5,14.5], $
     HISTYRANGE_MAXIND=pHP.yRange, $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     LAYOUT=[2,1,2], $
     ;; /NORMALIZE_MAXIND_HIST, $
     /ONLY_POS, $
     /SAVEPLOT, $
     PLOTSUFFIX='dayside--nightside--no_normalization--NORTH', $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

;;;;;;;;;;;;;;;
;;SOUTHERN HEMI

  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=18, $
     ;; HISTBINSIZE_MAXIND=0.125, $
     HISTBINSIZE_MAXIND=0.20, $
     /USE_DARTDB_START_ENDDATE, $
     HEMI='SOUTH', $
     PLOTTITLE='Dayside', $
     HISTXRANGE_MAXIND=[6.5,14.5], $
     ;; HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     LAYOUT=[2,1,1], $
     /ONLY_POS, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  pHP.yRange = [0,7.5e2]
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=18, $
     HISTBINSIZE_MAXIND=0.20, $
     /USE_DARTDB_START_ENDDATE, $
     HEMI='SOUTH', $
     PLOTTITLE='Nightside', $
     HISTXRANGE_MAXIND=[6.5,14.5], $
     HISTYRANGE_MAXIND=pHP.yRange, $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     LAYOUT=[2,1,2], $
     ;; /NORMALIZE_MAXIND_HIST, $
     /ONLY_POS, $
     /SAVEPLOT, $
     PLOTSUFFIX='dayside--nightside--no_normalization--SOUTH', $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr


 
END