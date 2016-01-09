PRO JOURNAL__20160109__PLOTS_OF_NEVENTS_DURING_STORMPHASES_WITH_ILATS

  dstCutoff              = -20

  maxInd                 = 08
  efpt                   = 'MAX'
  ePlotRange             = [2e-1,2e1]

  ;2016/01/08 Checking it out
  ;; charERange = [4,300]
  ;; charERange = [300,4000]

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       CHARERANGE=charERange, $
                                       /NPLOTS, $
                                       /LOGNEVENTSPLOT, $
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