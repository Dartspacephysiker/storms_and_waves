;2015/12/03
;En route pour Boston de Paris
PRO JOURNAL__20151209__PLOTS_OF_18_INTEG_ION_FLUX_UP_DURING_STORMPHASES_WITH_ILAT

  dstCutoff = -20

  ;;18-INTEG_ION_FLUX_UP
  maxInd    = 18
  ifpt      = 'integ_up'
  plotSuff  = '--inside_min_above_all_max'

  ;top range covers all, bottom range is higher than all range minima
  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /IONPLOTS, $
                                       IFLUXPLOTTYPE=ifpt, $
                                       /NONEGIFLUX, $
                                       /LOGIFPLOT, $
                                       IPLOTRANGE=[10^(8.2),10^(12.7)], $
                                       /LOGAVGPLOT, $
                                       ;; BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       PLOTSUFFIX=plotSuff, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       ;; SAVE_COMBINED_NAME=plotName, $
                                       /COMBINED_TO_BUFFER
                                       

END