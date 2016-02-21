;2016/02/20
;Chris wants us to try some new plots
PRO JOURNAL__20160220__PLOTS_OF_PROBOCCURRENCE_TIMEAVG_DURING_STORMPHASES

  dstCutoff = -20

  hemi                           = 'NORTH'
  minILAT                        = 54
  ;; maxILAT                        = 86
  binILAT                        = 2.0
  ;; binILAT                        = 2.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -54
  ;; binILAT                        = 4.0

  binMLT                         = 1.5

  maskMin                        = 10

  ;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  ;Time-averaged pFlux
  timeAvgd_pFluxPlot             = 1
  ;; timeAvgd_pFluxRange            = [1e-4,1e0]
  timeAvgd_pFluxRange            = [10^(-3.5),10^(0.5)]
  logTimeAvgd_pFlux              = 1

  ;Time-averaged pFlux
  timeAvgd_eFluxMaxPlot          = 1
  timeAvgd_eFluxMaxRange         = [1e-4,1e0]
  logtimeAvgd_eFluxMax           = 1

  do_despun                      = 0

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       HEMI=hemi, $
                                       MINILAT=minILAT, $
                                       MAXILAT=maxILAT, $
                                       BINILAT=binILAT, $
                                       BINMLT=binMLT, $
                                       DO_DESPUNDB=do_despun, $
                                       MASKMIN=maskMin, $
                                       /LOGAVGPLOT, $
                                       /PROBOCCURRENCEPLOT, $
                                       LOGPROBOCCURRENCE=logProbOccurrence, $
                                       PROBOCCURRENCERANGE=probOccurrenceRange, $
                                       TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                                       TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                                       LOGTIMEAVGD_PFLUX=logTimeAvgd_pFlux, $
                                       TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
                                       TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
                                       LOGTIMEAVGD_EFLUXMAX=logtimeAvgd_eFluxMax, $
                                       PLOTSUFFIX=plotSuff, $
                                       /MIDNIGHT, $
                                       /CB_FORCE_OOBLOW, $
                                       /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END