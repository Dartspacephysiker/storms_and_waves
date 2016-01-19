;2016/01/19
;Professor LaBelle want's a version of Figure 1 for the Southern Hemisphere
PRO JOURNAL__20160119__PLOTS_OF_49_PFLUXEST_DURING_STORMPHASES_WITH_ILATS__MAPPED_TO_IONOS__LOGAVG__SOUTH

  dstCutoff = -20

  ;;49-PFLUXEST
  maxInd    = 49

  plotSuff  = 'pFlux_mapped_to_ionos--SOUTH'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /MIRROR, $
                                       /PPLOTS, $
                                       /NONEGPFLUX, $
                                       /LOGPFPLOT, $
                                       ;; PPLOTRANGE=[10^(-0.5),10^(1.8)], $
                                       PPLOTRANGE=[2e-1,2e1], $
                                       /LOGAVGPLOT, $
                                       PLOTSUFFIX=plotSuff, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       /SOUTH, $
                                       MAXILAT=-54, $
                                       /CB_FORCE_OOBLOW, $
                                       /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER

END