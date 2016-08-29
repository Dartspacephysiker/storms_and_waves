;;08/29/16
FUNCTION BOXPLOT_STORMPERIOD_RATIOS, $
   BPD, $
   STACKEM=stackEm, $
   ADD_MEDIANS=add_medians, $
   INCLUDE_EXTRAS=include_extras, $
   EXCLUDE_MEAN_VALUES=exclude_mean_values, $          
   EXCLUDE_CI_VALUES=exclude_ci_values, $              
   EXCLUDE_OUTLIER_VALUES=exclude_outlier_values, $         
   EXCLUDE_SUSPECTED_OUTLIER_VALUES=exclude_suspected_outlier_values, $
   XRANGE=xRange, $
   YRANGE=yRange, $
   ADD_BOXPLOT_NAMES=add_boxplot_names, $
   SYMBOL_MEANS=symbol_means, $
   SYMBOL_OUTLIERS=symbol_outliers, $
   SYMBOL_SUSPECTED_OUTLIERS=symbol_suspected_outliers, $
   BPWIDTH=BPWidth, $
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

  COMPILE_OPT idl2

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
  
  nPlots          = KEYWORD_SET(stackEm) ? 3 : 1
  plotArr         = MAKE_ARRAY(nPlots,/OBJ)

  plotNames       = ['Quiescent','Main','Recovery']
  colorArr        = ['light gray','Red','Blue']
  lsArr           = ['-','-','-']

  yRange          = KEYWORD_SET(yRange) ? yRange : [MIN(BPD.data[*,0]),1.00]


  CASE KEYWORD_SET(stackEm) OF
     1: BEGIN

        plotDat = BPD.data
        IF KEYWORD_SET(add_medians) THEN BEGIN

           ;;Adds median of each previous bp
           FOR iPlot=0,nPlots-1 DO BEGIN

              j = iPlot+1
              WHILE j LE nPlots-1 DO BEGIN
                 plotDat[j,*] += plotDat[iPlot,2]
                 j++
              ENDWHILE
           ENDFOR

        ENDIF

        

        FOR iPlot=0,nPlots-1 DO BEGIN
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

           plotArr[iPlot]      = BOXPLOT(plotDat[iPlot,*], $
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
                                         COLOR=colorArr[iPlot], $
                                         ;; FILL_COLOR=colorArr[iPlot], $
                                         ;; BACKGROUND_COLOR=background_color, $
                                         LOWER_COLOR=lower_color, $
                                         LINESTYLE=lineStyle, $
                                         TRANSPARENCY=transparency, $
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
                                      ;; FILL_COLOR=colorArr, $
                                      ;; BACKGROUND_COLOR=background_color, $
                                      LOWER_COLOR=lower_color, $
                                      LINESTYLE=lineStyle, $
                                      TRANSPARENCY=transparency, $
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
           legend          = LEGEND(TARGET=plotArr[*], $
                                    /NORMAL, $
                                    POSITION=[0.35,0.3])
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


     ;; xLocations = ((FINDGEN(nBoxPlots)+1)/(nBoxPlots+1))


  ;; CASE SIZE(add_to_plotArr,/TYPE) OF
  ;;    1: BEGIN
  ;;       IF N_ELEMENTS(out_boxPlot) GT 0 THEN BEGIN
  ;;          out_boxPlot = [out_boxPlot,boxPlot]
  ;;       ENDIF ELSE BEGIN
  ;;          out_boxPlot = boxPlot
  ;;       ENDELSE
  ;;    END
  ;;    ELSE: out_boxPlot = boxPlot
  ;; ENDCASE
  ;; ENDIF

  ;; FOR iPlot=0,nPlots-1 DO BEGIN
  ;;    ;; PRINT,'Doing' + plotNames[i] + '...'

  ;;    ;;Get extras, if possible
  ;;    IF KEYWORD_SET(extras) THEN BEGIN
  ;;       IF N_ELEMENTS(ci_values) GT 0 THEN BEGIN
  ;;          tmpCi = ci_values[iPlot]
  ;;       ENDIF

  ;;       IF N_ELEMENTS(mean_values) GT 0 THEN BEGIN
  ;;          tmpMean = mean_values[iPlot]
  ;;       ENDIF

  ;;       IF N_ELEMENTS(outlier_values) GT 0 THEN BEGIN
  ;;          tmpWhere = WHERE(outlier_values[0,*] EQ iPlot,nTmp)
  ;;          IF nTmp GT 0 THEN BEGIN
  ;;             tmpOutlier = outlier_values[*,tmpWhere] 
  ;;          ENDIF ELSE BEGIN
  ;;             tmpOutlier = !NULL
  ;;          ENDELSE
  ;;       ENDIF

  ;;       IF N_ELEMENTS(suspected_outlier_values) GT 0 THEN BEGIN
  ;;          tmpWhere = WHERE(suspected_outlier_values[0,*] EQ iPlot,nTmp)
  ;;          IF nTmp GT 0 THEN BEGIN
  ;;             tmpSuspected_outlier = suspected_outlier_values[*,tmpWhere] 
  ;;          ENDIF ELSE BEGIN
  ;;             tmpSuspected_outlier = !NULL
  ;;          ENDELSE
  ;;       ENDIF
  ;;    ENDIF

  ;;    plotArr[iPlot]      = BOXPLOT(xLocs[iPlot], $
  ;;                                  ;; boxPlot         = BOXPLOT(xLocs, $
  ;;                                  BPD.data[iPlot,*], $
  ;;                                  XRANGE=xRange, $
  ;;                                  YRANGE=yRange, $
  ;;                                  NAME=plotNames[iPlot], $
  ;;                                  ;; NAME=plotNames[iPlot], $
  ;;                                  WIDTH=BPWidth, $
  ;;                                  WHISKERS=whiskers, $
  ;;                                  ENDCAPS=endCaps, $
  ;;                                  MEDIAN=median, $
  ;;                                  NOTCH=notch, $
  ;;                                  CI_VALUES=tmpCi, $
  ;;                                  MEAN_VALUES=tmpMean, $
  ;;                                  OUTLIER_VALUES=tmpOutlier, $
  ;;                                  SUSPECTED_OUTLIER_VALUES=tmpSuspected_outlier, $
  ;;                                  SYMBOL_MEANS=symbol_means, $
  ;;                                  SYMBOL_OUTLIERS=symbol_outliers, $
  ;;                                  SYMBOL_SUSPECTED_OUTLIERS=symbol_suspected_outliers, $
  ;;                                  ;; COLOR=colorArr, $
  ;;                                  FILL_COLOR=colorArr[iPlot], $
  ;;                                  ;; FILL_COLOR=colorArr, $
  ;;                                  ;; BACKGROUND_COLOR=background_color, $
  ;;                                  LOWER_COLOR=lower_color, $
  ;;                                  LINESTYLE=lineStyle, $
  ;;                                  TRANSPARENCY=transparency, $
  ;;                                  MARGIN=margin, $
  ;;                                  LAYOUT=layout, $
  ;;                                  POSITION=position, $
  ;;                                  CLIP=clip, $
  ;;                                  LOCATION=location, $
  ;;                                  OVERPLOT=KEYWORD_SET(overplot) OR iPlot GT 0, $
  ;;                                  ;; OVERPLOT=KEYWORD_SET(overplot), $
  ;;                                  BUFFER=buffer, $
  ;;                                  CURRENT=window)
     
  ;;    IF iPlot EQ 0 THEN BEGIN
  ;;       plotArr[0].axes[0].Hide = 1
  ;;       plotArr[0].axes[2].Hide = 1
  ;;    ENDIF

  ;; ENDFOR

  ;; Add a title.
  plotArr[0].title = "Storm ratios" + (KEYWORD_SET(plotTitle) ? "!C" + plotTitle : '')
  
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

