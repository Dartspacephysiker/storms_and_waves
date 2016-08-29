;;2016/08/29
PRO JOURNAL__20160829__STORMSTATS__MASTER_URSI_PLOT

  COMPILE_OPT IDL2

  stormRatPlots    = 1
  dstMinPlots      = 1
  stormFreqPlots   = 1

  calc_all_times   = 1
  full_Dst_DB      = 1

  monthInterval    = 18
  ;; yearInterval  = 3

  smallColor       = 'blue'
  smallName        = 'Small storms'
  largeColor       = 'red'
  largeName        = 'Large storms'

  studyTransp      = 80
  xThick           = 2.0
  yThick           = 2.0
  thick            = 2.0
  xMinor           = 9.0

  ;;SavePlot names
  saveAllPlots     = 1

  sRatSPName   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--stormRatios_1957-2011.png'
  dstMinSPName = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--dstMinStats_1957-2011.png'
  freqSPName   = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--stormFrequencyStats_1957-2011.png'

  ;;stormRatio plot options
  sRat_studyTransp = 65
  sRat_shadeStudyArea = 1
  ;; sRatYRange   = [0,1.0]
  sRatYRange   = [0,100]
  sRat_xShowText = 0
  sRat_shadeTxt = 1
  ;; sRatTxtOffset = 0.02
  sRatTxtOffset = 2

  ;;Dstmin plot options
  DMinLargeTransp = 60
  DMinSmallTransp = 80
  dstMinYRange    = [-300,-15]
  dstMinLegPos    = [JULDAY(6,1,1963),dstMinYRange[0]+50]
  dstMin_xShowText = 0
  DstMin_shadeStudyArea = 1
  DstMin_shadeTxt = 0
  dstMinTxtOffset = 10
  dstMinLineStyle = ['-','--','-.']

  ;;Freq plot options
  freqYRange      = [0,80]
  ;; freqYRange   = !NULL
  freqUnits       = 'Years'
  freqLegendIncl  = [0,1,2]
  ;; freqTotName  = 'All storms'
  freq_xShowText  = 1
  freqTotName     = 'Total'
  freqLegPos      = [JULDAY(6,1,1963),freqYRange[1]-5]
  freq_shadeStudyArea = 1
  freq_shadeTxt   = 0
  freqTxtOffset   = 2
  freqLineStyle   = ['-','--','-.']

  ;;FAST study period
  fStudy1_UTC    = STR_TO_TIME('1996-10-06/16:26:02.417')
  fStudy2_UTC    = STR_TO_TIME('1999-11-03/03:20:59.853')
  fStudy1_julDay = UTC_TO_JULDAY(fStudy1_UTC)
  fStudy2_julDay = UTC_TO_JULDAY(fStudy2_UTC)

  ;;Load DBs
  LOAD_NOAA_AND_BRETT_DBS_AND_QI,storms, $
                                 FULLMONTY_BRETTDB=full_Dst_DB

  LOAD_DST_AE_DBS,Dst,ae,LUN=lun, $
                  DST_AE_DIR=Dst_AE_dir, $
                  DST_AE_FILE=Dst_AE_file, $
                  FULL_DST_DB=full_Dst_DB


  ;;Get stormRatio stats
  stormRat = GET_STORMPERIOD_RATIOS__TIME_SERIES(Dst, $
                                                 /INCLUDE_STATISTICS, $
                                                 NMONTHS_PER_CALC=monthInterval, $
                                                 NDAYS_PER_CALC=dayInterval, $
                                                 NYEARS_PER_CALC=yearInterval, $
                                                 NHOURS_PER_CALC=hourInterval, $
                                                 FULL_DST_DB=full_Dst_DB, $
                                                 T1_UTC=t1_UTC, $
                                                 T2_UTC=t2_UTC, $
                                                 T1_JULDAY=t1_julDay, $
                                                 T2_JULDAY=t2_julDay, $
                                                 CALC_FOR_ALL_AVAILABLE_TIMES=calc_all_times, $
                                                 VERBOSE=verbose)

  ;;Get Dst storm statistics
  large = GET_DST_STATISTICS_TIMESERIES_FROM_STORMSTRUCT( $
          storms, $
          /LARGE_STORMS, $
          NMONTHS_PER_CALC=monthInterval, $
          NDAYS_PER_CALC=dayInterval, $
          NYEARS_PER_CALC=yearInterval, $
          NHOURS_PER_CALC=hourInterval, $
          FULL_DST_DB=full_Dst_DB, $
          T1_UTC=t1_UTC, $
          T2_UTC=t2_UTC, $
          T1_JULDAY=t1_julDay, $
          T2_JULDAY=t2_julDay, $
          CALC_FOR_ALL_AVAILABLE_TIMES=calc_all_times, $
          VERBOSE=verbose) 
  
  small = GET_DST_STATISTICS_TIMESERIES_FROM_STORMSTRUCT( $
          storms, $
          /SMALL_STORMS, $
          NMONTHS_PER_CALC=monthInterval, $
          NDAYS_PER_CALC=dayInterval, $
          NYEARS_PER_CALC=yearInterval, $
          NHOURS_PER_CALC=hourInterval, $
          FULL_DST_DB=full_Dst_DB, $
          T1_UTC=t1_UTC, $
          T2_UTC=t2_UTC, $
          T1_JULDAY=t1_julDay, $
          T2_JULDAY=t2_julDay, $
          CALC_FOR_ALL_AVAILABLE_TIMES=calc_all_times, $
          VERBOSE=verbose) 
  
  all   = GET_DST_STATISTICS_TIMESERIES_FROM_STORMSTRUCT( $
          storms, $
          NMONTHS_PER_CALC=monthInterval, $
          NDAYS_PER_CALC=dayInterval, $
          NYEARS_PER_CALC=yearInterval, $
          NHOURS_PER_CALC=hourInterval, $
          FULL_DST_DB=full_Dst_DB, $
          T1_UTC=t1_UTC, $
          T2_UTC=t2_UTC, $
          T1_JULDAY=t1_julDay, $
          T2_JULDAY=t2_julDay, $
          CALC_FOR_ALL_AVAILABLE_TIMES=calc_all_times, $
          VERBOSE=verbose) 


  ;;Combine large and small statistics before feeding into PLOT_DSTMIN_STATISTICS
  COMBINE_DST_STATISTICS_BOXPLOT_DATA,final,large.totalmin.BPD,NAME=large.totalmin.name
  COMBINE_DST_STATISTICS_BOXPLOT_DATA,final,small.totalmin.BPD,NAME=small.totalmin.name


  ;;Now plots
  ;; plotHash = HASH()
  ;; this = BOXPLOT_STORMPERIOD_RATIOS(stormRat.stats.BPD, $
  ;;                                   /ADD_MEDIANS, $
  ;;                                   /STACKEM, $
  ;;                                   /ADD_BOXPLOT_NAMES)

  ;; STOP

  ;; plotHash = plotHash + HASH(this,this.name)

  ;; this = BOXPLOT_DSTMIN_STATISTICS(final,/ADD_BOXPLOT_NAMES,XRANGE=[-400,0])

  window = WINDOW(DIMENSIONS=[1000,800])

  ;; dstMinTimeSeriesPos    = [0.0,0.5,1.0,1.0]
  ;; stormFreqTimeSeriesPos = [0.0,0.0,1.0,0.5]

  IF KEYWORD_SET(stormRatPlots) THEN BEGIN

     sRatPlots = PLOT_STORMPERIOD_RATIOS__TIME_SERIES( $
                 stormRat, $
                 NXTICKS=nXTicks, $
                 FULL_DST_DB=full_Dst_DB, $
                 YLOG=yLog, $
                 YRANGE=sRatYRange, $
                 XSHOWTEXT=sRat_xShowText, $
                 XTHICK=xThick, $
                 YTHICK=yThick, $
                 THICK=thick, $
                 XMINOR=xMinor, $
                 TITLE=title, $
                 NO_TIME_LABEL=no_time_label, $
                 CURRENT=window, $
                 LAYOUT=layout, $
                 POSITION=position, $
                 MARGIN=margin, $
                 CLIP=clip, $
                 BUFFER=buffer, $
                 SAVEPLOT=savePlot, $
                 SPNAME=sPName, $
                 PLOTDIR=plotDir, $
                 CLOSE_WINDOW_AFTER_SAVE=close_window_after_save)

     IF KEYWORD_SET(sRat_shadeStudyArea) THEN BEGIN

        ;; Define the large study area.
        boxCoords   = [[fStudy1_julDay,sRatYRange[0]], $
                       [fStudy1_julDay,sRatYRange[1]], $
                       [fStudy2_julDay,sRatYRange[1]], $
                       [fStudy2_julDay,sRatYRange[0]]]
        
        ;; Draw the large study area using POLYGON.
        sRatPoly  = POLYGON(boxCoords, $
                              TARGET=sRatPlots[0], $
                              /DATA, $
                              FILL_BACKGROUND=1, $
                              FILL_COLOR='gray', $
                              TRANSPARENCY=sRat_studyTransp, $
                              ;; COLOR='gray', $
                              THICK=2)
        
        ;; Draw the text for the large study area.
        IF KEYWORD_SET(sRat_shadeTxt) THEN BEGIN
           sRatText  = TEXT(MEAN([fStudy1_julDay,fStudy2_julDay]), $
                              sRatYRange[1]+sRatTxtOffset, $
                              TARGET=sRatPlots[0], $
                              CLIP=0, $
                              ALIGNMENT=0.5, $
                              /DATA, $
                              'FAST Study', $
                              COLOR='black', $
                              FONT_SIZE=18)
        ENDIF
     ENDIF     

     IF KEYWORD_SET(saveAllPlots) THEN BEGIN
        IF ~KEYWORD_SET(plotDir) THEN SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY

        PRINT,'Saving sRat plot ...'
        window.Save,plotDir+sRatSPName

        window.Close
        window = !NULL
     ENDIF ELSE BEGIN
        STOP
     ENDELSE

  ENDIF 

  IF KEYWORD_SET(dstMinPlots) THEN BEGIN

     IF N_ELEMENTS(window) EQ 0 THEN BEGIN
        window = WINDOW(DIMENSIONS=[1000,800])
     ENDIF

     large_i     = WHERE(storms.is_largeStorm,COMPLEMENT=small_i)

     ;; dstMinPlots = MAKE_ARRAY(3,/OBJ)
     ;; dstMinPlots[0] = PLOT_DSTMIN_STATISTICS__TIME_SERIES( $
     ;;                  all.min.BPD,all.times, $
     ;;                  /SUPPRESS_LINEPLOT, $
     ;;                  SCATTERDATA=TRANSPOSE([[storms.julday], $
     ;;                                         [storms.dst]]), $
     ;;                  SCATTERSYMTRANSP=80, $
     ;;                  YRANGE=[-300,0], $
     ;;                  ;; /OVERPLOT, $
     ;;                  /FULL_DST_DB, $
     ;;                  POSITION=dstMinTimeSeriesPos, $
     ;;                  CURRENT=window)

     dstMinPlots = MAKE_ARRAY(4,/OBJ)

     dstMinPlots[0] = PLOT_DSTMIN_STATISTICS__TIME_SERIES( $
                      small.min.BPD,small.times, $
                      NAME=smallName, $
                      XSHOWTEXT=dstMin_xShowText, $
                      XTHICK=xThick, $
                      YTHICK=yThick, $
                      XMINOR=xMinor, $
                      COLOR=smallColor, $
                      YRANGE=dstMinYRange, $
                      LINESTYLE=dstMinLineStyle[0], $
                      THICK=thick, $
                      SCATTERDATA=TRANSPOSE([[storms.julday[small_i]], $
                                             [storms.dst[small_i]]]), $
                      SCATTERSYMCOLOR=smallColor, $
                      SCATTERSYMTRANSP=DMinSmallTransp, $
                      POSITION=dstMinTimeSeriesPos, $
                      /FULL_DST_DB, $
                      CURRENT=window)

     dstMinPlots[2] = PLOT_DSTMIN_STATISTICS__TIME_SERIES( $
                      large.min.BPD,large.times, $
                      NAME=largeName, $
                      XSHOWTEXT=dstMin_xShowText, $
                      XTHICK=xThick, $
                      YTHICK=yThick, $
                      XMINOR=xMinor, $
                      COLOR=largeColor, $
                      YRANGE=dstMinYRange, $
                      LINESTYLE=dstMinLineStyle[1], $
                      THICK=thick, $
                      SCATTERDATA=TRANSPOSE([[storms.julday[large_i]], $
                                             [storms.dst[large_i]]]), $
                      SCATTERSYMCOLOR=largeColor, $
                      SCATTERSYMTRANSP=DMinLargeTransp, $
                      POSITION=dstMinTimeSeriesPos, $
                      /OVERPLOT, $
                      CURRENT=window, $
                      /FULL_DST_DB)

     legend          = LEGEND(TARGET=dstMinPlots[[0,2]], $
                              HORIZONTAL_ALIGNMENT=0.0, $
                              /DATA, $
                              POSITION=dstMinLegPos)

     IF KEYWORD_SET(DstMin_shadeStudyArea) THEN BEGIN

        ;; Define the large study area.
        boxCoords   = [[fStudy1_julDay,dstMinYRange[0]], $
                       [fStudy1_julDay,dstMinYRange[1]], $
                       [fStudy2_julDay,dstMinYRange[1]], $
                       [fStudy2_julDay,dstMinYRange[0]]]
        
        ;; Draw the large study area using POLYGON.
        dstMinPoly  = POLYGON(boxCoords, $
                              TARGET=dstMinPlots[0], $
                              /DATA, $
                              FILL_BACKGROUND=1, $
                              FILL_COLOR='gray', $
                              TRANSPARENCY=studyTransp, $
                              ;; COLOR='gray', $
                              THICK=2)
        
        ;; Draw the text for the large study area.
        IF KEYWORD_SET(dstMin_shadeTxt) THEN BEGIN
           dstMinText  = TEXT(MEAN([fStudy1_julDay,fStudy2_julDay]), $
                              dstMinYRange[1]+dstMinTxtOffset, $
                              TARGET=dstMinPlots[0], $
                              CLIP=0, $
                              ALIGNMENT=0.5, $
                              /DATA, $
                              'FAST Study', $
                              COLOR='black', $
                              FONT_SIZE=18)
        ENDIF
     ENDIF

     IF KEYWORD_SET(saveAllPlots) THEN BEGIN
        IF ~KEYWORD_SET(plotDir) THEN SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY

        PRINT,'Saving dstMin plot ...'
        window.Save,plotDir+dstMinSPName

        window.Close
        window = !NULL
     ENDIF ELSE BEGIN
        STOP
     ENDELSE

  ENDIF

  IF KEYWORD_SET(stormFreqPlots) THEN BEGIN

     IF N_ELEMENTS(window) EQ 0 THEN BEGIN
        window = WINDOW(DIMENSIONS=[1000,800])
     ENDIF

     iPlot              = 0
     freqPlots          = MAKE_ARRAY(3,/OBJ)

     freqPlots[iPlot++] = PLOT_DST_STORMFREQ_STATISTICS__TIME_SERIES( $
                          small, $
                          /FULL_DST_DB, $
                          YRANGE=freqYRange, $
                          FREQUNITS=freqUnits, $
                          NAME=smallName, $
                          XSHOWTEXT=freq_xShowText, $
                          XTHICK=xThick, $
                          YTHICK=yThick, $
                          XMINOR=xMinor, $
                          LINESTYLE=freqLineStyle[iPlot-1], $
                          THICK=thick, $
                          COLOR=smallColor, $
                          POSITION=stormFreqTimeSeriesPos, $
                          ;; /OVERPLOT, $
                          CURRENT=window)

     freqPlots[iPlot++] = PLOT_DST_STORMFREQ_STATISTICS__TIME_SERIES( $
                          large, $
                          YRANGE=freqYRange, $
                          /FULL_DST_DB, $
                          FREQUNITS=freqUnits, $
                          NAME=largeName, $
                          XSHOWTEXT=freq_xShowText, $
                          XTHICK=xThick, $
                          YTHICK=yThick, $
                          XMINOR=xMinor, $
                          LINESTYLE=freqLineStyle[iPlot-1], $
                          THICK=thick, $
                          COLOR=largeColor, $
                          POSITION=stormFreqTimeSeriesPos, $
                          /OVERPLOT, $
                          CURRENT=window)

     freqPlots[iPlot++] = PLOT_DST_STORMFREQ_STATISTICS__TIME_SERIES( $
                          all, $
                          YRANGE=freqYRange, $
                          /FULL_DST_DB, $
                          FREQUNITS=freqUnits, $
                          NAME=freqTotName, $
                          XSHOWTEXT=freq_xShowText, $
                          XTHICK=xThick, $
                          YTHICK=yThick, $
                          XMINOR=xMinor, $
                          LINESTYLE=freqLineStyle[iPlot-1], $
                          THICK=thick, $
                          POSITION=stormFreqTimeSeriesPos, $
                          /OVERPLOT, $
                          CURRENT=window)

     stormFreqLegend = LEGEND(TARGET=freqPlots[freqLegendIncl], $
                              /DATA, $
                              HORIZONTAL_ALIGNMENT=0.0, $
                              ;; /NORMAL, $
                              POSITION=freqLegPos)

     IF KEYWORD_SET(freq_shadeStudyArea) THEN BEGIN

        ;; Define the large study area.
        boxCoords    = [[fStudy1_julDay,freqYRange[0]], $
                        [fStudy1_julDay,freqYRange[1]], $
                        [fStudy2_julDay,freqYRange[1]], $
                        [fStudy2_julDay,freqYRange[0]]]
        
        ;; Draw the large study area using POLYGON.
        freqPoly     = POLYGON(boxCoords, $
                               TARGET=freqPlots[0], $
                               /DATA, $
                               FILL_BACKGROUND=1, $
                               FILL_COLOR='gray', $
                               TRANSPARENCY=studyTransp, $
                               ;; COLOR='gray', $
                               THICK=2)
        
        ;; Draw the text for the large study area.
        IF KEYWORD_SET(freq_shadeTxt) THEN BEGIN
           freqText     = TEXT(MEAN([fStudy1_julDay,fStudy2_julDay]), $
                               freqYRange[1]+freqTxtOffset, $
                               CLIP=0, $
                               ALIGNMENT=0.5, $
                               /DATA, $
                               TARGET=freqPlots[0], $
                               'FAST Study', $
                               COLOR='black', $
                               FONT_SIZE=18)
        ENDIF
     ENDIF

     IF KEYWORD_SET(saveAllPlots) THEN BEGIN
        IF ~KEYWORD_SET(plotDir) THEN SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY

        PRINT,'Saving freq plot ...'
        window.Save,plotDir+freqSPName

        window.Close
        window = !NULL
     ENDIF

  ENDIF

END
