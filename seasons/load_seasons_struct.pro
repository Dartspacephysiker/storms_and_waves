;;01/26/17
;;seasons struct generated by READ_SEASONS_GMT_FILE
PRO LOAD_SEASONS_STRUCT,seasons,spring,summer,fall,winter

  COMPILE_OPT IDL2

  structDir    = '/SPENCEdata/Research/database/storm_data/seasons/'
  structFile   = 'seasons_v0_0__idl.sav'
  
  IF ~KEYWORD_SET(quiet) THEN BEGIN
     PRINT,"Restoring seasons struct ..."
  ENDIF

  IF ~FILE_TEST(structDir+structFile) THEN BEGIN
     PRINT,"Couldn't find seasons struct file!"
     STOP
  ENDIF

  RESTORE,structDir+structFile

END
