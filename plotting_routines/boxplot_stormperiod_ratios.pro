;;08/29/16
FUNCTION BOXPLOT_STORMPERIOD_RATIOS, $
   BPD, $
   ADD_MEDIANS=add_medians, $
   MED_OFFSETS=median_offsets, $
   SET_AT_ZERO_LINE=set_at_zero_line, $
   INCLUDE_EXTRAS=include_extras, $
   EXCLUDE_MEAN_VALUES=exclude_mean_values, $          
   EXCLUDE_CI_VALUES=exclude_ci_values, $              
   EXCLUDE_OUTLIER_VALUES=exclude_outlier_values, $         
   EXCLUDE_SUSPECTED_OUTLIER_VALUES=exclude_suspected_outlier_values, $
   XRANGE=xRange, $
   YRANGE=yRange, $
   ADD_BOXPLOT_NAMES=add_boxplot_names, $
   ADD_COLUMN_TEXT=add_column_text, $
   SYMBOL_MEANS=symbol_means, $
   SYMBOL_OUTLIERS=symbol_outliers, $
   SYMBOL_SUSPECTED_OUTLIERS=symbol_suspected_outliers, $
   BP_LOCATIONS=bp_locations, $
   BPWIDTH=BPWidth, $
   STACKEM=stackEm, $
   LEGEND__STACKEM=legend__stackEm, $
   PLOTTITLE=plotTitle, $
   CLIP=clip, $
   COLOR=color, $
   FILL_COLOR=fill_color, $
   BACKGROUND_COLOR=background_color, $
   LOWER_COLOR=lower_color, $
   ENDCAPS=endCaps, $
   MEDIAN=median, $
   NOTCH=notch, $
   LINESTYLE=lineStyle, $
   THICK=thick, $
   XTHICK=xThick, $
   YTHICK=yThick, $
   KILL_YTEXT=kill_yText, $
   TRANSPARENCY=transparency, $
   WHISKERS=whiskers, $
   MARGIN=margin, $
   LAYOUT=layout, $
   POSITION=position, $
   LOCATION=location, $
   OVERPLOT=overplot, $
   BUFFER=buffer, $
   CURRENT=window, $
   CLOSE_WINDOW_AFTER_SAVE=close_window_after_save, $
   SAVEPLOT=savePlot, $
   SPNAME=sPName, $
   PLOTDIR=plotDir

  COMPILE_OPT IDL2,STRICTARRSUBS

  @plot_stormstats_defaults.pro

  ;;Want stuff like outliers and stuff?
  extras = N_ELEMENTS(include_extras) GT 0 ? include_extras : 1

  IF KEYWORD_SET(extras) THEN BEGIN
     EXTRACT_BOXPLOT_EXTRAS__STORMRATIO_STATISTICS, $
        BPD, $
        CI_VALUES=ci_values, $
        MEAN_VALUES=mean_values, $
        OUTLIER_VALUES=outlier_values, $
        SUSPECTED_OUTLIER_VALUES=suspected_outlier_values, $
        EXCLUDE_MEAN_VALUES=exclude_mean_values, $          
        EXCLUDE_CI_VALUES=exclude_ci_values, $              
        EXCLUDE_OUTLIER_VALUES=exclude_outlier_values, $
        EXCLUDE_SUSPECTED_OUTLIER_VALUES=exclude_suspected_outlier_values
  ENDIF

  ;;Now plots
  ;;Window?
  IF ~ISA(window) THEN BEGIN
     window       = WINDOW(DIMENSIONS=[1000,800])
  ENDIF
  
  nBoxPlots          = KEYWORD_SET(stackEm) ? 3 : 1
  plotArr         = MAKE_ARRAY(nBoxPlots,/OBJ)

  ;; plotNames       = ['Quiescent','Main','Recovery']
  ;; colorArr        = ['light gray','Red','Blue']
  ;; plotNames       = ['Main','Recovery','Quiescent']
  ;; colorArr        = ['Red','Blue','light gray']
  plotNames       = ['Recovery','Main','Quiescent']
  color           = N_ELEMENTS(color)      GT 0 ? color      : ['Blue','Red','black']
  ;; fill_color      = N_ELEMENTS(fill_color) GT 0 ? fill_color : ['Blue','Red','light gray']
  ;; lsArr           = ['-','--','-.']

  x_vals          = KEYWORD_SET(bp_locations) ? bp_locations : [-1,0,1]

  yRange          = KEYWORD_SET(yRange) ? yRange : [MIN(BPD.data[*,0]),1.00]


  CASE KEYWORD_SET(stackEm) OF
     1: BEGIN

        plotDat = BPD.data*100

        CASE 1 OF
           KEYWORD_SET(add_medians): BEGIN

              ;;Adds median of each previous bp
              FOR iPlot=0,nBoxPlots-1 DO BEGIN

                 CASE KEYWORD_SET(median_offsets) OF
                    1: BEGIN
                       plotDat[iPlot,*] += (median_offsets[iPlot] - plotDat[iPlot,2])
                    END
                    ELSE: BEGIN
                       j = iPlot+1
                       WHILE j LT nBoxPlots-1 DO BEGIN
                          plotDat[j,*] += plotDat[iPlot,2]
                          j++
                       ENDWHILE
                    END
                 ENDCASE

              ENDFOR

           END
           KEYWORD_SET(set_at_zero_line): BEGIN

           END
           ELSE: BEGIN

           END
        ENDCASE
        

        FOR iPlot=0,nBoxPlots-1 DO BEGIN
           ;; PRINT,'Doing' + plotNames[i] + '...'

           ;;Get extras, if possible
           IF KEYWORD_SET(extras) THEN BEGIN
              IF N_ELEMENTS(ci_values) GT 0 THEN BEGIN
                 tmpCi = ci_values[iPlot]
              ENDIF

              IF N_ELEMENTS(mean_values) GT 0 THEN BEGIN
                 tmpMean = mean_values[iPlot]
              ENDIF

              IF N_ELEMENTS(outlier_values) GT 0 THEN BEGIN
                 tmpWhere = WHERE(outlier_values[0,*] EQ iPlot,nTmp)
                 IF nTmp GT 0 THEN BEGIN
                    tmpOutlier = outlier_values[*,tmpWhere] 
                 ENDIF ELSE BEGIN
                    tmpOutlier = !NULL
                 ENDELSE
              ENDIF

              IF N_ELEMENTS(suspected_outlier_values) GT 0 THEN BEGIN
                 tmpWhere = WHERE(suspected_outlier_values[0,*] EQ iPlot,nTmp)
                 IF nTmp GT 0 THEN BEGIN
                    tmpSuspected_outlier = suspected_outlier_values[*,tmpWhere] 
                 ENDIF ELSE BEGIN
                    tmpSuspected_outlier = !NULL
                 ENDELSE
              ENDIF
           ENDIF

           ;; plotArr[iPlot]      = BOXPLOT(plotDat[iPlot,*], $
           plotArr[iPlot]      = BOXPLOT([x_vals[iPlot]],plotDat[iPlot,*], $
                                         XRANGE=xRange, $
                                         YRANGE=yRange, $
                                         NAME=plotNames[iPlot], $
                                         WIDTH=BPWidth, $
                                         WHISKERS=whiskers, $
                                         ENDCAPS=endCaps, $
                                         MEDIAN=median, $
                                         NOTCH=notch, $
                                         CI_VALUES=tmpCi, $
                                         MEAN_VALUES=tmpMean, $
                                         OUTLIER_VALUES=tmpOutlier, $
                                         SUSPECTED_OUTLIER_VALUES=tmpSuspected_outlier, $
                                         SYMBOL_MEANS=symbol_means, $
                                         SYMBOL_OUTLIERS=symbol_outliers, $
                                         SYMBOL_SUSPECTED_OUTLIERS=symbol_suspected_outliers, $
                                         COLOR=N_ELEMENTS(color) EQ nBoxPlots ? $
                                         color[iPlot] : color, $
                                         ;; FILL_COLOR=N_ELEMENTS(fill_color) EQ nBoxPlots ? $
                                         ;; fill_color[iPlot] : fill_color, $
                                         ;; FILL_COLOR=(iPlot EQ 2 ? 'light gray' : !NULL), $
                                         ;; BACKGROUND_COLOR=background_color, $
                                         LOWER_COLOR=lower_color, $
                                         LINESTYLE=lineStyle, $
                                         XTHICK=xThick, $
                                         YTHICK=yThick, $
                                         THICK=thick, $
                                         YSHOWTEXT=KEYWORD_SET(kill_yText) ? 0 : !NULL, $
                                         TRANSPARENCY=(iPlot EQ 2 ? !NULL : transparency), $
                                         ;; TRANSPARENCY=transparency, $
                                         MARGIN=margin, $
                                         LAYOUT=layout, $
                                         POSITION=position, $
                                         CLIP=clip, $
                                         LOCATION=location, $
                                         OVERPLOT=KEYWORD_SET(overplot) OR iPlot GT 0, $
                                         BUFFER=buffer, $
                                         CURRENT=window)
           
           IF iPlot EQ 0 THEN BEGIN
              plotArr[0].axes[0].Hide = 1
              plotArr[0].axes[2].Hide = 1
              plotArr[0].axes[3].Hide = 1
           ENDIF

        ENDFOR
     END
     ELSE: BEGIN

        nBoxPlots = N_ELEMENTS(BPD.data[*,0])
        xLocs     = INDGEN(nBoxPlots)

        iPlot               = 0
        plotArr[iPlot]      = BOXPLOT(xLocs, $
                                      BPD.data, $
                                      XRANGE=xRange, $
                                      YRANGE=yRange, $
                                      ;; NAME=plotNames[iPlot], $
                                      ;; NAME=plotNames[iPlot], $
                                      WIDTH=BPWidth, $
                                      WHISKERS=whiskers, $
                                      ENDCAPS=endCaps, $
                                      MEDIAN=median, $
                                      NOTCH=notch, $
                                      CI_VALUES=ci_values, $
                                      MEAN_VALUES=mean_values, $
                                      OUTLIER_VALUES=outlier_values, $
                                      SUSPECTED_OUTLIER_VALUES=suspected_outlier_values, $
                                      SYMBOL_MEANS=symbol_means, $
                                      SYMBOL_OUTLIERS=symbol_outliers, $
                                      SYMBOL_SUSPECTED_OUTLIERS=symbol_suspected_outliers, $
                                      ;; COLOR=colorArr, $
                                      ;; FILL_COLOR=colorArr[iPlot], $
                                      ;; FILL_COLOR=(iPlot EQ 2 ? 'light gray' : !NULL), $
                                      ;; FILL_COLOR=colorArr, $
                                      ;; BACKGROUND_COLOR=background_color, $
                                      LOWER_COLOR=lower_color, $
                                      LINESTYLE=lineStyle, $
                                      TRANSPARENCY=(iPlot EQ 2 ? !NULL : transparency), $
                                      ;; TRANSPARENCY=transparency, $
                                      MARGIN=margin, $
                                      LAYOUT=layout, $
                                      POSITION=position, $
                                      CLIP=clip, $
                                      LOCATION=location, $
                                      ;; OVERPLOT=KEYWORD_SET(overplot) OR iPlot GT 0, $
                                      OVERPLOT=KEYWORD_SET(overplot), $
                                      BUFFER=buffer, $
                                      CURRENT=window)


           IF iPlot EQ 0 THEN BEGIN
              plotArr[0].axes[0].Hide = 1
              plotArr[0].axes[2].Hide = 1
           ENDIF

     END
  ENDCASE

  IF KEYWORD_SET(add_boxplot_names) THEN BEGIN

     CASE KEYWORD_SET(stackEm) OF
        1: BEGIN
           IF KEYWORD_SET(legend__stackEm) THEN BEGIN
              legend          = LEGEND(TARGET=plotArr[*], $
                                       /NORMAL, $
                                       POSITION=[0.35,0.3])
           ENDIF
        END
        ELSE: BEGIN
           yLocs  = REFORM(plotData[*,2])

           bpNames = MAKE_ARRAY(nBoxPlots,/OBJ)
           FOR k=0,nBoxPlots-1 DO BEGIN
              ;; bpNames[k] = TEXT((xLocs[k])/(nBoxPlots+1),yLocation,BPD.name[k], $
              bpNames[k] = TEXT(xLocs[k],yLocs[k],plotNames[k], $
                                /DATA, $
                                CLIP=0, $
                                ALIGNMENT=0.5)
           ENDFOR
        END
     ENDCASE
  ENDIF

  IF KEYWORD_SET(add_column_text) THEN BEGIN
     colText = TEXT(x_vals[0], $
                    102, $
                    add_column_text, $
                    TARGET=plotArr[0], $
                    /DATA, $
                    ;; FONT_SIZE=xTickFont_size, $
                    FONT_SIZE=18, $
                    VERTICAL_ALIGNMENT=0.5, $
                    CLIP=0, $
                    ALIGNMENT=0.5)

  END

  ;; Add a title.
  ;; plotArr[0].title = "Storm ratios" + (KEYWORD_SET(plotTitle) ? "!C" + plotTitle : '')
  
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
     window.Save,pDir+spName

     IF KEYWORD_SET(close_window_after_save) THEN BEGIN
        window.Close
        window      = !NULL
     ENDIF

  ENDIF

  RETURN,plotArr
  
END

