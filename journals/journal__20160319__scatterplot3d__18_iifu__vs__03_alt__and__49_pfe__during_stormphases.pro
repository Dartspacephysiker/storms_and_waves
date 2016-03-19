PRO JOURNAL__20160319__SCATTERPLOT3D__18_IIFU__VS__03_ALT__AND__49_PFE__DURING_STORMPHASES

  hemi              = "NORTH"
  ;; restrict_altRange = [0000,1000]
  ;; restrict_altRange = [1000,2000]
  ;; restrict_altRange = [2000,3000]
  ;; restrict_altRange = [3000,4175]
  ;; restrict_altRange = [4000,4175]

  ;; winTitle          = STRING("Cusp and Pre-midnight ") ;(Altitude Range: [",I0,", ",I0,"] km)")',restrict_altRange[0],restrict_altRange[1])
  winTitle          = STRING("Dayside & Nightside ") ;(Altitude Range: [",I0,", ",I0,"] km)")',restrict_altRange[0],restrict_altRange[1])

  maxInd1           = 03
  custom_maxInd2    = "maximus.(10)/(maximus.width_x)*(mapRatio.ratio)^(0.5)"   ;;factor of 100 for conv to cm
  custom_maxName2   = '10_eflux_losscone_integ__avgd'
  custom_maxInd3    = "maximus.(18)/(maximus.width_x*100.)*(mapRatio.ratio)^(0.5)"   ;;factor of 100 for conv to cm
  custom_maxName3   = '18_integ_ion_flux_up__avgd'
  ;; maxInd2           = 18  

  log_maxInd1       = 0
  log_maxInd2       = 1
  log_maxInd3       = 1

  logPlot_maxInd1   = 0
  logPlot_maxInd2   = 0
  logPlot_maxInd3   = 0

  only_pos1         = 1
  only_pos2         = 1
  only_pos3         = 1

  xTitle            = "Altitude (km)"
  yTitle            = "Spatially avgd e!U-!N flux (mW/m!U2!N)"
  zTitle            = "Spatially avgd upward ion flux (#/cm!U2!N-s) at 100 km"

  night_mlt         = [-6.0,6.0]
  day_mlt           = [6.0,18.0]

  ;; night_mlt         = [19.5,24.0]
  ;; night_ilat        = [60,84]
  ;; day_mlt           = [11.5,17.0]
  ;; day_ilat          = [60,80]

  dayXRange         = [340,4175]
  nightXRange       = [340,4175]
  dayYRange         = [-3.0,3.0]
  nightYRange       = [-3.0,3.0]
  dayZRange         = [3.0,11.0]
  nightZRange       = [3.0,11.0]

  day_transp        = 94
  night_transp      = 89

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;titles and suffixes
  ;; pT_day            = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',day_mlt[0],day_mlt[1])
  ;; pT_night          = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',24+night_mlt[0],night_mlt[1])
  pSuff             = STRING(FORMAT='(F0.1,"-",F0.1,"--",' + $
                                     'F0.1,"-",F0.1,"_MLT")',day_mlt[0],day_mlt[1], $
                      24+night_mlt[0],night_mlt[1]) + ( KEYWORD_SET(despun) ? '--despun' : '') ;$
                      ;; + STRING(FORMAT='("--altRange_",I0,"-",I0)',restrict_altRange[0],restrict_altRange[1]) $
                      ;; + '--cusp_n_premidnight'


  ;;normalized dayside
  SCATTERPLOT3D_THREE_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     RESTRICT_ALTRANGE=restrict_altRange, $
     MAXIND1=maxInd1, $
     ;; MAXIND2=maxInd2, $
     CUSTOM_MAXIND2=custom_maxInd2, $
     CUSTOM_MAXNAME2=custom_maxName2, $
     CUSTOM_MAXIND3=custom_maxInd3, $
     CUSTOM_MAXNAME3=custom_maxName3, $
     RANGE_MAXIND1=dayXRange, $
     TITLE_MAXIND1=xTitle, $
     RANGE_MAXIND2=dayYRange, $
     TITLE_MAXIND2=yTitle, $
     RANGE_MAXIND3=dayzRange, $
     TITLE_MAXIND3=zTitle, $
     LOG_MAXIND1=log_maxInd1, $
     LOG_MAXIND2=log_maxInd2, $
     LOG_MAXIND3=log_maxInd3, $
     LOGPLOT_MAXIND1=logPlot_maxInd1, $
     LOGPLOT_MAXIND2=logPlot_maxInd2, $
     LOGPLOT_MAXIND3=logPlot_maxInd3, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_day, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     MINILAT=N_ELEMENTS(day_ilat) GT 0 ? day_ilat[0] : !NULL, $
     MAXILAT=N_ELEMENTS(day_ilat) GT 0 ? day_ilat[1] : !NULL, $
     HEMI=hemi, $
     NPLOTROWS=2, $
     NPLOTCOLUMNS=3, $
     ONLY_POS1=only_pos1, $
     ONLY_POS2=only_pos2, $
     ONLY_POS3=only_pos3, $
     SYM_TRANSPARENCY=day_transp, $
     CURRENT_WINDOW=window, $
     WINDOW_TITLE=winTitle, $
     OUTPLOTARR=outPlotArr, $
     OUT_PLOT_I=out_plot_i, $
     OUTLINFITSTR_LIST=outLinFitStr_list, $
     OUTLINEPLOTARR=outLinePlotArr

  ;;normalized nightside
  SCATTERPLOT3D_THREE_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     RESTRICT_ALTRANGE=restrict_altRange, $
     MAXIND1=maxInd1, $
     ;; MAXIND2=maxInd2, $
     CUSTOM_MAXIND2=custom_maxInd2, $
     CUSTOM_MAXNAME2=custom_maxName2, $
     CUSTOM_MAXIND3=custom_maxInd3, $
     CUSTOM_MAXNAME3=custom_maxName3, $
     RANGE_MAXIND1=nightXRange, $
     TITLE_MAXIND1=title_maxInd1, $
     RANGE_MAXIND2=nightYRange, $
     TITLE_MAXIND2=title_maxInd2, $
     RANGE_MAXIND3=nightZRange, $
     TITLE_MAXIND3=zTitle, $
     LOG_MAXIND1=log_maxInd1, $
     LOG_MAXIND2=log_maxInd2, $
     LOG_MAXIND3=log_maxInd3, $
     LOGPLOT_MAXIND1=logPlot_maxInd1, $
     LOGPLOT_MAXIND2=logPlot_maxInd2, $
     LOGPLOT_MAXIND3=logPlot_maxInd3, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_night, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     MINILAT=N_ELEMENTS(night_ilat) GT 0 ? night_ilat[0] : !NULL, $
     MAXILAT=N_ELEMENTS(night_ilat) GT 0 ? night_ilat[1] : !NULL, $
     HEMI=hemi, $
     NPLOTROWS=2, $
     NPLOTCOLUMNS=3, $
     ONLY_POS1=only_pos1, $
     ONLY_POS2=only_pos2, $
     ONLY_POS3=only_pos3, $
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
