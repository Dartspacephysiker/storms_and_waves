;;08/27/16
PRO BOXPLOT_DSTMIN_STATISTICS,BPDStr, $
                              ;; CI_VALUES=ci_values, $
                              ;; MEAN_VALUES=mean_values, $
                              ;; OUTLIER_VALUES=outlier_values, $                               
                              ;; SUSPECTED_OUTLIER_VALUES=suspected_outlier_values, $
                              SYMBOL_MEANS=symbol_means, $
                              SYMBOL_OUTLIERS=symbol_outliers, $
                              SYMBOL_SUSPECTED_OUTLIERS=symbol_suspected_outliers, $
                              BPWIDTH=BPWidth, $
                              PLOTTITLE=plotTitle, $
                              CLIP=clip, $
                              ENDCAPS=endCaps, $
                              MEDIAN=median, $
                              NOTCH=notch, $
                              LOWER_COLOR=lower_color, $
                              LINESTYLE=lineStyle, $
                              TRANSPARENCY=transparency, $
                              WHISKERS=whiskers, $
                              MARGIN=margin, $
                              LAYOUT=layout, $
                              POSITION=position, $
                              LOCATION=location, $
                              OVERPLOT=overplot, $
                              BUFFER=buffer, $
                              WINDOW=current
                              
                              
  IF 


  COMPILE_OPT IDL2

  wt_boxes = BOXPLOT(BPD, $
                     CI_VALUES=TAG_EXIST(BPDStr,"BPD_CI") ? BPDStr.BPD_CI : !NULL, $
                     ;; MEAN_VALUES=TAG_EXIST(BPDStr,"BPD_CI") ? BPDStr.BPD_CI : !NULL, $
                     OUTLIER_VALUES=outlier_values, $                               
                     SUSPECTED_OUTLIER_VALUES=suspected_outlier_values, $
                     SYMBOL_MEANS=symbol_means, $
                     SYMBOL_OUTLIERS=symbol_outliers, $
                     SYMBOL_SUSPECTED_OUTLIERS=symbol_suspected_outliers, $
                     MEDIAN=median, $
                     NOTCH=notch, $
                     LOWER_COLOR=lower_color, $
                     LINESTYLE=lineStyle, $
                     TRANSPARENCY=transparency, $
                     WHISKERS=whiskers, $
                     MARGIN=margin, $
                     LAYOUT=layout, $
                     POSITION=position, $
                     XTITLE="Dst minimum (nT)", $
                     TITLE=plotTitle, $
                     CLIP=clip, $
                     ENDCAPS=endCaps, $
                     FILL_COLOR='white', $
                     WIDTH=BPWidth, $
                     WHISKERS=whiskers, $
                     LOCATION=location, $
                     OVERPLOT=overplot, $
                     BUFFER=buffer, $
                     BACKGROUND_COLOR="light gray", $
                     WINDOW=current)
  

END
