;2015/12/25
;Yes, Christmas morning in Utah
PRO JOURNAL__20151225__PLOTS_OF_18_INTEG_ION_FLUX_UP_DURING_STORMPHASES_WITH_ILAT__MEDIAN

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
                                       ;; IPLOTRANGE=[10^(8.2),10^(12.7)], $
                                       IPLOTRANGE=[10^(8.0),10^(12.0)], $
                                       ;; /LOGAVGPLOT, $
                                       /MEDIANPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       /NORTH, $
                                       MINILAT=54, $
                                       PLOTSUFFIX=plotSuff, $
                                       /CB_FORCE_OOBHIGH, $
                                       /CB_FORCE_OOBLOW, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER
                                       

END