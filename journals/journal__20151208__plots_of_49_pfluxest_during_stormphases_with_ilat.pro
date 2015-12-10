;2015/12/08
PRO JOURNAL__20151208__PLOTS_OF_49_PFLUXEST_DURING_STORMPHASES_WITH_ILAT

  dstCutoff = -20

  ;;49-PFLUXEST
  maxInd    = 49

  plotSuff  = 'above_lowVals'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PPLOTS, $
                                       /NONEGPFLUX, $
                                       /LOGPFPLOT, $
                                       PPLOTRANGE=[10^(-3.8),10^(-1.5)], $    ;Less than all values
                                       /LOGAVGPLOT, $
                                       PLOTSUFFIX=plotSuff, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER

  plotSuff  = 'inside_extremeVals'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PPLOTS, $
                                       /NONEGPFLUX, $
                                       /LOGPFPLOT, $
                                       PPLOTRANGE=[10^(-3.8),10^(-2.0)], $    ;Less than all values
                                       /LOGAVGPLOT, $
                                       PLOTSUFFIX=plotSuff, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER

  plotSuff  = 'outside_extremeVals'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PPLOTS, $
                                       /NONEGPFLUX, $
                                       /LOGPFPLOT, $
                                       PPLOTRANGE=[10^(-4.05),10^(-1.5)], $ ;encompasses all values for each phase
                                       /LOGAVGPLOT, $
                                       PLOTSUFFIX=plotSuff, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER
END