;;08/27/16
FUNCTION PLOT_DST_STORMFREQ_STATISTICS__TIME_SERIES,stats, $
   ADD_LEGEND=add_legend, $
   NXTICKS=nXTicks, $
   FREQUNITS=freqUnits, $
   FULL_DST_DB=full_Dst_DB, $
   YLOG=yLog, $
   YRANGE=yRange, $
   LINESTYLE=lineStyle, $
   TITLE=title, $
   NAME=name, $
   NO_TIME_LABEL=no_time_label, $
   COLOR=color, $
   CURRENT=window, $
   LAYOUT=layout, $
   POSITION=position, $
   CLIP=clip, $
   MARGIN=margin, $
   BUFFER=buffer, $
   OVERPLOT=overplot, $
   SAVEPLOT=savePlot, $
   SPNAME=sPName, $
   PLOTDIR=plotDir, $
   CLOSE_WINDOW_AFTER_SAVE=close_window_after_save

  COMPILE_OPT IDL2

  ;;Now plots
  ;;Window?
  IF ~ISA(window) THEN BEGIN
     window       = WINDOW(DIMENSIONS=[1000,800])
  ENDIF
  
  nPlots          = 1 
  plotArr         = MAKE_ARRAY(nPlots,/OBJ)


  IF N_ELEMENTS(freqUnits) EQ 0 THEN BEGIN
     freqUnits    = 'Months'
  ENDIF

  IF N_ELEMENTS(freqUnits) EQ 0 THEN BEGIN
     y_values              = stats.N
     unitTitleString       = '(Period!U-1!N)'

  ENDIF ELSE BEGIN
     CASE STRUPCASE(freqUnits) OF
        'MONTHS': BEGIN
           divide_by_times = 1
           divFactor       = 30.0D
           unitTitleString = '(30 days!U-1!N)'
        END
        'YEARS': BEGIN
           divide_by_times = 0
           divFactor       = !NULL
           unitTitleString = '(Year!U-1!N)'
        END
        'DAYS': BEGIN
           divide_by_times = 1
           divFactor       = 1.0D
           unitTitleString = '(Day!U-1!N)'
        END
        ELSE: BEGIN
           divide_by_times = 0
           divFactor       = !NULL
           unitTitleString = '(Period!U-1!N)'
        END
     ENDCASE

     y_values              = stats.N
     IF divide_by_times THEN BEGIN
        y_values           = y_values*divFactor/(stats.times[1,*]-stats.times[0,*])
     ENDIF
  ENDELSE

  CASE 1 OF
     KEYWORD_SET(no_time_label): BEGIN
        x_values        = INDGEN(N_ELEMENTS(stats.times[0,*]))

     END
     ELSE: BEGIN
        ;;For time axis
        ;; dummy           = LABEL_DATE(DATE_FORMAT=['%D-%M','%Y'])
        dummy           = LABEL_DATE(DATE_FORMAT=['%Y'])
        x_values        = MEAN(stats.times,/DOUBLE,DIMENSION=1)
        ;; xRange          = [MIN(x_values),MAX(x_values)]
     END
  ENDCASE

  ;; xRange          = [000,4500]
  yRange          = KEYWORD_SET(yRange) ? yRange : [0,MAX(y_values)]

  ;; xTickValues     = [500,1000,1500,2000,2500,3000,3500,4000,4500]
  ;; xTickName       = STRCOMPRESS(xTickValues,/REMOVE_ALL)

  IF KEYWORD_SET(full_Dst_DB) THEN BEGIN
     xTickValues = TIMEGEN(START=JULDAY(1,1,1960),FINAL=JULDAY(1,1,2010),UNITS='Years', $
                           STEP_SIZE=10)
  ENDIF

  FOR iPlot=0,nPlots-1 DO BEGIN

     plotArr[iPlot]      = PLOT(x_values, $
                                y_values, $
                                XRANGE=xRange, $
                                YRANGE=yRange, $
                                NAME=KEYWORD_SET(name) ? name[iPlot] : !NULL, $
                                YTITLE='Storm Frequency ' + unitTitleString, $
                                XMAJOR=nXTicks, $
                                XTICKVALUES=xTickValues, $
                                XTICKFORMAT=KEYWORD_SET(no_time_label) ? $
                                !NULL : 'LABEL_DATE', $
                                XTICKUNITS=KEYWORD_SET(no_time_label) ? $
                                !NULL : 'Time', $
                                COLOR=color, $
                                LAYOUT=layout, $
                                POSITION=position, $
                                MARGIN=margin, $
                                CLIP=clip, $
                                BUFFER=buffer, $
                                OVERPLOT=overplot, $
                                CURRENT=window)
     
     
  ENDFOR

  IF KEYWORD_SET(add_legend) THEN BEGIN

     legend          = LEGEND(TARGET=plotArr[*], $
                              /NORMAL, $
                              POSITION=[0.35,0.3])
  ENDIF

  ;; Add a title.
  plotArr[0].title = "Storm Dst Minimum" + (KEYWORD_SET(title) ? "!C" + title : '')
  
  IF KEYWORD_SET(savePlot) THEN BEGIN

     IF KEYWORD_SET(spName) THEN outName = spName ELSE BEGIN
        outName = GET_TODAY_STRING() + '--stormDstMin.png'
     ENDELSE
     IF N_ELEMENTS(plotDir) GT 0 THEN BEGIN
        pDir = plotDir
     ENDIF ELSE BEGIN
        SET_PLOT_DIR,pDir,/ADD_TODAY,/FOR_STORMS
     ENDELSE

     PRINT,'Saving to ' + spName + '...'
     window.save,pDir+spName

     IF KEYWORD_SET(close_window_after_save) THEN BEGIN
        window.close
        window      = !NULL
     ENDIF

  ENDIF


  RETURN,plotArr


END
