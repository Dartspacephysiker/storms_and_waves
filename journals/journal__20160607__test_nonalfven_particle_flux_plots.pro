;;06/07/16
PRO JOURNAL__20160607__TEST_NONALFVEN_PARTICLE_FLUX_PLOTS

  COMPILE_OPT IDL2

  dstCutoff                      = -20

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 1
  eNumFluxPlot                   = 0
  ePlots                         = 0
  nonAlfven_flux_plots           = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;bonus
  do_despun                      = 0

  divide_by_width_x              = 0

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
  ;;EPlots
  ePlotRange                     = [10^(-1.0),10^(1.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = 'eflux_losscone_integ'
  ;; eNumFlPlotRange                = [10^(-1.0),10^(1.0)]
  eNumFlPlotRange                = [10^(8.0),10^(10.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifpt                           = 'INTEG_UP'
  iPlotRange                     = [10.^(6.0),10.^(9.0)]

  PLOT_ALFVEN_STATS_DURING_STORMPHASES, $
     DSTCUTOFF=dstCutoff, $
     HEMI=hemi, $
     DO_DESPUNDB=do_despun, $
     MASKMIN=maskMin, $
     BINMLT=binMLT, $
     MINILAT=minILAT, $
     MAXILAT=maxILAT, $
     BINILAT=binILAT, $
     EPLOTS=ePlots, $
     EPLOTRANGE=ePlotRange, $
     /NONEGEFLUX, $
     /LOGEFPLOT, $
     ENUMFLPLOTS=eNumFluxPlot, $
     ENUMFLPLOTTYPE=enumfpt, $
     /NONEGENUMFL, $            ;Because we're not interested in upflowing electrons
     /LOGENUMFLPLOT, $
     ENUMFLPLOTRANGE=eNumFlPlotRange, $
     IONPLOTS=ionPlots, $
     IFLUXPLOTTYPE=ifpt, $
     /NONEGIFLUX, $
     /LOGIFPLOT, $
     IPLOTRANGE=iPlotRange, $
     NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
     NONALFVEN_FLUX_PLOTS=nonAlfven_flux_plots, $
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
