;;Just how much action, anyway?
PRO JOURNAL__20160627__PLOTS_OF_10_18_49__GROSS_RATES__DURING_STORMPHASES__PRE_NOV1999

  dstCutoff = -20
  
  do_despun                      = 1
  orbRange                       = [500,12670]

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
  binILAT                        = 2.5

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -60
  ;; binILAT                        = 2.5

  binMLT                         = 1.5

  maskMin                        = 10
  tHist_mask_bins_below_thresh   = 10

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = 'eflux_losscone_integ'
  eNumFlPlotRange                = [10^(5.0),10^(8.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifpt                           = 'INTEG_UP'
  iPlotRange                     = [10.^(20.0),10.^(23.0)]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;49--PFLUXEST
  pPlotRange                     = [10.^(5.0),10.^(8.0)] ;for pFlux divided by width_x and multiplied by area
  logPFPlot                      = 1
  ;; multiply_pFlux_by_width_x      = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]
  ;; logProbOccurrence              = 1

  grossRate_info_file            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + $
                                   '--grossRate_info--' + hemi + '--maxInds_10_18_49.txt'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES, $
     DSTCUTOFF=dstCutoff, $
     ORBRANGE=orbRange, $
     HEMI=hemi, $
     DO_DESPUNDB=do_despun, $
     MASKMIN=maskMin, $
     THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
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
     WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
   ;; DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
     ;; /LOGAVGPLOT, $
     /MIDNIGHT, $
     /CB_FORCE_OOBLOW, $
     /CB_FORCE_OOBHIGH, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER

END