;;2016/08/29
;;You want statistics of big storms, don't you? Bare tenk på det: 
;;CALDAT,storms.julday[where(storms.dst LE -300)],month,day,year
PRO JOURNAL__20160829__STORMSTATS__MASTER_URSI_PLOT

  COMPILE_OPT IDL2,STRICTARRSUBS

  ;;SavePlot names
  saveAllPlots         = 1

  stormRatPlots        = 1
  sRatTimeSeries       = 1
  sRatBoxPlots         = 1

  dMinPlots            = 1
  dMinTimeSeries       = 1
  dMinBoxPlots         = 1

  sFrqPlots            = 1
  sFrqTimeSeries       = 1
  sFrqBoxPlots         = 1
  
  calc_all_times       = 1
  full_Dst_DB          = 1

  monthInterval        = 18
  FASTmonthInterval    = 37
  ;; yearInterval      = 3

  sRatSPName           = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--stormRatios_1957-2011.png'
  dMinSPName           = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--dstMinStats_1957-2011.png'
  sFrqSPName           = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--stormFrequencyStats_1957-2011.png'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot optionszz

  smallColor           = 'blue'
  smallName            = 'Small storms'
  largeColor           = 'red'
  largeName            = 'Large storms'
  allColor             = 'black'

  ;;stormRatio plot options
  sRat_studyTransp     = 45
  sRat_shadeStudyArea  = 1
  ;; sRatYRange        = [0,1.0]
  sRatYRange           = [0,100]
  sRat_xShowText       = 0
  sRat_shadeTxt        = 0
  ;; sRatTxtOffset     = 0.02
  sRatTxtOffset        = 2
  sRatLineStyle        = ['-','--']

  ;; sRatBPLocs        = [-0.5,0.5,0.0] ;mp, rp, quiescence
  sRatBPLocs           = REPLICATE(4.0,3) ;mp, rp, quiescence
  sRatBPThick          = 2.0
  sRatBPTransp         = 15
  sRatBPWidth          = 1.0
  sRatBPXRange         = [0,10]
  sRatBPColumnText     = '1957–!C2011'

  sRatBP_addPoints     = 1
  sRatFASTXVals        = REPLICATE(8.2,3)
  sRatFASTYVals        = [0.174,0.134,0.691]
  sRatFASTYVals[1]     = sRatFASTYVals[0]+sRatFASTYVals[1]
  sRatFastCol          = [smallColor,largeColor,allColor]
  ;; sRatFastCol       = REPLICATE('green',3)
  sRatBP_addText       = 1

  ;;Dstmin plot options
  DMinLargeTransp      = 60
  DMinSmallTransp      = 80
  dMinYRange           = [-300,-15]
  dMinLegPos           = [JULDAY(6,1,1963),dMinYRange[0]+50]
  dMin_xShowText       = 0
  DMin_shadeStudyArea  = 1
  DMin_shadeTxt        = 0
  dMinTxtOffset        = 10
  dMinLineStyle        = ['-','--']
  dMinSymbols          = ['+','x']
  ;; dMinLargeThick       = 4.0

  dMinBPLocs           = REPLICATE(4.0,2) ;mp, rp, quiescence
  dMinBPThick          = 2.0
  dMinBPTransp         = 20
  dMinBPWidth          = 1.0
  dMinBPXRange         = [0,10]
  dMinBPColor          = [smallColor,largeColor]
  ;; dMinBPFillColor      = [smallColor,largeColor]

  dMinBP_addPoints     = 1
  dMinFASTXVals        = REPLICATE(8.2,2)
  ;; dMinFASTYVals     = [0.174,0.134]
  dMinFastCol          = [smallColor,largeColor]

  ;;Freq plot options
  sFrqYRange           = [0,80]
  ;; sFrqYRange        = !NULL
  sFrqUnits            = 'Years'
  sFrqLegendIncl       = [2,0,1]
  ;; sFrqTotName       = 'All storms'
  sFrq_xShowText       = 1
  sFrqTotName          = 'Total'
  sFrqLegPos           = [JULDAY(4,1,1962),sFrqYRange[1]-4.0]
  sFrq_shadeStudyArea  = 1
  sFrq_shadeTxt        = 0
  sFrqTxtOffset        = 2
  sFrqLineStyle        = ['-','--','-.']

  ;; sFrqBPLocs           = [2.5,3.0,3.5] ;small and large and ALL
  ;; sFrqBPLocs           = [3.0,3.0,3.0] ;small and large and ALL
  sFrqBPLocs           = [4.0,2.5,5.5] ;small and large and ALL
  ;; sFrqBPLocs           = [2.5,4.0,4.0] ;small and large and ALL
  ;; sFrqBPLocs           = REPLICATE(4.0,3) ;small and large and ALL
  sFrqBPThick          = 2.0
  sFrqBPTransp         = 15
  sFrqBPWidth          = [1.0,1.0,1.0]
  sFrqBPXRange         = [0,10]

  sFrqBP_addPoints     = 1
  sFrqFASTXVals        = REPLICATE(8.2,3)
  ;; sFrqFASTYVals     = [0.174,0.134]
  sFrqColor            = [smallColor,largeColor,allColor]
  ;; sFrqBPFillColor      = [smallColor,largeColor,allColor]
  sFrqBPFillColor      = !NULL
  sFrqFastCol          = [smallColor,largeColor,allColor]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot minutiae

  studyTransp          = sRat_studyTransp
  ;; studyBPSym           = 'Star'
  studyBPSym           = '+'
  studyBPSym_thick     = 2.0
  studyFillColor       = 'light green'
  xThick               = 2.0
  yThick               = 2.0
  thick                = 2.0
  xMinor               = 9.0

  ;;FAST study period
  fStudy1_UTC          = STR_TO_TIME('1996-10-06/16:26:02.417')
  fStudy2_UTC          = STR_TO_TIME('1999-11-03/03:20:59.853')
  fStudy1_julDay       = UTC_TO_JULDAY(fStudy1_UTC)
  fStudy2_julDay       = UTC_TO_JULDAY(fStudy2_UTC)

  tsPos_combPlot       = [0.10,0.05,0.75,0.95]
  bpPos_combPlot       = [0.75,0.05,0.95,0.95] ;Boxplot position for a combine time series/boxplot

  ;;Plot positions
  CASE 1 OF
     KEYWORD_SET(sRatTimeSeries) AND KEYWORD_SET(sRatBoxPlots): BEGIN
        sRatTSPos      = tsPos_combPlot

        sRatBPPos      = bpPos_combPlot
        dMinTSPos      = tsPos_combPlot
        dMinBPPos      = bpPos_combPlot
     END
     ELSE: 
  ENDCASE

  CASE 1 OF
     KEYWORD_SET(dMinTimeSeries) AND KEYWORD_SET(dMinBoxPlots): BEGIN
        dMinTSPos      = tsPos_combPlot
        dMinBPPos      = bpPos_combPlot
     END
     ELSE: 
  ENDCASE

  CASE 1 OF
     KEYWORD_SET(sFrqTimeSeries) AND KEYWORD_SET(sFrqBoxPlots): BEGIN
        sFrqTSPos      = tsPos_combPlot
        sFrqBPPos      = bpPos_combPlot
     END
     ELSE: 
  ENDCASE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Load DBs
  LOAD_NOAA_AND_BRETT_DBS_AND_QI,storms, $
                                 FULLMONTY_BRETTDB=full_Dst_DB

  LOAD_DST_AE_DBS,Dst,ae,LUN=lun, $
                  DST_AE_DIR=Dst_AE_dir, $
                  DST_AE_FILE=Dst_AE_file, $
                  FULL_DST_DB=full_Dst_DB

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Gather statistics

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
          /ADD_FREQ_STATS, $
          VERBOSE=verbose) 
  
  fast_i         = WHERE((storms.julDay GE fStudy1_julDay) AND $
                         (storms.julDay LE fStudy2_julDay),count)
  outlier_i      = WHERE(storms.dst LE $
                         MAX(large.totalmin.bpd.extras.suspected_outlier_values[1,*]))
  outlier_fast_i = CGSETINTERSECTION(fast_i,outlier_i,COUNT=nFastOutlier)

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
          /ADD_FREQ_STATS, $
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
          /ADD_FREQ_STATS, $
          VERBOSE=verbose) 


  ;;Combine large and small statistics before feeding into PLOT_DSTMIN_STATISTICS
  COMBINE_DST_STATISTICS_BOXPLOT_DATA,finalDMin,small.totalmin.BPD,NAME=small.totalmin.name
  COMBINE_DST_STATISTICS_BOXPLOT_DATA,finalDMin,large.totalmin.BPD,NAME=large.totalmin.name

  COMBINE_DST_STATISTICS_BOXPLOT_DATA,finalFreq,small.freq.BPD,NAME=small.freq.name
  COMBINE_DST_STATISTICS_BOXPLOT_DATA,finalFreq,large.freq.BPD,NAME=large.freq.name
  COMBINE_DST_STATISTICS_BOXPLOT_DATA,finalFreq,all.freq.BPD,NAME=all.freq.name

  ;;Now FAST stats
  earliest_UTC = STR_TO_TIME('1996-10-06/16:26:02.417')
  latest_UTC   = STR_TO_TIME('1999-11-03/03:20:59.853')

  ;;Get Dst storm statistics
  PRINT,'Getting FAST storm stats ...'
  largeF = GET_DST_STATISTICS_TIMESERIES_FROM_STORMSTRUCT( $
           storms, $
           RESTRICT_I=restrict_i, $
           /LARGE_STORMS, $
           NMONTHS_PER_CALC=FASTmonthInterval, $
           NDAYS_PER_CALC=dayInterval, $
           NYEARS_PER_CALC=yearInterval, $
           NHOURS_PER_CALC=hourInterval, $
           FULL_DST_DB=full_Dst_DB, $
           T1_UTC=earliest_UTC, $
           T2_UTC=latest_UTC, $
           T1_JULDAY=t1_julDay, $
           T2_JULDAY=t2_julDay, $
           ;; CALC_FOR_ALL_AVAILABLE_TIMES=calc_all_times, $
           /ADD_FREQ_STATS, $
           VERBOSE=verbose) 
  
  smallF = GET_DST_STATISTICS_TIMESERIES_FROM_STORMSTRUCT( $
           storms, $
           RESTRICT_I=restrict_i, $
           /SMALL_STORMS, $
           NMONTHS_PER_CALC=FASTmonthInterval, $
           NDAYS_PER_CALC=dayInterval, $
           NYEARS_PER_CALC=yearInterval, $
           NHOURS_PER_CALC=hourInterval, $
           FULL_DST_DB=full_Dst_DB, $
           T1_UTC=earliest_UTC, $
           T2_UTC=latest_UTC, $
           T1_JULDAY=t1_julDay, $
           T2_JULDAY=t2_julDay, $
           ;; CALC_FOR_ALL_AVAILABLE_TIMES=calc_all_times, $
           /ADD_FREQ_STATS, $
           VERBOSE=verbose) 

  allF = GET_DST_STATISTICS_TIMESERIES_FROM_STORMSTRUCT( $
         storms, $
         RESTRICT_I=restrict_i, $
         NMONTHS_PER_CALC=FASTmonthInterval, $
         NDAYS_PER_CALC=dayInterval, $
         NYEARS_PER_CALC=yearInterval, $
         NHOURS_PER_CALC=hourInterval, $
         FULL_DST_DB=full_Dst_DB, $
         T1_UTC=earliest_UTC, $
         T2_UTC=latest_UTC, $
         T1_JULDAY=t1_julDay, $
         T2_JULDAY=t2_julDay, $
         ;; CALC_FOR_ALL_AVAILABLE_TIMES=calc_all_times, $
         /ADD_FREQ_STATS, $
         VERBOSE=verbose) 



  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now plots
  window = WINDOW(DIMENSIONS=[1200,800])

  ;; dstMinTimeSeriesPos    = [0.0,0.5,1.0,1.0]
  ;; sFrqTSPos = [0.0,0.0,1.0,0.5]

  IF KEYWORD_SET(stormRatPlots) THEN BEGIN

     IF KEYWORD_SET(sRatTimeSeries) THEN BEGIN

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
                    ;; POSITION=position, $
                    POSITION=sRatTSPos, $
                    MARGIN=margin, $
                    CLIP=clip, $
                    BUFFER=buffer, $
                    SAVEPLOT=savePlot, $
                    SPNAME=sPName, $
                    PLOTDIR=plotDir, $
                    CLOSE_WINDOW_AFTER_SAVE=close_window_after_save, $
                    OUT_MEDIAN_OFFSETS=sRatMedOffsets)

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
                               FILL_COLOR=studyFillColor, $
                               TRANSPARENCY=sRat_studyTransp, $
                               ;; COLOR=studyFillColor, $
                               THICK=2)
           
           ;; Draw the text for the large study area.
           IF KEYWORD_SET(sRat_shadeTxt) THEN BEGIN
              sRatText  = TEXT(MEAN([fStudy1_julDay,fStudy2_julDay]), $
                               sRatYRange[1]+sRatTxtOffset, $
                               TARGET=sRatPlots[0], $
                               CLIP=0, $
                               ALIGNMENT=0.5, $
                               /DATA, $
                               'FAST!CStudy', $
                               COLOR='black', $
                               VERTICAL_ALIGNMENT=0.5, $
                               FONT_SIZE=18)
           ENDIF
        ENDIF

     ENDIF     

     IF KEYWORD_SET(sRatBoxPlots) THEN BEGIN
        sRatBP = BOXPLOT_STORMPERIOD_RATIOS(stormRat.stats.BPD, $
                                            BP_LOCATIONS=sRatBPLocs, $
                                            BPWIDTH=sRatBPWidth, $
                                            XRANGE=sRatBPXRange, $
                                            YRANGE=sRatYRange, $
                                            /ADD_MEDIANS, $
                                            ;; MED_OFFSETS=sRatMedOffsets, $
                                            /STACKEM, $
                                            /ADD_BOXPLOT_NAMES, $
                                            ADD_COLUMN_TEXT=sRatBPColumnText, $
                                            THICK=sRatBPThick, $
                                            XTHICK=xThick, $
                                            YTHICK=yThick, $
                                            ;; KILL_YTEXT=KEYWORD_SET(sRatTimeSeries), $
                                            /KILL_YTEXT, $
                                            TRANSPARENCY=sRatBPTransp, $
                                            POSITION=sRatBPPos, $
                                            CURRENT=window)

        IF KEYWORD_SET(sRatBP_addPoints) THEN BEGIN
           
           sRatBPSyms  = SYMBOL( $
                         sRatFASTXVals, $
                         sRatFASTYVals*100, $
                         studyBPSym, $
                         SYM_THICK=studyBPSym_thick, $
                         /DATA, $
                         ;; /NORMAL, $
                         ;; TARGET=this[0], $
                         ;; TARGET=window, $
                         ;; TARGET=sRatPlots[0], $
                         TARGET=sRatBP[0], $
                         CLIP=0, $
                         SYM_COLOR=sRatFastCol, $
                         SYM_SIZE=3.0, $
                         /SYM_FILLED)
        ENDIF

        IF KEYWORD_SET(sRatBP_addText) THEN BEGIN
           
           sRatBPText  = TEXT( $
                         sRatFASTXVals[0], $
                         102, $
                         'FAST!CStudy', $
                         /DATA, $
                         ;; /NORMAL, $
                         ;; TARGET=this[0], $
                         ;; TARGET=window, $
                         ;; TARGET=sRatPlots[0], $
                         TARGET=sRatBP[0], $
                         ALIGNMENT=0.5, $
                         VERTICAL_ALIGNMENT=0.5, $
                         CLIP=0, $
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

  IF KEYWORD_SET(dMinPlots) THEN BEGIN

     IF N_ELEMENTS(window) EQ 0 THEN BEGIN
        window = WINDOW(DIMENSIONS=[1200,800])
     ENDIF

     large_i     = WHERE(storms.is_largeStorm,COMPLEMENT=small_i)

     ;; dMinPlots = MAKE_ARRAY(3,/OBJ)
     ;; dMinPlots[0] = PLOT_DSTMIN_STATISTICS__TIME_SERIES( $
     ;;                  all.min.BPD,all.times, $
     ;;                  /SUPPRESS_LINEPLOT, $
     ;;                  SCATTERDATA=TRANSPOSE([[storms.julday], $
     ;;                                         [storms.dst]]), $
     ;;                  SCATTERSYMTRANSP=80, $
     ;;                  YRANGE=[-300,0], $
     ;;                  ;; /OVERPLOT, $
     ;;                  /FULL_DST_DB, $
     ;;                  POSITION=dMinTSPos, $
     ;;                  CURRENT=window)

     IF KEYWORD_SET(dMinTimeSeries) THEN BEGIN
        dMinPlots = MAKE_ARRAY(4,/OBJ)

        dMinPlots[0] = PLOT_DSTMIN_STATISTICS__TIME_SERIES( $
                       small.min.BPD,small.times, $
                       NAME=smallName, $
                       XSHOWTEXT=dMin_xShowText, $
                       XTHICK=xThick, $
                       YTHICK=yThick, $
                       XMINOR=xMinor, $
                       COLOR=smallColor, $
                       YRANGE=dMinYRange, $
                       LINESTYLE=dMinLineStyle[0], $
                       CLIP=clip, $
                       THICK=thick, $
                       SCATTERDATA=TRANSPOSE([[storms.julday[small_i]], $
                                              [storms.dst[small_i]]]), $
                       SCATTERSYMBOL=dMinSymbols[0], $
                       SCATTERSYMCOLOR=smallColor, $
                       SCATTERSYMTRANSP=DMinSmallTransp, $
                       POSITION=dMinTSPos, $
                       /FULL_DST_DB, $
                       CURRENT=window)

        dMinPlots[2] = PLOT_DSTMIN_STATISTICS__TIME_SERIES( $
                       large.min.BPD,large.times, $
                       NAME=largeName, $
                       XSHOWTEXT=dMin_xShowText, $
                       XTHICK=xThick, $
                       YTHICK=yThick, $
                       XMINOR=xMinor, $
                       COLOR=largeColor, $
                       YRANGE=dMinYRange, $
                       LINESTYLE=dMinLineStyle[1], $
                       CLIP=clip, $
                       THICK=dMinLargeThick, $
                       SCATTERDATA=TRANSPOSE([[storms.julday[large_i]], $
                                              [storms.dst[large_i]]]), $
                       SCATTERSYMBOL=dMinSymbols[1], $
                       SCATTERSYMCOLOR=largeColor, $
                       SCATTERSYMTRANSP=DMinLargeTransp, $
                       POSITION=dMinTSPos, $
                       /OVERPLOT, $
                       CURRENT=window, $
                       /FULL_DST_DB)

        legend          = LEGEND(TARGET=dMinPlots[[0,2]], $
                                 FONT_SIZE=18, $
                                 HORIZONTAL_ALIGNMENT=0.0, $
                                 /DATA, $
                                 POSITION=dMinLegPos)

        IF KEYWORD_SET(DMin_shadeStudyArea) THEN BEGIN

           ;; Define the large study area.
           boxCoords   = [[fStudy1_julDay,dMinYRange[0]], $
                          [fStudy1_julDay,dMinYRange[1]], $
                          [fStudy2_julDay,dMinYRange[1]], $
                          [fStudy2_julDay,dMinYRange[0]]]
           
           ;; Draw the large study area using POLYGON.
           dMinPoly  = POLYGON(boxCoords, $
                               TARGET=dMinPlots[0], $
                               /DATA, $
                               FILL_BACKGROUND=1, $
                               FILL_COLOR=studyFillColor, $
                               TRANSPARENCY=studyTransp, $
                               ;; COLOR=studyFillColor, $
                               THICK=2)
           
           ;; Draw the text for the large study area.
           IF KEYWORD_SET(dMin_shadeTxt) THEN BEGIN
              dMinText  = TEXT(MEAN([fStudy1_julDay,fStudy2_julDay]), $
                               dMinYRange[1]+dMinTxtOffset, $
                               TARGET=dMinPlots[0], $
                               CLIP=0, $
                               ALIGNMENT=0.5, $
                               /DATA, $
                               'FAST Study', $
                               COLOR='black', $
                               FONT_SIZE=18)
           ENDIF
        ENDIF
     ENDIF

     IF KEYWORD_SET(dMinBoxPlots) THEN BEGIN
        dMinBPs = MAKE_ARRAY(2,/OBJ)

        dMinBPs[0] = BOXPLOT_DSTMIN_STATISTICS( $
                     finalDMin, $
                     ;; /ADD_BOXPLOT_NAMES, $
                     ;; INCLUDE_EXTRAS=0, $
                     /EXCLUDE_OUTLIER_VALUES, $
                     /EXCLUDE_SUSPECTED_OUTLIER_VALUES, $
                     COLOR=dMinBPColor, $
                     FILL_COLOR=dMinBPFillColor, $
                     BPWIDTH=dMinBPWidth, $
                     BP_LOCATIONS=dMinBPLocs, $
                     XRANGE=dMinBPXRange, $
                     YRANGE=dMinYRange, $
                     LINESTYLE=dMinLineStyle, $
                     THICK=dMinBPThick, $
                     TRANSPARENCY=dMinBPTransp, $
                     XMINOR=xMinor, $
                     XTHICK=xThick, $
                     YTHICK=yThick, $
                     KILL_YTEXT=KEYWORD_SET(dMinTimeSeries), $
                     ;; /KILL_YTEXT, $
                     POSITION=dMinBPPos, $
                     CURRENT=window)


        IF KEYWORD_SET(dMinBP_addPoints) THEN BEGIN
           
           dMinBPSyms  = SYMBOL( $
                         dMinFASTXVals, $
                         [smallf.totalmin.bpd.data[2], $
                          largef.totalmin.bpd.data[2]], $
                         studyBPSym, $
                         SYM_THICK=studyBPSym_thick, $
                         /DATA, $
                         ;; /NORMAL, $
                         ;; TARGET=this[0], $
                         ;; TARGET=window, $
                         ;; TARGET=dMinPlots[0], $
                         TARGET=dMinBPs[0], $
                         CLIP=0, $
                         SYM_COLOR=dMinFastCol, $
                         SYM_SIZE=3.0, $
                         /SYM_FILLED)
        ENDIF
     ENDIF


     IF KEYWORD_SET(saveAllPlots) THEN BEGIN
        IF ~KEYWORD_SET(plotDir) THEN SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY

        PRINT,'Saving dstMin plot ...'
        window.Save,plotDir+dMinSPName

        window.Close
        window = !NULL
     ENDIF ELSE BEGIN
        STOP
     ENDELSE

  ENDIF

  IF KEYWORD_SET(sFrqPlots) THEN BEGIN

     IF N_ELEMENTS(window) EQ 0 THEN BEGIN
        window = WINDOW(DIMENSIONS=[1200,800])
     ENDIF

     IF KEYWORD_SET(sFrqTimeSeries) THEN BEGIN

        iPlot              = 0
        sFrqPlots          = MAKE_ARRAY(3,/OBJ)

        sFrqPlots[iPlot++] = PLOT_DST_STORMFREQ_STATISTICS__TIME_SERIES( $
                             small, $
                             /FULL_DST_DB, $
                             YRANGE=sFrqYRange, $
                             FREQUNITS=sFrqUnits, $
                             NAME=smallName, $
                             XSHOWTEXT=sFrq_xShowText, $
                             XTHICK=xThick, $
                             YTHICK=yThick, $
                             XMINOR=xMinor, $
                             LINESTYLE=sFrqLineStyle[iPlot-1], $
                             THICK=thick, $
                             COLOR=smallColor, $
                             POSITION=sFrqTSPos, $
                             ;; /OVERPLOT, $
                             CURRENT=window)

        sFrqPlots[iPlot++] = PLOT_DST_STORMFREQ_STATISTICS__TIME_SERIES( $
                             large, $
                             YRANGE=sFrqYRange, $
                             /FULL_DST_DB, $
                             FREQUNITS=sFrqUnits, $
                             NAME=largeName, $
                             XSHOWTEXT=sFrq_xShowText, $
                             XTHICK=xThick, $
                             YTHICK=yThick, $
                             XMINOR=xMinor, $
                             LINESTYLE=sFrqLineStyle[iPlot-1], $
                             THICK=thick, $
                             COLOR=largeColor, $
                             POSITION=sFrqTSPos, $
                             /OVERPLOT, $
                             CURRENT=window)

        sFrqPlots[iPlot++] = PLOT_DST_STORMFREQ_STATISTICS__TIME_SERIES( $
                             all, $
                             YRANGE=sFrqYRange, $
                             /FULL_DST_DB, $
                             FREQUNITS=sFrqUnits, $
                             NAME=sFrqTotName, $
                             XSHOWTEXT=sFrq_xShowText, $
                             XTHICK=xThick, $
                             YTHICK=yThick, $
                             XMINOR=xMinor, $
                             LINESTYLE=sFrqLineStyle[iPlot-1], $
                             COLOR=allColor, $
                             THICK=thick, $
                             POSITION=sFrqTSPos, $
                             /OVERPLOT, $
                             CURRENT=window)

        sFrqLegend = LEGEND(TARGET=sFrqPlots[sFrqLegendIncl], $
                            /DATA, $
                            FONT_SIZE=18, $
                            HORIZONTAL_ALIGNMENT=0.0, $
                            ;; /NORMAL, $
                            POSITION=sFrqLegPos)

        IF KEYWORD_SET(sFrq_shadeStudyArea) THEN BEGIN

           ;; Define the large study area.
           boxCoords    = [[fStudy1_julDay,sFrqYRange[0]], $
                           [fStudy1_julDay,sFrqYRange[1]], $
                           [fStudy2_julDay,sFrqYRange[1]], $
                           [fStudy2_julDay,sFrqYRange[0]]]
           
           ;; Draw the large study area using POLYGON.
           sFrqPoly     = POLYGON(boxCoords, $
                                  TARGET=sFrqPlots[0], $
                                  /DATA, $
                                  FILL_BACKGROUND=1, $
                                  FILL_COLOR=studyFillColor, $
                                  TRANSPARENCY=studyTransp, $
                                  ;; COLOR=studyFillColor, $
                                  THICK=2)
           
           ;; Draw the text for the large study area.
           IF KEYWORD_SET(sFrq_shadeTxt) THEN BEGIN
              sFrqText     = TEXT(MEAN([fStudy1_julDay,fStudy2_julDay]), $
                                  sFrqYRange[1]+sFrqTxtOffset, $
                                  CLIP=0, $
                                  ALIGNMENT=0.5, $
                                  /DATA, $
                                  TARGET=sFrqPlots[0], $
                                  'FAST Study', $
                                  COLOR='black', $
                                  FONT_SIZE=18)
           ENDIF

        ENDIF

     ENDIF

     IF KEYWORD_SET(sFrqBoxPlots) THEN BEGIN
        sFrqBPs = MAKE_ARRAY(3,/OBJ)

        sFrqBPs[0] = BOXPLOT_DSTMIN_STATISTICS( $
                     finalFreq, $
                     ;; /ADD_BOXPLOT_NAMES, $
                     ;; INCLUDE_EXTRAS=0, $
                     /EXCLUDE_OUTLIER_VALUES, $
                     /EXCLUDE_SUSPECTED_OUTLIER_VALUES, $
                     COLOR=sFrqColor, $
                     FILL_COLOR=sFrqBPFillColor, $
                     BPWIDTH=sFrqBPWidth, $
                     BP_LOCATIONS=sFrqBPLocs, $
                     XRANGE=sFrqBPXRange, $
                     YRANGE=sFrqYRange, $
                     THICK=sFrqBPThick, $
                     TRANSPARENCY=sFrqBPTransp, $
                     LINESTYLE=sFrqLineStyle, $
                     XMINOR=xMinor, $
                     XTHICK=xThick, $
                     YTHICK=yThick, $
                     KILL_YTEXT=KEYWORD_SET(sFrqTimeSeries), $
                     ;; /KILL_YTEXT, $
                     POSITION=sFrqBPPos, $
                     CURRENT=window)


        IF KEYWORD_SET(sFrqBP_addPoints) THEN BEGIN
           
           sFrqBPSyms  = SYMBOL( $
                         sFrqFASTXVals, $
                         [smallf.freq.bpd.data[2], $
                          largef.freq.bpd.data[2], $
                          allf.freq.bpd.data[2]], $
                         studyBPSym, $
                         SYM_THICK=studyBPSym_thick, $
                         /DATA, $
                         ;; /NORMAL, $
                         ;; TARGET=this[0], $
                         ;; TARGET=window, $
                         ;; TARGET=sFrqPlots[0], $
                         TARGET=sFrqBPs[0], $
                         CLIP=0, $
                         SYM_COLOR=sFrqFastCol, $
                         SYM_SIZE=3.0, $
                         /SYM_FILLED)
        ENDIF
     ENDIF

     IF KEYWORD_SET(saveAllPlots) THEN BEGIN
        IF ~KEYWORD_SET(plotDir) THEN SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY

        PRINT,'Saving storm frequency plot ...'
        window.Save,plotDir+sFrqSPName

        window.Close
        window = !NULL
     ENDIF

  ENDIF

END
