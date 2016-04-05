;;This thing will do versions of Fig 1 for both hemispheres
PRO JOURNAL__20160405__PLOTS_OF_11_NEG_TOTAL_EFLUX_INTEG__18_NEG_INTEG_ION_FLUX__DURING_STORMPHASES__AVGED_INTEG_QUANTS
  dstCutoff = -20

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 1
  eNumFluxPlot                   = 1
  nEvents                        = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;bonus
  divide_by_width_x              = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  hemi                           = 'BOTH'
  minILAT                        = 60
  maxILAT                        = 85
  binILAT                        = 5.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -60
  ;; binILAT                        = 2.5

  binMLT                         = 6.0
  shiftMLT                       = 3.0

  maskMin                        = 5

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 11
  enumfpt                        = 'TOTAL_EFLUX_INTEG'
  ;; eNumFlPlotRange                = [10^(-1.5),10^(0.0)]
  ;; logENumFlPlot                  = 1
  eNumFlPlotRange                = [0.85,1.05]
  logENumFlPlot                  = 0
  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 17
  ifpt                           = 'INTEG'
  iPlotRange                     = [10.^(1.0),10.^(6.0)]

  nEventsPlotRange               = [0,100]

  ;;;;;;;;;;;;;;;;;;;;;;
  do_despun                      = 1
  maskMin                        = 5

  PLOT_ALFVEN_STATS_DURING_STORMPHASES, $
     DSTCUTOFF=dstCutoff, $
     HEMI=hemi, $
     DO_DESPUNDB=do_despun, $
     MASKMIN=maskMin, $
     BINMLT=binMLT, $
     SHIFTMLT=shiftMLT, $
     MINILAT=minILAT, $
     MAXILAT=maxILAT, $
     BINILAT=binILAT, $
     IONPLOTS=ionPlots, $
     IFLUXPLOTTYPE=ifpt, $
     NPLOTS=nEvents, $
     NEVENTSPLOTRANGE=nEventsPlotRange, $
     /NOPOSIFLUX, $
     /LOGIFPLOT, $
     IPLOTRANGE=iPlotRange, $
     ENUMFLPLOTS=eNumFluxPlot, $
     ENUMFLPLOTTYPE=enumfpt, $
     /NOPOSENUMFL, $            ;Because we're not interested in upflowing electrons
     LOGENUMFLPLOT=logENumFlPlot, $
     ENUMFLPLOTRANGE=eNumFlPlotRange, $
     MULTIPLY_BY_WIDTH_X=multiply_pFlux_by_width_x, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     PLOTSUFFIX=plotSuff, $
     /LOGAVGPLOT, $
     /MIDNIGHT, $
     /CB_FORCE_OOBLOW, $
     /CB_FORCE_OOBHIGH, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER

END