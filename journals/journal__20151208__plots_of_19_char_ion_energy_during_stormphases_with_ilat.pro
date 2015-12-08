;2015/12/08
PRO JOURNAL__20151208__PLOTS_OF_19_CHAR_ION_ENERGY_DURING_STORMPHASES_WITH_ILAT

  dstCutoff = -20

  ;;17-INTEG_ION_FLUX
  maxInd    = 19
  ifpt      = 'integ'
  plotSuff  = 'inside_extremeVals--'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /CHARIEPLOTS, $
                                       /NONEGCHARIE, $
                                       /LOGCHARIEPLOT, $
                                       ;; CHARIEPLOTRANGE=[10^0.5,10^2.5], $  ;encompasses all high and low vals
                                       CHARIEPLOTRANGE=[10^1.,10^2.], $      ; inside of highest and lowest vals
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
                                       /CHARIEPLOTS, $
                                       /NONEGCHARIE, $
                                       /LOGCHARIEPLOT, $
                                       CHARIEPLOTRANGE=[10^0.5,10^2.5], $  ;encompasses all high and low vals
                                       PLOTSUFFIX=plotSuff, $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END