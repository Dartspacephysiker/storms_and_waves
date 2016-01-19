;2016/01/19
;Making a version of Figure 1 in the storm pape that only includes data from the Southern Hemisphere
PRO JOURNAL__20160119__PLOTS_OF_PROBOCCURRENCE_DURING_STORMPHASES_WITH_ILATS__COMBINED__SOUTH

  dstCutoff = -20

  plotSuff  = '--inside_extremeVals'
  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /MIRROR, $
                                       /SOUTH, $
                                       /PROBOCCURRENCEPLOT, $
                                       /LOGPROBOCCURRENCE, $
                                       ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
                                       PROBOCCURRENCERANGE=[1e-4,1e0], $
                                       PLOTSUFFIX=plotSuff, $
                                       /MIDNIGHT, $
                                       BINMLT=1.5, $
                                       MAXILAT=-54, $
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