PRO JOURNAL__20160225__HISTOPLOTS_OF_10_EFLUX_LOSSCONE_INTEG_DURING_STORMPHASES__DIV_BY_WIDTH_X

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  ;; fancy_plotNames   = 1
  ;; @fluxplot_defaults
  ;; xTitle            = 'Log ' + title__alfDB_ind_10

  xTitle            = "Average e!U-!N Flux (mW/m!U2!N) at 100 km" 
  
  night_mlt         = [-6.0,6.0]
  day_mlt           = [6.0,18.0]

  divide_by_width_x = 1

  ;;titles and suffixes
  ;; pT_day            = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',day_mlt[0],day_mlt[1])
  ;; pT_night          = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',24+night_mlt[0],night_mlt[1])
  pSuff             = STRING(FORMAT='(F0.1,"-",F0.1,"--",' + $
                                     'F0.1,"-",F0.1,"_MLT")',day_mlt[0],day_mlt[1], $
                      24+night_mlt[0],night_mlt[1])

  histBinsize       = 0.20

  dayXRange         = [-4.0,2.0]
  dayYRange         = [0,1.0e4]

  nightXRange       = [-4.0,2.0]
  nightYRange       = [0,2.2e3]

  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=10, $
     ;; HISTBINSIZE_MAXIND=0.125, $
     HISTBINSIZE_MAXIND=histBinsize, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_day, $
     HISTXRANGE_MAXIND=dayXRange, $
     HISTXTITLE_MAXIND=xTitle, $
     ;; HISTYRANGE_MAXIND=[0,0.15], $
     HISTYRANGE_MAXIND=dayYRange, $
     /HISTYTITLE__ONLY_ONE, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
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
  pHP.yRange = nightYRange
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=10, $
     HISTBINSIZE_MAXIND=histBinsize, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=nightXRange, $
     HISTXTITLE_MAXIND=xTitle, $
     HISTYRANGE_MAXIND=pHP.yRange, $
     /HISTYTITLE__ONLY_ONE, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
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
     PLOTTITLE=pT_night, $
     PLOTSUFFIX=pSuff, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

 
END
