;2016/01/19
;Professor LaBelle want's a version of Figure 1 for the Southern Hemisphere
PRO JOURNAL__20160119__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG_DURING_STORMPHASES_WITH_ILATS__LOGAVG__SOUTH

  dstCutoff = -20

  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd    = 10
  enumfpt   = 'eflux_losscone_integ'
  plotSuff  = 'SOUTH--'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /MIRROR, $
                                       /ENUMFLPLOTS, $
                                       ENUMFLPLOTTYPE=enumfpt, $
                                       /NONEGENUMFL, $ ;Because we're not interested in upflowing electrons
                                       /LOGENUMFLPLOT, $
                                       ENUMFLPLOTRANGE=[10^(2.0),10^(4.0)], $
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