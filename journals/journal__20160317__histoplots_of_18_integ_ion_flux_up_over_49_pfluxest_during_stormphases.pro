PRO JOURNAL__20160317__HISTOPLOTS_OF_18_INTEG_ION_FLUX_UP_OVER_49_PFLUXEST_DURING_STORMPHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;49-PFLUXEST
  maxInd            = 49


  fancy_plotNames   = 1
  @fluxplot_defaults

  ;;factor of 100 for conv to cm
  custom_maxInd     = "maximus.(18)/(maximus.width_x*100.)*(mapRatio.ratio)^(0.5)/(maximus.(49))"
  custom_maxName    = 'log_18_integ_ion_flux_up_DIVBY_49_pfluxest'
  ;; xTitle            = +'Log ' + title__alfDB_ind_18
  xTitle            = "Log( (Spatially avgd upward ion flux (#/cm!U2!N-s) ) / (Poynting Flux (mW/m) ) at 100 km )"

  night_mlt         = [-6.0,6.0]
  day_mlt           = [6.0,18.0]

  multiply_by_width_x = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Binsize
  histBinsize       = 0.2
  dayYRange         = [0,0.08]
  nightYRange       = [0,0.08]

  ;;use these for including stats text
  include_stats     = 0
  ;; dayYRange         = [0,0.18]
  ;; nightYRange       = [0,0.18]

  no_legend         = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;titles and suffixes
  ;; pT_day            = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',day_mlt[0],day_mlt[1])
  ;; pT_night          = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',24+night_mlt[0],night_mlt[1])
  pSuff             = STRING(FORMAT='(F0.1,"-",F0.1,"--",' + $
                                     'F0.1,"-",F0.1,"_MLT")',day_mlt[0],day_mlt[1], $
                      24+night_mlt[0],night_mlt[1])

  dayXRange         = [3.4,11.4]
  ;; dayYRange         = [0,6.0e3]

  nightXRange       = [3.4,11.4]
  ;; nightYRange       = [0,1.5e3]

  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     CUSTOM_MAXIND=custom_maxInd, $
     CUSTOM_MAXNAME=custom_maxName, $
     ;; MAXIND=maxInd, $
     HISTBINSIZE_MAXIND=histBinsize, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_day, $
     HISTXRANGE_MAXIND=dayXRange, $
     HISTXTITLE_MAXIND=xTitle, $
     HISTYRANGE_MAXIND=dayYRange, $
     /HISTYTITLE__ONLY_ONE, $
     MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
     /LOG_DBQUANTITY, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     HEMI="NORTH", $
     LAYOUT=[2,1,1], $
     /NORMALIZE_MAXIND_HIST, $
     /ONLY_POS, $
     NO_STATISTICS_TEXT=~KEYWORD_SET(include_stats), $
     NO_LEGEND=no_legend, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  pHP.yRange = nightYRange
  pHP.xRange = nightXRange
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     CUSTOM_MAXIND=custom_maxInd, $
     CUSTOM_MAXNAME=custom_maxName, $
     ;; MAXIND=maxInd, $
     HISTBINSIZE_MAXIND=histBinsize, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=nightXRange, $
     HISTXTITLE_MAXIND=xTitle, $
     ;; HISTYRANGE_MAXIND=[0,0.08], $
     HISTYRANGE_MAXIND=pHP.yRange, $
     /HISTYTITLE__ONLY_ONE, $
     MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
     /LOG_DBQUANTITY, $
     ;; /NIGHTSIDE, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     HEMI="NORTH", $
     LAYOUT=[2,1,2], $
     /NORMALIZE_MAXIND_HIST, $
     /ONLY_POS, $
     NO_STATISTICS_TEXT=~KEYWORD_SET(include_stats), $
     NO_LEGEND=no_legend, $
     /SAVEPLOT, $
     PLOTTITLE=pT_night, $
     PLOTSUFFIX=pSuff, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

 
END
