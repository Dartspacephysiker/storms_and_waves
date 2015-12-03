;2015/12/03
;En route to Boston from Paris
PRO JOURNAL__20151203__PLOTS_OF_PROBOCCURRENCE_DURING_STORMPHASES_WITH_ILATS

  dstCutoff = -20

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /PROBOCCURRENCEPLOT, $
                                       /LOGPROBOCCURRENCE, $
                                       ;; PROBOCCURRENCERANGE=[1e-3,6e-1], $
                                       PROBOCCURRENCERANGE=[1e-4,1e0], $
                                       /MIDNIGHT

END