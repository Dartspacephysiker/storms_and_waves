;;06/08/16
;;The heights--as wild as this database can
PRO JOURNAL__20160608__TEST_OUT_NEWELL_EFLUX_PLOTS_FOR_STORMPHASES__NONALFVEN__ALFVEN_CANDIDATES_REMOVED

  COMPILE_OPT IDL2,STRICTARRSUBS

  dstCutoff                      = -20

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 0
  eNumFluxPlot                   = 1
  ePlots                         = 1

  nonAlfven_flux_plots           = 1
  newell_analyze_eFlux           = 1
  nonAlfven__junk_alfven_candidates = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;bonus
  do_despun                      = 0

  divide_by_width_x              = 0

  save_alf_stormphase_indices    = 0

  fancyPresentationMode          = 1 ;Erases stormphase titles, suppresses gridlabels, and blows up plot titles. Keep it.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 60
  ;; maxILAT                        = 85
  ;; binILAT                        = 2.5

  hemi                           = 'SOUTH'
  minILAT                        = -85
  maxILAT                        = -60
  binILAT                        = 2.5

  binMLT                         = 1.5

  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;NEWELL PLOTS
  ;; newell_plotRange               = [1,1000] ;for pFlux multiplied by width_x
  ;; log_newellPlot                 = 1
  ;; newellPlot_autoscale           = 0
  ;; newellPlot_normalize           = 1
  ;; colorBar_for_all               = 1

  newellPlot_probOccurrence      = 0

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;EPlots
  ePlotRange                     = [10^(-1.0),10^(1.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = 'eflux_losscone_integ'
  eNumFlPlotRange                = [10^(8.0),10^(10.0)]

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
     EPLOTS=ePlots, $
     EPLOTRANGE=ePlotRange, $
     /NONEGEFLUX, $
     /LOGEFPLOT, $
     ENUMFLPLOTS=eNumFluxPlot, $
     ENUMFLPLOTTYPE=enumfpt, $
     /NONEGENUMFL, $            ;Because we're not interested in upflowing electrons
     /LOGENUMFLPLOT, $
     ENUMFLPLOTRANGE=eNumFlPlotRange, $
     NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
     NONALFVEN_FLUX_PLOTS=nonAlfven_flux_plots, $
     NONALFVEN__JUNK_ALFVEN_CANDIDATES=nonAlfven__junk_alfven_candidates, $
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
     SUPPRESS_TITLES=fancyPresentationMode, $
     ADD_CENTER_TITLE__STORMPHASE_PLOTS=fancyPresentationMode, $
     LABELS_FOR_PRESENTATION=fancyPresentationMode, $
     COLORBAR_FOR_ALL=colorBar_for_all, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER



END

