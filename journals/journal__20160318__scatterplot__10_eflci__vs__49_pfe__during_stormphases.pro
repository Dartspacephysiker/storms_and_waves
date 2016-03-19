PRO JOURNAL__20160318__SCATTERPLOT__10_EFLCI__VS__49_PFE__DURING_STORMPHASES

  hemi              = "NORTH"

  maxInd1           = 49
  custom_maxInd2     = "maximus.(10)/(maximus.width_x)*(mapRatio.ratio)^(0.5)"   ;;factor of 100 for conv to cm
  custom_maxName2    = '10_eflux_losscone_integ__avgd'
  ;; maxInd2           = 18  

  log_maxInd1       = 1
  log_maxInd2       = 1

  logPlot_maxInd1   = 0
  logPlot_maxInd2   = 0

  only_pos1         = 1
  only_pos2         = 1

  xTitle            = "Poynting Flux (mW/m) at 100 km"
  yTitle            = "Spatially avgd e!U-!N flux (mW/m!U2!N)"
  night_mlt         = [-6.0,6.0]
  day_mlt           = [6.0,18.0]

  dayXRange         = [-3.0,4.0]
  nightXRange       = [-3.0,4.0]
  dayYRange         = [-3.0,4.0]
  nightYRange       = [-3.0,4.0]

  day_transp        = 96
  night_transp      = 92

  ;; dayYRange         = [0,0.18]
  ;; nightYRange       = [0,0.18]

  no_legend         = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;titles and suffixes
  ;; pT_day            = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',day_mlt[0],day_mlt[1])
  ;; pT_night          = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',24+night_mlt[0],night_mlt[1])
  pSuff             = STRING(FORMAT='(F0.1,"-",F0.1,"--",' + $
                                     'F0.1,"-",F0.1,"_MLT")',day_mlt[0],day_mlt[1], $
                      24+night_mlt[0],night_mlt[1]) + ( KEYWORD_SET(despun) ? '--despun' : '')


  ;;normalized dayside
  SCATTERPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND1=maxInd1, $
     ;; MAXIND2=maxInd2, $
     CUSTOM_MAXIND2=custom_maxInd2, $
     CUSTOM_MAXNAME2=custom_maxName2, $
     RANGE_MAXIND1=dayXRange, $
     TITLE_MAXIND1=xTitle, $
     RANGE_MAXIND2=dayYRange, $
     TITLE_MAXIND2=yTitle, $
     ONLY_ONE__TITLE_MAXIND2=only_one__title_maxInd2, $
     LOG_MAXIND1=log_maxInd1, $
     LOG_MAXIND2=log_maxInd2, $
     LOGPLOT_MAXIND1=logPlot_maxInd1, $
     LOGPLOT_MAXIND2=logPlot_maxInd2, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_day, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     HEMI=hemi, $
     NPLOTROWS=2, $
     NPLOTCOLUMNS=3, $
     ONLY_POS1=only_pos1, $
     ONLY_POS2=only_pos2, $
     SYM_TRANSPARENCY=day_transp, $
     NO_LEGEND=no_legend, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outPlotArr, $
     OUT_PLOT_I=out_plot_i, $
     OUTLINFITSTR_LIST=outLinFitStr_list, $
     OUTLINEPLOTARR=outLinePlotArr

  ;;normalized nightside
  SCATTERPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND1=maxInd1, $
     ;; MAXIND2=maxInd2, $
     CUSTOM_MAXIND2=custom_maxInd2, $
     CUSTOM_MAXNAME2=custom_maxName2, $
     RANGE_MAXIND1=nightXRange, $
     TITLE_MAXIND1=title_maxInd1, $
     RANGE_MAXIND2=nightYRange, $
     TITLE_MAXIND2=title_maxInd2, $
     ONLY_ONE__TITLE_MAXIND2=only_one__title_maxInd2, $
     LOG_MAXIND1=log_maxInd1, $
     LOG_MAXIND2=log_maxInd2, $
     LOGPLOT_MAXIND1=logPlot_maxInd1, $
     LOGPLOT_MAXIND2=logPlot_maxInd2, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_night, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     HEMI=hemi, $
     NPLOTROWS=2, $
     NPLOTCOLUMNS=3, $
     ONLY_POS1=only_pos1, $
     ONLY_POS2=only_pos2, $
     NO_LEGEND=no_legend, $
     SYM_TRANSPARENCY=night_transp, $
     CURRENT_WINDOW=window, $
     /SAVEPLOT, $
     OUTPLOTARR=outPlotArr, $
     OUT_PLOT_I=out_plot_i, $
     OUTLINFITSTR_LIST=outLinFitStr_list, $
     OUTLINEPLOTARR=outLinePlotArr

END
