;2015/12/22
;Well, the plots of Poynting flux during stormphases seem to show a dawn/dusk line of 
; asymmetry. It's time to look at the distributions along that line of asymmetry.
PRO JOURNAL__20151222__HISTOPLOTS_OF_49_PFLUXEST_DURING_STORMPHASES__OVERLAY_PHASE__DAWN_DUSK_ASYMMETRY__THIRD_CHOICE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;PFLUXEST
  
  night_mlt = [-4,9]
  day_mlt   = [9,20]

  ;;normalized dayside, pos and neg
  histoplot_alfvendbquantities_during_stormphases__overlay_phases, $
     MAXIND=49, $
     HISTBINSIZE_MAXIND=0.1, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE='9-20 MLT', $
     HISTXRANGE_MAXIND=[-1.2,2.8], $
     HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     ;; /DAYSIDE, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     HEMI="NORTH", $
     LAYOUT=[2,1,1], $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     /NO_STATISTICS_TEXT, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  histoplot_alfvendbquantities_during_stormphases__overlay_phases, $
     MAXIND=49, $
     HISTBINSIZE_MAXIND=0.1, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[-1.2,2.8], $
     HISTYRANGE_MAXIND=[0,0.10], $
     /LOG_DBQUANTITY, $
     ;; /NIGHTSIDE, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     HEMI="NORTH", $
     LAYOUT=[2,1,2], $
     /NORMALIZE_MAXIND_HIST, $
     ;; PLOTSUFFIX='nightside', $
     PLOTTITLE='20-9 MLT', $
     PLOTSUFFIX='9-20_MLT--20-9_MLT', $
     /SAVEPLOT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     /NO_STATISTICS_TEXT, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

END