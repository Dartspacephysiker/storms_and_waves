;;2016/09/14
;;Trying some things Jim suggested
;;1. Put thresh on statistics
;;2. Fold NH and SH
PRO JOURNAL__20161118__PLOTS_OF_10_18_49__DURING_STORMPHASES__FINALIZE_URSI_FIG__INCLUDE_GROSS_INTEGRALS

  dstCutoff                    = -20
  ;; use_mostRecent_Dst_files  = 1

  do_despun                    = 0
  ;; orbRange                  = [500,12670]
  ;; orbRange                  = [1000,10800]
  orbRange                     = [1000,10600]
  altRange                     = [[300,4180]]

  justData                     = 0

  EA_binning                   = 1

  use_AACGM                    = 1

  minMC                        = 1
  maxNegMC                     = -1

  show_integrals               = 1

  ;;;;;;;;;;;;;;;;;
  ;;turn plots on and off
  ionPlots                       = 1
  probOccurrencePlot             = 1
  eNumFluxPlots                  = 1
  ePlots                         = 1
  pFluxPlot                      = 1
  tHistDenominatorPlot           = 1
  nPlots                         = 1

  divide_by_width_x              = 1
  do_timeAvg_fluxQuantities      = 1
  do_grossRate_fluxQuantities    = 0
  do_logAvg_the_timeAvg          = 0

  add_variance_plots             = 0
  only_variance_plots            = 0
  var__rel_to_mean_variance      = 0

  ;;Variance plots?
  ;; var__plotRange                 =  [[0.0,1.0], $
  ;;                                    [0.0,1.0], $
  ;;                                    [0.4,2.0]]
  var__plotRange                 = !NULL ;populate as we go

  var__do_stddev_instead         = 0

  fancyPresentationMode          = 1 ;Erases stormphase titles, 
                                     ;suppresses gridlabels, blows up plot titles. Keep it.

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Hemi stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 90

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -90
  ;; maxILAT                        = -60
  ;; orbRange                       = [2000,10600]

  ;; binILAT                        = 2.5
  ;; binMLT                         = 1.5

  ;; maskMin                        = 5
  ;; tHist_mask_bins_below_thresh   = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;08-ELEC_ENERGY_FLUX
  eFluxPlotType                  = 'Max'
  ;; ePlotRange                     = [1e5,1e8]
  ePlotRange                     = [1e-3,1e0]
  logEfPlot                      = 1
  noNegEflux                     = 1
  eFluxVarPlotRange              = [1e1,1e8]
  var__plotRange                 = [[var__plotRange],[eFluxVarPlotRange]]
  
  ;;;;;;;;;;;;;;;;;;;;;;
  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd                         = 10
  enumfpt                        = ['Eflux_Losscone_Integ', 'ESA_Number_flux']
  noNegENumFl                    = [1,1]
  logENumFlPlot                  = [1,1]
  ;; ENumFlPlotRange             = [[1e-1,1e1], $
  ;;                             [1e7,1e9]]
  ;; eNumFlPlotRange                = [[10^(5.0),10^(8.0)], $
  ;;                                   [1e21,1e24]]
  eNumFlPlotRange                = [[1e-3,1e0], $
                                    [1e7,1e9]]
  eNumFlVarPlotRange             = [[1e1,1e8], $
                                    [1e1,1e8]]
  var__plotRange                 = [[var__plotRange],[eNumFlVarPlotRange]]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;18-INTEG_ION_FLUX_UP
  maxInd                         = 18
  ifpt                           = 'INTEG_UP'
  noNegIFlux                     = 1
  iPlotRange                     = [1e6,1e8]
  logIFPlot                      = 1
  iVarPlotRange                  = [1e1,1e8]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;49--PFLUXEST
  pPlotRange                     = [1e-3,1e0] ;for pFlux divided by width_x and multiplied by area
  logPFPlot                      = 1
  ;; multiply_pFlux_by_width_x      = 1
  pVarPlotRange                  = [1e1,1e8]
  var__plotRange                 = [[var__plotRange],[pVarPlotRange]]

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;Time histogram               
  tHistDenomPlotRange            = [0,300]
  ;; tHistDenomPlotAutoscale        = 1
  ;; tHistDenomPlotNormalize        = 0
  tHistDenomPlot_noMask          = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;N Events
  nEventsPlotRange               = [0,500]
  nEventsPlot__noMask            = 1

  ;;;;;;;;;;;;;;;;;;;;;;
  ;PROBOCCURRENCE
  probOccurrenceRange  = [1e-3,1e-1]
  logProbOccurrence    = 1


  altStr               = STRING(FORMAT='("orbs_",I0,"-",I0,"--",I0,"-",I0,"km")', $
                                orbRange[0], $
                                orbRange[1], $
                                altRange[0], $
                                altRange[1])

  plotPrefix           = (KEYWORD_SET(plotPref) ? plotPref : '') + altStr

  ;; grossRate_info_file  = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + $
  ;;                        '--grossRate_info--' + hemi + '--' + $
  ;;                        altStr + $
  ;;                        (KEYWORD_SET(tHist_mask_bins_below_thresh) ? '--tThresh_'+ $
  ;;                         STRCOMPRESS(tHist_mask_bins_below_thresh,/REMOVE_ALL) : '') + $
  ;;                        (KEYWORD_SET(maskMin) ? '--maskMin_'+ $
  ;;                         STRCOMPRESS(maskMin,/REMOVE_ALL) : '') + $
  ;;                        '--maxInds_08_10_18_49.txt'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES, $
     DSTCUTOFF=dstCutoff, $
     ;; USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
     ORBRANGE=orbRange, $
     ALTITUDERANGE=altRange, $
     NUMORBLIM=numOrbLim, $
     HEMI=hemi, $
     DO_DESPUNDB=do_despun, $
     USE_AACGM=use_aacgm, $
     MASKMIN=maskMin, $
     THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
     THISTDENOMINATORPLOT=tHistDenominatorPlot, $
     THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
     THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
     THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
     THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
     BINMLT=binMLT, $
     MINILAT=minILAT, $
     MAXILAT=maxILAT, $
     BINILAT=binILAT, $
     MIN_MAGCURRENT=minMC, $
     MAX_NEGMAGCURRENT=maxNegMC, $
     EQUAL_AREA_BINNING=EA_binning, $
     NPLOTS=nPlots, $
     NEVENTSPLOTRANGE=nEventsPlotRange, $
     NEVENTSPLOT__NOMASK=nEventsPlot__noMask, $
     LOGNEVENTSPLOT=logNEventsPlot, $
     NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
     NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
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
     ADD_VARIANCE_PLOTS=add_variance_plots, $
     ONLY_VARIANCE_PLOTS=only_variance_plots, $
     VAR__PLOTRANGE=var__plotRange, $
     VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
     VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
     JUSTDATA=justData, $
     /MIDNIGHT, $
     /CB_FORCE_OOBLOW, $
     /CB_FORCE_OOBHIGH, $
     NO_STORMPHASE_TITLES=fancyPresentationMode, $
     SUPPRESS_GRIDLABELS=fancyPresentationMode, $
     SUPPRESS_TITLES=fancyPresentationMode, $
     ADD_CENTER_TITLE__STORMPHASE_PLOTS=fancyPresentationMode, $
     LABELS_FOR_PRESENTATION=fancyPresentationMode, $
     SHOW_INTEGRALS=show_integrals, $
     MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
     MAKE_INTEGRAL_SAVFILE=make_integral_savfiles, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER

END

