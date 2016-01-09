;2016/01/01
;Welcome to the new year!
PRO JOURNAL__20160101__PLOTS_OF_18_INTEG_ION_FLUX_UP_DURING_STORMPHASES_WITH_ILAT__LOGAVG

  dstCutoff = -20

  ;;18-INTEG_ION_FLUX_UP
  maxInd    = 18
  ifpt      = 'integ_up'
  plotSuff  = '--inside_min_above_all_max'
  plotSuff  = '--inside_min_above_all_max--charerange_4_300eV'
  plotSuff  = '--inside_min_above_all_max--charerange_300_4000eV'

  ;top range covers all, bottom range is higher than all range minima
  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /IONPLOTS, $
                                       IFLUXPLOTTYPE=ifpt, $
                                       ;; CHARERANGE=[4,300], $
                                       CHARERANGE=[300,4000], $
                                       /NONEGIFLUX, $
                                       /LOGIFPLOT, $
                                       ;; IPLOTRANGE=[10^(8.2),10^(12.7)], $
                                       IPLOTRANGE=[1e8,1e12], $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       /NORTH, $
                                       MINILAT=54, $
                                       PLOTSUFFIX=plotSuff, $
                                       /CB_FORCE_OOBHIGH, $
                                       /CB_FORCE_OOBLOW, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER
                                       

END