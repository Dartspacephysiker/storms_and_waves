;2016/02/23
;;And try it again!!
;;PFLUXEST maxes out at 10 with the current config, so keep it!
PRO JOURNAL__20160224__PLOTS_OF_49_PFLUXEST__TIMEAVG_DURING_STORMPHASES

  dstCutoff = -20

  hemi                           = 'NORTH'

  ;; minILAT                        = 60
  ;; maxILAT                        = 85
  ;; binILAT                        = 5.0
  ;; binILAT                        = 2.5
  ;; binMLT                         = 1.0

  minILAT                        = 61
  maxILAT                        = 85
  binILAT                        = 3.0
  binMLT                         = 1.5

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -54
  ;; binILAT                        = 4.0

  maskMin                        = 10

  ;; ;;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]
  ;; logProbOccurrence              = 1

  ;;49--pFluxEst
  pPlotRange                     = [1e-2,1e0] ;for time-averaged
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
                                       ;; /PROBOCCURRENCEPLOT, $
                                       ;; LOGPROBOCCURRENCE=logProbOccurrence, $
                                       ;; PROBOCCURRENCERANGE=probOccurrenceRange, $
                                       /DO_TIMEAVG_FLUXQUANTITIES, $
                                       /PPLOTS, $
                                       LOGPFPLOT=logPFPlot, $
                                       PPLOTRANGE=pPlotRange, $
                                       /MIDNIGHT, $
                                       /CB_FORCE_OOBLOW, $
                                       /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END