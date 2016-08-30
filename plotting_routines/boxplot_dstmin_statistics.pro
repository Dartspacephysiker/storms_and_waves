;;08/27/16
FUNCTION BOXPLOT_DSTMIN_STATISTICS, $
   BPD, $
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
   BP_LOCATIONS=bp_locations, $
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
   XMINOR=xMinor, $
   XTHICK=xThick, $
   YTHICK=yThick, $
   KILL_YTEXT=kill_yText, $
   THICK=thick, $
   TRANSPARENCY=transparency, $
   WHISKERS=whiskers, $
   MARGIN=margin, $
   LAYOUT=layout, $
   POSITION=position, $
   LOCATION=location, $
   OVERPLOT=overplot, $
   BUFFER=buffer, $
   CURRENT=window ;;  , $

  @plot_stormstats_defaults.pro

  COMPILE_OPT idl2

  ;; IF N_ELEMENTS(fill_color      ) EQ 0 THEN fill_color       = "light gray"
  ;; IF N_ELEMENTS(background_color) EQ 0 THEN background_color = "white"
  IF N_ELEMENTS(clip            ) EQ 0 THEN clip             = 0

  stackEm    = 1
  nBoxPlots  = KEYWORD_SET(stackEm) ? N_ELEMENTS(BPD.data[*,0]) : 1
  BPArr      = MAKE_ARRAY(nBoxPlots,/OBJ)

  xLocs      = KEYWORD_SET(bp_locations) ? bp_locations : (FINDGEN(nBoxPlots)+1)

  ;;Want stuff like outliers and stuff?
  extras = N_ELEMENTS(include_extras) GT 0 ? include_extras : 1

  IF KEYWORD_SET(extras) THEN BEGIN
     EXTRACT_BOXPLOT_EXTRAS__DST_STATISTICS, $
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
  

  CASE KEYWORD_SET(stackEm) OF
     1: BEGIN

        FOR iPlot=0,nBoxPlots-1 DO BEGIN

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
           

           BPArr[iPlot] = BOXPLOT([xLocs[iPlot]], $
                                  BPD.data[iPlot,*], $
                                  TITLE=plotTitle, $
                                  XRANGE=xRange, $
                                  YRANGE=yRange, $
                                  ;; YTITLE="Dst minimum (nT)", $
                                  WIDTH=N_ELEMENTS(BPWidth) EQ nBoxPlots ? $
                                  BPWidth[iPlot] : BPWidth, $
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
                                  COLOR=N_ELEMENTS(color) EQ nBoxPlots ? $
                                  color[iPlot] : color, $
                                  FILL_COLOR=N_ELEMENTS(fill_color) EQ nBoxPlots ? $
                                  fill_color[iPlot] : fill_color, $
                                  BACKGROUND_COLOR=background_color, $
                                  LOWER_COLOR=lower_color, $
                                  LINESTYLE=N_ELEMENTS(lineStyle) EQ nBoxPlots ? $
                                  lineStyle[iPlot] : lineStyle, $
                                  XMINOR=xMinor, $
                                  YSHOWTEXT=KEYWORD_SET(kill_yText) ? 0 : !NULL, $
                                  XTHICK=xThick, $
                                  YTHICK=yThick, $
                                  YTICKFONT_SIZE=yTickFont_size, $
                                  YTICKFONT_STYLE=yTickFont_style, $
                                  THICK=thick, $
                                  TRANSPARENCY=transparency, $
                                  MARGIN=margin, $
                                  LAYOUT=layout, $
                                  POSITION=position, $
                                  CLIP=clip, $
                                  LOCATION=location, $
                                  OVERPLOT=iPlot GT 0, $
                                  BUFFER=buffer, $
                                  CURRENT=window)
           

           IF iPlot EQ 0 THEN BEGIN
              BPArr[iPlot].axes[0].Hide = 1
              BPArr[iPlot].axes[2].Hide = 1
              BPArr[iPlot].axes[3].Hide = 1
           ENDIF

        ENDFOR
     END
     ELSE: BEGIN
        
        BPArr[0] = BOXPLOT([xLocs[iPlot]], $
                           BPD.data, $
                           TITLE=plotTitle, $
                           XRANGE=xRange, $
                           YRANGE=yRange, $
                           YTITLE="Dst minimum (nT)", $
                           WIDTH=N_ELEMENTS(BPWidth) EQ nBoxPlots ? $
                           BPWidth[iPlot] : BPWidth, $
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
                           COLOR=N_ELEMENTS(color) EQ nBoxPlots ? $
                           color[iPlot] : !NULL, $
                           FILL_COLOR=N_ELEMENTS(fill_color) EQ nBoxPlots ? $
                           fill_color[iPlot] : !NULL, $
                           BACKGROUND_COLOR=background_color, $
                           LOWER_COLOR=lower_color, $
                           LINESTYLE=lineStyle, $
                           XTHICK=xThick, $
                           YTHICK=yThick, $
                           THICK=thick, $
                           TRANSPARENCY=transparency, $
                           MARGIN=margin, $
                           LAYOUT=layout, $
                           POSITION=position, $
                           CLIP=clip, $
                           LOCATION=location, $
                           OVERPLOT=overplot, $
                           BUFFER=buffer, $
                           CURRENT=window)
        

        BPArr[0].axes[0].Hide = 1
        BPArr[0].axes[2].Hide = 1
        BPArr[0].axes[3].Hide = 1

     END
  ENDCASE

  IF KEYWORD_SET(add_boxplot_names) THEN BEGIN

     ;; xLocations = ((FINDGEN(nBoxPlots)+1)/(nBoxPlots+1))
     yLocation  = -10

     bpNames = MAKE_ARRAY(nBoxPlots,/OBJ)
     FOR k=0,nBoxPlots-1 DO BEGIN
        ;; bpNames[k] = TEXT((xLocs[k])/(nBoxPlots+1),yLocation,BPD.name[k], $
        bpNames[k] = TEXT((xLocs[k]),yLocation,BPD.name[k], $
                          /DATA, $
                          FONT_SIZE=yTickFont_size, $
                          TARGET=BPArr[*], $
                          CLIP=0, $
                          ALIGNMENT=0.5)
     ENDFOR

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
  ENDIF

  RETURN,BPArr

END
