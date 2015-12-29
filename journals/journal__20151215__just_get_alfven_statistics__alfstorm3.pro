;2015/12/15
;I just want to know how many Alfvén events occur during each phase, k?
;
;
;NORTHERN AND SOUTHERN HEMI
;+--------------------+--------------------+--------------------+--------------------+--------------------+
;|       Phase        |    Time (hours)    |   N Alfvén waves   |   Percentage of    |Percentage of Alfvén|
;|                    |                    |                    |  four-year period  | wave observations  |
;|                    |                    |                    |                    |                    |
;|                    |                    |                    |                    |                    |
;|                    |                    |                    |                    |                    |
;|                    |                    |                    |                    |                    |
;|                    |                    |                    |                    |                    |
;+--------------------+--------------------+--------------------+--------------------+--------------------+
;|     Non-storm      |       24213        |       136172       |        69.1        |       59.74        |
;|                    |                    |                    |                    |                    |
;|                    |                    |                    |                    |                    |
;+--------------------+--------------------+--------------------+--------------------+--------------------+
;|        Main        |        4670        |       50226        |        13.3        |       22.04        |
;|                    |                    |                    |                    |                    |
;|                    |                    |                    |                    |                    |
;+--------------------+--------------------+--------------------+--------------------+--------------------+
;|      Recovery      |        6165        |       41527        |        17.6        |       18.22        |
;|                    |                    |                    |                    |                    |
;|                    |                    |                    |                    |                    |
;+--------------------+--------------------+--------------------+--------------------+--------------------+
;|       TOTAL        |       35048        |       227925       |       100.00       |       100.00       |
;|                    |                    |                    |                    |                    |
;|                    |                    |                    |                    |                    |
;+--------------------+--------------------+--------------------+--------------------+--------------------+


PRO JOURNAL__20151215__JUST_GET_ALFVEN_STATISTICS__ALFSTORM3

  dstCutoff = -20

  ;;12-MAX_CHARE_LOSSCONE
  maxInd    = 12
  plotSuff  = 'inside_extremeVals--'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /CHAREPLOTS, $
                                       CHARETYPE='Losscone', $
                                       /NONEGCHARE, $
                                       /NORTH, $
                                       /LOGCHAREPLOT, $
                                       CHAREPLOTRANGE=[10^(1.6),10^(3.0)], $   ; inside of highest and lowest vals
                                       PLOTSUFFIX=plotSuff, $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54 ;, $
                                       ;; /COMBINE_STORMPHASE_PLOTS, $
                                       ;; /SAVE_COMBINED_WINDOW, $
                                       ;; /COMBINED_TO_BUFFER


  plotSuff  = 'outside_extremeVals--'

  PLOT_ALFVEN_STATS_DURING_STORMPHASES,DSTCUTOFF=dstCutoff, $
                                       /CHAREPLOTS, $
                                       CHARETYPE='Losscone', $
                                       /NONEGCHARE, $
                                       /LOGCHAREPLOT, $
                                       /NORTH, $
                                       CHAREPLOTRANGE=[10^(1.2),10^(3.4)], $   ;encompasses all high and low vals
                                       PLOTSUFFIX=plotSuff, $
                                       /LOGAVGPLOT, $
                                       BINMLT=1.5, $
                                       /MIDNIGHT, $
                                       MINILAT=54 ;, $
                                       ;; /COMBINE_STORMPHASE_PLOTS, $
                                       ;; /SAVE_COMBINED_WINDOW, $
                                       ;; /COMBINED_TO_BUFFER


END