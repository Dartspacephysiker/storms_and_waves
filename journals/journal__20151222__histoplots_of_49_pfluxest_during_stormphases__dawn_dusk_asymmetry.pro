;2015/12/22
;Well, the plots of Poynting flux during stormphases seem to show a dawn/dusk line of 
; asymmetry. It's time to look at the distributions along that line of asymmetry.
PRO JOURNAL__20151222__HISTOPLOTS_OF_49_PFLUXEST_DURING_STORMPHASES__DAWN_DUSK_ASYMMETRY

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;PFLUXEST
  
  night_mlt = [-4.5,7.5]
  day_mlt   = [7.5,19.5]

  ;;normalized dayside, pos and neg
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=49, $
     HISTBINSIZE_MAXIND=0.1, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[-1.5,3], $
     HISTYRANGE_MAXIND=[0,0.1], $
     /LOG_DBQUANTITY, $
     ;; /DAYSIDE, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     HEMI="NORTH", $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     /NO_STATISTICS_TEXT, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=49, $
     HISTBINSIZE_MAXIND=0.1, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[-1.5,3], $
     HISTYRANGE_MAXIND=[0,0.1], $
     /LOG_DBQUANTITY, $
     ;; /NIGHTSIDE, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     HEMI="NORTH", $
     /NORMALIZE_MAXIND_HIST, $
     ;; PLOTSUFFIX='nightside', $
     PLOTTITLE='7.5-19.5 MLT (black) 19.5-7.5 MLT (red)', $
     PLOTSUFFIX='7.5-19.5MLT_black--19.5-7.5MLT_red', $
     /SAVEPLOT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     /NO_STATISTICS_TEXT, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

END