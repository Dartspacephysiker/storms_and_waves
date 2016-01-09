PRO JOURNAL__20160108__PLOTS_OF_08_ELEC_ENERGY_FLUX_DURING_STORMPHASES_WITH_ILATS__LOGAVG__CHARE_NEWELL_2009

  dstCutoff              = -20

  ;;08-ELEC_ENERGY_FLUX
  maxInd                 = 08
  efpt                   = 'MAX'
  ePlotRange             = [2e-1,2e1]
  ;; ePlotRange             = [0,1e2]

  ;2016/01/08 Checking it out
  ;; charERange = [4,300]
  ;; charERange = [300,4000]

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       CHARERANGE=charERange, $
                                       /EPLOTS, $
                                       EPLOTRANGE=ePlotRange, $                                       
                                       /LOGEFPLOT, $
                                       EFLUXPLOTTYPE=efpt, $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       /NORTH, $
                                       MINILAT=54, $
                                       /CB_FORCE_OOBHIGH, $
                                       /CB_FORCE_OOBLOW, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       /COMBINED_TO_BUFFER


END