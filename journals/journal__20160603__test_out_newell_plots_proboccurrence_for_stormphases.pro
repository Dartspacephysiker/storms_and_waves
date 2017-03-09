;;06/03/16
;;Now you know
PRO JOURNAL__20160603__TEST_OUT_NEWELL_PLOTS_PROBOCCURRENCE_FOR_STORMPHASES

  COMPILE_OPT IDL2,STRICTARRSUBS

  dstCutoff                      = -20

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 0
  probOccurrencePlot             = 0
  eNumFluxPlot                   = 0
  pFluxPlot                      = 0
  nPlots                         = 1
  newellPlots                    = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;bonus
  do_despun                      = 0

  divide_by_width_x              = 0

  save_alf_stormphase_indices    = 1

  fancyPresentationMode          = 1 ;Erases stormphase titles, suppresses gridlabels, and blows up plot titles. Keep it.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 85
  binILAT                        = 2.5

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -60
  ;; binILAT                        = 2.5

  binMLT                         = 1.5

  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;NEWELL PLOTS
  ;; newell_plotRange               = [1,1000] ;for pFlux multiplied by width_x
  ;; log_newellPlot                 = 1
  ;; newellPlot_autoscale           = 0
  ;; newellPlot_normalize           = 1
  ;; colorBar_for_all               = 1

  newellPlot_probOccurrence      = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = 'eflux_losscone_integ'
  eNumFlPlotRange                = [10^(-1.0),10^(1.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifpt                           = 'INTEG_UP'
  iPlotRange                     = [10.^(6.0),10.^(9.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;49--PFLUXEST
  ;; pPlotRange                     = [10.^(2.5),10.^(4.5)] ;for pFlux multiplied by width_x
  pPlotRange                     = [10.^(-1.0),10.^(1.0)] ;for pFlux multiplied by width_x AFTER I figured out I screwed up scaling with B
  logPFPlot                      = 1
  ;; multiply_pFlux_by_width_x      = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  maskMin                        = 10 ;since identification is better

  ;;;;;;;;;;;;;;;;;;;;;
  ;;N events
  nEventsPlotRange               = [10,5000]
  logNEventsPlot                 = 1

  PLOT_ALFVEN_STATS_DURING_STORMPHASES, $
     DSTCUTOFF=dstCutoff, $
     HEMI=hemi, $
     DO_DESPUNDB=do_despun, $
     MASKMIN=maskMin, $
     BINMLT=binMLT, $
     MINILAT=minILAT, $
     MAXILAT=maxILAT, $
     BINILAT=binILAT, $
     IONPLOTS=ionPlots, $
     IFLUXPLOTTYPE=ifpt, $
     /NONEGIFLUX, $
     /LOGIFPLOT, $
     IPLOTRANGE=iPlotRange, $
     ENUMFLPLOTS=eNumFluxPlot, $
     ENUMFLPLOTTYPE=enumfpt, $
     /NONEGENUMFL, $            ;Because we're not interested in upflowing electrons
     /LOGENUMFLPLOT, $
     ENUMFLPLOTRANGE=eNumFlPlotRange, $
     PPLOTS=pFluxPlot, $
     LOGPFPLOT=logPFPlot, $
     PPLOTRANGE=pPlotRange, $
     MULTIPLY_BY_WIDTH_X=multiply_pFlux_by_width_x, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     NEWELLPLOTS=newellPlots, $
     NEWELL_PLOTRANGE=newell_plotRange, $
     LOG_NEWELLPLOT=log_newellPlot, $
     NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
     NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
     NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
     NPLOTS=nPlots, $
     NEVENTSPLOTRANGE=nEventsPlotRange, $
     LOGNEVENTSPLOT=logNEventsPlot, $
     NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
     NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
     PLOTSUFFIX=plotSuff, $
     SAVE_ALF_STORMPHASE_INDICES=save_alf_stormphase_indices, $
     /LOGAVGPLOT, $
     /MIDNIGHT, $
     /CB_FORCE_OOBLOW, $
     /CB_FORCE_OOBHIGH, $
     NO_STORMPHASE_TITLES=fancyPresentationMode, $
     SUPPRESS_GRIDLABELS=fancyPresentationMode, $
     LABELS_FOR_PRESENTATION=fancyPresentationMode, $
     COLORBAR_FOR_ALL=colorBar_for_all, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER



END
