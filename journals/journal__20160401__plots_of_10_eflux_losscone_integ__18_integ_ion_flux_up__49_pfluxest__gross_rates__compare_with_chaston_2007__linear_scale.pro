;2016/04/01 The idea here is to make plots directly analagous to those in Chaston et al. [2007], "How important are dispersive …"
PRO JOURNAL__20160401__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG__18_INTEG_ION_FLUX_UP__49_PFLUXEST__GROSS_RATES__COMPARE_WITH_CHASTON_2007__LINEAR_SCALE
  dstCutoff = -20

  ;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 1
  probOccurrencePlot             = 1
  eNumFluxPlot                   = 1
  pFluxPlot                      = 1

  divide_by_width_x              = 1
  do_timeAvg_fluxQuantities      = 1
  do_grossRate_fluxQuantities    = 1
  do_logAvg_the_timeAvg          = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 85

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -61

  binILAT                        = 2.5

  binMLT                         = 1.5

  maskMin                        = 5

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = 'eflux_losscone_integ'
  ;; eNumFlPlotRange                = [10^(4.5),10^(7.5)]
  ;; eNumFlPlotRange                = [10^(6.5),10^(8.5)]
  eNumFlPlotRange                = [0,5e8]
  logENumFlPlot                  = 0
  noNegeNumFl                    = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifpt                           = 'INTEG_UP'
  ;; iPlotRange                     = [10.^(21.0),10.^(24.0)]
  iPlotRange                     = [0,1e23]
  logIFPlot                      = 0
  noNegIFlux                     = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;49--PFLUXEST
  ;; pPlotRange                     = [10.^(6.5),10.^(8.5)] ;for pFlux divided by width_x and multiplied by area
  pPlotRange                     = [0,5e8] ;for pFlux divided by width_x and multiplied by area
  logPFPlot                      = 0
  ;; multiply_pFlux_by_width_x      = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]
  probOccurrenceRange            = [0,0.05]
  logProbOccurrence              = 0

  do_despun                      = 0

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
     NONEGIFLUX=noNegIFlux, $
     LOGIFPLOT=logIFPlot, $
     IPLOTRANGE=iPlotRange, $
     ENUMFLPLOTS=eNumFluxPlot, $
     ENUMFLPLOTTYPE=enumfpt, $
     NONEGENUMFL=noNegENumFl, $            ;Because we're not interested in upflowing electrons
     LOGENUMFLPLOT=logENumFlPlot, $
     ENUMFLPLOTRANGE=eNumFlPlotRange, $
     PPLOTS=pFluxPlot, $
     LOGPFPLOT=logPFPlot, $
     PPLOTRANGE=pPlotRange, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     ;; MULTIPLY_BY_WIDTH_X=multiply_pFlux_by_width_x, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     PLOTSUFFIX=plotSuff, $
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
     DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
     DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
     ;; /LOGAVGPLOT, $
     /MIDNIGHT, $
     ;; /CB_FORCE_OOBLOW, $
     /CB_FORCE_OOBHIGH, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER

END