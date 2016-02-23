;2016/02/23
;;And try it again!!
PRO JOURNAL__20160223__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG__18_INTEG_ION_FLUX_UP__TIME_AND_SPACEAVG_DURING_STORMPHASES

  dstCutoff = -20

  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 85
  binILAT                        = 3.0
  ;; binILAT                        = 2.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -54
  ;; binILAT                        = 4.0

  binMLT                         = 1.0

  maskMin                        = 10

   ;; 10-EFLUX_LOSSCONE_INTEG
   eNumFlPlotType                = 'Eflux_Losscone_Integ'
   eNumFlRange                   = [10^(-4.0),10^(0.0)]
   logENumFlPlot                 = 1
   noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  logIFPlot                      = 1

  do_despun                      = 1
  divide_by_width_x              = 1

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       HEMI=hemi, $
                                       MINILAT=minILAT, $
                                       MAXILAT=maxILAT, $
                                       BINILAT=binILAT, $
                                       BINMLT=binMLT, $
                                       DO_DESPUNDB=do_despun, $
                                       MASKMIN=maskMin, $
                                       /LOGAVGPLOT, $
                                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                       /DO_TIMEAVG_FLUXQUANTITIES, $
                                       /ENUMFLPLOTS, $
                                       LOGENUMFLPLOT=logeNumFlPlot, $
                                       ENUMFLPLOTRANGE=eNumFlRange, $
                                       ENUMFLPLOTTYPE=eNumFlPlotType, $
                                       /IONPLOTS, $
                                       LOGIFPLOT=logIFPlot, $
                                       IPLOTRANGE=iPlotRange, $
                                       IFLUXPLOTTYPE=iFluxPlotType, $
                                       PLOTSUFFIX=plotSuff, $
                                       /MIDNIGHT, $
                                       /CB_FORCE_OOBLOW, $
                                       /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END