;2016/08/19 Now we need OMNI to do it too
PRO GET_AE_OMNIDB_INDICES, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   ;; AECUTOFF=AeCutoff, $
   ;; SMOOTH_AE=smooth_AE, $
   ;; EARLIEST_UTC=earliest_UTC, $
   ;; LATEST_UTC=latest_UTC, $
   ;; USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
   ;; EARLIEST_JULDAY=earliest_julDay, $
   ;; LATEST_JULDAY=latest_julDay, $
   ;; USE_AU=use_au, $
   ;; USE_AL=use_al, $
   ;; USE_AO=use_ao, $
   HIGH_AE_I=high_ae_i, $
   LOW_AE_I=low_ae_i, $
   HIGH_I=high_i, $
   LOW_I=low_i, $
   N_HIGH=n_high, $
   N_LOW=n_low, $
   OUT_NAME=navn, $
   HIGH_AE_T1=high_ae_t1, $
   LOW_AE_T1=low_ae_t1, $
   HIGH_AE_T2=high_ae_t2, $
   LOW_AE_T2=low_ae_t2, $
   LUN=lun

  COMPILE_OPT idl2

  @common__omni_stability.pro

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  LOAD_DST_AE_DBS,dst,ae,LUN=lun

  CASE 1 OF
     KEYWORD_SET(alfDB_plot_struct.ae_opt.use_AU): BEGIN
        AE_str = 'AU'
     END
     KEYWORD_SET(alfDB_plot_struct.ae_opt.use_AO): BEGIN
        AE_str = 'AO'
     END
     KEYWORD_SET(alfDB_plot_struct.ae_opt.use_AL): BEGIN
        AE_str = 'AL'
     END
     ELSE: BEGIN
        AE_str = 'AE'
     END
  ENDCASE

  PRINTF,lun,'Restoring culled OMNI data to get mag_utc ...'
  dataDir                        = "/SPENCEdata/Research/database/"
  RESTORE,dataDir + "/OMNI/culled_OMNI_magdata.dat"

  OMNI__SELECT_COORDS,Bx, $
                      By_GSE,Bz_GSE,Bt_GSE, $
                      thetaCone_GSE,phiClock_GSE,cone_overClock_GSE,Bxy_over_Bz_GSE, $
                      By_GSM,Bz_GSM,Bt_GSM, $
                      thetaCone_GSM,phiClock_GSM,cone_overClock_GSM,Bxy_over_Bz_GSM, $
                      OMNI_COORDS=alfDB_plot_struct.OMNI_coords, $
                      LUN=lun

  C_OMNI__clean_i = GET_CLEAN_OMNI_I(C_OMNI__Bx,C_OMNI__By,C_OMNI__Bz, $
                                     LUN=lun)
  C_OMNI__time_i  = GET_OMNI_TIME_I(mag_UTC, $
                                    IMF_STRUCT=IMF_struct, $
                                    LUN=lun)

  good_i   = CGSETINTERSECTION(C_OMNI__clean_i,C_OMNI__time_i,COUNT=nGood)
  IF nGood LE 1 THEN BEGIN
     PRINT,'WHATTTTTTT'
     STOP
  ENDIF

  ;;Cast in the parlance of other routines
  dbTimes  = TEMPORARY(mag_utc)
  dbString = 'OMNI DB'

  todaysFile = TODAYS_AE_OMNIDB_INDICES(AECUTOFF=alfDB_plot_struct.ae_opt.AEcutoff, $
                                        AE_STR=ae_str, $
                                        SMOOTH_AE=alfDB_plot_struct.ae_opt.smooth_AE)
  
  GET_LOW_AND_HIGH_AE_PERIODS, $
     ae, $
     AECUTOFF=alfDB_plot_struct.ae_opt.AeCutoff, $
     SMOOTH_AE=alfDB_plot_struct.ae_opt.smooth_AE, $
     EARLIEST_UTC=IMF_struct.earliest_UTC, $
     LATEST_UTC=IMF_struct.latest_UTC, $
     USE_JULDAY_NOT_UTC=IMF_struct.use_julDay_not_UTC, $
     EARLIEST_JULDAY=IMF_struct.earliest_julDay, $
     LATEST_JULDAY=IMF_struct.latest_julDay, $
     USE_AU=alfDB_plot_struct.ae_opt.use_au, $
     USE_AL=alfDB_plot_struct.ae_opt.use_al, $
     USE_AO=alfDB_plot_struct.ae_opt.use_ao, $
     HIGH_AE_I=high_ae_i, $
     LOW_AE_I=low_ae_i, $
     N_HIGH=n_high, $
     N_LOW=n_low, $
     OUT_NAME=navn, $
     QUIET=quiet, $
     LUN=lun

  ae_i_list = LIST(high_ae_i,low_ae_i)
  strings = ["high_","low_"] + AE_str

  IF FILE_TEST(todaysFile) THEN BEGIN
     PRINTF,lun,"Already have nonstorm and storm " + dbString + " inds! Restoring today's file..."
     RESTORE,todaysFile
  ENDIF ELSE BEGIN
     
     FOR i=0,1 DO BEGIN
        inds=AE_i_list[i]
        help,inds
        GET_STREAKS,inds, $
                    START_I=start_AE_ii, $
                    STOP_I=stop_AE_ii, $
                    SINGLE_I=single_AE_ii
        
        GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES, $
           T1_ARR=AE.time[inds[start_AE_ii]], $
           T2_ARR=AE.time[inds[stop_AE_ii]], $
           DBSTRUCT=dbStruct, $
           DBTIMES=dbTimes, $
           RESTRICT_W_THESEINDS=good_i, $
           /FOR_OMNI_DB, $
           OUT_INDS_LIST=inds_list, $
           PRINT_DATA_AVAILABILITY=0, $
           VERBOSE=0, $
           /LIST_TO_ARR
        
        IF i EQ 0 THEN BEGIN
           high_i                  = inds_list
           high_ae_t1              = ae.time[inds[start_ae_ii]]
           high_ae_t2              = ae.time[inds[stop_ae_ii]]
           PRINT,"N " + dbString + " inds for high " + AE_str + " retrieved  : " + $
                 STRCOMPRESS(N_ELEMENTS(inds_list),/REMOVE_ALL)
        ENDIF ELSE BEGIN
           IF i EQ 1 THEN BEGIN
              low_i                = inds_list
              low_ae_t1            = ae.time[inds[start_ae_ii]]
              low_ae_t2            = ae.time[inds[stop_ae_ii]]
              PRINT,"N " + dbString + " inds for low " + AE_str + " retrieved  : " + $
                    STRCOMPRESS(N_ELEMENTS(inds_list),/REMOVE_ALL)
           ENDIF
        ENDELSE
        
     ENDFOR

     PRINTF,lun,"Saving " + dbString + " AE/AO/AU/AL indices for today..."
     SAVE,high_i,low_i,high_ae_i,low_ae_i, $
          n_high,n_low, $
          high_ae_t1,high_ae_t2,low_ae_t1,low_ae_t2, $
          FILENAME=todaysFile

  ENDELSE

END