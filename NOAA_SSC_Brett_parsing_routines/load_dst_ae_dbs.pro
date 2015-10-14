;2015/10/13
PRO LOAD_DST_AE_DBS,dst,ae,LUN=lun,DST_AE_DIR=dst_AE_dir,DST_AE_FILE=dst_AE_file

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  DefDst_AE_dir         = '/SPENCEdata/Research/Cusp/database/processed/'
  ;;defDST_AE_file        = 'idl_ae_dst_data.dat'
  ;; defDST_AE_smoothedFile= 'idl_ae_dst_data--smoothed.dat'
  ;; defDST_AE_file= 'idl_ae_dst_data--smoothed.dat'
  defDST_AE_file= 'idl_ae_dst_data--smoothed_w_deriv.dat'

  IF N_ELEMENTS(dst_AE_dir)  EQ 0 THEN dst_AE_dir = DefDst_AE_dir
  IF N_ELEMENTS(dst_AE_file) EQ 0 THEN dst_AE_file = DefDst_AE_file
  ;;IF N_ELEMENTS(dst_AE_smoothedFile) EQ 0 THEN dst_AE_smoothedFile = DefDst_AE_smoothedFile
  

  IF N_ELEMENTS(dst) EQ 0 OR N_ELEMENTS(ae) EQ 0 THEN BEGIN
     IF FILE_TEST(dst_AE_dir+dst_AE_file) THEN RESTORE,dst_AE_dir+dst_AE_file
     IF dst EQ !NULL THEN BEGIN
        PRINT,"Couldn't load Dst and AE DBs!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There are already Dst and AE structs loaded! Not loading " + dst_AE_file
  ENDELSE

END