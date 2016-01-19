;2016/01/19
;Professor LaBelle want's a version of Figure 1 for the Southern Hemisphere
PRO JOURNAL__20160119__PLOTS_OF_18_INTEG_ION_FLUX_UP_DURING_STORMPHASES_WITH_ILATS__LOGAVG__SOUTH

  dstCutoff = -20

  ;;18-INTEG_ION_FLUX_UP
  maxInd    = 18
  ifpt      = 'integ_up'
  plotSuff  = 'SOUTH--'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /MIRROR, $
                                       /IONPLOTS, $
                                       IFLUXPLOTTYPE=ifpt, $
                                       /NONEGIFLUX, $
                                       /LOGIFPLOT, $
                                       IPLOTRANGE=[1e8,1e12], $
                                       PLOTSUFFIX=plotSuff, $
                                       /LOGAVGPLOT, $
                                       /SOUTH, $
                                       BINMLT=1.5, $
                                       MAXILAT=-54, $
                                       /MIDNIGHT, $
                                       /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER

END