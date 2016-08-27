;;08/27/16
FUNCTION PLOT_DSTMIN_STATISTICS__TIME_SERIES,BPD,times, $
   SCATTERDATA=scatterData, $
   SCATTERSYMBOL=scatterSymbol, $
   SCATTERSYMCOLOR=scatterSymColor, $
   SCATTERSYMSIZE=scatterSymSize, $
   SCATTERSYMTRANSP=scatterSymTransp, $
   INCLUDE_EXTRAS=include_extras, $
   EXCLUDE_MEAN_VALUES=exclude_mean_values, $          
   EXCLUDE_CI_VALUES=exclude_ci_values, $              
   EXCLUDE_OUTLIER_VALUES=exclude_outlier_values, $         
   EXCLUDE_SUSPECTED_OUTLIER_VALUES=exclude_suspected_outlier_values, $
   ADD_LEGEND=add_legend, $
   NXTICKS=nXTicks, $
   FULL_DST_DB=full_Dst_DB, $
   YLOG=yLog, $
   YRANGE=yRange, $
   LINESTYLE=lineStyle, $
   TITLE=title, $
   NAME=name, $
   NO_TIME_LABEL=no_time_label, $
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
  
  nPlots          = 1 + KEYWORD_SET(scatterData)
  plotArr         = MAKE_ARRAY(nPlots,/OBJ)

  ;;Get good boxplot indices
  goodBP_i        = WHERE(~BPD.bad,nGood)

  goodBP_i        = INDGEN(N_ELEMENTS(BPD.bad))

  IF N_ELEMENTS(scatterSymbol) EQ 0 THEN scatterSymbol = '+'

  IF nGood EQ 0 THEN STOP

  ;;Want stuff like outliers and stuff?
  extras = N_ELEMENTS(include_extras) GT 0 ? include_extras : 1

  IF KEYWORD_SET(extras) THEN BEGIN
     
     EXTRACT_BOXPLOT_EXTRAS__DST_STATISTICS,BPD, $
                                            CI_VALUES=ci_values, $
                                            MEAN_VALUES=mean_values, $
                                            OUTLIER_VALUES=outlier_values, $
                                            SUSPECTED_OUTLIER_VALUES=suspected_outlier_values, $
                                            EXCLUDE_MEAN_VALUES=exclude_mean_values, $          
                                            EXCLUDE_CI_VALUES=exclude_ci_values, $              
                                            EXCLUDE_OUTLIER_VALUES=exclude_outlier_values, $         
                                            EXCLUDE_SUSPECTED_OUTLIER_VALUES=exclude_suspected_outlier_values

  ENDIF

  ;; xRange          = [000,4500]
  yRange          = KEYWORD_SET(yRange) ? yRange : [MIN(BPD.data[0,*]),-15]

  ;; xTickValues     = [500,1000,1500,2000,2500,3000,3500,4000,4500]
  ;; xTickName       = STRCOMPRESS(xTickValues,/REMOVE_ALL)

  CASE 1 OF
     KEYWORD_SET(no_time_label) OR (N_ELEMENTS(times) EQ 0): BEGIN
        x_values        = INDGEN(N_ELEMENTS(BPD.data[0,*]))
     END
     ELSE: BEGIN
        ;;For time axis
        ;; dummy           = LABEL_DATE(DATE_FORMAT=['%D-%M','%Y'])
        dummy           = LABEL_DATE(DATE_FORMAT=['%Y'])
        x_values        = MEAN(times,/DOUBLE,DIMENSION=1)
        ;; xRange          = [MIN(x_values),MAX(x_values)]
     END
  ENDCASE

  IF KEYWORD_SET(full_Dst_DB) THEN BEGIN
     xTickValues = TIMEGEN(START=JULDAY(1,1,1960),FINAL=JULDAY(1,1,2010),UNITS='Years', $
                           STEP_SIZE=10)
  ENDIF

  FOR iPlot=0,nPlots-1 DO BEGIN


     ;; PRINT,'Doing' + plotNames[i] + '...'

     plotArr[iPlot]      = PLOT(x_values[goodBP_i], $
                                BPD.data[2,goodBP_i], $
                                XRANGE=xRange, $
                                YRANGE=yRange, $
                                NAME=KEYWORD_SET(name) ? name[iPlot] : !NULL, $
                                YTITLE='Dst minimum (nT)', $
                                XMAJOR=nXTicks, $
                                XTICKVALUES=xTickValues, $
                                XTICKFORMAT=KEYWORD_SET(no_time_label) ? $
                                !NULL : 'LABEL_DATE', $
                                XTICKUNITS=KEYWORD_SET(no_time_label) ? $
                                !NULL : 'Time', $
                                FILL_COLOR=fill_color, $
                                LAYOUT=layout, $
                                POSITION=position, $
                                MARGIN=margin, $
                                CLIP=clip, $
                                BUFFER=buffer, $
                                OVERPLOT=overplot, $
                                CURRENT=window)
     
     
     IF KEYWORD_SET(scatterData) THEN BEGIN
        iPlot++

        plotArr[iPlot] = PLOT(scatterData[0,*], $
                              scatterData[1,*], $
                              SYMBOL=scatterSymbol, $
                              SYM_COLOR=scatterSymColor, $
                              SYM_SIZE=scatterSymSize, $
                              SYM_TRANSPARENCY=scatterSymTransp, $
                              XTICKVALUES=xTickValues, $
                              XTICKFORMAT=KEYWORD_SET(no_time_label) ? $
                              !NULL : 'LABEL_DATE', $
                              XTICKUNITS=KEYWORD_SET(no_time_label) ? $
                              !NULL : 'Time', $
                              LINESTYLE='', $
                              LAYOUT=layout, $
                              POSITION=position, $
                              MARGIN=margin, $
                              CLIP=clip, $
                              /OVERPLOT, $
                              CURRENT=window)

     ENDIF

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
