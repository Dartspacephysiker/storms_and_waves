;2015/12/07
;I want to try to combine these silly images.
PRO JOURNAL__20151207__PLOTS_OF_PROBOCCURRENCE_DURING_STORMPHASES_WITH_ILATS__COMBINED

  dstCutoff = -20

  ;; plotName  = 'stormphases--combined_probOccurrence.png'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PROBOCCURRENCEPLOT, $
                                       /LOGPROBOCCURRENCE, $
                                       ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
                                       PROBOCCURRENCERANGE=[1e-4,1e0], $
                                       /MIDNIGHT, $
                                       MINILAT=54, $
                                       /COMBINE_STORMPHASE_PLOTS, $
                                       /SAVE_COMBINED_WINDOW, $
                                       ;; SAVE_COMBINED_NAME=plotName, $
                                       /COMBINED_TO_BUFFER
  
END