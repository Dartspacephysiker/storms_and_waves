PRO JOURNAL__20160321__HISTOPLOTS_OF_10_EFLUX_LOSSCONE_INTEG_DURING_STORMPHASES__HIGHER_ALTS

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd            = 10

  ;; restrict_altRange = [0340,1000]
  ;; restrict_altRange = [1000,2000]
  ;; restrict_altRange = [2000,3000]
  ;; restrict_altRange = [3000,4175]
  ;; restrict_altRange = [4000,4175]
  restrict_altRange = [0340,2000] & dayYRange = [0,0.15] & nightYRange = [0,0.15]
  ;; restrict_altRange = [2000,4175] & dayYRange = [0,0.14] &  nightYRange = [0,0.14]


  histoBinsize      = 0.20

  fancy_plotNames   = 1
  @fluxplot_defaults
  xTitle            = 'Log ' + title__alfDB_ind_10 + STRING(FORMAT='(" ([",I0,", ",I0,"] km)")',restrict_altRange[0],restrict_altRange[1])
  
  night_mlt         = [-6.0,6.0]
  day_mlt           = [6.0,18.0]

  ;;titles and suffixes
  ;; pT_day            = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',day_mlt[0],day_mlt[1])
  ;; pT_night          = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',24+night_mlt[0],night_mlt[1])
  pSuff             = STRING(FORMAT='(F0.1,"-",F0.1,"--",' + $
                                     'F0.1,"-",F0.1,"_MLT")',day_mlt[0],day_mlt[1], $
                      24+night_mlt[0],night_mlt[1]) + $
                      STRING(FORMAT='("altRange_",I0,"-",I0)',restrict_altRange[0],restrict_altRange[1])

  dayXRange         = [0.2,6.0]
  nightXRange       = [0.2,6.0]

  ;; dayYRange         = [0,1.2e4]
  ;; nightYRange       = [0,2.5e3]

  normalize         = 1

  ;;use these for including stats text
  include_stats     = 0
  ;; dayYRange         = [0,0.10]
  ;; nightYRange       = [0,0.10]

  no_legend         = 1

  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     RESTRICT_ALTRANGE=restrict_altRange, $
     MAXIND=maxInd, $
     ;; HISTBINSIZE_MAXIND=0.125, $
     HISTBINSIZE_MAXIND=histoBinsize, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_day, $
     HISTXRANGE_MAXIND=nightXRange, $
     HISTXTITLE_MAXIND=xTitle, $
     ;; HISTYRANGE_MAXIND=[0,0.15], $
     HISTYRANGE_MAXIND=dayYRange, $
     /HISTYTITLE__ONLY_ONE, $
     /LOG_DBQUANTITY, $
     ;; /DAYSIDE, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     HEMI="NORTH", $
     NORMALIZE_MAXIND_HIST=normalize, $
     LAYOUT=[2,1,1], $
     /ONLY_POS, $
     NO_STATISTICS_TEXT=~KEYWORD_SET(include_stats), $
     NO_LEGEND=no_legend, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  pHP.yRange = nightYRange
  pHP.xRange = nightxRange
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     RESTRICT_ALTRANGE=restrict_altRange, $
     MAXIND=maxInd, $
     HISTBINSIZE_MAXIND=histoBinsize, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=nightXRange, $
     HISTXTITLE_MAXIND=xTitle, $
     HISTYRANGE_MAXIND=pHP.yRange, $
     /HISTYTITLE__ONLY_ONE, $
     /LOG_DBQUANTITY, $
     ;; /NIGHTSIDE, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     HEMI="NORTH", $
     NORMALIZE_MAXIND_HIST=normalize, $
     LAYOUT=[2,1,2], $
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