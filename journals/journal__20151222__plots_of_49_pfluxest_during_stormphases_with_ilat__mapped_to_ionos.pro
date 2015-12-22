;2015/12/22
;I've now got all the vals that map Poynting flux to the ionosphere
PRO JOURNAL__20151222__PLOTS_OF_49_PFLUXEST_DURING_STORMPHASES_WITH_ILAT__MAPPED_TO_IONOS

  dstCutoff = -20

  ;;49-PFLUXEST
  maxInd    = 49

  plotSuff  = 'above_lowVals--pFlux_mapped_to_ionos'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PPLOTS, $
                                       /NONEGPFLUX, $
                                       /LOGPFPLOT, $
                                       PPLOTRANGE=[10^(-3.5),10^(-1.2)], $    ;Less than all values
                                       /LOGAVGPLOT, $
                                       PLOTSUFFIX=plotSuff, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER

  plotSuff  = 'inside_extremeVals--pFlux_mapped_to_ionos'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PPLOTS, $
                                       /NONEGPFLUX, $
                                       /LOGPFPLOT, $
                                       PPLOTRANGE=[10^(-3.5),10^(-1.95)], $    ;Less than all values
                                       /LOGAVGPLOT, $
                                       PLOTSUFFIX=plotSuff, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER

  plotSuff  = 'outside_extremeVals--pFlux_mapped_to_ionos'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PPLOTS, $
                                       /NONEGPFLUX, $
                                       /LOGPFPLOT, $
                                       PPLOTRANGE=[10^(-3.7),10^(-1.2)], $ ;encompasses all values for each phase
                                       /LOGAVGPLOT, $
                                       PLOTSUFFIX=plotSuff, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER
END