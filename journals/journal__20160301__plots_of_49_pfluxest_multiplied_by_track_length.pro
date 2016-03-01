;2016/03/01 A plot requested by Chris
PRO JOURNAL__20160301__PLOTS_OF_49_PFLUXEST_MULTIPLIED_BY_TRACK_LENGTH

  dstCutoff = -20

  hemi                           = 'NORTH'
  minILAT                        = 54
  maxILAT                        = 86
  binILAT                        = 2.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -54
  ;; binILAT                        = 2.0

  binMLT                         = 1.5

  maskMin                        = 10

  ;; ;;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]
  ;; logProbOccurrence              = 1

  ;;49--pFluxEst
  pPlotRange                     = [10.^(2.5),10.^(4.5)] ;for pFlux multiplied by width_x
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
                                       /MULTIPLY_BY_WIDTH_X, $
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
