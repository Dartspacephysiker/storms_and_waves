;;2015/11/24 Wowzers
;;At KSAT in Tromsø
PRO JOURNAL__20151124__HISTOPLOTS_OF_12_MAX_CHARE_LOSSCONE_DURING_STORMPHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;12--MAX_CHARE_LOSSCONE
  
  ;;normalized dayside, pos
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=12, $
     HISTBINSIZE_MAXIND=0.125, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0.9,4.5], $
     HISTYRANGE_MAXIND=[0,0.20], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     /ONLY_POS, $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr

  ;;normalized nightside, pos
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES, $
     MAXIND=12, $
     HISTBINSIZE_MAXIND=0.125, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0.9,4.5], $
     HISTYRANGE_MAXIND=[0,0.20], $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     /ONLY_POS, $
     /NORMALIZE_MAXIND_HIST, $
     PLOTTITLE='Dayside--black Nightside--red (Only positive vals)', $
     PLOTSUFFIX='dayside_black--nightside_red--only_pos', $
     /SAVEPLOT, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

END