PRO JOURNAL__20160104__PLOTS_OF_12_MAX_CHARE_LOSSCONE_DURING_STORMPHASES_WITH_ILATS__LOGAVG

  dstCutoff = -20

  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd    = 12
  enumfpt   = 'max_chare_losscone'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /CHAREPLOTS, $
                                       CHAREPLOTRANGE=[3e1,3e3], $
                                       /LOGCHAREPLOT, $
                                       CHARETYPE='LOSSCONE', $
                                       ;; /ENUMFLPLOTS, $
                                       ;; ENUMFLPLOTTYPE=enumfpt, $
                                       ;; /NONEGENUMFL, $ ;Because we're not interested in upflowing electrons
                                       ;; /LOGENUMFLPLOT, $
                                       ;; ENUMFLPLOTRANGE=[0,6], $
                                       ;; ENUMFLPLOTRANGE=[10^(1.75),10^(4.25)], $
                                       ;; ENUMFLPLOTRANGE=[10^(2.0),10^(4.60206)], $
                                       ;; ENUMFLPLOTRANGE=[10^(2.0),10^(4.0)], $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       ;; BINILAT=2.0, $
                                       ;; MINILAT=56, $
                                       ;; BINLSHELL=2, $
                                       ;; /DO_LSHELL, $
                                       ;; /REVERSE_LSHELL, $
                                       /MIDNIGHT, $
                                       /BOTH_HEMIS, $
                                       MINILAT=54, $
                                       ;; /CB_FORCE_OOBHIGH, $
                                       /CB_FORCE_OOBLOW, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       ;; SAVE_COMBINED_NAME=plotName, $
                                       ;; /FANCY_PLOTNAMES, $
                                       /COMBINED_TO_BUFFER


END