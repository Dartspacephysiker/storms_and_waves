;;This thing will do versions of Fig 1 for both hemispheres
PRO JOURNAL__20160402__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG__18_INTEG_ION_FLUX_UP__49_PFLUXEST__PROBOCCURRENCE_DURING_STORMPHASES__AVGED_INTEG_QUANTS
  dstCutoff = -20

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 1
  probOccurrencePlot             = 1
  eNumFluxPlot                   = 1
  pFluxPlot                      = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;bonus
  divide_by_width_x              = 1

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
     PLOTSUFFIX=plotSuff, $
     /LOGAVGPLOT, $
     /MIDNIGHT, $
     /CB_FORCE_OOBLOW, $
     /CB_FORCE_OOBHIGH, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER

END