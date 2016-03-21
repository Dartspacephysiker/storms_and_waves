PRO JOURNAL__20160321__HISTOPLOTS_OF_49_PFLUXEST_DURING_STORMPHASES__MULTIPLIED_BY_WIDTH_X__HIGHER_ALTS

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;49-PFLUXEST
  maxInd            = 49

  ;; restrict_altRange = [0000,1000]
  ;; restrict_altRange = [1000,2000]
  ;; restrict_altRange = [2000,3000]
  ;; restrict_altRange = [3000,4175]
  ;; restrict_altRange = [4000,4175]
  restrict_altRange = [0340,2000]
  ;; restrict_altRange = [2000,4175]

  fancy_plotNames   = 1
  @fluxplot_defaults

  ;; xTitle            = +'Log ' + title__alfDB_ind_18
  xTitle            = "Log Integ. Poynting Flux (mW/m) at 100 km" + STRING(FORMAT='(" ([",I0,", ",I0,"] km)")',restrict_altRange[0],restrict_altRange[1])

  night_mlt         = [-6.0,6.0]
  day_mlt           = [6.0,18.0]

  multiply_by_width_x = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Binsize
  histBinsize       = 0.2
  dayYRange         = [0,0.14]
  nightYRange       = [0,0.14]

  ;;use these for including stats text
  include_stats     = 0
  ;; dayYRange         = [0,0.09]
  ;; nightYRange       = [0,0.09]

  ;; histBinsize       = 0.2
  ;; dayYRange         = [0,0.13]
  ;; nightYRange       = [0,0.13]

  no_legend         = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;titles and suffixes
  ;; pT_day            = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',day_mlt[0],day_mlt[1])
  ;; pT_night          = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',24+night_mlt[0],night_mlt[1])
  pSuff             = STRING(FORMAT='(F0.1,"-",F0.1,"--",' + $
                                     'F0.1,"-",F0.1,"_MLT")',day_mlt[0],day_mlt[1], $
                      24+night_mlt[0],night_mlt[1]) + $
                      STRING(FORMAT='("altRange_",I0,"-",I0)',restrict_altRange[0],restrict_altRange[1])

  dayXRange         = [1.5,7.5]
  ;; dayYRange         = [0,6.0e3]

  nightXRange       = [1.5,7.5]
  ;; nightYRange       = [0,1.5e3]

  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     RESTRICT_ALTRANGE=restrict_altRange, $
     MAXIND=maxInd, $
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
     RESTRICT_ALTRANGE=restrict_altRange, $
     MAXIND=maxInd, $
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
