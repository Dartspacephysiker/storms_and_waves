;2016/02/20
PRO JOURNAL__20160220__PLOTS_OF_PROBOCCURRENCE_TIMEAVG_DURING_STORMPHASES

  dstCutoff = -20

  plotSuff  = '--inside_extremeVals'

  binMLT                         = 1.0

  ;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]

  ;Time-averaged pFlux
  timeAvgd_pFluxPlot             = 1
  timeAvgd_pFluxRange            = [1e-3,1e1]
  logTimeAvgd_pFlux              = 1

  ;Time-averaged pFlux
  timeAvgd_eFluxMaxPlot          = 1
  timeAvgd_eFluxMaxRange         = [1e-4,1e0]
  logtimeAvgd_eFluxMax           = 1

  do_despun                      = 1

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       ;; /MIRROR, $
                                       ;; /SOUTH, $
                                       ;; MAXILAT=-54, $
                                       /NORTH, $
                                       MINILAT=54, $
                                       /LOGAVGPLOT, $
                                       /PROBOCCURRENCEPLOT, $
                                       /LOGPROBOCCURRENCE, $
                                       ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
                                       PROBOCCURRENCERANGE=probOccurrenceRange, $
                                       TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                                       TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                                       LOGTIMEAVGD_PFLUX=logTimeAvgd_pFlux, $
                                       TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
                                       TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
                                       LOGTIMEAVGD_EFLUXMAX=logtimeAvgd_eFluxMax, $
                                       PLOTSUFFIX=plotSuff, $
                                       /MIDNIGHT, $
                                       BINMLT=binMLT, $
                                       /CB_FORCE_OOBLOW, $
                                       /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END