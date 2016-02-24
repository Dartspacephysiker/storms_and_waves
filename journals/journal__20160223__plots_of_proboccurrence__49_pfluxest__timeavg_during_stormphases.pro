;2016/02/23
;;And try it again!!
PRO JOURNAL__20160223__PLOTS_OF_PROBOCCURRENCE__49_PFLUXEST__TIMEAVG_DURING_STORMPHASES

  dstCutoff = -20

  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 86
  binILAT                        = 5.0
  ;; binILAT                        = 2.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -54
  ;; binILAT                        = 4.0

  binMLT                         = 1.0

  maskMin                        = 10

  ;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  ;;49--pFluxEst
  pPlotRange                     = [1e-3,1e1] ;for time-averaged
  logPFPlot                      = 1

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
                                       /DO_TIMEAVG_FLUXQUANTITIES, $
                                       ;; /PPLOTS, $
                                       ;; LOGPFPLOT=logPFPlot, $
                                       ;; PPLOTRANGE=pPlotRange, $
                                       PLOTSUFFIX=plotSuff, $
                                       /MIDNIGHT, $
                                       /CB_FORCE_OOBLOW, $
                                       ;; /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END