PRO JOURNAL__20160113__PLOTS_OF_16_ION_FLUX_UP_DURING_STORMPHASES_WITH_ILATS__LOGAVG

  dstCutoff              = -20

  ;;08-ELEC_ENERGY_FLUX
  maxInd                 = 16
  ifpt                   = 'MAX_UP'
  ;; iPlotRange             = [5e7,5e9]
  iPlotRange             = [10^(5.5),10^(8.5)]

  ;2016/01/08 Checking it out
  ;; charERange = [4,300]
  ;; charERange = [300,4000]

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       ;; CHARERANGE=charERange, $
                                       /IONPLOTS, $
                                       IPLOTRANGE=iPlotRange, $                                       
                                       /LOGIFPLOT, $
                                       IFLUXPLOTTYPE=ifpt, $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       /NORTH, $
                                       MINILAT=54, $
                                       /CB_FORCE_OOBHIGH, $
                                       /CB_FORCE_OOBLOW, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END