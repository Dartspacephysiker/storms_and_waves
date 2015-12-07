;2015/12/03
;En route to Boston from Paris
;2015/12/07 Added stuff for combining these plots
PRO JOURNAL__20151203__PLOTS_OF_17_INTEG_ION_FLUX_DURING_STORMPHASES_WITH_ILAT

  dstCutoff = -20

  ;;17-INTEG_ION_FLUX
  maxInd    = 17
  ifpt      = 'integ'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /IONPLOTS, $
                                       IFLUXPLOTTYPE=ifpt, $
                                       /NONEGIFLUX, $
                                       /LOGIFPLOT, $
                                       IPLOTRANGE=[1e3,1e13], $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       ;; SAVE_COMBINED_NAME=plotName, $
                                       /COMBINED_TO_BUFFER

  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /IONPLOTS, $
  ;;                                      IFLUXPLOTTYPE=ifpt, $
  ;;                                      /NOPOSIFLUX, $
  ;;                                      /LOGIFPLOT, $
  ;;                                      IPLOTRANGE=[6e4,6e12], $
  ;;                                      /LOGAVGPLOT, $
  ;;                                      BINMLT=1.5, $
  ;;                                      /MIDNIGHT


END