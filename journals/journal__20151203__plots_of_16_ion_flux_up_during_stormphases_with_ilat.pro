;2015/12/03
;En route pour Boston de Paris
PRO JOURNAL__20151203__PLOTS_OF_16_ION_FLUX_UP_DURING_STORMPHASES_WITH_ILAT

  dstCutoff = -20

  ;;16-ION_FLUX_UP
  maxInd    = 16
  ifpt      = 'max_up'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /IONPLOTS, $
                                       IFLUXPLOTTYPE=ifpt, $
                                       /NONEGIFLUX, $
                                       /LOGIFPLOT, $
                                       IPLOTRANGE=[1e5,1.58489e9], $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT

END