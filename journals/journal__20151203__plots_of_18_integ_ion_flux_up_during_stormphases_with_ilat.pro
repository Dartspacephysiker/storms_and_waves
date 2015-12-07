;2015/12/03
;En route pour Boston de Paris
PRO JOURNAL__20151203__PLOTS_OF_18_INTEG_ION_FLUX_UP_DURING_STORMPHASES_WITH_ILAT

  dstCutoff = -20

  ;;18-INTEG_ION_FLUX_UP
  maxInd    = 18
  ifpt      = 'integ_up'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /IONPLOTS, $
                                       IFLUXPLOTTYPE=ifpt, $
                                       /NONEGIFLUX, $
                                       /LOGIFPLOT, $
                                       IPLOTRANGE=[5e7,2e12], $
                                       /LOGAVGPLOT, $
                                       ;; BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       ;; SAVE_COMBINED_NAME=plotName, $
                                       /COMBINED_TO_BUFFER
                                       

END