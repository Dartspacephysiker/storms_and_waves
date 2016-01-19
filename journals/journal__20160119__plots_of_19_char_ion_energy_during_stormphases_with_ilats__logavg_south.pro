;2016/01/19
;Professor LaBelle want's a version of Figure 1 for the Southern Hemisphere
PRO JOURNAL__20160119__PLOTS_OF_19_CHAR_ION_ENERGY_DURING_STORMPHASES_WITH_ILATS__LOGAVG_SOUTH

  dstCutoff = -20

  maxInd    = 19

  plotSuff  = 'SOUTH--'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /MIRROR, $
                                       /CHARIEPLOTS, $
                                       /NONEGCHARIE, $
                                       /LOGCHARIEPLOT, $
                                       ;; CHARIEPLOTRANGE=[10^1.,10^2.2], $
                                       ;; CHARIEPLOTRANGE=[10^(0.0),10^(2.3010299)], $
                                       CHARIEPLOTRANGE=[1e0,1e2], $
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