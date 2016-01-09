;2016/01/01
;Welcome to the new year!
PRO JOURNAL__20160101__PLOTS_OF_10_EFLUX_LOSSCONE_INTEG_DURING_STORMPHASES_WITH_ILATS__LOGAVG

  dstCutoff = -20

  ;;10-EFLUX_LOSSCONE_INTEG
  maxInd    = 10
  enumfpt   = 'eflux_losscone_integ'

  ;2016/01/08 Checking it out
  ;; charERange = [4,300]
  ;; charERange = [300,4000]

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /ENUMFLPLOTS, $
                                       ENUMFLPLOTTYPE=enumfpt, $
                                       CHARERANGE=charERange, $
                                       /NONEGENUMFL, $ ;Because we're not interested in upflowing electrons
                                       /LOGENUMFLPLOT, $
                                       ;; ENUMFLPLOTRANGE=[0,6], $
                                       ;; ENUMFLPLOTRANGE=[10^(1.75),10^(4.25)], $
                                       ;; ENUMFLPLOTRANGE=[10^(2.0),10^(4.60206)], $
                                       ENUMFLPLOTRANGE=[10^(2.0),10^(4.0)], $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       ;; BINILAT=2.0, $
                                       ;; MINILAT=56, $
                                       ;; BINLSHELL=2, $
                                       ;; /DO_LSHELL, $
                                       ;; /REVERSE_LSHELL, $
                                       /MIDNIGHT, $
                                       /NORTH, $
                                       MINILAT=54, $
                                       /CB_FORCE_OOBHIGH, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       ;; SAVE_COMBINED_NAME=plotName, $
                                       ;; /FANCY_PLOTNAMES, $
                                       /COMBINED_TO_BUFFER


END