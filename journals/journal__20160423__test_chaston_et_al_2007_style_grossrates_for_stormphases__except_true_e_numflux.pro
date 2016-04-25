;2016/04/23 I've added a bunch of keywords with the specific goal of testing just how on earth they compare to what I've been doing
PRO JOURNAL__20160423__TEST_CHASTON_ET_AL_2007_STYLE_GROSSRATES_FOR_STORMPHASES__EXCEPT_TRUE_E_NUMFLUX

  nonstorm                         = 0
  altitudeRange                    = [2000,4175]

  altString                        = STRING(FORMAT='("altRange_",I0,"-",I0)', $
                                            altitudeRange[0],altitudeRange[1])
  plotSuff                         = altString

  ;; variance plots
  add_variance_plots               = 1
  var__rel_to_mean_variance        = 0
  var__autoscale                   = 1
  ;; var__plotRange                 = [0,0.5]

  divide_by_width_x                = 0 ;for ion plot and eflux plot
  multiply_by_width_x              = 1 ;for (true) eNumFl plot
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Which plots?
  probOccurrencePlot               = 0
  tHistDenominatorPlot             = 0
  nOrbsWithEventsPerContribOrbsPlot = 1
  orbContribPlot                   = 1
  ionPlots                         = 1
  eNumFlPlots                      = 1
  pPlots                           = 1

  ;;data opts
  do_timeAvg                       = 0
  do_grossRate_fluxQuantities      = 0
  do_grossRate_with_long_width     = 1
  div_fluxPlots_by_applicable_orbs = 1

  logAvgPlot                       = 0

  autoscale_fluxPlots              = 0

  colorbar_for_all                 = 1

  CASE 1 OF
     KEYWORD_SET(do_timeAvg):                       avgString   = '--timeAvgs'
     KEYWORD_SET(div_fluxPlots_by_applicable_orbs): avgString   = '--orbAvgs'
     ELSE:                                          avgString   = '--no_time_or_orb_avgd'
  ENDCASE

  CASE 1 OF
     KEYWORD_SET(do_grossRate_fluxQuantities):      grossString = '--mult_by_area'
     KEYWORD_SET(do_grossRate_with_long_width):     grossString = '--mult_by_longwidth'
     ELSE:                                          grossString = '--no_grossrate_stuff'
  ENDCASE

  grossRate_info_file            = '/SPENCEdata/Research/Cusp/storms_Alfvens/journals/journal__' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--storm_grossRates_estilo_Chaston_et_al_2007--' + altString + avgString + grossString + '--NOT_despun.txt'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 84

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -61

  ;; binILAT                        = 2.0
  binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 2.0
  ;; shiftMLT                       = 0.5

  ;;DB stuff
  do_despun                      = 0

  ;;Bonus
  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;;NOWEPCO
  nowepco_autoscale              = 1

  ;THISTDENOMINATORPLOT
  tHistDenomPlotAutoscale        = 1
  tHistDenomPlot_noMask          = 1

  ;;orbcontribplot
  orbContribAutoscale            = 1
  orbContrib_noMask              = 1

  ;; ;;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  ;;49--pFluxEst
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  ;; pPlotRange                     = [1e-3,5e-1] ;for time-averaged
  ;; logPFPlot                      = 1
  ;; pPlotRange                     = [0,5e-1] ;for time-averaged
  pPlotRange                     = [5e6,1e9] ;for time-averaged
  logPFPlot                      = 1

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                 = ['ESA_Number_flux','Eflux_Losscone_Integ']
  ;; eNumFlRange                   = [10.^(-3.0),10.^(-1.0)] ;for time-, space-averaged
  ;; logENumFlPlot                 = 1
  eNumFlRange                   = [[5e21,5e23],[5e6,1e9]] ;for time-, space-averaged
  logENumFlPlot                  = 1
  absENumFl                      = 0
  noNegeNumFl                    = 1
  autoscale_eNumFlplots          = 0

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  ;; iPlotRange                     = [10.^(5.0),10.^(7.0)] ;for time-averaged plot
  ;; logIFPlot                      = 1
  iPlotRange                     = [5e21,5e23] ;for time-averaged plot
  logIFPlot                      = 1

  PLOT_ALFVEN_STATS_DURING_STORMPHASES, $
     ALTITUDERANGE=altitudeRange, $
     CHARERANGE=charERange, $
     MASKMIN=maskMin, $
     HEMI=hemi, $
     BINMLT=binMLT, $
     SHIFTMLT=shiftMLT, $
     MINILAT=minILAT, $
     MAXILAT=maxILAT, $
     BINILAT=binILAT, $
     /MIDNIGHT, $
     DO_DESPUNDB=do_despun, $
     /DO_NOT_CONSIDER_IMF, $
     SMOOTHWINDOW=smoothWindow, $
     LOGAVGPLOT=logAvgPlot, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
     ADD_VARIANCE_PLOTS=add_variance_plots, $
     VAR__PLOTRANGE=var__plotRange, $
     VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
     VAR__AUTOSCALE=var__autoscale, $
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
     DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
     DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
     DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
     WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
     PPLOTS=pPlots, $
     THISTDENOMINATORPLOT=tHistDenominatorPlot, $
     THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
     THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
     THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
     THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
     NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
     NOWEPCO_RANGE=nowepco_range, $
     NOWEPCO_AUTOSCALE=nowepco_autoscale, $
     ORBCONTRIBPLOT=orbContribPlot, $
     ORBCONTRIBRANGE=orbContribRange, $
     ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
     ORBCONTRIB_NOMASK=orbContrib_noMask, $
     LOGORBCONTRIBPLOT=logOrbContribPlot, $
     LOGPFPLOT=logPFPlot, $
     PPLOTRANGE=pPlotRange, $
     ENUMFLPLOTS=eNumFlPlots, $
     ENUMFLPLOTTYPE=eNumFlPlotType, $
     ENUMFLPLOTRANGE=eNumFlRange, $
     AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
     LOGENUMFLPLOT=logENumFlPlot, $
     ABSENUMFL=absENumFl, $
     NONEGENUMFL=noNegeNumFl, $
     IONPLOTS=ionPlots, $
     IFLUXPLOTTYPE=iFluxPlotType, $
     /NONEGIFLUX, $
     COLORBAR_FOR_ALL=colorbar_for_all, $
     IPLOTRANGE=iPlotRange, $
     LOGIFPLOT=logIFPlot, $
     PLOTSUFFIX=plotSuff, $
     ;; /CB_FORCE_OOBHIGH, $
     ;; /CB_FORCE_OOBLOW, $
     /COMBINE_STORMPHASE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER



END