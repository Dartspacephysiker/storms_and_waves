;2017/11/30
;; katusInt: Intense storms only
;; katusMod: Moderate storms only
;; katusCom: Intense and moderate combined
FUNCTION LOAD_KATUS_STORM_PHASES,INTENSE=intense, $
                                 MODERATE=moderate, $
                                 COMBINED=combined

  COMPILE_OPT IDL2,STRICTARRSUBS

  dir      = '/SPENCEdata/Research/database/storm_data/processed/katus_et_al_2013__normalized_storm_phases/'
  katusFil = 'katus_IDL_structs.sav'

  IF ~FILE_TEST(dir+katusFil) THEN STOP

  RESTORE,dir+katusFil

  IF N_ELEMENTS(katusInt) EQ 0 OR $
     N_ELEMENTS(katusMod) EQ 0 OR $
     N_ELEMENTS(katusCom) EQ 0    $
  THEN STOP

  CASE 1 OF
     KEYWORD_SET(intense ): BEGIN
        RETURN,katusInt
     END
     KEYWORD_SET(moderate): BEGIN
        RETURN,katusMod
     END
     KEYWORD_SET(combined): BEGIN
        RETURN,katusCom
     END
  ENDCASE

END
