PRO JOURNAL__20160319__SCATTERPLOT__10_EFLCI__VS__49_PFE__HIGH_ALTS__CUSP_AND_PREMIDNIGHT__DURING_STORMPHASES

  hemi              = "NORTH"
  restrict_altRange = [0000,1000]
  ;; restrict_altRange = [1000,2000]
  ;; restrict_altRange = [2000,3000]
  ;; restrict_altRange = [3000,4175]
  ;; restrict_altRange = [4000,4175]

  winTitle          = STRING(FORMAT='("Cusp and Pre-midnight (Altitude Range: [",I0,", ",I0,"] km)")',restrict_altRange[0],restrict_altRange[1])

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

  xTitle            = "Poynting Flux (mW/m!U2!N) at 100 km"
  yTitle            = "Spatially avgd e!U-!N flux (mW/m!U2!N)"
  night_mlt         = [19.5,24.0]
  night_ilat        = [60,84]
  day_mlt           = [11.5,17.0]
  day_ilat          = [60,80]

  dayXRange         = [-3.0,4.0]
  nightXRange       = [-3.0,4.0]
  dayYRange         = [-3.0,3.0]
  nightYRange       = [-3.0,3.0]

  day_transp        = 94
  night_transp      = 89

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;titles and suffixes
  ;; pT_day            = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',day_mlt[0],day_mlt[1])
  ;; pT_night          = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',24+night_mlt[0],night_mlt[1])
  pSuff             = STRING(FORMAT='(F0.1,"-",F0.1,"--",' + $
                                     'F0.1,"-",F0.1,"_MLT")',day_mlt[0],day_mlt[1], $
                      24+night_mlt[0],night_mlt[1]) + ( KEYWORD_SET(despun) ? '--despun' : '') + $
                      STRING(FORMAT='("--altRange_",I0,"-",I0)',restrict_altRange[0],restrict_altRange[1]) + '--cusp_n_premidnight'


  ;;normalized dayside
  SCATTERPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     RESTRICT_ALTRANGE=restrict_altRange, $
     MAXIND1=maxInd1, $
     ;; MAXIND2=maxInd2, $
     CUSTOM_MAXIND2=custom_maxInd2, $
     CUSTOM_MAXNAME2=custom_maxName2, $
     RANGE_MAXIND1=dayXRange, $
     TITLE_MAXIND1=xTitle, $
     RANGE_MAXIND2=dayYRange, $
     TITLE_MAXIND2=yTitle, $
     LOG_MAXIND1=log_maxInd1, $
     LOG_MAXIND2=log_maxInd2, $
     LOGPLOT_MAXIND1=logPlot_maxInd1, $
     LOGPLOT_MAXIND2=logPlot_maxInd2, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_day, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     MINILAT=day_ilat[0], $
     MAXILAT=day_ilat[1], $
     HEMI=hemi, $
     NPLOTROWS=2, $
     NPLOTCOLUMNS=3, $
     ONLY_POS1=only_pos1, $
     ONLY_POS2=only_pos2, $
     SYM_TRANSPARENCY=day_transp, $
     CURRENT_WINDOW=window, $
     WINDOW_TITLE=winTitle, $
     OUTPLOTARR=outPlotArr, $
     OUT_PLOT_I=out_plot_i, $
     OUTLINFITSTR_LIST=outLinFitStr_list, $
     OUTLINEPLOTARR=outLinePlotArr

  ;;normalized nightside
  SCATTERPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     RESTRICT_ALTRANGE=restrict_altRange, $
     MAXIND1=maxInd1, $
     ;; MAXIND2=maxInd2, $
     CUSTOM_MAXIND2=custom_maxInd2, $
     CUSTOM_MAXNAME2=custom_maxName2, $
     RANGE_MAXIND1=nightXRange, $
     TITLE_MAXIND1=title_maxInd1, $
     RANGE_MAXIND2=nightYRange, $
     TITLE_MAXIND2=title_maxInd2, $
     LOG_MAXIND1=log_maxInd1, $
     LOG_MAXIND2=log_maxInd2, $
     LOGPLOT_MAXIND1=logPlot_maxInd1, $
     LOGPLOT_MAXIND2=logPlot_maxInd2, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_night, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     MINILAT=night_ilat[0], $
     MAXILAT=night_ilat[1], $
     HEMI=hemi, $
     NPLOTROWS=2, $
     NPLOTCOLUMNS=3, $
     ONLY_POS1=only_pos1, $
     ONLY_POS2=only_pos2, $
     SYM_TRANSPARENCY=night_transp, $
     CURRENT_WINDOW=window, $
     WINDOW_TITLE=winTitle, $
     /SAVEPLOT, $
     PLOTSUFFIX=pSuff, $
     OUTPLOTARR=outPlotArr, $
     OUT_PLOT_I=out_plot_i, $
     OUTLINFITSTR_LIST=outLinFitStr_list, $
     OUTLINEPLOTARR=outLinePlotArr

END
