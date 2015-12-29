;;2015/12/05 Wowzers
;;Think about it
PRO JOURNAL__20151229__HISTOPLOTS_OF_10_EFLUX_LOSSCONE_INTEG_DURING_STORMPHASES__OVERLAID_PHASES__DAWN_DUSK_ASYMMETRY__NO_NORM

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  @fluxplot_defaults
  xTitle            = 'Log ' + title__alfDB_ind_10_pub
  
  night_mlt         = [-4.5,7.5]
  day_mlt           = [7.5,19.5]

  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=10, $
     ;; HISTBINSIZE_MAXIND=0.125, $
     HISTBINSIZE_MAXIND=0.20, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE='7.5-19.5 MLT', $
     HISTXRANGE_MAXIND=[0.5,5.5], $
     HISTXTITLE_MAXIND=xTitle, $
     ;; HISTYRANGE_MAXIND=[0,0.15], $
     HISTYRANGE_MAXIND=[0,1.2e4], $
     /HISTYTITLE__ONLY_ONE, $
     /LOG_DBQUANTITY, $
     ;; /DAYSIDE, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     HEMI="NORTH", $
     LAYOUT=[2,1,1], $
     /ONLY_POS, $
     /NO_STATISTICS_TEXT, $
     /NO_LEGEND, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  pHP.yRange = [0,3e3]
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=10, $
     HISTBINSIZE_MAXIND=0.20, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0.5,5.5], $
     HISTXTITLE_MAXIND=xTitle, $
     HISTYRANGE_MAXIND=pHP.yRange, $
     /HISTYTITLE__ONLY_ONE, $
     /LOG_DBQUANTITY, $
     ;; /NIGHTSIDE, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     HEMI="NORTH", $
     LAYOUT=[2,1,2], $
     /ONLY_POS, $
     /NO_STATISTICS_TEXT, $
     /NO_LEGEND, $
     /SAVEPLOT, $
     PLOTTITLE='19.5-7.5 MLT', $
     PLOTSUFFIX='7.5-19.5_MLT--19.5-7.5_MLT', $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

 
END