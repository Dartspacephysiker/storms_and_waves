;;2016/04/16 Im Wien. How much variation in the action are we getting during stormtime, children?
PRO JOURNAL__20160416__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG__18_INTEG_ION_FLUX_UP__49_PFLUXEST__TIMEAVG_VARIANCE__DURING_STORMPHASES
  dstCutoff = -20

  ;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 1
  probOccurrencePlot             = 1
  eNumFluxPlot                   = 1
  pFluxPlot                      = 1

  divide_by_width_x              = 1
  do_timeAvg_fluxQuantities      = 1
  do_grossRate_fluxQuantities    = 0
  do_logAvg_the_timeAvg          = 0

  add_variance_plots             = 1
  only_variance_plots            = 0
  var__rel_to_mean_variance      = 1
  var__do_stddev_instead         = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 85
  binILAT                        = 2.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -83
  ;; maxILAT                        = -61
  ;; binILAT                        = 2.0

  binMLT                         = 1.5

  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = 'eflux_losscone_integ'
  eNumFlPlotRange                = [10.^(-3.0),10.^(-1.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifpt                           = 'INTEG_UP'
  iPlotRange                     = [10.^(4.5),10.^(7.5)]  ;for time-averaged plot

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;49--PFLUXEST
  eNumFlPlotRange                = [10.^(-3.0),10.^(-1.0)]
  logPFPlot                      = 1
  ;; multiply_pFlux_by_width_x      = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]
  ;; logProbOccurrence              = 1

  do_despun                      = 1

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
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     ;; MULTIPLY_BY_WIDTH_X=multiply_pFlux_by_width_x, $
     ;; PROBOCCURRENCEPLOT=probOccurrencePlot, $
     ;; LOGPROBOCCURRENCE=logProbOccurrence, $
     ;; PROBOCCURRENCERANGE=probOccurrenceRange, $
     PLOTSUFFIX=plotSuff, $
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
     DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
     DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
     ADD_VARIANCE_PLOTS=add_variance_plots, $
     ONLY_VARIANCE_PLOTS=only_variance_plots, $
     VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
     VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
     ;; /LOGAVGPLOT, $
     /MIDNIGHT, $
     /CB_FORCE_OOBLOW, $
     /CB_FORCE_OOBHIGH, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER

END