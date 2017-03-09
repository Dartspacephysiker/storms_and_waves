;;08/26/16
;;After this, read 'em into structs with READ_FULLMONTY_STORM_FILES
PRO MAKE_BRETTSTYLE_DB_FROM_FULLMONTY_DST_STRUCT

  COMPILE_OPT IDL2,STRICTARRSUBS

  DST_STORMFINDER_V2__SPENCE_EDIT, $
     ;; arg1_julday, $
     ;; arg2_dst, $
     ;; arg3_storms, $
     ;; arg4_sstimes, $
     ;; arg5_lgtimes, $
     ;; SETHH2L=setHH2L, $
     ;; SETDD2=setDD2, $
     ;; STADATE=stadate, $
     ;; ENDDATE=enddate, $
     ;; /SAVEDATA, $
     /PRINT_SMALLSTORMS_TO_TEXTFILE, $
     /PRINT_LARGESTORMS_TO_TEXTFILE




END
