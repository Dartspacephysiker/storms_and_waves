;;2016/04/16 Im Wien. Based on output from my 2016/03/19 journal (ALT vs. IUIF), it looks like I ought to restrict the gross rate
;;calculations to being above 2000 km
PRO JOURNAL__20160419__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG__18_INTEG_ION_FLUX_UP__49_PFLUXEST__LOGAVG_VARIANCE__HIGHER_ALT__DURING_STORMPHASES
  dstCutoff = -20

  ;; altitudeRange                  = [2000,4180]
  ;; plotSuff                       = STRING(FORMAT='("--altRange_",I0,"-",I0)', $
  ;;                                         altitudeRange[0], $
  ;;                                         altitudeRange[1])
  ;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  eNumFluxPlot                   = 1
  pFluxPlot                      = 1
  ionPlots                       = 1
  probOccurrencePlot             = 0

  divide_by_width_x              = 1

  logAvgPlot                     = 1
  do_timeAvg_fluxQuantities      = 0
  do_grossRate_fluxQuantities    = 0
  do_logAvg_the_timeAvg          = 0

  add_variance_plots             = 1
  only_variance_plots            = 0
  var__rel_to_mean_variance      = 0

  var__plotRange                 =  [[0.0,1.0], $
                                     [0.0,1.0], $
                                     [0.4,2.0]]

  var__do_stddev_instead         = 0
  ;;for std. dev
  ;; var__plotRange                 = [[0.0,1.0], $
  ;;                                   [0.0,1.0], $
  ;;                                   [0.25,1.25]]

  colorbar_for_all               = 1
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 84
  binILAT                        = 3.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -83
  ;; maxILAT                        = -61
  ;; binILAT                        = 2.0

  binMLT                         = 2.0

  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = 'eflux_losscone_integ'
  ;; eNumFlPlotRange                = [10.^(-3.0),10.^(-1.0)]
  eNumFlPlotRange                = [10.^(-1.0),10.^(1.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifpt                           = 'INTEG_UP'
  ;; iPlotRange                     = [10.^(4.5),10.^(7.5)]  ;for time-averaged plot
  iPlotRange                     = [10.^(6),10.^(9)]  ;for time-averaged plot

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;49--PFLUXEST
  ;; eNumFlPlotRange                = [10.^(-3.0),10.^(-1.0)]
  pPlotRange                     = [10.^(-1.0),10.^(1.0)]
  logPFPlot                      = 1
  ;; multiply_pFlux_by_width_x      = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  do_despun                      = 0

  PLOT_ALFVEN_STATS_DURING_STORMPHASES, $
     DSTCUTOFF=dstCutoff, $
     HEMI=hemi, $
     ALTITUDERANGE=altitudeRange, $
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
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
     DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
     DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
     ADD_VARIANCE_PLOTS=add_variance_plots, $
     ONLY_VARIANCE_PLOTS=only_variance_plots, $
     VAR__PLOTRANGE=var__plotRange, $
     VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
     VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
     LOGAVGPLOT=logAvgPlot, $
     /MIDNIGHT, $
     PLOTSUFFIX=plotSuff, $
     COLORBAR_FOR_ALL=colorbar_for_all, $
     ;; /CB_FORCE_OOBLOW, $
     ;; /CB_FORCE_OOBHIGH, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER

END