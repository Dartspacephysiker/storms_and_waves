;2016/01/01
;Welcome to the new year!
PRO JOURNAL__20160101__PLOTS_OF_19_CHAR_ION_ENERGY_DURING_STORMPHASES_WITH_ILAT__LOGAVG

  dstCutoff = -20

  ;;19-CHAR_ION_ENERGY
  maxInd    = 19
  ;; ifpt      = 'integ'

  plotSuff  = 'above_lowVals'
  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /CHARIEPLOTS, $
                                       /NONEGCHARIE, $
                                       /LOGCHARIEPLOT, $
                                       ;; CHARIEPLOTRANGE=[10^1.,10^2.2], $
                                       ;; CHARIEPLOTRANGE=[10^(0.0),10^(2.3010299)], $
                                       CHARIEPLOTRANGE=[1e0,1e2], $
                                       PLOTSUFFIX=plotSuff, $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /CB_FORCE_OOBHIGH, $
                                       ;; /CB_FORCE_OOBLOW, $
                                       /NORTH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER

  ;; plotSuff  = 'inside_extremeVals--'
  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /CHARIEPLOTS, $
  ;;                                      /NONEGCHARIE, $
  ;;                                      /LOGCHARIEPLOT, $
  ;;                                      ;; CHARIEPLOTRANGE=[10^0.5,10^2.5], $  ;encompasses all high and low vals
  ;;                                      CHARIEPLOTRANGE=[10^1.,10^2.], $      ; inside of highest and lowest vals
  ;;                                      PLOTSUFFIX=plotSuff, $
  ;;                                      /LOGAVGPLOT, $
  ;;                                      BINMLT=1.5, $
  ;;                                      /MIDNIGHT, $
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      /COMBINED_TO_BUFFER


  ;; plotSuff  = 'outside_extremeVals--'

  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /CHARIEPLOTS, $
  ;;                                      /NONEGCHARIE, $
  ;;                                      /LOGCHARIEPLOT, $
  ;;                                      CHARIEPLOTRANGE=[10^0.5,10^2.5], $  ;encompasses all high and low vals
  ;;                                      PLOTSUFFIX=plotSuff, $
  ;;                                      /LOGAVGPLOT, $
  ;;                                      BINMLT=1.5, $
  ;;                                      /MIDNIGHT, $
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      /COMBINED_TO_BUFFER


END