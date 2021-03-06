;;2015/11/19 Wowzers
PRO JOURNAL__20151119__HISTOPLOTS_OF_MAG_CURRENT_DURING_STORMPHASES

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;INTEG_ION_FLUX_UP

  ;;normalized nightside, pos and neg
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES,MAXIND=6, $
     HISTBINSIZE_MAXIND=5.0, $
     /USE_DARTDB_START_ENDDATE, $
     /NIGHTSIDE, $
     HISTXRANGE_MAXIND=[0,100], $
     HISTYRANGE_MAXIND=[0,0.75], $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     /NORMALIZE_MAXIND_HIST, $
     OUTPLOTARR=outplotArr, $
     /ONLY_POS
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES,MAXIND=6, $
     HISTBINSIZE_MAXIND=5.0, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTSUFFIX='nightside--sep_pos_and_neg', $
     PLOTTITLE='Nightside', $
     /NIGHTSIDE, $
     HISTXRANGE_MAXIND=[0,100], $
     HISTYRANGE_MAXIND=[0,0.75], $
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
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES,MAXIND=6, $
     HISTBINSIZE_MAXIND=5.0, $
     /USE_DARTDB_START_ENDDATE, $
     /DAYSIDE, $
     HISTXRANGE_MAXIND=[0,100], $
     HISTYRANGE_MAXIND=[0,0.75], $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     /NORMALIZE_MAXIND_HIST, $
     OUTPLOTARR=outplotArr, $
     /ONLY_POS
  HISTOPLOT_ALFVENDBQUANTITIES_DURING_STORMPHASES,MAXIND=6, $
     HISTBINSIZE_MAXIND=5.0, $
     /USE_DARTDB_START_ENDDATE, $
     PLOTSUFFIX='dayside--sep_pos_and_neg', $
     PLOTTITLE='Dayside', $
     /DAYSIDE, $
     HISTXRANGE_MAXIND=[0,100], $
     HISTYRANGE_MAXIND=[0,0.75], $
     HISTOPLOT_PARAM_STRUCT=pHP, $
     CURRENT_WINDOW=window, $
     /NORMALIZE_MAXIND_HIST, $
     OUTPLOTARR=outplotArr, $
     /ONLY_NEG, $
     PLOTCOLOR='RED', $
     /FILL_BACKGROUND
  
END