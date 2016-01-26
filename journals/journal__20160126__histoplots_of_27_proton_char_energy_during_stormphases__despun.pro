PRO JOURNAL__20160126__HISTOPLOTS_OF_27_PROTON_CHAR_ENERGY_DURING_STORMPHASES__DESPUN

alfDB_dataName_27                    = '27-PROTON_CHAR_ENERGY'
alfDB_dataName_31                    = '31-HELIUM_CHAR_ENERGY'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;29-OXY_CHAR_ENERGY
  fancy_plotNames   = 1
  @fluxplot_defaults
  maxInd            = 27
  maxInd_plotRange  = [0.0,3.0]
  maxInd_binsize    = 0.1
  xTitle            = +'Log ' + title__alfDB_ind_27
  
  day_mlt           = [6.0,18.0]
  night_mlt         = [-6.0,6.0]

  norm              = 1
  dayYRange         = [0.0,0.3]
  nightYRange       = dayYRange
  ;; dayYRange         = [0,6.0e3]
  ;; nightYRange       = [0,1.5e3]

  ;;titles and suffixes
  pSuff             = STRING(FORMAT='(F0.1,"-",F0.1,"--",' + $
                                     'F0.1,"-",F0.1,"_MLT")',day_mlt[0],day_mlt[1], $
                      24+night_mlt[0],night_mlt[1])

  ;;normalized dayside
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=maxInd, $
     /DO_DESPUNDB, $
     HISTBINSIZE_MAXIND=maxind_binsize, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_day, $
     HISTXRANGE_MAXIND=maxInd_plotRange, $
     HISTXTITLE_MAXIND=xTitle, $
     HISTYRANGE_MAXIND=dayYRange, $
     /HISTYTITLE__ONLY_ONE, $
     /LOG_DBQUANTITY, $
     MINMLT=day_mlt[0], $
     MAXMLT=day_mlt[1], $
     HEMI="NORTH", $
     LAYOUT=[2,1,1], $
     NORMALIZE_MAXIND_HIST=norm, $
     /ONLY_POS, $
     /NO_STATISTICS_TEXT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside
  pHP.yRange = nightYRange
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
     MAXIND=maxInd, $
     /DO_DESPUNDB, $
     HISTBINSIZE_MAXIND=maxind_binsize, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTTITLE=pT_night, $
     HISTXRANGE_MAXIND=maxInd_plotRange, $
     HISTXTITLE_MAXIND=xTitle, $
     HISTYRANGE_MAXIND=pHP.yRange, $
     /HISTYTITLE__ONLY_ONE, $
     /LOG_DBQUANTITY, $
     MINMLT=night_mlt[0], $
     MAXMLT=night_mlt[1], $
     HEMI="NORTH", $
     LAYOUT=[2,1,2], $
     NORMALIZE_MAXIND_HIST=norm, $
     /ONLY_POS, $
     /NO_STATISTICS_TEXT, $
     /SAVEPLOT, $
     PLOTSUFFIX=pSuff, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

 
END