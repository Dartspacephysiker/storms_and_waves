;2015/12/24
;Well, the plots of Poynting flux during stormphases seem to show a dawn/dusk line of 
; asymmetry. It's time to look at the distributions along that line of asymmetry.
PRO JOURNAL__20151224__HISTOPLOTS_OF_10_EFLUX_LOSSCONE_INTEG_DURING_STORMPHASES__DAWN_DUSK_ASYMMETRY

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  
  night_mlt = [-4.5,7.5]
  day_mlt   = [7.5,19.5]

  ;;normalized dayside, pos and neg
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=10, $
     HISTBINSIZE_MAXIND=0.2, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0.5,5.5], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /LOG_DBQUANTITY, $
     ;; /DAYSIDE, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     HEMI="NORTH", $
     /ONLY_POS, $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     /NO_STATISTICS_TEXT, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=10, $
     HISTBINSIZE_MAXIND=0.2, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0.5,5.5], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /LOG_DBQUANTITY, $
     ;; /NIGHTSIDE, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     HEMI="NORTH", $
     /ONLY_POS, $
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