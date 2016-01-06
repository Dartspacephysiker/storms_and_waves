PRO JOURNAL__20160106__PLOTS_OF_08_ELEC_ENERGY_FLUX_DURING_STORMPHASES_WITH_ILATS__LOGAVG__BOTH_HEMIS

  @journal__20160106__plot_defaults.pro

  dstCutoff              = -20

  ;;08-ELEC_ENERGY_FLUX
  maxInd                 = 08
  efpt                   = 'MAX'
  ePlotRange             = [2e-1,2e1]

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /EPLOTS, $
                                       EPLOTRANGE=ePlotRange, $                                       
                                       /LOGEFPLOT, $
                                       EFLUXPLOTTYPE=efpt, $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       HEMI=hemi, $
                                       MINILAT=54, $
                                       /CB_FORCE_OOBHIGH, $
                                       /CB_FORCE_OOBLOW, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END