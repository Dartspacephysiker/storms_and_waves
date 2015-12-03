;2015/12/03
;En route to Boston from Paris
PRO JOURNAL__20151203__PLOTS_OF_NEVENTS_DURING_STORMPHASES
  dstCutoff = -20

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /NPLOTS, $
                                       /LOGNEVENTSPLOT, $
                                       NEVENTSPLOTRANGE=[0,1e4], $
                                       /MIDNIGHT
                                       ;; HEMI='NORTH', $
                                       ;; /LOGAVGPLOT, $
                                       ;; BINMLT=1.5, $
                                       ;; /MIDNIGHT

END