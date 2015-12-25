;2015/12/25

PRO JOURNAL__20151225__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG_DURING_STORMPHASES_WITH_ILATS__MEDIAN

  dstCutoff = -20

  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd    = 10
  enumfpt   = 'eflux_losscone_integ'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /ENUMFLPLOTS, $
                                       ENUMFLPLOTTYPE=enumfpt, $
                                       /NONEGENUMFL, $ ;Because we're not interested in upflowing electrons
                                       /LOGENUMFLPLOT, $
                                       ;; ENUMFLPLOTRANGE=[0,6], $
                                       ;; ENUMFLPLOTRANGE=[10^(1.75),10^(4.25)], $
                                       ENUMFLPLOTRANGE=[10^(2.0),10^(4.60206)], $
                                       ;; /LOGAVGPLOT, $
                                       /MEDIANPLOT, $
                                       BINMLT=1.5, $
                                       ;; BINILAT=2.0, $
                                       ;; MINILAT=56, $
                                       ;; BINLSHELL=2, $
                                       ;; /DO_LSHELL, $
                                       ;; /REVERSE_LSHELL, $
                                       /MIDNIGHT, $
                                       /NORTH, $
                                       MINILAT=54, $
                                       ;; /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       ;; SAVE_COMBINED_NAME=plotName, $
                                       /COMBINED_TO_BUFFER


  ;;11-TOTAL_EFLUX_INTEG
  ;; maxInd    = 11
  ;; enumfpt   = 'total_eflux_integ'

  ;; PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
  ;;                                      /ENUMFLPLOTS, $
  ;;                                      ENUMFLPLOTTYPE=enumfpt, $
  ;;                                      /NONEGENUMFL, $     ;Because we're not interested in upflowing electrons
  ;;                                      /LOGENUMFLPLOT, $
  ;;                                      ;; ENUMFLPLOTRANGE=[0,6], $
  ;;                                      ENUMFLPLOTRANGE=[1.5e1,5e4], $
  ;;                                      /LOGAVGPLOT, $
  ;;                                      BINMLT=1.5, $
  ;;                                      ;; /DO_LSHELL, $
  ;;                                      ;; /REVERSE_LSHELL, $
  ;;                                      /MIDNIGHT, $
  ;;                                      MINILAT=54, $
  ;;                                      /COMBINE_STORMPHASE_PLOTS, $
  ;;                                      /SAVE_COMBINED_WINDOW, $
  ;;                                      ;; SAVE_COMBINED_NAME=plotName, $
  ;;                                      /COMBINED_TO_BUFFER

END