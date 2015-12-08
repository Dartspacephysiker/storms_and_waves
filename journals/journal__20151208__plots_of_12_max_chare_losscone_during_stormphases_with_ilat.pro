;2015/12/08
PRO JOURNAL__20151208__PLOTS_OF_12_MAX_CHARE_LOSSCONE_DURING_STORMPHASES_WITH_ILAT

  dstCutoff = -20

  ;;12-MAX_CHARE_LOSSCONE
  maxInd    = 12
  plotSuff  = 'inside_extremeVals--'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /CHAREPLOTS, $
                                       CHARETYPE='Losscone', $
                                       /NONEGCHARE, $
                                       /LOGCHAREPLOT, $
                                       CHAREPLOTRANGE=[10^(1.6),10^(3.0)], $   ; inside of highest and lowest vals
                                       PLOTSUFFIX=plotSuff, $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


  plotSuff  = 'outside_extremeVals--'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /CHAREPLOTS, $
                                       CHARETYPE='Losscone', $
                                       /NONEGCHARE, $
                                       /LOGCHAREPLOT, $
                                       CHAREPLOTRANGE=[10^(1.2),10^(3.4)], $   ;encompasses all high and low vals
                                       PLOTSUFFIX=plotSuff, $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END