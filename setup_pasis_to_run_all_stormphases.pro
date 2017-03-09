;;12/09/16
PRO SETUP_PASIS_TO_RUN_ALL_STORMPHASES, $
   ALL_STORM_PHASES=all_storm_phases, $
   DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
   AND_TILING_OPTIONS=and_tiling_options, $
   GROUP_LIKE_PLOTS_FOR_TILING=group_like_plots_for_tiling, $
   TILE_IMAGES=tile_images, $
   TILING_ORDER=tiling_order, $
   N_TILE_COLUMNS=n_tile_columns, $
   N_TILE_ROWS=n_tile_rows, $
   TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
   COLORBAR_FOR_ALL=colorbar_for_all, $
   TILEPLOTSUFF=tilePlotSuff

  COMPILE_OPT IDL2,STRICTARRSUBS

  all_storm_phases    = 1
  do_not_consider_IMF = 1

  IF ~KEYWORD_SET(colorbar_for_all) THEN BEGIN
     tile__no_colorbar_array  = [1,0,1]
  ENDIF ELSE BEGIN
     tile__no_colorbar_array  = [0,0,0]
  ENDELSE

  IF KEYWORD_SET(no_stormphase_titles) THEN BEGIN
     niceStrings = !NULL
  ENDIF ELSE BEGIN
     niceStrings = ["Quiescent","Main phase","Recovery phase"]
  ENDELSE

  tileStr    = ["quiesc"   ,"mp"        ,"rp"]
  tileTitle  = ["Quiescent","Main phase","Recovery phase"]


  IF KEYWORD_SET(and_tiling_options) THEN BEGIN
     tile_images                 = 1
     IF KEYWORD_SET(group_like_plots_for_tiling) THEN BEGIN
        tiling_order             = [0,1,2]
        n_tile_columns           = 3
        n_tile_rows              = 1

        tilePlotSuff                = ""
     ENDIF
  ENDIF
END
