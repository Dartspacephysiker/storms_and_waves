;;08/27/16
FUNCTION BOXPLOT_DSTMIN_STATISTICS,BPD, $
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
                                   WINDOW=current ;;  , $

  
  
  COMPILE_OPT idl2

  IF N_ELEMENTS(fill_color      ) EQ 0 THEN fill_color       = "light gray"
  IF N_ELEMENTS(background_color) EQ 0 THEN background_color = "white"
  IF N_ELEMENTS(clip            ) EQ 0 THEN clip             = 0

  nBoxPlots = N_ELEMENTS(BPD.data[*,0])
  xLocs      = (FINDGEN(nBoxPlots)+1)

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
  

  boxPlot = BOXPLOT(xLocs, $
                    BPD.data, $
                    TITLE=plotTitle, $
                    XRANGE=xRange, $
                    YRANGE=yRange, $
                    YTITLE="Dst minimum (nT)", $
                    ;; YTITLE=yTitle, $
                    ;; XMAJOR=0, $
                    ;; XMINOR=0, $
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
                    COLOR=color, $
                    FILL_COLOR=fill_color, $
                    BACKGROUND_COLOR=background_color, $
                    LOWER_COLOR=lower_color, $
                    LINESTYLE=lineStyle, $
                    TRANSPARENCY=transparency, $
                    MARGIN=margin, $
                    LAYOUT=layout, $
                    POSITION=position, $
                    CLIP=clip, $
                    LOCATION=location, $
                    OVERPLOT=overplot, $
                    BUFFER=buffer, $
                    WINDOW=current)
  

  boxPlot.axes[0].Hide = 1
  boxPlot.axes[2].Hide = 1

  IF KEYWORD_SET(add_boxplot_names) THEN BEGIN

     ;; xLocations = ((FINDGEN(nBoxPlots)+1)/(nBoxPlots+1))
     yLocation  = -5

     bpNames = MAKE_ARRAY(nBoxPlots,/OBJ)
     FOR k=0,nBoxPlots-1 DO BEGIN
        ;; bpNames[k] = TEXT((xLocs[k])/(nBoxPlots+1),yLocation,BPD.name[k], $
        bpNames[k] = TEXT((xLocs[k]),yLocation,BPD.name[k], $
                          /DATA, $
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

  RETURN,boxPlot

END
