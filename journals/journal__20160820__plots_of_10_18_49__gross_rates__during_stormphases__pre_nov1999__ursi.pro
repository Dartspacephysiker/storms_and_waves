;;2016/08/20
;;For that URSI paper
PRO JOURNAL__20160820__PLOTS_OF_10_18_49__GROSS_RATES__DURING_STORMPHASES__PRE_NOV1999__URSI

  dstCutoff = -20
  
  do_despun                      = 1
  ;; orbRange                       = [500,12670]
  ;; orbRange                       = [1000,10800]
  orbRange                       = [1000,12670]
  altRange                       = [[1000,4180]]

  ;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 1
  probOccurrencePlot             = 1
  eNumFluxPlots                  = 1
  ePlots                         = 1
  pFluxPlot                      = 1

  divide_by_width_x              = 1
  do_timeAvg_fluxQuantities      = 1
  do_grossRate_fluxQuantities    = 1
  do_logAvg_the_timeAvg          = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 60
  ;; maxILAT                        = 90
  ;; binILAT                        = 2.5

  hemi                           = 'SOUTH'
  minILAT                        = -90
  maxILAT                        = -60
  binILAT                        = 2.5

  binMLT                         = 1.5

  ;; maskMin                        = 10
  ;; tHist_mask_bins_below_thresh   = 5

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;08-ELEC_ENERGY_FLUX
  eFluxPlotType                  = 'Max'
  ePlotRange                     = [1e5,1e8]
  logEfPlot                      = 1
  noNegEflux                     = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = ['Eflux_Losscone_Integ', 'ESA_Number_flux']
  noNegENumFl                    = [1,1]
  logENumFlPlot                  = [1,1]
  ;; ENumFlPlotRange             = [[1e-1,1e1], $
  ;;                             [1e7,1e9]]
  eNumFlPlotRange                = [[10^(5.0),10^(8.0)], $
                                    [1e21,1e24]]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifpt                           = 'INTEG_UP'
  noNegIFlux                     = 1
  iPlotRange                     = [10.^(20.0),10.^(23.0)]
  logIFPlot                      = 1
  ;;;;;;;;;;;;;;;;;;;;;;
  ;;49--PFLUXEST
  pPlotRange                     = [10.^(5.0),10.^(8.0)] ;for pFlux divided by width_x and multiplied by area
  logPFPlot                      = 1
  ;; multiply_pFlux_by_width_x      = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1


  altStr                         = STRING(FORMAT='("orbs_",I0,"-",I0,"--",I0,"-",I0,"km")', $
                                          orbRange[0], $
                                          orbRange[1], $
                                          altRange[0], $
                                          altRange[1])

  plotPrefix                     = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

  grossRate_info_file            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + $
                                   '--grossRate_info--' + hemi + '--' + $
                                   altStr + '--maxInds_08_10_18_49.txt'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES, $
     DSTCUTOFF=dstCutoff, $
     ORBRANGE=orbRange, $
     ALTITUDERANGE=altRange, $
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
     NONEGIFLUX=noNegIFlux, $
     LOGIFPLOT=logIFPlot, $
     IPLOTRANGE=iPlotRange, $
     EPLOTS=ePlots, $
     EFLUXPLOTTYPE=eFluxPlotType, $
     EPLOTRANGE=ePlotRange, $
     NONEGEFLUX=noNegEFlux, $
     LOGEFPLOT=logEFPlot, $
     ENUMFLPLOTS=eNumFluxPlots, $
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
     PLOTPREFIX=plotPrefix, $
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