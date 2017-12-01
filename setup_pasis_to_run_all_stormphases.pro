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
   STACKED_PLOTS=stacked_plots, $
   TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
   COLORBAR_FOR_ALL=colorbar_for_all, $
   USE_KATUS_STORM_PHASES=use_katus_storm_phases, $
   TILEPLOTSUFF=tilePlotSuff

  COMPILE_OPT IDL2,STRICTARRSUBS

  all_storm_phases    = 1
  do_not_consider_IMF = 1

  IF KEYWORD_SET(use_katus_storm_phases) THEN BEGIN

     CASE use_katus_storm_phases OF
        1: BEGIN
           
           tile__no_colorbar_array  = [1,0,1]

           niceStrings   = ["Initial phase","Main phase","Recovery phase"]
           tileStr       = ["init"         ,"mp"        ,"rp"]
           tileTitle     = ["Initial phase","Main phase","Recovery phase"]
           IF KEYWORD_SET(stacked_plots) THEN BEGIN
              tileOrder  = [ 0,1, $
                            -9,2]
              tileCol    = 2
              tileRow    = 2
           ENDIF ELSE BEGIN
              tileOrder  = [0,1,2]
              tileCol    = 3
              tileRow    = 1
           ENDELSE
           tilePlotSuff  = ""

        END
        2: BEGIN

           tile__no_colorbar_array  = [0,1,1, $
                                       1,1,1]

           niceStrings   = ["Initial phase","Early main phase","Early recovery phase", $
                            "Late main phase","Late recovery phase"]
           tileStr       = ["init","earlyMP","earlyRP"]
           tileTitle     = ["Initial phase","Early main phase","Early recovery phase", $
                            "Late main phase","Late recovery phase"]
           tileOrder     = [0,1,2, $
                            -9,3,4]
           tileCol       = 3
           tileRow       = 2
           tilePlotSuff  = ""

        END
     ENDCASE

  ENDIF ELSE BEGIN

     tile__no_colorbar_array  = [1,0,1]

     niceStrings   = ["Quiescent","Main phase","Recovery phase"]
     tileStr       = ["quiesc"   ,"mp"        ,"rp"]
     tileTitle     = ["Quiescent","Main phase","Recovery phase"]
     tileOrder     = [0,1,2]
     tileCol       = KEYWORD_SET(stacked_plots) ? 1 : 3
     tileRow       = KEYWORD_SET(stacked_plots) ? 3 : 1
     tilePlotSuff  = ""


  ENDELSE
  
  IF KEYWORD_SET(no_stormphase_titles) THEN BEGIN
     niceStrings = !NULL
  ENDIF

  IF KEYWORD_SET(colorbar_for_all) THEN BEGIN
     tile__no_colorbar_array *= 0
  ENDIF

  IF KEYWORD_SET(and_tiling_options) THEN BEGIN
     tile_images                 = 1
     IF KEYWORD_SET(group_like_plots_for_tiling) THEN BEGIN
        tiling_order             = tileOrder
        n_tile_columns           = tileCol
        n_tile_rows              = tileRow
        tilePlotSuff             = ""
     ENDIF
  ENDIF

END
