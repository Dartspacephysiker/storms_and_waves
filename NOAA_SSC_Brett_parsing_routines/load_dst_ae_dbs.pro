;2015/10/13
PRO LOAD_DST_AE_DBS,Dst,ae,LUN=lun, $
                    DST_AE_DIR=Dst_AE_dir, $
                    DST_AE_FILE=Dst_AE_file, $
                    FULL_DST_DB=full_Dst_db

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  DefDst_AE_dir              = '/SPENCEdata/Research/database/geomag_indices__1999-2009/processed/'
  ;;defDst_AE_file           = 'idl_ae_Dst_data.dat'
  ;; defDst_AE_smoothedFile  = 'idl_ae_Dst_data--smoothed.dat'
  ;; defDst_AE_file          = 'idl_ae_Dst_data--smoothed.dat'
  defDst_AE_file             = 'idl_ae_dst_data--smoothed_w_deriv.dat'

  defFullDstDir              = '/SPENCEdata/Research/database/storm_data/'
  defFullDstFile             = 'dst_1957-2011.sav'

  CASE 1 OF
     KEYWORD_SET(full_Dst_db): BEGIN
        PRINT,"You've requested the full Dst Monty. You don't get AE in this case."
        IF N_ELEMENTS(Dst_AE_dir)  EQ 0 THEN Dst_AE_dir  = defFullDstDir
        IF N_ELEMENTS(Dst_AE_file) EQ 0 THEN Dst_AE_file = defFullDstFile
     END
     ELSE: BEGIN
        IF N_ELEMENTS(Dst_AE_dir)  EQ 0 THEN Dst_AE_dir  = defDst_AE_dir
        IF N_ELEMENTS(Dst_AE_file) EQ 0 THEN Dst_AE_file = defDst_AE_file

     END
  ENDCASE

  IF N_ELEMENTS(Dst) EQ 0 OR N_ELEMENTS(ae) EQ 0 THEN BEGIN
     IF FILE_TEST(Dst_AE_dir+Dst_AE_file) THEN RESTORE,Dst_AE_dir+Dst_AE_file
     IF Dst EQ !NULL THEN BEGIN
        CASE 1 OF
           KEYWORD_SET(full_Dst_db): BEGIN
              PRINT,"Couldn't load full Dst DB!"
           END
           ELSE: BEGIN
              PRINT,"Couldn't load Dst and AE DBs!"
           END
        ENDCASE
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There are already Dst and AE structs loaded! Not loading " + Dst_AE_file
  ENDELSE

END