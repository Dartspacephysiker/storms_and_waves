;;2016/04/13 Now we can calculate probOccurrence à la Chaston et al. [2007]
PRO JOURNAL__20160413__PLOTS_OF_CHASTON2007_STYLE_PROBOCCURRENCE_DURING_STORMPHASES
  dstCutoff = -20

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 0
  probOccurrencePlot             = 1
  eNumFluxPlot                   = 0
  pFluxPlot                      = 0

  norbsWeventsPerOrbContribPlot  = 1
  nowepco_range                  = [0,0.52]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;bonus
  divide_by_width_x              = 1

  cb_force_oobLow                = 0
  cb_force_oobHigh               = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 84
  binILAT                        = 3.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -84
  ;; maxILAT                        = -60
  ;; binILAT                        = 3.0

  binMLT                         = 2.0

  maskMin                        = 10

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

  do_despun                      = 0
  maskMin                        = 10 ;since identification is better

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
     NORBSWITHEVENTSPERCONTRIBORBSPLOT=norbsWeventsPerOrbContribPlot, $
     PLOTSUFFIX=plotSuff, $
     /LOGAVGPLOT, $
     /MIDNIGHT, $
     CB_FORCE_OOBLOW=cb_force_oobLow, $
     CB_FORCE_OOBHIGH=cb_force_oobHigh, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER

END