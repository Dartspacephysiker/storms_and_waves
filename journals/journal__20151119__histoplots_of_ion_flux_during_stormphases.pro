;;2015/11/19 Wowzers
PRO JOURNAL__20151119__HISTOPLOTS_OF_ION_FLUX_DURING_STORMPHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ION_FLUX
  
  ;;normalized nightside
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=15, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[2,12], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     ;; PLOTSUFFIX='nightside', $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     /ONLY_POS
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=15, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[2,12], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /LOG_DBQUANTITY, $
     /NIGHTSIDE, $
     /SAVEPLOT, $
     PLOTSUFFIX='nightside--neg_and_pos_separ', $
     PLOTTITLE='Nightside', $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     /NORMALIZE_MAXIND_HIST, $
     OUTPLOTARR=outplotArr, $
     /ONLY_NEG, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND
  window.close
  delvar,pHP,window,outplotarr


  ;;normalized dayside, pos and neg
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=15, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[2,12], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     /ONLY_POS
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=15, $
     HISTBINSIZE_MAXIND=0.25, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[2,12], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /LOG_DBQUANTITY, $
     /DAYSIDE, $
     PLOTSUFFIX='dayside--neg_and_pos_separ', $
     /SAVEPLOT, $
     PLOTTITLE='Dayside', $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     /ONLY_NEG, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

END