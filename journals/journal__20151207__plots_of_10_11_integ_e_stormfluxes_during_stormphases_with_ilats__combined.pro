;2015/11/30

;Notes
;2015/12/03 Used this again because there were some problems with hist_2d.pro
; when doing both hemis that have probably been affecting us for a while
PRO JOURNAL__20151207__PLOTS_OF_10_11_INTEG_E_STORMFLUXES_DURING_STORMPHASES_WITH_ILATS__COMBINED

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
                                       ENUMFLPLOTRANGE=[1.5e1,5e4], $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       ;; BINILAT=2.0, $
                                       ;; MINILAT=56, $
                                       ;; BINLSHELL=2, $
                                       ;; /DO_LSHELL, $
                                       ;; /REVERSE_LSHELL, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       ;; SAVE_COMBINED_NAME=plotName, $
                                       /COMBINED_TO_BUFFER


  ;;11-TOTAL_EFLUX_INTEG
  maxInd    = 11
  enumfpt   = 'total_eflux_integ'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /ENUMFLPLOTS, $
                                       ENUMFLPLOTTYPE=enumfpt, $
                                       /NONEGENUMFL, $     ;Because we're not interested in upflowing electrons
                                       /LOGENUMFLPLOT, $
                                       ;; ENUMFLPLOTRANGE=[0,6], $
                                       ENUMFLPLOTRANGE=[1.5e1,5e4], $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       ;; /DO_LSHELL, $
                                       ;; /REVERSE_LSHELL, $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       ;; SAVE_COMBINED_NAME=plotName, $
                                       /COMBINED_TO_BUFFER

END