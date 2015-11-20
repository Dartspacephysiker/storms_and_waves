;;2015/11/19 Wowzers
PRO JOURNAL__20151119__HISTOPLOTS_OF_CHAR_ION_ENERGY_DURING_STORMPHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;CHAR_ION_ENERGY
  
  ;;normalized nightside
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=19, $
     HISTBINSIZE_MAXIND=2.0, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0,250], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /NIGHTSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     ;; PLOTSUFFIX='nightside', $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     /ONLY_POS
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=19, $
     HISTBINSIZE_MAXIND=2.0, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0,250], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /NIGHTSIDE, $
     PLOTSUFFIX='nightside--neg_and_pos_separ', $
     PLOTTITLE='Nightside', $
     /SAVEPLOT, $
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
     MAXIND=19, $
     HISTBINSIZE_MAXIND=2.0, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0,250], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /DAYSIDE, $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     /ONLY_POS
  histoplot_alfvendbquantities_during_stormphases, $
     MAXIND=19, $
     HISTBINSIZE_MAXIND=2.0, $
     /USE_DARTDB_START_ENDDATE, $
     HISTXRANGE_MAXIND=[0,250], $
     HISTYRANGE_MAXIND=[0,0.15], $
     /DAYSIDE, $
     PLOTSUFFIX='dayside--neg_and_pos_separ', $
     PLOTTITLE='Dayside', $
     /SAVEPLOT, $
     /NORMALIZE_MAXIND_HIST, $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     OUTPLOTARR=outplotArr, $
     /ONLY_NEG, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND

END