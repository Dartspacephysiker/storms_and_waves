PRO JOURNAL__20160625__GET_HISTOPLOT_DATA_FOR_10_EFLUX_LOSSCONE_AVG_18_AVG_ION_FLUX_UP_49_PFLUXEST_DURING_STORMPHASES__PRE_NOV1999

  hemi                   = "NORTH"
  orbRange               = [500,12670]

  saveDir                = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/journals/20160625--stormphase_histo_data--10_EFLCI_18_IIFU_49_PFE/'

  fancy_plotNames        = 1
  @fluxplot_defaults

  ;; xTitle                 = +'Log ' + title__alfDB_ind_18
  xTitleArr              = ['Log ' + title__alfDB_ind_10,'Log ' + title__alfDB_ind_18,"Log Integrated Poynting Flux (mW/m) at 100 km"]

  night_mlt              = [-6.0,6.0]
  day_mlt                = [6.0,18.0]

  divide_by_width_x      = [1,1,0]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG, 18-INTEG_ION_FLUX_UP, 49-PFLUXEST
  maxIndArr              = [       10,        18,       49]
  histBinsizeArr         = [     0.10,      0.1,     0.1]
  nightXRangeArr         = [[-4.0,3.0],[2,12],[-2.0,4.0]]
  dayXRangeArr           = [[-4.0,3.0],[2,12],[-2.0,4.0]]
  nightYRangeArr         = [ [0,0.12], [0,0.102],[0,0.13]]
  dayYRangeArr           = [ [0,0.12], [0,0.102],[0,0.13]]
  normalize              = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;titles and suffixes
  ;; pT_day            = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',day_mlt[0],day_mlt[1])
  ;; pT_night          = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',24+night_mlt[0],night_mlt[1])
  pSuff                  = STRING(FORMAT='(F0.1,"-",F0.1,"--",' + $
                                  'F0.1,"-",F0.1,"_MLT")',day_mlt[0],day_mlt[1], $
                                  24+night_mlt[0],night_mlt[1])


  FOR i=0,N_ELEMENTS(maxIndArr)-1 DO BEGIN
     maxInd              = maxIndArr[i]
     xTitle              = xTitleArr[i]
     dayXRange           = dayXRangeArr[*,i]
     nightXRange         = nightXRangeArr[*,i]
     dayYRange           = dayYRangeArr[*,i]
     nightYRange         = nightYRangeArr[*,i]
     histBinsize         = histBinsizeArr[i]

     ;;normalized dayside
     HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
        MAXIND=maxInd, $
        RESTRICT_ORBRANGE=orbRange, $
       HISTBINSIZE_MAXIND=histBinsize, $
        PLOTTITLE=pT_day, $
        HISTXRANGE_MAXIND=dayXRange, $
        HISTXTITLE_MAXIND=xTitle, $
        HISTYRANGE_MAXIND=dayYRange, $
        ;; HISTYRANGE_MAXIND=[0,0.08], $
        /HISTYTITLE__ONLY_ONE, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x[i], $
        /LOG_DBQUANTITY, $
        ;; /DAYSIDE, $
        MINMLT=day_mlt[0], $
        MAXMLT=day_mlt[1], $
        HEMI=hemi, $
        LAYOUT=[2,1,1], $
        NORMALIZE_MAXIND_HIST=normalize, $
        /ONLY_POS, $
        SAVEDIR=saveDir, $
        /SAVEFILE, $
        PLOTSUFFIX=pSuff, $
        /NO_STATISTICS_TEXT, $
        HISTOPLOT_PARAM_STRUCT=pHP, $
        CURRENT_WINDOW=window, $
        OUTPLOTARR=outplotArr

     ;;normalized nightside
     pHP.yRange = nightYRange
     pHP.xRange = nightXRange
     HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES__OVERLAY_PHASES, $
        MAXIND=maxInd, $
        HISTBINSIZE_MAXIND=histBinsize, $
        HISTXRANGE_MAXIND=nightXRange, $
        HISTXTITLE_MAXIND=xTitle, $
        HISTYRANGE_MAXIND=pHP.yRange, $
        /HISTYTITLE__ONLY_ONE, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x[i], $
        /LOG_DBQUANTITY, $
        ;; /NIGHTSIDE, $
        MINMLT=night_mlt[0], $
        MAXMLT=night_mlt[1], $
        HEMI=hemi, $
        LAYOUT=[2,1,2], $
        NORMALIZE_MAXIND_HIST=normalize, $
        /ONLY_POS, $
        /NO_STATISTICS_TEXT, $
        /SAVEFILE, $
        SAVEDIR=saveDir, $
        PLOTTITLE=pT_night, $
        PLOTSUFFIX=pSuff, $
        HISTOPLOT_PARAM_STRUCT=pHP, $
        CURRENT_WINDOW=window, $
        OUTPLOTARR=outplotArr


     pHP          = !NULL
     window.close
     window       = !NULL
     outplotArr   = !NULL
  ENDFOR

END
