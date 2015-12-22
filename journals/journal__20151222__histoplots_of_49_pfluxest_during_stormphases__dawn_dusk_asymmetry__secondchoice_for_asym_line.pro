;2015/12/22
;Checking out the mainphase h2d plot makes me want to try a different line of asymmetry
PRO JOURNAL__20151222__HISTOPLOTS_OF_49_PFLUXEST_DURING_STORMPHASES__DAWN_DUSK_ASYMMETRY__SECONDCHOICE_FOR_ASYM_LINE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;PFLUXEST
  
  night_mlt = [-3,9]
  day_mlt   = [9,21]

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
     PLOTTITLE='9-21 MLT (black) 21-9 MLT (red)', $
     PLOTSUFFIX='9-21MLT_black--21-9MLT_red', $
     /SAVEPLOT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     /NO_STATISTICS_TEXT, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

END