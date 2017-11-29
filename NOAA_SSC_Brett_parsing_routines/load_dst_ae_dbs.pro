;2015/10/13
PRO LOAD_DST_AE_DBS,Dst,ae, $
                    DST_AE_DIR=Dst_AE_dir, $
                    DST_AE_FILE=Dst_AE_file, $
                    FULL_DST_DB=full_Dst_DB, $
                    NO_AE=no_AE, $
                    FORCE_LOAD_DB=force_load_DB, $
                    LUN=lun

  @common__dst_and_ae_db.pro

  COMPILE_OPT IDL2,STRICTARRSUBS

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  ;; First see if we've already got 'em
  haveDst = N_ELEMENTS(DST__Dst) GT 0

  IF haveDst THEN BEGIN
     IF ( KEYWORD_SET(full_Dst_DB) AND ~KEYWORD_SET(DST__fullMonty)) OR $
        (~KEYWORD_SET(full_Dst_DB) AND  KEYWORD_SET(DST__fullMonty))    $
     THEN BEGIN
        DST__LOAD = 1
     ENDIF ELSE BEGIN
        DST__LOAD = 0
     ENDELSE
  ENDIF ELSE BEGIN
     DST__LOAD = 1
  ENDELSE

  IF KEYWORD_SET(force_load_DB) THEN BEGIN
     PRINT,FORMAT='("Forcing load of ",A0)', $
           (KEYWORD_SET(full_Dst_DB) ? "full-Monty Dst DB" : "Dst and AE DBs")
     DST__LOAD = 1
  ENDIF

  defDst_AE_dir              = '/SPENCEdata/Research/database/geomag_indices__1999-2009/processed/'
  ;;defDst_AE_file           = 'idl_ae_Dst_data.dat'
  ;; defDst_AE_smoothedFile  = 'idl_ae_Dst_data--smoothed.dat'
  ;; defDst_AE_file          = 'idl_ae_Dst_data--smoothed.dat'
  defDst_AE_file             = 'idl_ae_dst_data--smoothed_w_deriv.dat'

  ;; defFullDstDir              = '/SPENCEdata/Research/database/storm_data/'
  ;; defFullDstFile             = 'dst_1957-2011.sav'
  defFullDstDir              = '/SPENCEdata/Research/database/storm_data/processed/'
  defFullDstFile             = 'idl_dst_data--1957-2011--smoothed_w_deriv.dat'

  CASE 1 OF
     KEYWORD_SET(full_Dst_DB): BEGIN
        PRINT,"You've requested the full Dst Monty. You don't get AE in this case."
        DST__fullMonty       = 1
        IF N_ELEMENTS(Dst_AE_dir)  EQ 0 THEN Dst_AE_dir  = defFullDstDir
        IF N_ELEMENTS(Dst_AE_file) EQ 0 THEN Dst_AE_file = defFullDstFile
     END
     ELSE: BEGIN
        DST__fullMonty       = 1
        IF N_ELEMENTS(Dst_AE_dir)  EQ 0 THEN Dst_AE_dir  = defDst_AE_dir
        IF N_ELEMENTS(Dst_AE_file) EQ 0 THEN Dst_AE_file = defDst_AE_file

     END
  ENDCASE

  ;; IF N_ELEMENTS(DST__Dst) EQ 0 OR N_ELEMENTS(AE__ae) EQ 0 THEN BEGIN
  IF KEYWORD_SET(DST__LOAD) THEN BEGIN

     IF FILE_TEST(Dst_AE_dir+Dst_AE_file) THEN BEGIN
        RESTORE,Dst_AE_dir+Dst_AE_file
     ENDIF
        
     IF Dst EQ !NULL THEN BEGIN
        CASE 1 OF
           KEYWORD_SET(full_Dst_DB): BEGIN
              PRINT,"Couldn't load full Dst DB!"
           END
           ELSE: BEGIN
              PRINT,"Couldn't load Dst and AE DBs!"
           END
        ENDCASE
        STOP
     ENDIF

  ENDIF ELSE BEGIN
     ;; PRINTF,lun,"There are already Dst and AE structs loaded! Not loading " + Dst_AE_file
     PRINTF,lun,FORMAT='(A0," already loaded! Not loading ",A0)', $
            (DST__fullMonty ? 'Full-Monty Dst is' : 'Dst and AE structs are'), $
            DST__dbFile
  ENDELSE

  ;; DST__Dst    = TEMPORARY(Dst)
  DST__Dst    = Dst
  DST__dbDir  = Dst_AE_dir
  Dst__dbFile = DST_AE_file
  DST__LOAD   = 0
     

  IF N_ELEMENTS(AE) GT 0 THEN BEGIN
     
     AE__AE   = AE
     AE__dbDir = Dst_AE_dir
     AE__dbFile = Dst_AE_file

  ENDIF ELSE BEGIN

     IF ~(KEYWORD_SET(no_AE) OR KEYWORD_SET(DST__fullMonty)) THEN BEGIN
        PRINT, "Don't have AE! You OK with that?"
        STOP
     ENDIF

  ENDELSE
     
END
