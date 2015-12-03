;2015/11/30
PRO JOURNAL__20151203__PLOTS_OF_18_INTEG_ION_FLUX_UP_DURING_STORMPHASES_WITH_LSHELL


  dstCutoff = -20

  ;;18-INTEG_ION_FLUX_UP
  maxInd    = 18
  ifpt      = 'integ_up'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /IONPLOTS, $
                                       IFLUXPLOTTYPE=ifpt, $
                                       /NONEGIFLUX, $
                                       /LOGIFPLOT, $
                                       IPLOTRANGE=[1e5,1e15], $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       BINLSHELL=2, $
                                       /DO_LSHELL, $
                                       /REVERSE_LSHELL, $
                                       /MIDNIGHT

  ;;17-INTEG_ION_FLUX
  maxInd    = 17
  ifpt      = 'integ'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /IONPLOTS, $
                                       IFLUXPLOTTYPE=ifpt, $
                                       /NONEGIFLUX, $
                                       /LOGIFPLOT, $
                                       IPLOTRANGE=[1e5,1e15], $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /DO_LSHELL, $
                                       /REVERSE_LSHELL, $
                                       /MIDNIGHT

END