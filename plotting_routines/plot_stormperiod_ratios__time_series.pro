FUNCTION PLOT_STORMPERIOD_RATIOS__TIME_SERIES,stormRatStruct, $
   NXTICKS=nXTicks, $
   FULL_DST_DB=full_Dst_DB, $
   YLOG=yLog, $
   YRANGE=yRange, $
   TITLE=title, $
   NO_TIME_LABEL=no_time_label, $
   CURRENT=window, $
   LAYOUT=layout, $
   POSITION=position, $
   BUFFER=buffer, $
   SAVEPLOT=savePlot, $
   SPNAME=sPName, $
   PLOTDIR=plotDir, $
   CLOSE_WINDOW_AFTER_SAVE=close_window_after_save

  COMPILE_OPT idl2


  histList        = LIST(stormRatStruct.nsRatio, $
                         stormRatStruct.mpRatio, $
                         stormRatStruct.rpRatio)

  ;;Now plots
  ;;Window?
  IF ~ISA(window) THEN BEGIN
     window       = WINDOW(DIMENSIONS=[1000,800])
  ENDIF
  
  nPlots          = 3
  plotArr         = MAKE_ARRAY(3,/OBJ)
  plotMargin      = [0.15, 0.25, 0.15, 0.15]

  ;; plotNames       = ['Broadband','Monoenergetic','Diffuse']
  plotNames       = ['Quiescent','Main','Recovery']
  colorArr        = ['light gray','Red','Blue']
  lsArr           = ['-','-','-']

  ;; xRange          = [000,4500]
  yRange          = KEYWORD_SET(yRange) ? yRange : [MIN(histList[0]),1.00]

  ;; xTickValues     = [500,1000,1500,2000,2500,3000,3500,4000,4500]
  ;; xTickName       = STRCOMPRESS(xTickValues,/REMOVE_ALL)

  CASE 1 OF
     KEYWORD_SET(no_time_label): BEGIN
        x_values        = INDGEN(stormRatStruct.nIntervals)
     END
     ELSE: BEGIN
        ;;For time axis
        ;; dummy           = LABEL_DATE(DATE_FORMAT=['%D-%M','%Y'])
        dummy           = LABEL_DATE(DATE_FORMAT=['%Y'])
        x_values        = MEAN(stormRatStruct.times,/DOUBLE,DIMENSION=1)
     END
  ENDCASE

  IF KEYWORD_SET(full_Dst_DB) THEN BEGIN
     xTickValues = TIMEGEN(START=JULDAY(1,1,1960),FINAL=JULDAY(1,1,2010),UNITS='Years', $
                         STEP_SIZE=10)
  ENDIF

  FOR iPlot=0,nPlots-1 DO BEGIN
     CASE iPlot OF
        0: BEGIN
           y_values      = (histList[0])
           bottom_values = !NULL
        END
        1: BEGIN
           y_values      = (histList[1]+histList[0])
           bottom_values = (histList[0])
        END
        2: BEGIN
           y_values      = (histList[2]+histList[1]+histList[0])
           bottom_values = (histList[0] + histList[1])
        END
     ENDCASE

     ;; PRINT,'Doing' + plotNames[i] + '...'

     plotArr[iPlot]      = BARPLOT(x_values, $
                                   y_values, $
                                   XRANGE=xRange, $
                                   YRANGE=yRange, $
                                   BOTTOM_VALUES=bottom_values, $
                                   NAME=plotNames[iPlot], $
                                   XMAJOR=nXTicks, $
                                   OUTLINE=0, $
                                   ;; XMINOR=0, $
                                   XTICKVALUES=xTickValues, $
                                   ;; XTICKNAME=xTickName, $
                                   XTICKFORMAT=KEYWORD_SET(no_time_label) ? $
                                   !NULL : 'LABEL_DATE', $
                                   XTICKUNITS=KEYWORD_SET(no_time_label) ? $
                                   ;; !NULL : ['Time','Time'], $
                                   !NULL : 'Time', $
                                   ;; XTICKS=nXTicks, $
                                   ;; INDEX=indexArr[0], $
                                   ;; NBARS=nBars, $
                                   FILL_COLOR=colorArr[iPlot], $
                                   ;; BOTTOM_COLOR=bottom_color, $
                                   LAYOUT=layout, $
                                   POSITION=position, $
                                   BUFFER=buffer, $
                                   OVERPLOT=iPlot GT 0, $
                                   CURRENT=window)
     
     
  ENDFOR

  legend          = LEGEND(TARGET=plotArr[*], $
                           /NORMAL, $
                           POSITION=[0.35,0.3])


  ;; Add a title.
  plotArr[0].title = "Storm ratios" + (KEYWORD_SET(title) ? "!C" + title : '')
  
  IF KEYWORD_SET(savePlot) THEN BEGIN

     IF KEYWORD_SET(spName) THEN outName = spName ELSE BEGIN
        outName = GET_TODAY_STRING() + '--stormRatios.png'
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