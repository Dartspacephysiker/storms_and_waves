;2016/01/01
;Welcome to the new year!
PRO JOURNAL__20160101__PLOTS_OF_49_PFLUXEST_DURING_STORMPHASES_WITH_ILAT__MAPPED_TO_IONOS__LOGAVG

  dstCutoff = -20

  ;;49-PFLUXEST
  maxInd    = 49

  plotSuff  = 'above_lowVals--pFlux_mapped_to_ionos'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PPLOTS, $
                                       /NONEGPFLUX, $
                                       /LOGPFPLOT, $
                                       ;; PPLOTRANGE=[10^(-0.5),10^(1.8)], $
                                       PPLOTRANGE=[2e-1,2e1], $
                                       /LOGAVGPLOT, $
                                       PLOTSUFFIX=plotSuff, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       /NORTH, $
                                       MINILAT=54, $
                                       /CB_FORCE_OOBLOW, $
                                       /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER

  ;; plotSuff  = 'inside_extremeVals--pFlux_mapped_to_ionos'

  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /PPLOTS, $
  ;;                                      /NONEGPFLUX, $
  ;;                                      /LOGPFPLOT, $
  ;;                                      PPLOTRANGE=[10^(-3.5),10^(-1.95)], $    ;Less than all values
  ;;                                      /LOGAVGPLOT, $
  ;;                                      PLOTSUFFIX=plotSuff, $
  ;;                                      BINMLT=1.5, $
  ;;                                      /MIDNIGHT, $
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      /COMBINED_TO_BUFFER

  ;; plotSuff  = 'outside_extremeVals--pFlux_mapped_to_ionos'

  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /PPLOTS, $
  ;;                                      /NONEGPFLUX, $
  ;;                                      /LOGPFPLOT, $
  ;;                                      PPLOTRANGE=[10^(-3.7),10^(-1.2)], $ ;encompasses all values for each phase
  ;;                                      /LOGAVGPLOT, $
  ;;                                      PLOTSUFFIX=plotSuff, $
  ;;                                      BINMLT=1.5, $
  ;;                                      /MIDNIGHT, $
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      /COMBINED_TO_BUFFER
END