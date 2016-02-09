;2016/02/05
;Friggin' fastloc ...
PRO JOURNAL__20160205__PLOTS_OF_PROBOCCURRENCE_DURING_STORMPHASES_WITH_ILATS__COMBINED__FASTLOCINTERVALS4

  dstCutoff = -20

  plotSuff  = '--inside_extremeVals'
  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       ;; /MIRROR, $
                                       ;; /SOUTH, $
                                       ;; MAXILAT=-54, $
                                       /NORTH, $
                                       MINILAT=54, $
                                       /LOGAVGPLOT, $
                                       /PROBOCCURRENCEPLOT, $
                                       /LOGPROBOCCURRENCE, $
                                       ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
                                       PROBOCCURRENCERANGE=[3e-3,3e-1], $
                                       PLOTSUFFIX=plotSuff, $
                                       /MIDNIGHT, $
                                       BINMLT=1.5, $
                                       /CB_FORCE_OOBLOW, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER
  
  ;; plotSuff  = '--outside_extremeVals'
  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /PROBOCCURRENCEPLOT, $
  ;;                                      /LOGPROBOCCURRENCE, $
  ;;                                      ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
  ;;                                      PROBOCCURRENCERANGE=[10^(-3.2),10^(-1.0)], $
  ;;                                      PLOTSUFFIX=plotSuff, $
  ;;                                      /MIDNIGHT, $
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      /COMBINED_TO_BUFFER

  ;; plotSuff  = '--above_all_lowVals'
  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /PROBOCCURRENCEPLOT, $
  ;;                                      /LOGPROBOCCURRENCE, $
  ;;                                      ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
  ;;                                      PROBOCCURRENCERANGE=[10^(-3.2),10^(-0.2)], $
  ;;                                      PLOTSUFFIX=plotSuff, $
  ;;                                      /MIDNIGHT, $
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      /COMBINED_TO_BUFFER


END